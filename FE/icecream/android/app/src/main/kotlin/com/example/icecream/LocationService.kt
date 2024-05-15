package com.example.icecream

import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.Service
import android.content.Intent
import android.location.Location
import android.location.LocationListener
import android.location.LocationManager
import android.os.Build
import android.os.Bundle
import android.os.IBinder
import android.util.Log
import androidx.core.app.NotificationCompat
import androidx.core.content.ContextCompat
import android.content.pm.PackageManager
import com.rabbitmq.client.ConnectionFactory
import com.rabbitmq.client.Channel
import com.rabbitmq.client.Connection
import java.text.SimpleDateFormat
import java.util.*
import kotlin.concurrent.fixedRateTimer
import okhttp3.OkHttpClient
import okhttp3.Request
import org.json.JSONObject
import java.io.IOException
import android.content.Context

class LocationService : Service() {
    private lateinit var locationManager: LocationManager
    private lateinit var locationListener: LocationListener
    private var timer: Timer? = null
    private var isWithinTimeRange = false
    private var destinationId = -1

    private var connection: Connection? = null
    private var channel: Channel? = null

    companion object {
        private const val CHANNEL_ID = "LocationServiceChannel"
    }

    private fun createNotificationChannel() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val channel = NotificationChannel(
                CHANNEL_ID,
                "Location Service Channel",
                NotificationManager.IMPORTANCE_DEFAULT
            )
            channel.description = "Channel for Location Service"
            val notificationManager = getSystemService(NotificationManager::class.java)
            notificationManager?.createNotificationChannel(channel)
        }
    }

    override fun onCreate() {
        super.onCreate()
        Log.d("LocationService", "Service onCreate")
        createNotificationChannel()
        val notification: Notification = NotificationCompat.Builder(this, CHANNEL_ID)
            .setContentTitle("Location Service")
            .setContentText("Running...")
            .setSmallIcon(R.drawable.ic_notification)
            .build()

        startForeground(1, notification)
        initializeRabbitMQ()
        initializeLocationManager()
        fetchTimeSettingsAndScheduleUpdates()
    }

    private fun initializeLocationManager() {
        locationManager = getSystemService(LOCATION_SERVICE) as LocationManager
        locationListener = object : LocationListener {
            override fun onLocationChanged(location: Location) {
                if (isWithinTimeRange) {
                    sendLocationToRabbitMQ(location, destinationId)
                } else {
                    sendLocationToRabbitMQ(location, -1)
                }
            }

            override fun onStatusChanged(provider: String?, status: Int, extras: Bundle?) {}
            override fun onProviderEnabled(provider: String) {}
            override fun onProviderDisabled(provider: String) {}
        }

        if (ContextCompat.checkSelfPermission(this, android.Manifest.permission.ACCESS_FINE_LOCATION) != PackageManager.PERMISSION_GRANTED &&
            ContextCompat.checkSelfPermission(this, android.Manifest.permission.ACCESS_COARSE_LOCATION) != PackageManager.PERMISSION_GRANTED) {
            Log.e("LocationService", "Permission not granted")
            stopSelf()
        } else {
            locationManager.requestLocationUpdates(LocationManager.GPS_PROVIDER, 5000, 10f, locationListener)
            Log.d("LocationService", "Location updates requested")
        }
    }

    private fun initializeRabbitMQ() {
        val factory = ConnectionFactory().apply {
            host = "k10e202.p.ssafy.io"
            port = 5672
        }

        try {
            connection = factory.newConnection()
            channel = connection!!.createChannel()
            channel!!.exchangeDeclare("crosswalk", "direct", true)
        } catch (e: Exception) {
            Log.e("LocationService", "Failed to connect to RabbitMQ", e)
        }
    }

    private fun sendLocationToRabbitMQ(location: Location, destinationId: Int) {
        val userId = getUserIdFromStorage()
        val message = String.format(
            "{\"latitude\": %.6f, \"longitude\": %.6f, \"userId\": %s, \"destinationId\": %d}",
            location.latitude, location.longitude, userId, destinationId
        )
        try {
            channel?.basicPublish("exchange_name", "routing_key", null, message.toByteArray())
            Log.d("LocationService", "Location sent to RabbitMQ")
        } catch (e: Exception) {
            Log.e("LocationService", "Failed to send message to RabbitMQ", e)
        }
    }

    private fun fetchTimeSettingsAndScheduleUpdates() {
        val userId = getUserIdFromStorage()
        val accessToken = getAccessTokenFromStorage()  // Assumes you have a method to retrieve the stored access token
        val client = OkHttpClient()
        val request = Request.Builder()
            .url("http://k10e202.p.ssafy.io:8080/api/destination?user_id=$userId")
            .addHeader("Authorization", "Bearer $accessToken")
            .build()

        client.newCall(request).enqueue(object : okhttp3.Callback {
            override fun onFailure(call: okhttp3.Call, e: IOException) {
                Log.e("LocationService", "API call failed: $e")
            }

            override fun onResponse(call: okhttp3.Call, response: okhttp3.Response) {
                response.use { res ->
                    if (!res.isSuccessful) throw IOException("Unexpected code $response")

                    val jsonData = res.body?.string()
                    val jsonObject = JSONObject(jsonData)
                    val dataArray = jsonObject.getJSONArray("data")

                    for (i in 0 until dataArray.length()) {
                        val item = dataArray.getJSONObject(i)
                        val startTime = item.getString("start_time")
                        val endTime = item.getString("end_time")
                        scheduleLocationUpdatesBasedOnTimeSettings(startTime, endTime)
                    }
                }
            }
        })
    }

    private fun getUserIdFromStorage(): String {
        val sharedPref = getSharedPreferences("AppData", Context.MODE_PRIVATE)
        return sharedPref.getString("userId", "defaultUserId") ?: "defaultUserId"
    }

    private fun getAccessTokenFromStorage(): String {
        val sharedPref = getSharedPreferences("AppData", Context.MODE_PRIVATE)
        return sharedPref.getString("accessToken", "") ?: ""
    }

    private fun scheduleLocationUpdatesBasedOnTimeSettings(startTime: String, endTime: String) {
        val currentTime = getCurrentTime()
        isWithinTimeRange = currentTime >= startTime && currentTime <= endTime
        if (isWithinTimeRange) {
            startFrequentLocationUpdates()
        } else {
            startInfrequentLocationUpdates()
        }
    }

    private fun getCurrentTime(): String {
        val calendar = Calendar.getInstance()
        return SimpleDateFormat("HH:mm", Locale.getDefault()).format(calendar.time)
    }

    private fun startFrequentLocationUpdates() {
        locationManager.requestLocationUpdates(LocationManager.GPS_PROVIDER, 1000, 0f, locationListener)
        Log.d("LocationService", "Started frequent location updates every 1 second")
    }

    private fun startInfrequentLocationUpdates() {
        locationManager.requestLocationUpdates(LocationManager.GPS_PROVIDER, 900000, 0f, locationListener)
        Log.d("LocationService", "Started infrequent location updates every 15 minutes")
    }

    override fun onDestroy() {
        super.onDestroy()
        locationManager.removeUpdates(locationListener)
        timer?.cancel()
        try {
            channel?.close()
            connection?.close()
        } catch (e: Exception) {
            Log.e("LocationService", "Failed to close RabbitMQ connection", e)
        }
    }

    override fun onBind(intent: Intent?): IBinder? {
        return null
    }
}
