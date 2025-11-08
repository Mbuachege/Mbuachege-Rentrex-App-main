package co.igloo.access.sdk.db

import android.content.Context

interface CredentialStorage {
    companion object {
        fun create(): CredentialStorage {
            return InMemoryTokenStorage()
        }

        fun createEncryptedSharedPreferencesImpl(context: Context): CredentialStorage {
            return EncryptedSharedPreferencesCredentialStorage(context)
        }
    }

    suspend fun hasToken(): Boolean

    suspend fun getToken(): String?

    suspend fun saveToken(authToken: String)

    suspend fun clear()
}