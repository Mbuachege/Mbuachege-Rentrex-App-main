package co.igloo.access.sdk.api

import java.util.Calendar
import java.util.Date

/**
 * Interface for caching last time from API Response
 */

interface ServerTimeCache {
    companion object {
        fun create(): ServerTimeCache {
            return InMemoryServerTimeCache()
        }
    }

    fun getLastServerTime(): Date?

    fun saveServerTime(time: Date)
}

internal class InMemoryServerTimeCache : ServerTimeCache {
    private var lastUpdated: Date? = null
    private var cache: Date? = null
    private val DEFAULT_TIME_CHECK_VALIDITY: Long = 60 * 60 * 1000

    override fun getLastServerTime(): Date? {
        if (cache == null) return null
        val currentTime = Calendar.getInstance().time

        // check if offsetTime < 1 hour than current time
        val cacheInterval = (currentTime.time - lastUpdated!!.time)
        return if (cacheInterval <= DEFAULT_TIME_CHECK_VALIDITY) {
            // Find timezone offset
            val offset = cache!!.time - currentTime.time
            val offsetTime = currentTime.time + offset
            val offsetDate = Date(offsetTime)
            return offsetDate
        } else null
    }

    override fun saveServerTime(time: Date) {
        cache = time
        lastUpdated = Calendar.getInstance().time
    }
}