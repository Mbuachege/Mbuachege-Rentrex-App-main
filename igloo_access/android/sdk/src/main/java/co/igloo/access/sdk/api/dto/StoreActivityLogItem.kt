package co.igloo.access.sdk.api.dto

import androidx.annotation.Keep
import com.google.gson.annotations.SerializedName

@Keep
data class StoreActivityLogRequest(@SerializedName("logsPayload") val logsPayload: List<String>)

@Keep
data class StoreActivityLogItem private constructor(
    @SerializedName("id") val id: String,
    @SerializedName("user") val user: String,
    @SerializedName("lockRef") val lockRef: String,
    @SerializedName("ts") val ts: Long,
    @SerializedName("payload") val payload: StoreActivityLogItemPayload,
) {
    constructor(
        user: String,
        lockRef: String,
        ts: Long,
        payload: StoreActivityLogItemPayload,
    ) : this(
        "${user}_${lockRef}_${ts}",
        user,
        lockRef,
        ts,
        payload,
    )
}

@Keep
data class StoreActivityLogItemPayload(
    @SerializedName("lockName") val lockName: String,
    @SerializedName("log") val log: String,
)