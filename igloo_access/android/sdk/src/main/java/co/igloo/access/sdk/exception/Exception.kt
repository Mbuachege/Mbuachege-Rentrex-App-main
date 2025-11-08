package co.igloo.access.sdk.exception

import timber.log.Timber
import java.util.concurrent.TimeoutException

sealed class IglooAccessException(
    open val status: Int,
    open val source: Throwable? = null,
    override val message: String? = null,
) : Throwable(message = message) {
    open class BluetoothException(
        status: Int,
        source: Throwable? = null,
        message: String? = null,
    ) : IglooAccessException(status, source, message) {
        class DeviceDisconnectedException(
            source: Throwable?,
            message: String?,
        ) : BluetoothException(12, source, message)

        class TimeoutException(
            source: Throwable? = null,
            message: String? = null,
        ) : BluetoothException(703, source, message)
    }

    class ApiException(status: Int, source: Throwable? = null, message: String? = null) :
        IglooAccessException(status, source, message)

    class GenericException(source: Throwable? = null, message: String? = null) :
        IglooAccessException(0, source, message)
}

internal fun Throwable.mapToIglooAccessException(): IglooAccessException {
    return when (this) {
        is IglooAccessException -> this
        is TimeoutException -> IglooAccessException.BluetoothException.TimeoutException(
            this,
            this.message
        )

        is retrofit2.HttpException -> IglooAccessException.ApiException(
            this.code(),
            this,
            this.message()
        )

        else -> {
            Timber.w(this, "Mapping unhandled exception")
            IglooAccessException.GenericException(this, this.message)
        }
    }
}



