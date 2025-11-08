package co.igloo.access.sdk.db

import android.content.Context
import androidx.room.Dao
import androidx.room.Database
import androidx.room.Insert
import androidx.room.Query
import androidx.room.Room
import androidx.room.RoomDatabase
import androidx.room.TypeConverter
import androidx.room.TypeConverters
import co.igloo.access.sdk.db.entity.ActivityLogEntity
import java.util.Date

const val DB_NAME = "iglooaccess_sdk_db";

@Database(entities = [ActivityLogEntity::class], version = 1)
@TypeConverters(DateConverter::class)
abstract class IglooAccessDb : RoomDatabase() {
    companion object {
        fun create(context: Context): IglooAccessDb {
            return Room.databaseBuilder(
                context,
                IglooAccessDb::class.java, DB_NAME
            ).build()
        }
    }

    abstract fun activityLogDao(): ActivityLogDao
}

@Dao
interface ActivityLogDao {
    @Insert
    suspend fun saveActivityLog(activityLog: ActivityLogEntity): Long

    @Query("SELECT * FROM activity_logs ORDER BY created_at ASC")
    suspend fun getActivityLogs(): List<ActivityLogEntity>

    @Query("DELETE FROM activity_logs WHERE uid = :uid")
    suspend fun deleteActivityLogById(uid: Long)

    @Query("DELETE FROM activity_logs WHERE uid IN (:uids)")
    suspend fun deleteMultipleActivityLogById(uids: List<Long>)
}

object DateConverter {
    @TypeConverter
    fun toDate(dateLong: Long?): Date? {
        return if (dateLong == null) null else Date(dateLong)
    }

    @TypeConverter
    fun fromDate(date: Date?): Long? {
        return date?.time
    }
}
