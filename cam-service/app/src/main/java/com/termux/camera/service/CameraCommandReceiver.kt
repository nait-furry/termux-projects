package com.termux.camera.service

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.os.Build
import androidx.core.content.ContextCompat

class CameraCommandReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        val serviceIntent = Intent(context, CameraForegroundService::class.java)
        when (intent.action) {
            ACTION_START -> serviceIntent.setAction(null)
            ACTION_STOP -> {
                context.stopService(serviceIntent)
                return
            }
            ACTION_FRONT -> serviceIntent.setAction(CameraForegroundService.ACTION_START_FRONT)
            ACTION_BACK -> serviceIntent.setAction(CameraForegroundService.ACTION_START_BACK)
            ACTION_SWITCH -> serviceIntent.setAction(CameraForegroundService.ACTION_SWITCH)
            ACTION_CAPTURE -> serviceIntent.setAction(CameraForegroundService.ACTION_CAPTURE)
            ACTION_BURST -> serviceIntent
                .setAction(CameraForegroundService.ACTION_BURST)
                .putExtra(
                    CameraForegroundService.EXTRA_COUNT,
                    intent.getIntExtra(CameraForegroundService.EXTRA_COUNT, CameraSettings.DEFAULT_BURST_COUNT)
                )
            ACTION_START_VIDEO -> serviceIntent.setAction(CameraForegroundService.ACTION_START_VIDEO)
            ACTION_STOP_VIDEO -> serviceIntent.setAction(CameraForegroundService.ACTION_STOP_VIDEO)
            ACTION_SET_RATE -> serviceIntent
                .setAction(CameraForegroundService.ACTION_SET_RATE)
                .putExtra(
                    CameraForegroundService.EXTRA_SECONDS,
                    intent.getIntExtra(
                        CameraForegroundService.EXTRA_SECONDS,
                        CameraSettings.DEFAULT_CAPTURE_INTERVAL_SECONDS
                    )
                )
            ACTION_SET_MODE -> serviceIntent
                .setAction(CameraForegroundService.ACTION_SET_MODE)
                .putExtra(
                    CameraForegroundService.EXTRA_MODE,
                    intent.getStringExtra(CameraForegroundService.EXTRA_MODE)
                )
            ACTION_SET_RESOLUTION -> serviceIntent
                .setAction(CameraForegroundService.ACTION_SET_RESOLUTION)
                .putExtra(
                    CameraForegroundService.EXTRA_RESOLUTION,
                    intent.getStringExtra(CameraForegroundService.EXTRA_RESOLUTION)
                )
            else -> return
        }

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            ContextCompat.startForegroundService(context, serviceIntent)
        } else {
            context.startService(serviceIntent)
        }
    }

    companion object {
        const val ACTION_START = "com.termux.camera.START"
        const val ACTION_STOP = "com.termux.camera.STOP"
        const val ACTION_FRONT = "com.termux.camera.FRONT"
        const val ACTION_BACK = "com.termux.camera.BACK"
        const val ACTION_SWITCH = "com.termux.camera.SWITCH"
        const val ACTION_CAPTURE = "com.termux.camera.CAPTURE"
        const val ACTION_BURST = "com.termux.camera.BURST"
        const val ACTION_START_VIDEO = "com.termux.camera.START_VIDEO"
        const val ACTION_STOP_VIDEO = "com.termux.camera.STOP_VIDEO"
        const val ACTION_SET_RATE = "com.termux.camera.SET_RATE"
        const val ACTION_SET_MODE = "com.termux.camera.SET_MODE"
        const val ACTION_SET_RESOLUTION = "com.termux.camera.SET_RESOLUTION"
    }
}
