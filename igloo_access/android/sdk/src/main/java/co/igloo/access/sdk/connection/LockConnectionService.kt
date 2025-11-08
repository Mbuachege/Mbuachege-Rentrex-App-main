package co.igloo.access.sdk.connection

import android.app.Service
import android.bluetooth.BluetoothGatt
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.content.ServiceConnection
import android.os.Binder
import android.os.IBinder
import androidx.annotation.RequiresPermission
import co.igloo.access.sdk.exception.IglooAccessException
import co.igloohome.ble.lock.IglooLock
import io.reactivex.Completable
import io.reactivex.Observable
import io.reactivex.Single
import io.reactivex.android.schedulers.AndroidSchedulers
import io.reactivex.subjects.PublishSubject
import timber.log.Timber
import java.util.concurrent.ConcurrentHashMap
import java.util.concurrent.TimeUnit

typealias LockConnectionState = Pair<String, Int>


class LockConnectionServiceWrapper(context: Context) : ServiceConnection {
    private var isConnected = false

    private lateinit var lockService: LockConnectionService

    init {
        val intent = Intent(context, LockConnectionService::class.java)
        context.bindService(intent, this, Context.BIND_AUTO_CREATE)
    }

    private fun doPrerequisiteCheck(): Completable {
        return Completable.fromCallable {
            if (!isConnected) throw NotImplementedError("Lock connection service is not yet connected.")
        }
    }

    fun observeLockStates(): Observable<LockConnectionState> {
        return doPrerequisiteCheck()
            .andThen(lockService.observeLockStates())
    }

    @RequiresPermission(allOf = ["android.permission.BLUETOOTH_SCAN", "android.permission.BLUETOOTH_CONNECT"])
    fun connect(bluetoothDeviceName: String, key: String?): Single<IglooLock> {
        return doPrerequisiteCheck()
            .andThen(lockService.connect(bluetoothDeviceName, key))
    }

    fun disconnect(bluetoothDeviceName: String): Completable {
        return doPrerequisiteCheck()
            .andThen(lockService.disconnect(bluetoothDeviceName))
    }

    fun disconnectAll(): Completable {
        return doPrerequisiteCheck()
            .andThen(lockService.disconnectAll())
    }

    @RequiresPermission(allOf = ["android.permission.BLUETOOTH_SCAN", "android.permission.BLUETOOTH_CONNECT"])
    fun scan(): Observable<IglooLock> {
        return doPrerequisiteCheck()
            .andThen(lockService.scan())
    }

    @RequiresPermission(allOf = ["android.permission.BLUETOOTH_SCAN", "android.permission.BLUETOOTH_CONNECT"])
    fun scanForLock(bluetoothDeviceName: String): Single<IglooLock> {
        return doPrerequisiteCheck()
            .andThen(lockService.scanForLock(bluetoothDeviceName))
    }

    fun stopScan(): Completable {
        return doPrerequisiteCheck()
            .andThen(lockService.stopScan())
    }

    override fun onServiceConnected(name: ComponentName?, service: IBinder?) {
        lockService = (service as LockConnectionService.ServiceBinder).getService()
        isConnected = true
    }

    override fun onServiceDisconnected(name: ComponentName?) {
        isConnected = false
    }
}

internal class LockConnectionService : Service() {
    inner class ServiceBinder : Binder() {
        fun getService(): LockConnectionService {
            return this@LockConnectionService
        }
    }

    private val binder = ServiceBinder()

    companion object {
        //Technically 7 but 1 reserved for TTLock
        private const val MAX_CONCURRENT_BLE_CONNECTIONS = 6
    }

    private val connectedLocks = ConcurrentHashMap<String, LockStateContainer>()
    private val inProgressLocks = ConcurrentHashMap<String, LockStateContainer>()
    private val lockStatesStream = PublishSubject.create<Pair<String, Int>>()

    private lateinit var lockScanner: LockScanner
    private lateinit var context: Context

    override fun onCreate() {
        super.onCreate()
        context = applicationContext
        lockScanner = LockScanner(context)
    }

