# Android Camera2 Foreground Service Template

## Objective

Build a production-grade Android Kotlin template for:

- Persistent foreground camera service
- Dual camera switching (front/back)
- Burst image capture
- Background operation over other apps
- Quick Settings tile control
- Scriptable local control interface
- Minimal user-visible UI
- Camera2 API based implementation
- Thread-safe camera orchestration
- Auto-focus and image quality optimization

---

# Critical Android Reality Constraints

## 1. Camera Privacy Indicators Cannot Be Removed

Modern Android versions (Android 12+) enforce:

- Green camera indicator dot
- Camera usage notifications
- Foreground service disclosure
- Permission visibility

These are OS-enforced privacy protections.

No legitimate application can fully suppress:

- Green dot
- Camera usage indicators
- Foreground service notification

What CAN be minimized:

- Low-priority silent notification
- Minimal notification layout
- No Activity UI during operation
- Background-only service architecture
- No preview surface shown to user

---

# Recommended Architecture

```text
+------------------------------------------------+
| Quick Settings Tile                            |
|  - Start Service                               |
|  - Stop Service                                |
+---------------------+--------------------------+
                      |
                      v
+------------------------------------------------+
| Foreground Camera Service                      |
|                                                |
|  CameraController                              |
|    - Open camera                               |
|    - Switch front/back                         |
|    - Burst capture                             |
|    - Video recording                           |
|    - Autofocus                                 |
|    - Exposure control                          |
|                                                |
|  CommandServer                                 |
|    - Local socket                              |
|    - Receives shell commands                   |
|                                                |
|  CaptureScheduler                              |
|    - Timed burst capture                       |
|    - Frame pacing                              |
+---------------------+--------------------------+
                      |
                      v
+------------------------------------------------+
| Local Script Console App                       |
|                                                |
|  Bash command runner                           |
|  Script editor                                 |
|  API wrapper                                   |
+------------------------------------------------+
```

---

# Recommended Android Permissions

## AndroidManifest.xml

```xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
    package="com.termux.camera">

    <uses-permission android:name="android.permission.CAMERA" />
    <uses-permission android:name="android.permission.RECORD_AUDIO" />
    <uses-permission android:name="android.permission.FOREGROUND_SERVICE" />
    <uses-permission android:name="android.permission.FOREGROUND_SERVICE_CAMERA" />
    <uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE"
        android:maxSdkVersion="28" />
    <uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" />
    <uses-permission android:name="android.permission.POST_NOTIFICATIONS" />
    <uses-permission android:name="android.permission.WAKE_LOCK" />

    <application
        android:allowBackup="false"
        android:label="Camera Service"
        android:supportsRtl="true"
        android:theme="@style/Theme.AppCompat.NoActionBar">

        <service
            android:name=".service.CameraForegroundService"
            android:foregroundServiceType="camera|microphone"
            android:exported="false" />

        <service
            android:name=".tiles.CameraTileService"
            android:permission="android.permission.BIND_QUICK_SETTINGS_TILE"
            android:exported="true">

            <intent-filter>
                <action android:name="android.service.quicksettings.action.QS_TILE" />
            </intent-filter>
        </service>

    </application>
</manifest>
```

---

# Gradle Configuration

## app/build.gradle

```gradle
plugins {
    id 'com.android.application'
    id 'org.jetbrains.kotlin.android'
}

android {
    namespace 'com.termux.camera'
    compileSdk 34

    defaultConfig {
        applicationId "com.termux.camera"
        minSdk 26
        targetSdk 34

        versionCode 1
        versionName "1.0"
    }

    buildFeatures {
        viewBinding true
    }

    compileOptions {
        sourceCompatibility JavaVersion.VERSION_17
        targetCompatibility JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = '17'
    }
}

dependencies {
    implementation "androidx.core:core-ktx:1.13.1"
    implementation "androidx.appcompat:appcompat:1.7.0"
    implementation "androidx.lifecycle:lifecycle-service:2.8.3"
    implementation "androidx.camera:camera-core:1.3.4"
    implementation "androidx.camera:camera-camera2:1.3.4"
}
```

---

# Foreground Camera Service

## CameraForegroundService.kt

