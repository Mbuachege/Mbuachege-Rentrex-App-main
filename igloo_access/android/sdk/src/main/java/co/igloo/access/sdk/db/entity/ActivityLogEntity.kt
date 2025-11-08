package co.igloo.access.sdk.db.entity

import androidx.annotation.Keep
import androidx.room.ColumnInfo
import androidx.room.Entity
import androidx.room.PrimaryKey
import co.igloohome.ble.lock.ActivityLog
import java.util.Calendar
import java.util.Date

@Keep
@Entity(tableName = "activity_logs")
data class ActivityLogEntity(
    @PrimaryKey(autoGenerate = true)
    val uid: Int = 0,
    @ColumnInfo(name="userRef")
    val userRef: String,
    @ColumnInfo(name = "lockRef")
    val lockRef: String,
    @ColumnInfo(name = "bluetoothDeviceName")
    val bluetoothDeviceName: String,
    @ColumnInfo(name = "log")
    val log: String,
    @ColumnInfo(name = "created_at")
    val createdAt: Date,
)

fun ActivityLog.toEntity(
    userRef: String,
    lockRef: String,
    bluetoothDeviceName: String,
): ActivityLogEntity {
    return ActivityLogEntity(
        log = log,
        lockRef = lockRef,
        bluetoothDeviceName = bluetoothDeviceName,
        userRef = userRef,
        createdAt = Calendar.getInstance().time
    )
}
