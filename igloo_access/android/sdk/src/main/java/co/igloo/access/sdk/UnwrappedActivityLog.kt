package co.igloo.access.sdk

import com.google.gson.Gson
import com.google.gson.JsonDeserializationContext
import com.google.gson.JsonDeserializer
import com.google.gson.JsonElement
import java.lang.reflect.Type

data class UnwrappedActivityLog(
    val logType: Int,
    val entryDate: Long,
    val keyId: Int,
    val operationId: Int? = null,
    val additionalFields: Map<String, Any>,
)

class UnwrappedActivityLogDeserializer : JsonDeserializer<UnwrappedActivityLog> {
    override fun deserialize(
        json: JsonElement,
        typeOfT: Type,
        context: JsonDeserializationContext,
    ): UnwrappedActivityLog {
        val gson = Gson()
        val jsonObject = json.asJsonObject
        val knownFields =
            UnwrappedActivityLog::class.java.declaredFields.map { it.name }.associateWith { true }
        val additionalFieldsMap = mutableMapOf<String, Any>()
        for ((key, value) in jsonObject.entrySet()) {
            val hasKey = knownFields[key] ?: false
            if (!hasKey) {
                additionalFieldsMap[key] = when {
                    value.isJsonNull -> null
                    value.isJsonPrimitive -> {
                        val primitive = value.asJsonPrimitive
                        when {
                            primitive.isBoolean -> primitive.asBoolean as Any
                            primitive.isNumber -> {
                                val number = primitive.asNumber
                                when {
                                    number.toDouble() % 1 == 0.0 -> {
                                        val longValue = number.toLong()
                                        if (longValue in Int.MIN_VALUE..Int.MAX_VALUE) longValue.toInt() else longValue
                                    }

                                    else -> number.toDouble()
                                }
                            }

                            primitive.isString -> primitive.asString
                            else -> primitive.toString()
                        }
                    }

                    value.isJsonArray -> value.asJsonArray.map {
                        context.deserialize<Any>(it, Any::class.java)
                    }

                    value.isJsonObject -> context.deserialize<Map<String, Any>>(
                        value,
                        Map::class.java
                    )

                    else -> value.toString()
                } as Any
            }
        }

        val instance = gson.fromJson(json, UnwrappedActivityLog::class.java)
        return instance.copy(additionalFields = additionalFieldsMap)
    }
}
