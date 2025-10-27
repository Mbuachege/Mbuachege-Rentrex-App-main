package com.app.prime_travel_flutter_ui_kit

import co.igloo.access.sdk.IglooPlugin
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import kotlinx.coroutines.*

class IglooBridge : FlutterPlugin, MethodChannel.MethodCallHandler {
    private lateinit var channel: MethodChannel
    private lateinit var iglooPlugin: IglooPlugin

    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(binding.binaryMessenger, "igloo_channel")
        channel.setMethodCallHandler(this)
        iglooPlugin = IglooPlugin(binding.applicationContext)
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        if (call.method == "unlock") {
            val deviceName = call.argument<String>("deviceName") ?: ""
            val key = call.argument<String>("key") ?: ""

            GlobalScope.launch(Dispatchers.IO) {
                try {
                    iglooPlugin.unlock(deviceName, key)
                    withContext(Dispatchers.Main) {
                        result.success("Unlocked successfully")
                    }
                } catch (e: Exception) {
                    withContext(Dispatchers.Main) {
                        result.error("UNLOCK_ERROR", e.message, null)
                    }
                }
            }
        } else {
            result.notImplemented()
        }
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {}
}