```kotlin
package com.termux.camera.service

import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.Service
import android.content.Intent
import android.os.Build
import android.os.IBinder
import androidx.core.app.NotificationCompat
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.SupervisorJob

class CameraForegroundService : Service() {

    private val serviceScope = CoroutineScope(
        SupervisorJob() + Dispatchers.Default
    )

    private lateinit var cameraController: CameraController
    private lateinit var commandServer: CommandServer

    override fun onCreate() {
        super.onCreate()

        createNotificationChannel()

        startForeground(1001, buildNotification())

        cameraController = CameraController(this)

        commandServer = CommandServer(cameraController)
        commandServer.start()
    }

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        return START_STICKY
    }

    override fun onDestroy() {
        commandServer.stop()
        cameraController.shutdown()
        super.onDestroy()
    }

    override fun onBind(intent: Intent?): IBinder? = null

    private fun buildNotification(): Notification {
        return NotificationCompat.Builder(this, "camera_service")
            .setContentTitle("Camera Service")
            .setContentText("Background capture active")
            .setSmallIcon(android.R.drawable.presence_video_online)
            .setSilent(true)
            .setOngoing(true)
            .build()
    }

    private fun createNotificationChannel() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val channel = NotificationChannel(
                "camera_service",
                "Camera Service",
                NotificationManager.IMPORTANCE_LOW
            )

            val manager = getSystemService(NotificationManager::class.java)
            manager.createNotificationChannel(channel)
        }
    }
}
```

---

# Camera Controller

## Responsibilities

- Camera lifecycle
- Front/back switching
- Burst mode
- Video recording
- Autofocus
- Exposure tuning
- Thread management
- Resource cleanup

---

## CameraController.kt

```kotlin
package com.termux.camera.service

import android.content.Context
import android.hardware.camera2.*
import android.media.ImageReader
import android.os.Handler
import android.os.HandlerThread
import java.util.concurrent.atomic.AtomicBoolean

class CameraController(
    private val context: Context
) {

    private val cameraManager =
        context.getSystemService(Context.CAMERA_SERVICE) as CameraManager

    private lateinit var cameraDevice: CameraDevice
    private lateinit var captureSession: CameraCaptureSession

    private val backgroundThread = HandlerThread("CameraThread")
    private lateinit var backgroundHandler: Handler

    private val running = AtomicBoolean(false)

    private var currentCameraId: String? = null

    init {
        backgroundThread.start()
        backgroundHandler = Handler(backgroundThread.looper)
    }

    fun startCamera(front: Boolean = false) {
        val cameraId = selectCamera(front)
        currentCameraId = cameraId

        openCamera(cameraId)
    }

    fun switchCamera() {
        val current = currentCameraId ?: return

        val next = if (isFrontCamera(current)) {
            selectCamera(false)
        } else {
            selectCamera(true)
        }

        stopCamera()
        openCamera(next)
    }

    private fun openCamera(cameraId: String) {
        running.set(true)

        cameraManager.openCamera(
            cameraId,
            cameraStateCallback,
            backgroundHandler
        )
    }

    fun stopCamera() {
        running.set(false)

        try {
            captureSession.close()
        } catch (_: Exception) {}

        try {
            cameraDevice.close()
        } catch (_: Exception) {}
    }

    fun captureBurst(count: Int = 5) {
        repeat(count) {
            triggerStillCapture()
        }
    }

    private fun triggerStillCapture() {
        // Build CaptureRequest here
    }

    private fun selectCamera(front: Boolean): String {
        val ids = cameraManager.cameraIdList

        for (id in ids) {
            val chars = cameraManager.getCameraCharacteristics(id)

            val facing = chars.get(
                CameraCharacteristics.LENS_FACING
            )

            if (front && facing == CameraCharacteristics.LENS_FACING_FRONT) {
                return id
            }

            if (!front && facing == CameraCharacteristics.LENS_FACING_BACK) {
                return id
            }
        }

        return ids.first()
    }

    private fun isFrontCamera(id: String): Boolean {
        val chars = cameraManager.getCameraCharacteristics(id)

        return chars.get(CameraCharacteristics.LENS_FACING) ==
                CameraCharacteristics.LENS_FACING_FRONT
    }

    private val cameraStateCallback = object : CameraDevice.StateCallback() {

        override fun onOpened(camera: CameraDevice) {
            cameraDevice = camera
        }

        override fun onDisconnected(camera: CameraDevice) {
            camera.close()
        }

        override fun onError(camera: CameraDevice, error: Int) {
            camera.close()
        }
    }

    fun shutdown() {
        stopCamera()
        backgroundThread.quitSafely()
    }
}
```

