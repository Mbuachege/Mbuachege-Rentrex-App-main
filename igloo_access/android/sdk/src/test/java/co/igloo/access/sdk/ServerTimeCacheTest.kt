package co.igloo.access.sdk

import co.igloo.access.sdk.api.InMemoryServerTimeCache
import io.mockk.every
import io.mockk.mockk
import io.mockk.mockkStatic
import org.junit.Assert
import org.junit.Test
import java.time.Clock
import java.time.Instant
import java.util.Calendar
import java.util.Date

class ServerTimeCacheTest {
    private val oneMinuteInMillis: Long = 60 * 1000
    private val oneHourInMillis: Long = 60 * 60 * 1000
    private val instant = Instant.now(Clock.systemUTC())

    private val gmt = Date.from(instant)
    private val gmt8 = Date.from(instant.plusMillis(oneHourInMillis * 8))

    @Test
    fun `when last updated is less than 1 hour, should return cached time`() {
        val mockkCalendar = mockk<Calendar>()
        mockkStatic(Calendar::class)
        every { Calendar.getInstance() } returns mockkCalendar
        every { mockkCalendar.time } returns gmt8

        val cache = InMemoryServerTimeCache()
        cache.saveServerTime(gmt)

        val currentTime = Date.from(instant.plusMillis(oneHourInMillis))
        every { mockkCalendar.time } returns currentTime
        val cachedDate = cache.getLastServerTime()
        Assert.assertEquals(gmt, cachedDate)
    }

    @Test
    fun `when last updated is more than 1 hour, should return null`() {
        val mockkCalendar = mockk<Calendar>()
        mockkStatic(Calendar::class)
        every { Calendar.getInstance() } returns mockkCalendar
        every { mockkCalendar.time } returns gmt8

        val cache = InMemoryServerTimeCache()
        cache.saveServerTime(gmt)

        val currentTime = Date(gmt8.time + (oneHourInMillis + oneMinuteInMillis))
        every { mockkCalendar.time } returns currentTime
        val cachedDate = cache.getLastServerTime()
        Assert.assertEquals(null, cachedDate)
    }
}