    override fun onLowMemory() {
        Timber.d("LockConnectionService received onLowMemory callback")
        closeAllConnectionAndRemoveCache()
        super.onLowMemory()
    }

    override fun onDestroy() {
        Timber.d("LockConnectionService received onDestroy callback")
        closeAllConnectionAndRemoveCache()
        super.onDestroy()
    }

    override fun onBind(intent: Intent?): IBinder {
        return binder
    }

    override fun onUnbind(intent: Intent?): Boolean {
        return super.onUnbind(intent)
    }

    @Synchronized
    private fun hasCache(bluetoothDeviceName: String) =
        connectedLocks.containsKey(bluetoothDeviceName) or inProgressLocks.containsKey(
            bluetoothDeviceName
        )

    @Synchronized
    private fun getCache(bluetoothDeviceName: String): Single<IglooLock> {
        return when {
            connectedLocks.containsKey(bluetoothDeviceName) -> {
                Timber.d("$bluetoothDeviceName exist in connectedLocks")
                Single.just(connectedLocks[bluetoothDeviceName]!!.lock)
            }

            inProgressLocks.containsKey(bluetoothDeviceName) -> {
                Timber.d("$bluetoothDeviceName exist in inProgressLocks")
                val lockStateContainer = inProgressLocks[bluetoothDeviceName]!!
                return when (lockStateContainer.state) {
                    LockState.CONNECTING -> {
                        observeLockStates().filter { it.first == bluetoothDeviceName }
                            .firstOrError()
                            .flatMap {
                                if (it.second == BluetoothGatt.STATE_CONNECTED) {
                                    Single.fromCallable {
                                        connectedLocks[bluetoothDeviceName]?.lock
                                            ?: inProgressLocks[bluetoothDeviceName]?.lock
                                            ?: throw IglooAccessException.GenericException(message = "Lock successfully connected but unable to find lock object in memory to return to Single.")
                                    }
                                } else {
                                    Single.error(IglooAccessException.GenericException(message = "Lock failed to connect. Observed lock state: ${it.second}"))
                                }
                            }
                    }

                    else -> Single.error(IglooAccessException.GenericException(message = "Found lockStateContainer in inProgressLocks but wrong state was found: ${lockStateContainer.state}. Please fix."))
                }
            }

            else -> Single.error(IglooAccessException.GenericException(message = "No cached lock found with BT device name $bluetoothDeviceName"))
        }
    }

    @Synchronized
    private fun closeConnectionAndRemoveCache(bluetoothDeviceName: String) {
        if (!hasCache(bluetoothDeviceName)) {
            Timber.d("Attempted to close and removing cache, but container not found for $bluetoothDeviceName")
        }

        synchronized(inProgressLocks) {
            inProgressLocks.remove(bluetoothDeviceName)?.let {
                Timber.d("Closing connection in inProgressLocks: $bluetoothDeviceName")
                it.close()
            }
            //Do some extra cleanup of stableLocks where connection is disposed but it is still in the map
            val invalidLocks = inProgressLocks
                .filter { it.value.connection.isDisposed }
                .map { it.key }

            Timber.w("Found ${invalidLocks.size} invalid locks in in progress locks")
            for (invalidLock in invalidLocks) {
                inProgressLocks.remove(invalidLock)
                Timber.d("Removed $invalidLock from in progress lock as an invalid lock")
            }

            Timber.d("Remaining in progress locks: ${inProgressLocks.map { it.key }}")
        }

        synchronized(connectedLocks) {
            connectedLocks.remove(bluetoothDeviceName)?.let {
                Timber.d("Closing connection in connectedLocks: $bluetoothDeviceName")
                it.close()
            }
            //Do some extra cleanup of stableLocks where connection is disposed but it is still in the map
            val invalidLocks = connectedLocks
                .filter { it.value.connection.isDisposed }
                .map { it.key }
            Timber.w("Found ${invalidLocks.size} invalid locks in connected locks")
            for (invalidLock in invalidLocks) {
                connectedLocks.remove(invalidLock)
                Timber.d("Removed $invalidLock from connected locks as an invalid lock")
            }

            Timber.d("Remaining connected locks: ${connectedLocks.map { it.key }}")
        }
    }

