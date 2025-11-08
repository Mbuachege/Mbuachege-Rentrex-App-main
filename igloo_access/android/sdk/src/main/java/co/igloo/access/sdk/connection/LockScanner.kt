package co.igloo.access.sdk.connection

import android.annotation.SuppressLint
import android.bluetooth.le.ScanSettings
import android.content.Context
import android.os.Handler
import android.os.Looper
import androidx.annotation.RequiresPermission
import co.igloohome.ble.lock.BleManager
import co.igloohome.ble.lock.IglooLock
import io.reactivex.Completable
import io.reactivex.Observable
import io.reactivex.Single

class LockScanner {
    companion object {
        val DEFAULT_SCAN_SETTINGS: ScanSettings =
            ScanSettings.Builder().setScanMode(ScanSettings.SCAN_MODE_LOW_LATENCY).build()
    }

    private val bleManager: BleManager
    private val scanManager: ScanManager

    @SuppressLint("MissingPermission")
    constructor(context: Context) {
        bleManager = BleManager(context)
        scanManager = ScanManager(bleManager.scan(DEFAULT_SCAN_SETTINGS, Handler(Looper.getMainLooper())).publish())
    }

    @SuppressLint("MissingPermission")
    constructor(bleManager: BleManager) {
        this.bleManager = bleManager
        this.scanManager = ScanManager(bleManager.scan(DEFAULT_SCAN_SETTINGS, Handler(Looper.getMainLooper())).publish())
    }

    @RequiresPermission("android.permission.BLUETOOTH_CONNECT")
    fun scan(
        scanSettings: ScanSettings = DEFAULT_SCAN_SETTINGS,
        handler: Handler? = null,
    ): Observable<IglooLock> {
        return if (handler == null) bleManager.scan(scanSettings, Handler(Looper.getMainLooper()))
        else bleManager.scan(scanSettings, handler)
    }

    @RequiresPermission("android.permission.BLUETOOTH_CONNECT")
    fun scanForLock(bluetoothDeviceName: String): Single<IglooLock> {
        return scanManager.startScan().filter { it.name == bluetoothDeviceName }.firstOrError()
    }

    fun stop(): Completable {
        return scanManager.stop()
    }
}