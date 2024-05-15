package com.example.icecream

import android.content.Intent
import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity
import io.flutter.plugin.common.MethodChannel
import io.flutter.embedding.engine.FlutterEngine
import com.google.gson.Gson
import android.util.Log

class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.example.icecream/locationService"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            Log.d("MainActivity", "Method called: ${call.method}")
            when (call.method) {
                "sendTimeSets" -> {
                    val timeSetsJson = call.argument<String>("timeSets")
                    val timeSets = Gson().fromJson(timeSetsJson, Array<TimeSet>::class.java).toList()
                    val serviceIntent = Intent(this, LocationService::class.java).apply {
                        putExtra("timeSets", ArrayList(timeSets)) // ArrayList로 캐스팅
                    }
                    startForegroundService(serviceIntent)
                    result.success("Time Sets Received and Service Started")
                }
                "startService" -> {
                    val serviceIntent = Intent(this, LocationService::class.java)
                    startForegroundService(serviceIntent)
                    result.success("Service Started")
                }
                else -> {
                    result.notImplemented()
                }
            }
        }
    }
}
