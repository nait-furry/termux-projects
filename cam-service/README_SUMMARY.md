# Camera Service Summary

## Purpose

This module is a minimal Android camera service that:

- runs as a foreground service
- opens Camera2 without a preview
- supports burst still capture
- supports front/back switching
- supports local commands over `127.0.0.1:8989`
- supports video recording via `MediaRecorder`
- exposes a Quick Settings tile and a simple console activity

## Key files

- `app/src/main/AndroidManifest.xml`
  - app permissions
  - launcher activity
  - foreground service declaration
  - Quick Settings tile declaration

- `app/src/main/java/com/termux/camera/ui/ScriptConsoleActivity.kt`
  - launcher UI
  - runtime permission requests
  - service start/stop buttons
  - command submission to the local command server

- `app/src/main/java/com/termux/camera/service/CameraForegroundService.kt`
  - Android `Service` lifecycle
  - foreground notification handling
  - creates `CameraController`
  - creates and starts `CommandServer`
  - handles action intents for camera control

- `app/src/main/java/com/termux/camera/service/CommandServer.kt`
  - localhost socket server on `127.0.0.1:8989`
  - text-based commands for camera actions

- `app/src/main/java/com/termux/camera/service/CameraController.kt`
  - Camera2 lifecycle and state management
  - open/close camera
  - capture stills and save JPEGs
  - switch cameras
  - video recording integration

- `app/src/main/java/com/termux/camera/service/VideoRecorder.kt`
  - `MediaRecorder` setup
  - start/stop video recording

- `app/src/main/java/com/termux/camera/tiles/CameraTileService.kt`
  - Quick Settings tile start/stop behavior

- `app/src/main/java/com/termux/camera/shell/ShellApi.kt`
  - client for sending commands to the local TCP server

- `scripts/camera-control.sh`
  - Termux shell wrapper for sending commands to the service

## Runtime flow

1. `ScriptConsoleActivity` launches and requests runtime permissions.
2. User presses `Start`, taps the Quick Settings tile, or starts the service externally.
3. `CameraForegroundService.onCreate()` runs:
   - creates the notification channel
   - starts foreground mode
   - initializes `CameraController`
   - starts `CommandServer`
4. `CameraForegroundService.onStartCommand()` processes action intents:
   - `ACTION_START_FRONT`, `ACTION_SWITCH`, `ACTION_BURST`, `ACTION_STOP`
   - default behavior opens the back camera if permitted
5. `CameraController.startCamera()` selects the requested camera and opens it on a background thread.
6. When the camera opens, `CameraController` creates an `ImageReader` and a capture session.
7. Burst captures queue still image requests and save JPEGs via `ImageReader`.
8. `start-video` and `stop-video` use `VideoRecorder` to manage an MP4 recording surface.
9. `CameraForegroundService.onDestroy()` stops the command server and shuts down camera resources.

## Local commands

The service listens only on localhost:

- host: `127.0.0.1`
- port: `8989`

Supported commands:

- `ping`
- `start` / `front` / `back`
- `stop`
- `switch`
- `burst [count]`
- `start-video`
- `stop-video`

## Exact test commands

Build and install:

```bash
cd /home/fury/termux/cam-service
./gradlew assembleDebug
adb install -r app/build/outputs/apk/debug/app-debug.apk
```

Start the app, grant permissions, then start the service:

```bash
adb shell am start-foreground-service -n com.termux.camera/.service.CameraForegroundService
```

Command server tests:

```bash
printf 'ping\n' | adb shell nc 127.0.0.1 8989
printf 'burst 5\n' | adb shell nc 127.0.0.1 8989
printf 'switch\n' | adb shell nc 127.0.0.1 8989
printf 'start-video\n' | adb shell nc 127.0.0.1 8989
printf 'stop-video\n' | adb shell nc 127.0.0.1 8989
printf 'stop\n' | adb shell nc 127.0.0.1 8989
```

Termux wrapper:

```bash
chmod +x scripts/camera-control.sh
scripts/camera-control.sh ping
scripts/camera-control.sh burst 5
scripts/camera-control.sh stop
```

Unit/build tests:

```bash
./gradlew testDebugUnitTest
./gradlew assembleDebug
```

## Notes

- The service is currently declared as `exported="false"` in the manifest.
- The command server is local-only and requires `android.permission.INTERNET` on Android.
- Captured JPEGs are saved to `Pictures/CameraService` on Android Q+.
- Video files are saved under the app external files `Movies` directory.
