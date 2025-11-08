package co.igloo.access.sdk.db

import android.content.Context
import android.content.SharedPreferences
import android.security.keystore.KeyGenParameterSpec
import android.security.keystore.KeyProperties
import androidx.core.content.edit
import androidx.security.crypto.EncryptedSharedPreferences
import androidx.security.crypto.MasterKey
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.withContext

const val PREFERENCES_NAME = "iglooaccess_sdk_preferences";

class EncryptedSharedPreferencesCredentialStorage(private val context: Context) :
    CredentialStorage {
    private var preferences: SharedPreferences

    init {
        val masterKey = MasterKey.Builder(context)
            .setKeyGenParameterSpec(
                KeyGenParameterSpec.Builder(
                    MasterKey.DEFAULT_MASTER_KEY_ALIAS,
                    KeyProperties.PURPOSE_ENCRYPT or KeyProperties.PURPOSE_DECRYPT
                )
                    .setEncryptionPaddings(KeyProperties.ENCRYPTION_PADDING_NONE)
                    .setBlockModes(KeyProperties.BLOCK_MODE_GCM)
                    .setKeySize(MasterKey.DEFAULT_AES_GCM_MASTER_KEY_SIZE)
                    .build()
            )
            .build()

        preferences = EncryptedSharedPreferences.create(
            context,
            PREFERENCES_NAME,
            masterKey,
            EncryptedSharedPreferences.PrefKeyEncryptionScheme.AES256_SIV,
            EncryptedSharedPreferences.PrefValueEncryptionScheme.AES256_GCM,
        )
    }

    override suspend fun hasToken(): Boolean {
        return withContext(Dispatchers.IO) {
            preferences.getString("access_token", null) != null
        }
    }

    override suspend fun getToken(): String? {
        return withContext(Dispatchers.IO) {
            preferences.getString("access_token", null)
        }
    }

    override suspend fun saveToken(authToken: String) {
        return withContext(Dispatchers.IO) {
            preferences.edit {
                putString("access_token", authToken)
                apply()
            }
        }
    }

    override suspend fun clear() {
        return withContext(Dispatchers.IO) {
            preferences.edit {
                remove("access_token")
                apply()
            }
        }
    }
}