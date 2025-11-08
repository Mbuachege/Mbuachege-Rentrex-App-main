package com.example.igloo_access

import android.app.Activity
import android.content.Context
import androidx.annotation.NonNull
import co.igloo.access.sdk.IglooPlugin // adjust to actual SDK class name
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch

/** IglooAccessPlugin */
class IglooAccessPlugin : FlutterPlugin, MethodCallHandler, ActivityAware {

    private lateinit var channel: MethodChannel
    private var context: Context? = null
    private var activity: Activity? = null
    private var iglooPlugin: IglooPlugin? = null
    private val scope = CoroutineScope(Dispatchers.Main)

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        context = flutterPluginBinding.applicationContext
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "com.yourapp.igloo/access")
        channel.setMethodCallHandler(this)
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        when (call.method) {
            "initialize" -> initialize(result)
            "hasRequiredPermissions" -> hasRequiredPermissions(result)
            "requestBluetoothPermissions" -> requestBluetoothPermissions(result)
            "unlock" -> unlock(call, result)
            "lock" -> lock(call, result)
            "sync" -> sync(result)
            else -> result.notImplemented()
        }
    }

    private fun initialize(result: Result) {
        try {
            iglooPlugin = IglooPlugin(context!!) // adjust constructor as per SDK
            result.success(true)
        } catch (e: Exception) {
            result.error("INIT_ERROR", e.message, null)
        }
    }

    private fun hasRequiredPermissions(result: Result) {
        try {
            val hasPerms = iglooPlugin?.hasRequiredPermissions(context!!) ?: false
            result.success(hasPerms)
        } catch (e: Exception) {
            result.error("PERMISSION_CHECK_FAILED", e.message, null)
        }
    }

    private fun requestBluetoothPermissions(result: Result) {
        try {
            iglooPlugin?.requestBluetoothPermissions(activity!!) { success ->
                result.success(success)
            }
        } catch (e: Exception) {
            result.error("REQUEST_PERMISSION_ERROR", e.message, null)
        }
    }

    private fun unlock(call: MethodCall, result: Result) {
        val lockData = call.argument<String>("lockData")
        if (lockData == null) {
            result.error("INVALID_ARGUMENT", "Missing lockData", null)
            return
        }

        scope.launch {
            try {
                iglooPlugin?.unlock(lockData) { success ->
                    result.success(success)
                }
            } catch (e: Exception) {
                result.error("UNLOCK_ERROR", e.message, null)
            }
        }
    }

    private fun lock(call: MethodCall, result: Result) {
        val lockData = call.argument<String>("lockData")
        if (lockData == null) {
            result.error("INVALID_ARGUMENT", "Missing lockData", null)
            return
        }

        scope.launch {
            try {
                iglooPlugin?.lock(lockData) { success ->
                    result.success(success)
                }
            } catch (e: Exception) {
                result.error("LOCK_ERROR", e.message, null)
            }
        }
    }

    private fun sync(result: Result) {
        scope.launch {
            try {
                iglooPlugin?.sync { success ->
                    result.success(success)
                }
            } catch (e: Exception) {
                result.error("SYNC_ERROR", e.message, null)
            }
        }
    }

    // -------- FlutterPlugin lifecycle --------
    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    // -------- ActivityAware lifecycle --------
    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        activity = binding.activity
    }

    override fun onDetachedFromActivityForConfigChanges() {
        activity = null
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        activity = binding.activity
    }

    override fun onDetachedFromActivity() {
        activity = null
    }
}
