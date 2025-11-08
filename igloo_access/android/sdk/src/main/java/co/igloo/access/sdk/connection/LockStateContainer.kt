package co.igloo.access.sdk.connection

import co.igloohome.ble.lock.IglooLock
import io.reactivex.disposables.Disposable
import timber.log.Timber

enum class LockState {
    CONNECTING,
    CONNECTED,
}

class LockStateContainer(val lock: IglooLock, var connection: Disposable, var state: LockState) {
    fun close() {
        if (connection.isDisposed) return
        connection.dispose()
        Timber.d("Connection disposed for lock ${lock.name}")
    }
}