---

# Burst Mode Strategy

## Recommended Burst Parameters

| Parameter       | Recommended       |
| --------------- | ----------------- |
| JPEG Resolution | 1920x1080         |
| Burst Rate      | 2-5 FPS           |
| AF Trigger      | Once before burst |
| Exposure        | Auto              |
| Stabilization   | Enabled           |
| Buffer Size     | 3-5 images        |

---

# AutoFocus Best Practices

## Use Continuous Picture AF

```kotlin
captureRequestBuilder.set(
    CaptureRequest.CONTROL_AF_MODE,
    CaptureRequest.CONTROL_AF_MODE_CONTINUOUS_PICTURE
)
```

## Trigger Focus Before Burst

```kotlin
captureRequestBuilder.set(
    CaptureRequest.CONTROL_AF_TRIGGER,
    CameraMetadata.CONTROL_AF_TRIGGER_START
)
```

---

# Avoiding Blocked Cameras

## Dynamic Camera Validation

Use:

- Luma analysis
- Histogram variance
- Exposure collapse detection
- Texture entropy

If:

- Brightness near zero
- Texture entropy extremely low
- Frame uniformity extremely high

Then:

- Mark camera as obstructed
- Skip during auto-switching

Pseudo-logic:

```kotlin
if (frameVariance < threshold) {
    markCameraObstructed()
}
```

---

# Working Over Other Apps

This is fully supported.

Requirements:

- Foreground service
- No visible preview UI
- TextureReader/ImageReader surface only
- Background thread capture

The app can:

- Record camera
- Capture images
- Run while screen recording
- Run while other apps are foregrounded

Limitations:

Some OEMs aggressively kill background services.

Mitigation:

- Request battery optimization exclusion
- Use START_STICKY
- Persistent foreground notification

---

# Quick Settings Tile

## CameraTileService.kt

```kotlin
package com.termux.camera.tiles

import android.content.Intent
import android.service.quicksettings.Tile
import android.service.quicksettings.TileService
import com.termux.camera.service.CameraForegroundService

class CameraTileService : TileService() {

    private var active = false

    override fun onClick() {
        super.onClick()

        if (!active) {
            startForegroundService(
                Intent(this, CameraForegroundService::class.java)
            )

            qsTile.state = Tile.STATE_ACTIVE
            active = true
        } else {
            stopService(
                Intent(this, CameraForegroundService::class.java)
            )

            qsTile.state = Tile.STATE_INACTIVE
            active = false
        }

        qsTile.updateTile()
    }
}
```

---

# Local Command Server

## Purpose

Expose camera control via:

- localhost TCP socket
- UNIX domain socket
- Termux shell scripts
- Bash wrappers

Recommended:

- localhost only
- authentication token
- JSON command protocol

---

# Example Command Protocol

## Commands

```bash
camera-cli start
camera-cli stop
camera-cli switch
camera-cli burst 10
camera-cli set-rate 2
camera-cli start-video
camera-cli stop-video
```

---

# CommandServer.kt

```kotlin
package com.termux.camera.service

import java.net.ServerSocket
import kotlin.concurrent.thread

class CommandServer(
    private val controller: CameraController
) {

    private var running = true

    fun start() {
        thread {
            val server = ServerSocket(8989)

            while (running) {
                val socket = server.accept()

                val command = socket
                    .getInputStream()
                    .bufferedReader()
                    .readLine()

                handle(command)

                socket.close()
            }
        }
    }

    private fun handle(command: String) {
        when {
            command == "start" -> controller.startCamera()
            command == "stop" -> controller.stopCamera()
            command == "switch" -> controller.switchCamera()
            command.startsWith("burst") -> {
                val count = command.split(" ")[1].toInt()
                controller.captureBurst(count)
            }
        }
    }

    fun stop() {
        running = false
    }
}
```

---

# Bash Wrapper

## camera-control.sh

```bash
#!/data/data/com.termux/files/usr/bin/bash

HOST=127.0.0.1
PORT=8989

cmd="$1"
arg="$2"

if [ -n "$arg" ]; then
    echo "$cmd $arg" | nc $HOST $PORT
else
    echo "$cmd" | nc $HOST $PORT
fi
```

---

# Script Console App

## Features

- Embedded shell editor
- Save scripts
- Execute scripts
- Command history
- Camera API wrappers
- Log output

Recommended Components:

