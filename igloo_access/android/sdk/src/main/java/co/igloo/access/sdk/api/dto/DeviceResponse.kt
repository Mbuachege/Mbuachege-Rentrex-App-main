package co.igloo.access.sdk.api.dto

import androidx.annotation.Keep
import com.google.gson.annotations.SerializedName
import java.util.Date

@Keep
data class DeviceResponse(
    @SerializedName("id") val id: String,
    @SerializedName("type") val type: String,
    @SerializedName("deviceId") val deviceId: String,
    @SerializedName("deviceName") val deviceName: String,
    @SerializedName("batteryLevel") val batteryLevel: Int,
    @SerializedName("pairedAt") val pairedAt: Date,
    @SerializedName("homeId") val homeId: List<String>,
    @SerializedName("linkedDevices") val linkedDevices: List<String>,
    @SerializedName("lastSync") val lastSync: Date,
    @SerializedName("admin_key") val adminKey: String,
    @SerializedName("lockRef") val deviceRef: String,
)