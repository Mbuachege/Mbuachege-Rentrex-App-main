package co.igloo.access.sdk

import android.util.Base64
import co.igloo.access.sdk.api.AuthApi
import co.igloo.access.sdk.api.dto.TokenResponse
import co.igloo.access.sdk.db.CredentialStorage
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.withContext

interface AuthService {
    companion object {
        fun create(
            credentialStorage: CredentialStorage,
            authApi: AuthApi,
        ): AuthService {
            return AuthServiceImpl(credentialStorage, authApi)
        }
    }

    suspend fun refreshToken(): TokenResponse

    suspend fun authenticate(
        clientId: String,
        clientSecret: String,
        scopes: List<Scope>,
    ): TokenResponse

    suspend fun logout()
}

class AuthServiceImpl(
    private val credentialStorage: CredentialStorage,
    private val api: AuthApi,
) : AuthService {
    private var cachedClientId: String? = null
    private var cachedClientSecret: String? = null
    private var cachedScopes: List<Scope>? = null

    override suspend fun refreshToken(): TokenResponse {
        return withContext(Dispatchers.IO) {
            if (cachedClientId == null || cachedClientSecret == null || cachedScopes == null) {
                throw NotImplementedError("No credentials found")
            }

            authenticate(cachedClientId!!, cachedClientSecret!!, cachedScopes!!)
        }
    }

    override suspend fun authenticate(
        clientId: String,
        clientSecret: String,
        scopes: List<Scope>,
    ): TokenResponse {
        return withContext(Dispatchers.IO) {
            cachedClientId = clientId
            cachedClientSecret = clientSecret
            cachedScopes = scopes

            val encodedCredential = Base64.encodeToString(
                "$clientId:$clientSecret".toByteArray(), Base64.NO_WRAP
            )
            val stringScopes = scopes.joinToString(" ") { it.value }
            val response = api.requestToken("Basic $encodedCredential", stringScopes)

            credentialStorage.saveToken(response.access_token)

            return@withContext response
        }
    }

    override suspend fun logout() {
        return withContext(Dispatchers.IO) {
            credentialStorage.clear()
        }
    }
}