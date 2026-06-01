# Camera Service Refactor Specification

## Objective

Refactor the existing camera service architecture to remove the localhost command server and replace it with Android-native control mechanisms.

The final application shall:

- operate primarily through a Quick Settings tile
- expose a scripting API via Android broadcast intents
- retain foreground-service operation
- support photo burst mode
- support video recording
- support front/back camera switching
- support dynamic camera selection
- provide a minimal configuration UI
- support headless operation after initial setup

---

# Architectural Changes

## Remove Local Socket Command Server

### Motivation

The current localhost TCP server introduces unnecessary complexity:

- socket lifecycle management
- networking permissions
- service startup ordering issues
- debugging complexity
- additional failure points

Android already provides native IPC mechanisms that better fit the use case.

### Required Changes

Delete:

```text
CommandServer.kt
ShellApi.kt
scripts/camera-control.sh
```

Remove all references to:

```text
127.0.0.1:8989
android.permission.INTERNET
Socket
ServerSocket
```

Remove all service initialization related to:

```kotlin
commandServer.start()
commandServer.stop()
```

from:

```text
CameraForegroundService.kt
```

---

# Primary Control Method

## Quick Settings Tile

The Quick Settings tile becomes the primary user control surface.

### Behavior

Tile OFF:

```text
Camera Service Stopped
```

Tap:

```text
Start Camera Service
```

Tile ON:

```text
Camera Service Running
```

Tap:

```text
Stop Camera Service
```

### Responsibilities

CameraTileService must:

- start CameraForegroundService
- stop CameraForegroundService
- update tile state
- reflect current service status

### Requirements

No launcher activity interaction shall be required during normal operation.

---

# Broadcast-Based Scripting API

## Objective

Replace the socket server with Android broadcast intents.

This provides:

- Termux integration
- ADB integration
- shell scripting support
- lower complexity

---

## New Component

Create:

```text
service/CameraCommandReceiver.kt
```

Manifest declaration:

```xml
<receiver
    android:name=".service.CameraCommandReceiver"
    android:exported="true"/>
```

---

## Supported Actions

### Service Control

```text
com.termux.camera.START
com.termux.camera.STOP
```

### Camera Selection

```text
com.termux.camera.FRONT
com.termux.camera.BACK
com.termux.camera.SWITCH
```

### Capture

```text
com.termux.camera.CAPTURE
com.termux.camera.BURST
```

Optional extra:

```text
count
```

Example:

```bash
am broadcast \
-a com.termux.camera.BURST \
--ei count 10
```

---

### Video

```text
com.termux.camera.START_VIDEO
com.termux.camera.STOP_VIDEO
```

---

### Runtime Configuration

```text
com.termux.camera.SET_RATE
com.termux.camera.SET_MODE
com.termux.camera.SET_RESOLUTION
```

Examples:

```bash
am broadcast \
-a com.termux.camera.SET_RATE \
--ei seconds 15
```

```bash
am broadcast \
-a com.termux.camera.SET_MODE \
--es mode video
```

---

# Settings Activity

## Objective

Provide a lightweight configuration screen.

This UI is not intended for routine operation.

It is only used to configure behavior.

---

## Rename

Replace:

```text
ScriptConsoleActivity
```

with:

```text
SettingsActivity
```

---

## Settings

### Capture Mode

Options:

```text
Photo
Video
```

---

### Burst Count

Default:

```text
5
```

---

### Capture Interval

Default:

```text
15 seconds
```

---

### Camera Switching Interval

Default:

```text
15 seconds
```

---

### Resolution

Options:

```text
Low
Medium
High
```

---

### Auto Camera Selection

Enable:

```text
true
```

Default:

```text
enabled
```

---

## Persistence

Store settings using:

```kotlin
SharedPreferences
```

or

```kotlin
DataStore
```

DataStore preferred.

---

# Camera Obstruction Detection

## Objective

