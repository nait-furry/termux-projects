package com.termux.camera.ui

import android.Manifest
import android.app.Activity
import android.content.pm.PackageManager
import android.os.Build
import android.os.Bundle
import android.text.InputType
import android.view.ViewGroup
import android.widget.AdapterView
import android.widget.ArrayAdapter
import android.widget.EditText
import android.widget.LinearLayout
import android.widget.ScrollView
import android.widget.Spinner
import android.widget.Switch
import android.widget.TextView
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import com.termux.camera.service.CameraSettings

class SettingsActivity : Activity() {
    private lateinit var settings: CameraSettings

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        settings = CameraSettings(this)
        requestRuntimePermissions()
        buildUi()
    }

    private fun buildUi() {
        val root = LinearLayout(this).apply {
            orientation = LinearLayout.VERTICAL
            setPadding(32, 32, 32, 32)
        }

        root.addView(title("Camera Service Settings"))
        root.addView(modeSpinner())
        root.addView(numberField("Burst count", settings.burstCount) { settings.burstCount = it })
        root.addView(
            numberField("Capture interval seconds", settings.captureIntervalSeconds) {
                settings.captureIntervalSeconds = it
            }
        )
        root.addView(
            numberField("Camera switching interval seconds", settings.cameraSwitchIntervalSeconds) {
                settings.cameraSwitchIntervalSeconds = it
            }
        )
        root.addView(resolutionSpinner())
        root.addView(autoSelectionSwitch())
        root.addView(
            TextView(this).apply {
                text = "Use the Quick Settings tile or broadcast intents for routine headless operation."
                textSize = 14f
                setPadding(0, 24, 0, 0)
            }
        )

        setContentView(
            ScrollView(this).apply {
                addView(root)
            }
        )
    }

    private fun title(text: String): TextView {
        return TextView(this).apply {
            this.text = text
            textSize = 22f
            setPadding(0, 0, 0, 24)
        }
    }

    private fun modeSpinner(): LinearLayout {
        val values = listOf(CameraSettings.MODE_PHOTO, CameraSettings.MODE_VIDEO)
        return spinnerRow("Capture mode", values, settings.captureMode) {
            settings.captureMode = it
        }
    }

    private fun resolutionSpinner(): LinearLayout {
        val values = listOf(
            CameraSettings.RESOLUTION_LOW,
            CameraSettings.RESOLUTION_MEDIUM,
            CameraSettings.RESOLUTION_HIGH
        )
        return spinnerRow("Resolution", values, settings.resolution) {
            settings.resolution = it
        }
    }

    private fun spinnerRow(
        label: String,
        values: List<String>,
        selected: String,
        onSelected: (String) -> Unit
    ): LinearLayout {
        val spinner = Spinner(this).apply {
            adapter = ArrayAdapter(
                this@SettingsActivity,
                android.R.layout.simple_spinner_dropdown_item,
                values
            )
            setSelection(values.indexOf(selected).coerceAtLeast(0))
            onItemSelectedListener = object : AdapterView.OnItemSelectedListener {
                override fun onItemSelected(
                    parent: AdapterView<*>?,
                    view: android.view.View?,
                    position: Int,
                    id: Long
                ) {
                    onSelected(values[position])
                }

                override fun onNothingSelected(parent: AdapterView<*>?) = Unit
            }
        }
        return row(label, spinner)
    }

    private fun numberField(
        label: String,
        value: Int,
        onChanged: (Int) -> Unit
    ): LinearLayout {
        val input = EditText(this).apply {
            setText(value.toString())
            inputType = InputType.TYPE_CLASS_NUMBER
            setSingleLine(true)
            setOnFocusChangeListener { _, hasFocus ->
                if (!hasFocus) {
                    onChanged(text.toString().toIntOrNull() ?: value)
                }
            }
        }
        return row(label, input)
    }

    private fun autoSelectionSwitch(): LinearLayout {
        val toggle = Switch(this).apply {
            text = if (settings.autoCameraSelection) "Enabled" else "Disabled"
            isChecked = settings.autoCameraSelection
            setOnCheckedChangeListener { _, checked ->
                settings.autoCameraSelection = checked
                text = if (checked) "Enabled" else "Disabled"
            }
        }
        return row("Auto camera selection", toggle)
    }

    private fun row(label: String, control: android.view.View): LinearLayout {
        return LinearLayout(this).apply {
            orientation = LinearLayout.VERTICAL
            setPadding(0, 0, 0, 20)
            addView(
                TextView(this@SettingsActivity).apply {
                    text = label
                    textSize = 14f
                }
            )
            addView(
                control,
                LinearLayout.LayoutParams(
                    ViewGroup.LayoutParams.MATCH_PARENT,
                    ViewGroup.LayoutParams.WRAP_CONTENT
                )
            )
        }
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
