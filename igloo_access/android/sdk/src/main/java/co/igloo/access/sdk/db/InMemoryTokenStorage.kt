package co.igloo.access.sdk.db

internal class InMemoryTokenStorage : CredentialStorage {
    private var token: String? = null

    override suspend fun hasToken(): Boolean = token != null

    override suspend fun getToken(): String? = token

    override suspend fun saveToken(authToken: String) {
        this.token = authToken
    }

    override suspend fun clear() {
        token = null
    }
}