    @Synchronized
    private fun closeAllConnectionAndRemoveCache() {
        synchronized(connectedLocks) {
            Timber.d("Disconnecting all connected locks")
            connectedLocks.forEach { it.value.close() }
            connectedLocks.clear()
        }

        synchronized(inProgressLocks) {
            Timber.d("Disconnecting all in progress locks")
            inProgressLocks.forEach { it.value.close() }
            inProgressLocks.clear()
        }
    }

    fun observeLockStates() = lockStatesStream.share()!!

    @RequiresPermission(allOf = ["android.permission.BLUETOOTH_SCAN", "android.permission.BLUETOOTH_CONNECT"])
    fun connect(bluetoothDeviceName: String, key: String?): Single<IglooLock> {
        return Single.defer {
            if (hasCache(bluetoothDeviceName)) {
                return@defer getCache(bluetoothDeviceName)
            }

            scanForLock(bluetoothDeviceName).flatMap { lock ->
                if (connectedLocks.size >= MAX_CONCURRENT_BLE_CONNECTIONS) {
                    return@flatMap Single.error(IglooAccessException.GenericException(null, "Concurrent connection exceeded limit"))
                } else {
                    return@flatMap Single.create<IglooLock> { emitter ->
                        inProgressLocks[bluetoothDeviceName] = LockStateContainer(
                            lock,
                            lock.connectByStringKey(context, key)
                                .subscribeOn(AndroidSchedulers.mainThread())
                                .subscribe({
                                    val container = inProgressLocks[bluetoothDeviceName]!!
                                    container.state = LockState.CONNECTED
                                    lockStatesStream.onNext(
                                        Pair(
                                            bluetoothDeviceName,
                                            BluetoothGatt.STATE_CONNECTED
                                        )
                                    )
                                    connectedLocks[bluetoothDeviceName] = container
                                    inProgressLocks.remove(bluetoothDeviceName)

                                    if (!emitter.isDisposed) {
                                        emitter.onSuccess(lock)
                                        Timber.d("Successfully connected to $bluetoothDeviceName.")
                                    }
                                }, {
                                    Timber.e(it, "Error connecting to V5 lock ${lock.name}.")
                                    closeConnectionAndRemoveCache(bluetoothDeviceName)
                                    lockStatesStream.onNext(
                                        Pair(
                                            bluetoothDeviceName,
                                            BluetoothGatt.STATE_DISCONNECTED
                                        )
                                    )
                                    if (!emitter.isDisposed) emitter.onError(it)
                                }),
                            LockState.CONNECTING
                        )
                    }
                        .timeout(15, TimeUnit.SECONDS)
                }
            }
        }
    }

    fun disconnect(bluetoothDeviceName: String): Completable {
        return Completable.fromAction {
            Timber.d("START Disconnecting lock: $bluetoothDeviceName")
            closeConnectionAndRemoveCache(bluetoothDeviceName)
            Timber.d("END Disconnected lock: $bluetoothDeviceName")
        }
            .delay(2, TimeUnit.SECONDS)
    }

    fun disconnectAll(): Completable {
        return Completable.fromAction {
            Timber.d("START disconnectAll")
            closeAllConnectionAndRemoveCache()
            Timber.d("END disconnectAll")
        }
            .delay(2, TimeUnit.SECONDS)
    }

    @RequiresPermission(allOf = ["android.permission.BLUETOOTH_SCAN", "android.permission.BLUETOOTH_CONNECT"])
    fun scan(): Observable<IglooLock> {
        return lockScanner.scan()
    }

    @RequiresPermission(allOf = ["android.permission.BLUETOOTH_SCAN", "android.permission.BLUETOOTH_CONNECT"])
    fun scanForLock(bluetoothDeviceName: String): Single<IglooLock> {
        return lockScanner.scanForLock(bluetoothDeviceName)
    }

    fun stopScan(): Completable {
        return lockScanner.stop()
    }
}