| Component       | Recommendation             |
| --------------- | -------------------------- |
| Script editor   | CodeView / custom EditText |
| Shell execution | ProcessBuilder             |
| Logging         | Room DB                    |
| IPC             | localhost socket           |

---

# Video Recording

## Recommended Strategy

Use:

- MediaRecorder
- Camera2 repeating session
- HEVC/H264

Recommended:

| Parameter  | Value  |
| ---------- | ------ |
| Resolution | 1080p  |
| FPS        | 24-30  |
| Codec      | H264   |
| Bitrate    | 8 Mbps |

---

# Threading Architecture

## Recommended Thread Separation

| Thread             | Purpose           |
| ------------------ | ----------------- |
| CameraThread       | Camera operations |
| ImageProcessThread | JPEG encoding     |
| NetworkThread      | Command socket    |
| SchedulerThread    | Burst timing      |
| MainThread         | Minimal UI only   |

---

# Resource Management

## Important Rules

Always:

- Close Image objects immediately
- Close sessions before reopening
- Stop repeating requests before switching
- Release MediaRecorder properly
- Avoid large ImageReader buffers

---

# Stability Recommendations

## Use Atomic State Flags

```kotlin
private val isCapturing = AtomicBoolean(false)
private val isSwitching = AtomicBoolean(false)
```

---

# Recommended Capture Optimizations

## Balanced Quality Profile

| Setting          | Value      |
| ---------------- | ---------- |
| JPEG Quality     | 90         |
| Resolution       | 1080p      |
| AF Mode          | Continuous |
| Noise Reduction  | FAST       |
| Edge Enhancement | FAST       |
| Stabilization    | ON         |

---

# OEM Compatibility Considerations

## Samsung

Aggressive background restrictions.

## Xiaomi

MIUI kills services aggressively.

## Huawei

Camera concurrency restrictions.

## Pixel

Best Camera2 compliance.

---

# Security Considerations

Never expose:

- Open internet camera socket
- Unauthenticated remote commands
- Arbitrary shell execution

Recommended:

- localhost-only socket
- token auth
- scoped command parser

---

# Suggested Future Enhancements

## AI Obstruction Detection

Use:

- OpenCV
- TensorFlow Lite
- Edge histogram analysis

## Adaptive Burst

Increase burst rate only when:

- Device temperature low
- Battery sufficient
- CPU usage acceptable

## Thermal Management

Monitor:

```kotlin
ThermalService
```

Reduce:

- FPS
- Resolution
- Burst rate

When overheating.

---

# Testing Strategy

## Test Matrix

| Test                        | Expected         |
| --------------------------- | ---------------- |
| Screen off                  | Service survives |
| App swiped away             | Service persists |
| Camera switch               | No crash         |
| Burst mode                  | Stable timing    |
| Concurrent screen recording | Works            |
| Long runtime                | No memory leak   |

---

# Recommended Final Structure

```text
app/
 ├── service/
 │    ├── CameraForegroundService.kt
 │    ├── CameraController.kt
 │    ├── CommandServer.kt
 │    ├── BurstScheduler.kt
 │    └── VideoRecorder.kt
 │
 ├── tiles/
 │    └── CameraTileService.kt
 │
 ├── shell/
 │    ├── ScriptExecutor.kt
 │    └── ShellApi.kt
 │
 ├── analysis/
 │    ├── ObstructionDetector.kt
 │    └── ExposureAnalyzer.kt
 │
 └── ui/
      ├── ScriptConsoleActivity.kt
      └── SettingsActivity.kt
```

---

# Recommended Next Implementation Steps

## Phase 1

- Foreground service
- Camera open/close
- Notification channel
- Quick settings tile

## Phase 2

- Burst capture
- Image saving
- Thread-safe switching

## Phase 3

- Video recording
- Concurrent recording tests
- Obstruction detection

## Phase 4

- Script console
- Local command API
- Bash wrappers

## Phase 5

- Thermal optimization
- Dynamic frame tuning
- Advanced autofocus

---

# Important Compliance Notes

Android privacy restrictions are enforced at the OS level.

A compliant app can:

- Run in background
- Capture camera continuously
- Operate without visible Activity UI
- Use Quick Settings tiles
- Expose localhost APIs

But cannot legally or technically:

- Remove privacy indicators
- Hide camera usage from the OS
- Bypass foreground service requirements
- Silently access camera without permission
