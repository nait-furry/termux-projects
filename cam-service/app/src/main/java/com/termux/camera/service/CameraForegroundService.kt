package com.termux.camera.service

import android.Manifest
import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.Service
import android.content.Intent
import android.content.pm.PackageManager
import android.os.Build
import android.os.IBinder
import androidx.core.app.NotificationCompat
import androidx.core.content.ContextCompat

class CameraForegroundService : Service() {

    private lateinit var cameraController: CameraController
    private lateinit var commandServer: CommandServer

    override fun onCreate() {
        super.onCreate()
        createNotificationChannel()
        startForeground(NOTIFICATION_ID, buildNotification())

        cameraController = CameraController(this)
        commandServer = CommandServer(cameraController)
        commandServer.start()
    }

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        when (intent?.action) {
            ACTION_STOP -> stopSelf()
            ACTION_START_FRONT -> cameraController.startCamera(front = true)
            ACTION_SWITCH -> cameraController.switchCamera()
            ACTION_BURST -> cameraController.captureBurst(intent.getIntExtra(EXTRA_COUNT, 5))
            else -> {
                if (hasCameraPermission()) {
                    cameraController.startCamera(front = false)
                }
            }
        }
        return START_STICKY
    }

    override fun onDestroy() {
        if (::commandServer.isInitialized) commandServer.stop()
        if (::cameraController.isInitialized) cameraController.shutdown()
        super.onDestroy()
    }

    override fun onBind(intent: Intent?): IBinder? = null

    private fun hasCameraPermission(): Boolean {
        return ContextCompat.checkSelfPermission(this, Manifest.permission.CAMERA) ==
            PackageManager.PERMISSION_GRANTED
    }

    private fun buildNotification(): Notification {
        return NotificationCompat.Builder(this, CHANNEL_ID)
            .setSmallIcon(android.R.drawable.presence_video_online)
            .setContentTitle("Camera Service")
            .setContentText("Background capture active")
            .setSilent(true)
            .setOngoing(true)
            .setPriority(NotificationCompat.PRIORITY_LOW)
            .build()
    }

    private fun createNotificationChannel() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val channel = NotificationChannel(
                CHANNEL_ID,
                "Camera Service",
                NotificationManager.IMPORTANCE_LOW
            )
            getSystemService(NotificationManager::class.java).createNotificationChannel(channel)
        }
    }

    companion object {
        const val ACTION_STOP = "com.termux.camera.action.STOP"
        const val ACTION_START_FRONT = "com.termux.camera.action.START_FRONT"
        const val ACTION_SWITCH = "com.termux.camera.action.SWITCH"
        const val ACTION_BURST = "com.termux.camera.action.BURST"
        const val EXTRA_COUNT = "count"
        private const val CHANNEL_ID = "camera_service"
        private const val NOTIFICATION_ID = 1001
    }
}
