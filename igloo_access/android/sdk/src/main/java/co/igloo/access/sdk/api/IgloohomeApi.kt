package co.igloo.access.sdk.api

import co.igloo.access.sdk.BuildConfig
import co.igloo.access.sdk.Scope
import co.igloo.access.sdk.ScopeAdapter
import co.igloo.access.sdk.UnwrappedActivityLog
import co.igloo.access.sdk.UnwrappedActivityLogDeserializer
import co.igloo.access.sdk.api.dto.DeviceResponse
import co.igloo.access.sdk.api.dto.ServerHealthResponse
import co.igloo.access.sdk.api.dto.StoreActivityLogRequest
import com.google.gson.GsonBuilder
import okhttp3.OkHttpClient
import okhttp3.logging.HttpLoggingInterceptor
import retrofit2.Retrofit
import retrofit2.converter.gson.GsonConverterFactory
import retrofit2.http.Body
import retrofit2.http.GET
import retrofit2.http.HeaderMap
import retrofit2.http.POST
import retrofit2.http.Path
import retrofit2.http.Query
import timber.log.Timber
import java.text.SimpleDateFormat
import java.util.Locale

internal interface IgloohomeApi {
    companion object {
        internal fun create(
            serverTimeCache: ServerTimeCache,
        ): IgloohomeApi {
            val loggingInterceptor = HttpLoggingInterceptor()
            loggingInterceptor.setLevel(HttpLoggingInterceptor.Level.BODY)

            val client = OkHttpClient.Builder()
                .apply {
                    interceptors().add { chain ->
                        val response = chain.proceed(chain.request())

                        val dateHeader = response.headers["Date"]
                        if (dateHeader != null) {
                            try {
                                val formatter =
                                    SimpleDateFormat(
                                        "EEE, dd MMM yyyy HH:mm:ss Z",
                                        Locale.getDefault()
                                    )
                                val date = formatter.parse(dateHeader)
                                serverTimeCache.saveServerTime(date!!)
                            } catch (e: Exception) {
                                Timber.w(e, "Unable to parse server date header")
                            }
                        }

                        response
                    }

                    interceptors().add(loggingInterceptor)
                }
                .build()

            val gson = GsonBuilder()
                .registerTypeAdapter(
                    UnwrappedActivityLog::class.java,
                    UnwrappedActivityLogDeserializer()
                )
                .registerTypeAdapter(Scope::class.java, ScopeAdapter())
                .setDateFormat("yyyy-MM-dd'T'HH:mm:ssZ")
                .create()

            val devUrl =
                "https://7z9n2xd6a8.execute-api.ap-southeast-1.amazonaws.com/development/igloohome/"
            val prodUrl = "https://api.igloodeveloper.co/igloohome/"
            val url = if (BuildConfig.DEBUG) devUrl else prodUrl
            val retrofit = Retrofit.Builder()
                .baseUrl(url)
                .addConverterFactory(GsonConverterFactory.create(gson))
                .client(client)
                .build()

            return retrofit.create(IgloohomeApi::class.java)
        }
    }

    @GET("devices/{bluetooth_device_name}")
    suspend fun getDeviceById(
        @Path("bluetooth_device_name") bluetoothDeviceName: String,
        @Query("lock_id") showLockRef: Int = 1,
        @HeaderMap header: Map<String, String>,
    ): DeviceResponse

    @POST("devices/{bluetooth_device_name}/activity")
    suspend fun storeActivityLogs(
        @Path("bluetooth_device_name") bluetoothDeviceName: String,
        @Body body: StoreActivityLogRequest,
        @HeaderMap header: Map<String, String>,
    )

    @GET("server-health")
    suspend fun healthCheck(
        @HeaderMap header: Map<String, String>,
    ): ServerHealthResponse
}