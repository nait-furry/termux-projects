package com.termux.camera.ui

import android.app.Activity
import android.os.Bundle
import android.widget.TextView

class SettingsActivity : Activity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(
            TextView(this).apply {
                text = "Camera Service stores photos in Pictures/CameraService and videos in the app Movies directory."
                textSize = 18f
                setPadding(32, 32, 32, 32)
            }
        )
    }
}
