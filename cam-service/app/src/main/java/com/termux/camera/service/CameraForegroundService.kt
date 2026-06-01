package com.termux.camera.service

import android.Manifest
import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.app.Service
import android.content.ComponentName
import android.content.Intent
import android.content.pm.PackageManager
import android.os.Build
import android.os.Handler
import android.os.IBinder
import android.os.Looper
import android.service.quicksettings.TileService
import androidx.core.app.NotificationCompat
import androidx.core.content.ContextCompat

class CameraForegroundService : Service() {

    private lateinit var cameraController: CameraController
    private lateinit var burstScheduler: BurstScheduler
    private lateinit var settings: CameraSettings
    private val switchHandler = Handler(Looper.getMainLooper())
    private val switchRunnable = object : Runnable {
        override fun run() {
            if (!isRunning || !settings.autoCameraSelection) return
            cameraController.switchCamera()
            switchHandler.postDelayed(this, settings.cameraSwitchIntervalSeconds * 1_000L)
        }
    }

    override fun onCreate() {
        super.onCreate()
        isRunning = true
        createNotificationChannel()
        startForeground(NOTIFICATION_ID, buildNotification())

        settings = CameraSettings(this)
        cameraController = CameraController(this)
        burstScheduler = BurstScheduler(cameraController)
        requestTileUpdate()
    }

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        when (intent?.action) {
            ACTION_STOP -> stopSelf()
            ACTION_START_FRONT -> {
                cameraController.startCamera(front = true)
                applyConfiguredRuntime()
            }
            ACTION_START_BACK -> {
                cameraController.startCamera(front = false)
                applyConfiguredRuntime()
            }
            ACTION_SWITCH -> cameraController.switchCamera()
            ACTION_CAPTURE -> cameraController.captureBurst(1)
            ACTION_BURST -> cameraController.captureBurst(intent.getIntExtra(EXTRA_COUNT, 5))
            ACTION_START_VIDEO -> cameraController.startVideo()
            ACTION_STOP_VIDEO -> cameraController.stopVideo()
            ACTION_SET_RATE -> {
                settings.captureIntervalSeconds = intent.getIntExtra(EXTRA_SECONDS, settings.captureIntervalSeconds)
                applyConfiguredRuntime()
            }
            ACTION_SET_MODE -> {
                settings.captureMode = intent.getStringExtra(EXTRA_MODE).orEmpty()
                applyConfiguredRuntime()
            }
            ACTION_SET_RESOLUTION -> {
                settings.resolution = intent.getStringExtra(EXTRA_RESOLUTION).orEmpty()
                cameraController.stopCamera()
                cameraController.startCamera(front = false)
                applyConfiguredRuntime()
            }
            else -> {
                if (hasCameraPermission()) {
                    cameraController.startCamera(front = false)
                    applyConfiguredRuntime()
                }
            }
        }
        return START_STICKY
    }

    override fun onDestroy() {
        isRunning = false
        switchHandler.removeCallbacksAndMessages(null)
        if (::burstScheduler.isInitialized) burstScheduler.shutdown()
        if (::cameraController.isInitialized) cameraController.shutdown()
        requestTileUpdate()
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
            .addAction(
                android.R.drawable.ic_menu_camera,
                "Capture",
                servicePendingIntent(ACTION_CAPTURE, 1)
            )
            .addAction(
                android.R.drawable.ic_menu_rotate,
                "Switch",
                servicePendingIntent(ACTION_SWITCH, 2)
            )
            .addAction(
                android.R.drawable.presence_video_online,
                "Start Video",
                servicePendingIntent(ACTION_START_VIDEO, 3)
            )
            .addAction(
                android.R.drawable.presence_video_busy,
                "Stop Video",
                servicePendingIntent(ACTION_STOP_VIDEO, 4)
            )
            .addAction(
                android.R.drawable.ic_menu_close_clear_cancel,
                "Stop Service",
                servicePendingIntent(ACTION_STOP, 5)
            )
            .build()
    }

    private fun servicePendingIntent(action: String, requestCode: Int): PendingIntent {
        val flags = PendingIntent.FLAG_UPDATE_CURRENT or
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) PendingIntent.FLAG_IMMUTABLE else 0
        return PendingIntent.getService(
            this,
            requestCode,
            Intent(this, CameraForegroundService::class.java).setAction(action),
            flags
        )
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

    private fun applyConfiguredRuntime() {
        burstScheduler.stop()
        switchHandler.removeCallbacks(switchRunnable)

        if (settings.captureMode == CameraSettings.MODE_VIDEO) {
            cameraController.startVideo()
        } else {
            cameraController.stopVideo()
            burstScheduler.start(
                settings.captureIntervalSeconds * 1_000L,
                settings.burstCount
            )
        }

        if (settings.autoCameraSelection) {
            switchHandler.postDelayed(
                switchRunnable,
                settings.cameraSwitchIntervalSeconds * 1_000L
            )
        }
    }

    private fun requestTileUpdate() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
            TileService.requestListeningState(
                this,
                ComponentName(this, com.termux.camera.tiles.CameraTileService::class.java)
            )
        }
    }

    companion object {
        const val ACTION_STOP = "com.termux.camera.action.STOP"
        const val ACTION_START_FRONT = "com.termux.camera.action.START_FRONT"
        const val ACTION_START_BACK = "com.termux.camera.action.START_BACK"
        const val ACTION_SWITCH = "com.termux.camera.action.SWITCH"
        const val ACTION_CAPTURE = "com.termux.camera.action.CAPTURE"
        const val ACTION_BURST = "com.termux.camera.action.BURST"
        const val ACTION_START_VIDEO = "com.termux.camera.action.START_VIDEO"
        const val ACTION_STOP_VIDEO = "com.termux.camera.action.STOP_VIDEO"
        const val ACTION_SET_RATE = "com.termux.camera.action.SET_RATE"
        const val ACTION_SET_MODE = "com.termux.camera.action.SET_MODE"
        const val ACTION_SET_RESOLUTION = "com.termux.camera.action.SET_RESOLUTION"
        const val EXTRA_COUNT = "count"
        const val EXTRA_SECONDS = "seconds"
        const val EXTRA_MODE = "mode"
        const val EXTRA_RESOLUTION = "resolution"
        @Volatile var isRunning: Boolean = false
            private set
        private const val CHANNEL_ID = "camera_service"
        private const val NOTIFICATION_ID = 1001
    }
}
