package com.termux.camera.service

import android.content.Context
import android.content.SharedPreferences
import android.util.Size

class CameraSettings(context: Context) {
    private val prefs: SharedPreferences =
        context.getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)

    var captureMode: String
        get() = prefs.getString(KEY_CAPTURE_MODE, MODE_PHOTO) ?: MODE_PHOTO
        set(value) {
            prefs.edit().putString(
                KEY_CAPTURE_MODE,
                if (value == MODE_VIDEO) MODE_VIDEO else MODE_PHOTO
            ).apply()
        }

    var burstCount: Int
        get() = prefs.getInt(KEY_BURST_COUNT, DEFAULT_BURST_COUNT)
        set(value) {
            prefs.edit().putInt(KEY_BURST_COUNT, value.coerceIn(1, 50)).apply()
        }

    var captureIntervalSeconds: Int
        get() = prefs.getInt(KEY_CAPTURE_INTERVAL_SECONDS, DEFAULT_CAPTURE_INTERVAL_SECONDS)
        set(value) {
            prefs.edit().putInt(KEY_CAPTURE_INTERVAL_SECONDS, value.coerceAtLeast(1)).apply()
        }

    var cameraSwitchIntervalSeconds: Int
        get() = prefs.getInt(KEY_CAMERA_SWITCH_INTERVAL_SECONDS, DEFAULT_CAMERA_SWITCH_INTERVAL_SECONDS)
        set(value) {
            prefs.edit().putInt(KEY_CAMERA_SWITCH_INTERVAL_SECONDS, value.coerceAtLeast(1)).apply()
        }

    var resolution: String
        get() = prefs.getString(KEY_RESOLUTION, RESOLUTION_HIGH) ?: RESOLUTION_HIGH
        set(value) {
            prefs.edit().putString(
                KEY_RESOLUTION,
                when (value) {
                    RESOLUTION_LOW, RESOLUTION_MEDIUM -> value
                    else -> RESOLUTION_HIGH
                }
            ).apply()
        }

    var autoCameraSelection: Boolean
        get() = prefs.getBoolean(KEY_AUTO_CAMERA_SELECTION, true)
        set(value) {
            prefs.edit().putBoolean(KEY_AUTO_CAMERA_SELECTION, value).apply()
        }

    fun maxJpegSize(): Size {
        return when (resolution) {
            RESOLUTION_LOW -> Size(640, 480)
            RESOLUTION_MEDIUM -> Size(1280, 720)
            else -> Size(1920, 1080)
        }
    }

    companion object {
        const val MODE_PHOTO = "photo"
        const val MODE_VIDEO = "video"
        const val RESOLUTION_LOW = "low"
        const val RESOLUTION_MEDIUM = "medium"
        const val RESOLUTION_HIGH = "high"

        const val DEFAULT_BURST_COUNT = 5
        const val DEFAULT_CAPTURE_INTERVAL_SECONDS = 15
        const val DEFAULT_CAMERA_SWITCH_INTERVAL_SECONDS = 15

        private const val PREFS_NAME = "camera_settings"
        private const val KEY_CAPTURE_MODE = "capture_mode"
        private const val KEY_BURST_COUNT = "burst_count"
        private const val KEY_CAPTURE_INTERVAL_SECONDS = "capture_interval_seconds"
        private const val KEY_CAMERA_SWITCH_INTERVAL_SECONDS = "camera_switch_interval_seconds"
        private const val KEY_RESOLUTION = "resolution"
        private const val KEY_AUTO_CAMERA_SELECTION = "auto_camera_selection"
    }
}
