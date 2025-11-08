package co.igloo.access.sdk.connection

import co.igloohome.ble.lock.IglooLock
import io.reactivex.Completable
import io.reactivex.Observable
import io.reactivex.disposables.Disposable
import io.reactivex.observables.ConnectableObservable
import timber.log.Timber
import java.util.concurrent.TimeUnit

/**
 * Helper class to manage BLE scan limit by scheduling scan command periodically
 */
class ScanManager(private val source: ConnectableObservable<IglooLock>) {
    companion object {
        const val DEFAULT_SCAN_DURATION = 30L
    }

    private var observerCount: Int = 0
    private var timerSubscription: Disposable? = null
    private var sourceSubs: Disposable? = null

    fun startScan(
        duration: Long = DEFAULT_SCAN_DURATION,
    ): Observable<IglooLock> {
        if (sourceSubs == null) sourceSubs = source.connect()

        return Observable.create { observer ->
            val sub = source
                .subscribe({
                    if (!observer.isDisposed) observer.onNext(it)
                }, {
                    Timber.e(it, "Error scan manager")
                    if (!observer.isDisposed) observer.onError(it)
                })

            observerCount++

            if (timerSubscription != null && !timerSubscription!!.isDisposed) {
                Timber.d("Dispose previous timer, because there's new observer")
            }
            timerSubscription?.dispose()
            timerSubscription = null

            observer.setCancellable {
                sub.dispose()

                observerCount--
                if (observerCount == 0) {
                    Timber.d("ScanManager received dispose command, keep source alive for $duration seconds")
                    timerSubscription = Completable.timer(duration, TimeUnit.SECONDS)
                        .subscribe({
                            sourceSubs?.dispose()
                            sourceSubs = null
                            Timber.d("ScanManager stopped")
                        }, {
                            Timber.e(it, "Error ScanManager timer")
                        })
                } else {
                    Timber.d("ScanManager received dispose command, but has other observer")
                }
            }
        }
    }

    fun stop(): Completable {
        return Completable.fromAction {
            observerCount = 0

            timerSubscription?.dispose()
            timerSubscription = null

            sourceSubs?.dispose()
            sourceSubs = null
        }
    }

    val isDisposed get() = sourceSubs == null || sourceSubs!!.isDisposed
}
