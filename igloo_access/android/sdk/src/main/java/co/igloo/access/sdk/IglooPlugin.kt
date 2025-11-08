package co.igloo.access.sdk

import android.bluetooth.BluetoothGatt
import android.bluetooth.BluetoothManager
import android.content.Context
import androidx.annotation.RequiresPermission
import co.igloo.access.sdk.api.IgloohomeApi
import co.igloo.access.sdk.api.ServerTimeCache
import co.igloo.access.sdk.api.dto.StoreActivityLogItem
import co.igloo.access.sdk.api.dto.StoreActivityLogItemPayload
import co.igloo.access.sdk.api.dto.StoreActivityLogRequest
import co.igloo.access.sdk.connection.LockConnectionServiceWrapper
import co.igloo.access.sdk.db.IglooAccessDb
import co.igloo.access.sdk.db.entity.toEntity
import co.igloo.access.sdk.exception.IglooAccessException
import co.igloo.access.sdk.exception.mapToIglooAccessException
import com.google.gson.Gson
import io.reactivex.Completable
import io.reactivex.Single
import io.reactivex.exceptions.UndeliverableException
import io.reactivex.plugins.RxJavaPlugins
import kotlinx.coroutines.coroutineScope
import kotlinx.coroutines.launch
import kotlinx.coroutines.rx2.await
import timber.log.Timber
import java.util.concurrent.TimeUnit

data class SyncResult(val batteryLevel: Int)

class IglooPlugin(private val context: Context) {
    companion object {
        const val DEFAULT_BLE_TIMEOUT = 15L
    }

    private val lockConnectionService = LockConnectionServiceWrapper(context)
    private val db = IglooAccessDb.create(context)
    private val serverTimeCache = ServerTimeCache.create()
    private val igloohomeApi = IgloohomeApi.create(serverTimeCache)

    init {
        RxJavaPlugins.setErrorHandler { throwable ->
            when (throwable) {
                is UndeliverableException -> {
                    Timber.w(throwable, "Swallowed exception")
                }

                else -> throw throwable
            }
        }
    }

    private inline fun <T> dispatch(action: () -> T): T {
        return try {
            action()
        } catch (e: Throwable) {
            throw e.mapToIglooAccessException()
        }
    }

    private fun ensureBluetoothServiceEnabled() {
        val bluetoothService =
            context.getSystemService(Context.BLUETOOTH_SERVICE) as BluetoothManager
        if (bluetoothService.adapter != null && bluetoothService.adapter.isEnabled) return
        throw IglooAccessException.BluetoothException(703, null, "Bluetooth is disabled")
    }

    /**
     * Lock with given [key]
     */
    @RequiresPermission(allOf = ["android.permission.BLUETOOTH_SCAN", "android.permission.BLUETOOTH_CONNECT", "android.permission.ACCESS_FINE_LOCATION"])
    suspend fun lock(
        bluetoothDeviceName: String,
        key: String,
        timeInSeconds: Long? = null,
        operationId: Int? = null,
    ) = coroutineScope {
        dispatch {
            ensureBluetoothServiceEnabled()

            val observeState = launch {
                lockConnectionService.observeLockStates()
                    .filter { it.first == bluetoothDeviceName && it.second == BluetoothGatt.STATE_DISCONNECTED }
                    .firstOrError()
                    .flatMapCompletable {
                        Completable.error(
                            IglooAccessException.BluetoothException.DeviceDisconnectedException(
                                null,
                                "bluetooth device is disconnected"
                            )
                        )
                    }
                    .await()
            }

            lockConnectionService.connect(bluetoothDeviceName, key)
                .flatMapCompletable { lock ->
                    lock.lock(timeInSeconds = timeInSeconds, operationId = operationId)
                }
                .timeout(DEFAULT_BLE_TIMEOUT, TimeUnit.SECONDS)
                .withLog("lock", bluetoothDeviceName, timeInSeconds, operationId)
                .await()

            observeState.cancel()
        }
    }

    /**
     * Unlock with given [key]
     *
     * If [timeInSeconds] timeInSeconds not provided, plugin will use the last date retrieved from server
     *
     * If time from server is also not found, plugin will not perform set time
     */
    @RequiresPermission(allOf = ["android.permission.BLUETOOTH_SCAN", "android.permission.BLUETOOTH_CONNECT", "android.permission.ACCESS_FINE_LOCATION"])
    suspend fun unlock(
        bluetoothDeviceName: String,
        key: String,
        timeInSeconds: Long? = null,
        operationId: Int? = null,
    ) = coroutineScope {
        dispatch {
            ensureBluetoothServiceEnabled()

            val observeState = launch {
                lockConnectionService.observeLockStates()
                    .filter { it.first == bluetoothDeviceName && it.second == BluetoothGatt.STATE_DISCONNECTED }
                    .firstOrError()
                    .flatMapCompletable {
                        Completable.error(
                            IglooAccessException.BluetoothException.DeviceDisconnectedException(
                                null,
                                "bluetooth device is disconnected"
                            )
                        )
                    }
                    .await()
            }

            lockConnectionService.connect(bluetoothDeviceName, key)
                .flatMapCompletable { lock ->
                    lock.unlock(
                        timeInSeconds = timeInSeconds,
                        duration = null,
                        operationId = operationId
                    )
                }
                .timeout(DEFAULT_BLE_TIMEOUT, TimeUnit.SECONDS)
                .withLog("unlock", bluetoothDeviceName, timeInSeconds, operationId)
                .await()

            observeState.cancel()
        }
    }

