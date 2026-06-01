# Camera Service — Developer Notes

This module implements a foreground Android camera service with headless control via Quick Settings tile and broadcast intents.

## Implementation Summary

- `CameraForegroundService.kt` — foreground service lifecycle, notification, action handling
- `CameraController.kt` — Camera2 lifecycle, burst capture, switching, JPEG saving
- `VideoRecorder.kt` — `MediaRecorder` integration for MP4 recording
- `CameraTileService.kt` — Quick Settings tile implementation
- `SettingsActivity.kt` — lightweight settings UI for persistent configuration
- `CameraCommandReceiver.kt` — broadcast receiver to accept external control commands
- `ObstructionDetector.kt` / `ExposureAnalyzer.kt` — basic frame analysis utilities

## Build and Install

```bash
cd /home/fury/termux/cam-service
./gradlew assembleDebug
adb install -r app/build/outputs/apk/debug/app-debug.apk
```

## Runtime Notes

- The app requests runtime permissions for `CAMERA`, `RECORD_AUDIO`, and (on Android 13+) `POST_NOTIFICATIONS`.
- The service is exported to allow control via broadcast intents (`CameraCommandReceiver`).
- Captures are saved without a preview surface via `ImageReader`.
- JPEGs are written to `Pictures/CameraService` on Android Q+.
- Video files are written to the app-specific external Movies directory.

## Starting the Service

From the UI: open the `SettingsActivity`, grant permissions, and use the Quick Settings tile to start/stop.

From ADB / Termux: start the foreground service directly (if needed):

```bash
adb shell am start-foreground-service -n com.termux.camera/.service.CameraForegroundService
```

## Broadcast control (ADB / Termux)

Use `am broadcast` to send commands to the app. Example commands:

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

## Testing

Run build and unit tests:

```bash
./gradlew testDebugUnitTest
./gradlew assembleDebug
```

Manual verification checklist:

1. Launch the app and grant permissions.
2. Start the service from the Quick Settings tile or send a `START` broadcast.
3. Send `CAPTURE` or `BURST` broadcasts and confirm JPEG files are created.
4. Send `SWITCH`, `FRONT`, or `BACK` broadcasts and ensure camera switches.
5. Send `START_VIDEO` then `STOP_VIDEO` and confirm an MP4 is created.
6. Stop the service and confirm the notification disappears.

## Notes and Next Steps

- The codebase no longer depends on a local TCP command server; documentation and scripts referencing `127.0.0.1:8989` have been removed or updated.
- Remaining work: polish obstruction detection thresholds, add automated tests for receiver actions, and remove any leftover external wrapper scripts if present.
