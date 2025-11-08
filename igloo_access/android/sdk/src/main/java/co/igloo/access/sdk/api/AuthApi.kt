package co.igloo.access.sdk.api

import co.igloo.access.sdk.BuildConfig
import co.igloo.access.sdk.api.dto.TokenResponse
import com.google.gson.GsonBuilder
import okhttp3.OkHttpClient
import okhttp3.logging.HttpLoggingInterceptor
import retrofit2.Retrofit
import retrofit2.converter.gson.GsonConverterFactory
import retrofit2.http.Header
import retrofit2.http.Headers
import retrofit2.http.POST
import retrofit2.http.Query

interface AuthApi {
    companion object {
        internal fun create(): AuthApi {
            val loggingInterceptor = HttpLoggingInterceptor()
            loggingInterceptor.setLevel(HttpLoggingInterceptor.Level.BODY)

            val client = OkHttpClient.Builder().addInterceptor(loggingInterceptor).build()
            val gson = GsonBuilder().create()

            val devUrl = "https://ighpartner.auth.hooddisrupt.com/"
            val prodUrl = "https://auth.igloohome.co/"
            val url = if(BuildConfig.DEBUG) devUrl else prodUrl
            val retrofit = Retrofit.Builder().baseUrl(url)
                .addConverterFactory(GsonConverterFactory.create(gson))
                .client(client)
                .build()

            return retrofit.create(AuthApi::class.java)
        }
    }

    @Headers("Content-Type: application/x-www-form-urlencoded")
    @POST("oauth2/token")
    suspend fun requestToken(
        @Header("Authorization") authHeader: String,
        @Query("scope") scope: String,
        @Query("grant_type") grantType: String = "client_credentials",
    ): TokenResponse
}