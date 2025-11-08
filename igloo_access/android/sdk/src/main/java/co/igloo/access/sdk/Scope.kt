package co.igloo.access.sdk

import com.google.gson.*
import java.lang.reflect.Type

enum class Scope(val value: String) {
    ALGOPIN_PERMANENT("igloohomeapi/algopin-permanent"),
    ALGOPIN_ONETIME("igloohomeapi/algopin-onetime"),
    ALGOPIN_DAILY("igloohomeapi/algopin-daily"),
    ALGOPIN_HOURLY("igloohomeapi/algopin-hourly"),
    CREATE_PIN_BRIDGE_PROXIED_JOB("igloohomeapi/create-pin-bridge-proxied-job"),
    DELETE_PIN_BRIDGE_PROXIED_JOB("igloohomeapi/delete-pin-bridge-proxied-job"),
    LOCK_BRIDGE_PROXIED_JOB("igloohomeapi/lock-bridge-proxied-job"),
    UNLOCK_BRIDGE_PROXIED_JOB("igloohomeapi/unlock-bridge-proxied-job"),
    GET_DEVICES("igloohomeapi/get-devices"),
    GET_JOB_STATUS("igloohomeapi/get-job-status"),
    CREATE_EKEY_ACCESS("igloohomeapi/create-ekey-access"),
    GET_DEVICE_STATUS_BRIDGE_PROXIED_JOB("igloohomeapi/get-device-status-bridge-proxied-job"),
    STORE_DEVICE_ACTIVITY("igloohomeapi/store-device-activity"),
    GET_PROPERTIES("igloohomeapi/get-properties"),
    GET_ACTIVITY_LOGS_BRIDGE_PROXIED_JOB("igloohomeapi/get-activity-logs-bridge-proxied-job"),
    GET_DEVICE_ACTIVITY("igloohomeapi/get-device-activity"),
    GET_BATTERY_LEVEL_BRIDGE_PROXIED_JOB("igloohomeapi/get-battery-level-bridge-proxied-job"),
    GET_MASTER_PIN("igloohomeapi/get-master-pin"),
}

class ScopeAdapter : JsonSerializer<Scope>, JsonDeserializer<Scope> {
    override fun serialize(
        src: Scope?,
        typeOfSrc: Type?,
        context: JsonSerializationContext?
    ): JsonElement {
        return JsonPrimitive(src?.value)
    }

    override fun deserialize(
        json: JsonElement?,
        typeOfT: Type?,
        context: JsonDeserializationContext?
    ): Scope? {
        val value = json?.asString
        return Scope.entries.find { it.value == value }
    }
}


