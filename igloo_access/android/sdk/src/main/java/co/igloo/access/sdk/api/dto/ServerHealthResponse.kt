package co.igloo.access.sdk.api.dto

import androidx.annotation.Keep
import co.igloo.access.sdk.Scope
import com.google.gson.annotations.SerializedName
import java.util.Date

@Keep
data class ServerHealthResponse(
    @SerializedName("isAdminLogin") val isAdminLogin: Boolean,
    @SerializedName("userRef") val userRef: String,
    @SerializedName("clientName") val clientName: String,
    @SerializedName("flow") val flow: String,
    @SerializedName("scopes") val scopes: List<Scope>,
    @SerializedName("tier") val tier: String,
    @SerializedName("endsAt") val endsAt: Date,
)
