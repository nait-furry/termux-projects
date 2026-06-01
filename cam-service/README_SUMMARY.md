# Camera Service Summary

## Purpose

This module is a minimal Android camera service that:

- runs as a foreground service
- opens Camera2 without a preview
- supports burst still capture
- supports front/back switching
- supports video recording via `MediaRecorder`
- exposes a Quick Settings tile and a lightweight `SettingsActivity` for configuration

## Key files

- `app/src/main/AndroidManifest.xml`
  - app permissions
  - launcher activity
  - foreground service declaration
  - Quick Settings tile declaration

- `app/src/main/java/com/termux/camera/ui/SettingsActivity.kt`
  - lightweight configuration UI
  - runtime permission requests and persistent settings

- `app/src/main/java/com/termux/camera/service/CameraForegroundService.kt`
  - Android `Service` lifecycle
  - foreground notification handling
  - initializes `CameraController` and schedulers
  - processes internal action intents

- `app/src/main/java/com/termux/camera/service/CameraController.kt`
  - Camera2 lifecycle and state management
  - open/close camera
  - capture stills and save JPEGs
  - switch cameras
  - video recording integration

- `app/src/main/java/com/termux/camera/service/CameraCommandReceiver.kt`
  - broadcast receiver for external control (ADB / Termux / scripts)

- `app/src/main/java/com/termux/camera/tiles/CameraTileService.kt`
  - Quick Settings tile start/stop behavior

## Runtime flow

1. `SettingsActivity` launches and requests runtime permissions.
2. User taps the Quick Settings tile, or an external broadcast starts/stops the service.
3. `CameraForegroundService.onCreate()` runs:
   - creates the notification channel
   - starts foreground mode
   - initializes `CameraController` and `BurstScheduler`
4. `CameraForegroundService.onStartCommand()` processes action intents:
   - start front/back, switch, burst, start/stop video, set rate/mode/resolution
5. `CameraController.startCamera()` selects and opens the requested camera on a background thread.
6. Burst captures queue still image requests and save JPEGs via `ImageReader`.
7. `start-video` and `stop-video` use `VideoRecorder` to manage an MP4 recording surface.
8. `CameraForegroundService.onDestroy()` releases camera resources and stops schedulers.

## Broadcast control (ADB / Termux)

Use `am broadcast` (ADB) or equivalent Termux commands to control the running service. Examples:

```bash
adb shell am broadcast -a com.termux.camera.START
adb shell am broadcast -a com.termux.camera.STOP
adb shell am broadcast -a com.termux.camera.CAPTURE
adb shell am broadcast -a com.termux.camera.BURST --ei count 5
adb shell am broadcast -a com.termux.camera.SWITCH
adb shell am broadcast -a com.termux.camera.FRONT
adb shell am broadcast -a com.termux.camera.BACK
adb shell am broadcast -a com.termux.camera.START_VIDEO
adb shell am broadcast -a com.termux.camera.STOP_VIDEO
```

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

Control via broadcasts (examples shown above).

Unit/build tests:

```bash
./gradlew testDebugUnitTest
./gradlew assembleDebug
```

## Notes

- The app exposes a broadcast receiver `CameraCommandReceiver` and the service is exported to allow `am broadcast` control.
- Settings persist via `CameraSettings` and are editable in the `SettingsActivity`.
- Captured JPEGs are saved to `Pictures/CameraService` on Android Q+.
- Video files are saved under the app external files `Movies` directory.
