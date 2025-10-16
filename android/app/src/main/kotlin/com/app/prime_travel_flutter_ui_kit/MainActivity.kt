package com.app.prime_travel_flutter_ui_kit

import android.Manifest
import android.os.Build
import android.os.Bundle
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import android.content.pm.PackageManager
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import co.igloo.access.sdk.IglooPlugin
import kotlinx.coroutines.*

class MainActivity : FlutterActivity() {
    private lateinit var iglooPlugin: IglooPlugin
    private val CHANNEL = "igloo_plugin_channel"
    private val scope = CoroutineScope(Dispatchers.Main + Job())

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        iglooPlugin = IglooPlugin(this.applicationContext)
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "unlock" -> {
                        val device = call.argument<String>("device") ?: ""
                        val key = call.argument<String>("key") ?: ""
                        unlock(device, key, result)
                    }
                    "getApiKey" -> {
                        try {
                            val appInfo = packageManager.getApplicationInfo(packageName, PackageManager.GET_META_DATA)
                            val apiKey = appInfo.metaData.getString("com.google.android.geo.API_KEY") ?: ""
                            result.success(apiKey)
                        } catch (e: Exception) {
                            result.error("API_KEY_ERROR", e.message, null)
                        }
                    }
                    else -> result.notImplemented()
                }
            }
    }

    private fun unlock(device: String, key: String, result: MethodChannel.Result) {
        scope.launch {
            try {
                ensurePermissions()
                iglooPlugin.unlock(device, key)
                result.success("Unlocked $device successfully")
            } catch (e: Exception) {
                result.error("UNLOCK_ERROR", e.message, null)
            }
        }
    }

    private fun ensurePermissions() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
            if (ContextCompat.checkSelfPermission(this, Manifest.permission.BLUETOOTH_CONNECT)
                != PackageManager.PERMISSION_GRANTED ||
                ContextCompat.checkSelfPermission(this, Manifest.permission.BLUETOOTH_SCAN)
                != PackageManager.PERMISSION_GRANTED
            ) {
                ActivityCompat.requestPermissions(this, arrayOf(
                    Manifest.permission.BLUETOOTH_SCAN,
                    Manifest.permission.BLUETOOTH_CONNECT
                ), 100)
            }
        } else {
            if (ContextCompat.checkSelfPermission(this, Manifest.permission.ACCESS_FINE_LOCATION)
                != PackageManager.PERMISSION_GRANTED
            ) {
                ActivityCompat.requestPermissions(this, arrayOf(
                    Manifest.permission.ACCESS_FINE_LOCATION
                ), 100)
            }
        }
    }
}