    /**
     * Sync with given [key]
     *
     * This function will perform get battery level, set time, get activity logs and store activity logs
     *
     * If [timeInSeconds] timeInSeconds not provided, plugin will use the last date retrieved from server
     *
     * If time from server is also not found, plugin will not perform set time
     */
    @RequiresPermission(allOf = ["android.permission.BLUETOOTH_SCAN", "android.permission.BLUETOOTH_CONNECT", "android.permission.ACCESS_FINE_LOCATION"])
    suspend fun sync(
        bluetoothDeviceName: String,
        key: String,
        timeInSeconds: Long? = null,
        getDeviceToken: String,
        storeLogsToken: String,
        operationId: Int? = null,
    ): SyncResult = coroutineScope {
        dispatch {
            ensureBluetoothServiceEnabled()

            Timber.d("Start sync")

            val observeState = launch {
                lockConnectionService.observeLockStates()
                    .filter { it.first == bluetoothDeviceName && it.second == BluetoothGatt.STATE_DISCONNECTED }
                    .firstOrError()
                    .flatMapCompletable {
                        Completable.error(
                            IglooAccessException.BluetoothException.DeviceDisconnectedException(
                                null,
                                "bluetooth device is disconnected"
                            )
                        )
                    }
                    .await()
            }

            val getDeviceAuthHeader = mapOf(
                "Authorization" to "Bearer $getDeviceToken"
            )
            val storeLogsHeader = mapOf(
                "Authorization" to "Bearer $storeLogsToken"
            )

            val gson = Gson()
            val lock = lockConnectionService.connect(bluetoothDeviceName, key)
                .timeout(DEFAULT_BLE_TIMEOUT, TimeUnit.SECONDS)
                .await()

            if (timeInSeconds != null) {
                lock.setTime(timeInSeconds, null)
                    .timeout(DEFAULT_BLE_TIMEOUT, TimeUnit.SECONDS)
                    .withLog("setTime", bluetoothDeviceName, timeInSeconds, operationId)
                    .await()
            } else if (serverTimeCache.getLastServerTime() != null) {
                val calculatedServerTimeInSeconds =
                    serverTimeCache.getLastServerTime()!!.time / 1000

                lock.setTime(calculatedServerTimeInSeconds, null)
                    .withLog("setTime", bluetoothDeviceName, timeInSeconds, operationId)
                    .timeout(DEFAULT_BLE_TIMEOUT, TimeUnit.SECONDS).await()
            }

            val batteryLevel =
                lock.getPowerState(null)
                    .timeout(DEFAULT_BLE_TIMEOUT, TimeUnit.SECONDS)
                    .withLog("getPowerState", bluetoothDeviceName, operationId)
                    .await()
                    .batteryLevel!!

            // Store current logs
            val userRef = igloohomeApi.healthCheck(header = getDeviceAuthHeader).userRef
            val device = igloohomeApi.getDeviceById(
                bluetoothDeviceName,
                showLockRef = 1,
                header = getDeviceAuthHeader,
            )

            var hasNext = true
            val pair =
                lock.getLogs(
                    timeInSeconds = timeInSeconds,
                    shouldRetainLogs = null,
                    removeIdStart = null,
                    removeIdEnd = null,
                    operationId = operationId
                )
                    .withLog("getLogs", bluetoothDeviceName, timeInSeconds, operationId)
                    .timeout(DEFAULT_BLE_TIMEOUT, TimeUnit.SECONDS)
                    .await()

            while (hasNext) {
                val activityLog = pair.first
                hasNext = pair.second

                val log = activityLog.toEntity(
                    userRef = userRef,
                    lockRef = device.deviceRef,
                    bluetoothDeviceName = bluetoothDeviceName,
                )
                db.activityLogDao().saveActivityLog(log)
            }

            // Store previously stored logs in database
            val cachedActivityLogs = db.activityLogDao().getActivityLogs()
            val cachedLogsPayload = cachedActivityLogs
                .map { log ->
                    StoreActivityLogItem(
                        user = log.userRef,
                        lockRef = log.lockRef,
                        ts = log.createdAt.time,
                        payload = StoreActivityLogItemPayload(
                            lockName = log.bluetoothDeviceName,
                            log = log.log,
                        )
                    )
                }.map { gson.toJson(it) }

            if (cachedActivityLogs.isNotEmpty()) {
                igloohomeApi.storeActivityLogs(
                    bluetoothDeviceName,
                    StoreActivityLogRequest(logsPayload = cachedLogsPayload),
                    header = storeLogsHeader,
                )

                db.activityLogDao()
                    .deleteMultipleActivityLogById(cachedActivityLogs.map { it.uid.toLong() }
                        .toList())
            }

            val result = SyncResult(batteryLevel)

            observeState.cancel()

            Timber.d("Complete sync")

            return@coroutineScope result
        }
    }
}

internal fun Completable.withLog(operationName: String, vararg params: Any?): Completable {
    return this.doOnSubscribe {
        Timber.d("Subscribe: $operationName(${params.joinToString(", ")})")
    }.doOnError {
        Timber.e(it, "Error: $operationName")
    }.doOnComplete {
        Timber.d("Complete: $operationName")
    }
}

internal fun <T> Single<T>.withLog(operationName: String, vararg params: Any?): Single<T> {
    return this.doOnSubscribe {
        Timber.d("Subscribe: $operationName(${params.joinToString(", ")})")
    }.doOnError {
        Timber.e(it, "Error: $operationName")
    }.doOnSuccess {
        Timber.d("Success: $operationName")
    }
}