Avoid switching to unusable cameras.

Examples:

- phone face-down
- camera covered
- device inside pocket

---

## Detection Method

Analyze incoming frames.

Compute:

```text
average brightness
```

For each camera.

---

## Rule

If:

```text
brightness < threshold
```

for:

```text
N consecutive frames
```

mark camera:

```text
blocked
```

Suggested:

```text
threshold = 5
frames = 30
```

---

## Behavior

When switching:

```text
Current Camera
    ↓
Next Camera Candidate
```

If candidate camera:

```text
blocked
```

then:

```text
skip candidate
```

and select another available camera.

---

## Recovery

Blocked cameras shall be periodically re-evaluated.

Suggested:

```text
every 60 seconds
```

---

# Foreground Notification

## Objective

Provide secondary controls without opening UI.

---

## Actions

Notification shall contain:

```text
Capture
Switch
Start Video
Stop Video
Stop Service
```

Each action sends an internal intent.

---

# Runtime Flow

## Startup

Quick Settings Tile

or

Broadcast Intent

↓

CameraForegroundService

↓

CameraController

↓

Camera Open

↓

Capture Loop

---

## Shutdown

Tile OFF

or

STOP Broadcast

↓

CameraForegroundService

↓

Release Camera

↓

Stop Foreground

↓

Destroy Service

---

# Testing Procedure

## Build

```bash
./gradlew assembleDebug
```

---

## Install

```bash
adb install -r app/build/outputs/apk/debug/app-debug.apk
```

---

## Grant Permissions

Manually grant:

```text
CAMERA
RECORD_AUDIO
POST_NOTIFICATIONS
```

if required.

---

# Broadcast Testing

## Start Service

```bash
adb shell am broadcast \
-a com.termux.camera.START
```

---

## Stop Service

```bash
adb shell am broadcast \
-a com.termux.camera.STOP
```

---

## Switch Camera

```bash
adb shell am broadcast \
-a com.termux.camera.SWITCH
```

---

## Front Camera

```bash
adb shell am broadcast \
-a com.termux.camera.FRONT
```

---

## Back Camera

```bash
adb shell am broadcast \
-a com.termux.camera.BACK
```

---

## Capture

```bash
adb shell am broadcast \
-a com.termux.camera.CAPTURE
```

---

## Burst

```bash
adb shell am broadcast \
-a com.termux.camera.BURST \
--ei count 5
```

---

## Start Video

```bash
adb shell am broadcast \
-a com.termux.camera.START_VIDEO
```

---

## Stop Video

```bash
adb shell am broadcast \
-a com.termux.camera.STOP_VIDEO
```

---

# Logcat Debugging

## Service Logs

```bash
adb logcat | grep CameraForegroundService
```

---

## Camera Logs

```bash
adb logcat | grep CameraController
```

---

## Tile Logs

```bash
adb logcat | grep CameraTileService
```

---

## Receiver Logs

```bash
adb logcat | grep CameraCommandReceiver
```

---

## Full Application Logs

```bash
adb logcat | grep com.termux.camera
```

---

# Logging Requirements

Every major state transition must be logged.

Examples:

```text
SERVICE_STARTED
SERVICE_STOPPED

CAMERA_OPENED
CAMERA_CLOSED

SWITCH_FRONT
SWITCH_BACK

BURST_STARTED
BURST_COMPLETED

VIDEO_STARTED
VIDEO_STOPPED

CAMERA_BLOCKED
CAMERA_UNBLOCKED
```

---

# Success Criteria

The refactor is complete when:

- no socket server exists
- no localhost communication exists
- Quick Settings tile fully controls service state
- broadcast API controls all camera actions
- settings persist across reboots
- service functions without UI interaction
- blocked cameras are skipped automatically
- all features are testable via ADB broadcasts
- logcat output clearly describes service behavior
- application builds with:

```bash
./gradlew assembleDebug
```

without errors
