package com.termux.camera.ui

import android.Manifest
import android.app.Activity
import android.content.Intent
import android.content.pm.PackageManager
import android.os.Build
import android.os.Bundle
import android.view.Gravity
import android.widget.Button
import android.widget.EditText
import android.widget.LinearLayout
import android.widget.ScrollView
import android.widget.TextView
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import com.termux.camera.service.CameraForegroundService
import com.termux.camera.shell.ShellApi

class ScriptConsoleActivity : Activity() {

    private lateinit var logView: TextView
    private lateinit var commandInput: EditText
    private val shellApi = ShellApi()

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        requestRuntimePermissions()
        buildUi()
    }

    private fun buildUi() {
        val root = LinearLayout(this).apply {
            orientation = LinearLayout.VERTICAL
            setPadding(24, 24, 24, 24)
        }

        val toolbar = LinearLayout(this).apply {
            orientation = LinearLayout.HORIZONTAL
            gravity = Gravity.CENTER_VERTICAL
        }

        val start = Button(this).apply {
            text = "Start"
            setOnClickListener { startCameraService() }
        }
        val stop = Button(this).apply {
            text = "Stop"
            setOnClickListener {
                stopService(Intent(this@ScriptConsoleActivity, CameraForegroundService::class.java))
                appendLog("service stop requested")
            }
        }
        val burst = Button(this).apply {
            text = "Burst"
            setOnClickListener { sendCommand("burst 5") }
        }
        val switch = Button(this).apply {
            text = "Switch"
            setOnClickListener { sendCommand("switch") }
        }
        toolbar.addView(start)
        toolbar.addView(stop)
        toolbar.addView(burst)
        toolbar.addView(switch)
        root.addView(toolbar)

        commandInput = EditText(this).apply {
            hint = "start, front, back, switch, burst 10, stop"
            setSingleLine(false)
            minLines = 3
        }
        root.addView(commandInput)

        val run = Button(this).apply {
            text = "Run Command"
            setOnClickListener { sendCommand(commandInput.text.toString()) }
        }
        root.addView(run)

        logView = TextView(this).apply {
            textSize = 14f
            setTextIsSelectable(true)
        }
        val scroll = ScrollView(this).apply {
            addView(logView)
        }
        root.addView(
            scroll,
            LinearLayout.LayoutParams(
                LinearLayout.LayoutParams.MATCH_PARENT,
                0,
                1f
            )
        )
        setContentView(root)
    }

    private fun startCameraService() {
        val intent = Intent(this, CameraForegroundService::class.java)
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            ContextCompat.startForegroundService(this, intent)
        } else {
            startService(intent)
        }
        appendLog("service start requested")
    }

    private fun sendCommand(command: String) {
        Thread {
            val result = try {
                shellApi.send(command)
            } catch (error: Exception) {
                "command failed: ${error.message}"
            }
            runOnUiThread { appendLog("> $command\n$result") }
        }.start()
    }

    private fun appendLog(message: String) {
        logView.append(message.trim() + "\n\n")
    }

    private fun requestRuntimePermissions() {
        val permissions = buildList {
            add(Manifest.permission.CAMERA)
            add(Manifest.permission.RECORD_AUDIO)
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
                add(Manifest.permission.POST_NOTIFICATIONS)
            }
        }.filter {
            ContextCompat.checkSelfPermission(this, it) != PackageManager.PERMISSION_GRANTED
        }
        if (permissions.isNotEmpty()) {
            ActivityCompat.requestPermissions(this, permissions.toTypedArray(), 10)
        }
    }
}
