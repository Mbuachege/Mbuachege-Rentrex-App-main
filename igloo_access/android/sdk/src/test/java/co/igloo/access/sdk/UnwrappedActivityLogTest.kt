package co.igloo.access.sdk

import com.google.gson.GsonBuilder
import org.junit.Assert.assertEquals
import org.junit.Test

class UnwrappedActivityLogTest {
    @Test
    fun `test deserialization with additional fields`() {
        val gson = GsonBuilder()
            .registerTypeAdapter(
                UnwrappedActivityLog::class.java,
                UnwrappedActivityLogDeserializer()
            )
            .create()

        val json = """
            {
                "logType": 1,
                "entryDate": 1627812000000,
                "keyId": 42,
                "operationId": 99,
                "customField1": "CustomValue1",
                "customField2": 12345
            }
        """.trimIndent()

        val result = gson.fromJson(json, UnwrappedActivityLog::class.java)

        assertEquals(1, result.logType)
        assertEquals(1627812000000, result.entryDate)
        assertEquals(42, result.keyId)
        assertEquals(99, result.operationId)

        assertEquals(2, result.additionalFields.size)
        assertEquals("CustomValue1", result.additionalFields["customField1"])
        assertEquals(
            12345,
            result.additionalFields["customField2"]
        )
    }

    @Test
    fun `test deserialization with missing optional field`() {
        val gson = GsonBuilder()
            .registerTypeAdapter(
                UnwrappedActivityLog::class.java,
                UnwrappedActivityLogDeserializer()
            )
            .create()

        val json = """
            {
                "logType": 1,
                "entryDate": 1627812000000,
                "keyId": 42,
                "customField1": "CustomValue1"
            }
        """.trimIndent()

        val result = gson.fromJson(json, UnwrappedActivityLog::class.java)

        assertEquals(1, result.logType)
        assertEquals(1627812000000, result.entryDate)
        assertEquals(42, result.keyId)
        assertEquals(null, result.operationId) // Missing optional field should be null

        println(result.additionalFields["customField1"])
        assertEquals(1, result.additionalFields.size)
        assertEquals("CustomValue1", result.additionalFields["customField1"])
    }
}