package co.igloo.access.sdk.api.dto

import androidx.annotation.Keep
import co.igloo.access.sdk.UnwrappedActivityLog

@Keep
data class RetrieveActivityLogResponse(val activityLogs: List<UnwrappedActivityLog>)
