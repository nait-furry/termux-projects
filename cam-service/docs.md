# Procedure

## Implementation Summary

This folder is a standalone Android camera service project. The implementation includes:

- `CameraForegroundService.kt` — foreground service lifecycle and notification
- `CameraController.kt` — Camera2 open/close, capture session, burst capture, switching, JPEG saving, cleanup
- `CommandServer.kt` — local command server on `127.0.0.1:8989`
- `VideoRecorder.kt` — `MediaRecorder` video recording support
- `CameraTileService.kt` — Quick Settings tile to start/stop the service
- `ScriptConsoleActivity.kt` — minimal launcher UI and command entry
- `ShellApi.kt` — local socket command client
- `scripts/camera-control.sh` — Termux wrapper for sending commands

## Build and Install

```bash
cd /home/fury/termux/cam-service
./gradlew assembleDebug
adb install -r app/build/outputs/apk/debug/app-debug.apk
```

## Runtime Notes

- The app requests runtime permissions for `CAMERA`, `RECORD_AUDIO`, and (on Android 13+) `POST_NOTIFICATIONS`.
- The service is declared as `android:exported="false"`, so it is intended to be started from within the app or the Quick Settings tile, not from an external UID.
- The command server listens only on localhost and is used by the activity and Termux wrapper.
- Captures are saved without a preview surface via `ImageReader`.
- JPEGs are written to `Pictures/CameraService` on Android Q+.
- Video files are written to the app-specific external Movies directory.

## Starting the Service

From the app UI:

- Open **Camera Service**
- Grant any requested permissions
- Tap `Start`

From the Quick Settings tile:

- Add the **Camera Service** tile
- Tap to toggle the foreground service on/off

> Note: `adb shell am start-foreground-service` may fail because the service is not exported.

## Local Commands

The service listens on:

- host: `127.0.0.1`
- port: `8989`

Supported commands:

- `ping`
- `start`
- `front`
- `back`
- `stop`
- `switch`
- `burst [count]`
- `start-video`
- `stop-video`

From an Android shell:

```bash
printf 'ping\n' | adb shell nc 127.0.0.1 8989
printf 'burst 5\n' | adb shell nc 127.0.0.1 8989
printf 'switch\n' | adb shell nc 127.0.0.1 8989
printf 'start-video\n' | adb shell nc 127.0.0.1 8989
printf 'stop-video\n' | adb shell nc 127.0.0.1 8989
printf 'stop\n' | adb shell nc 127.0.0.1 8989
```

From Termux on-device:

```bash
chmod +x scripts/camera-control.sh
scripts/camera-control.sh ping
scripts/camera-control.sh start
scripts/camera-control.sh burst 5
scripts/camera-control.sh switch
scripts/camera-control.sh stop
```

## Testing

Run build and unit tests:

```bash
./gradlew testDebugUnitTest
./gradlew assembleDebug
```

Manual verification:

1. Launch the app and grant permissions.
2. Start the service from the app or Quick Settings tile.
3. Send `ping` and expect `ok`.
4. Send `burst 3` and confirm JPEG files are created.
5. Send `switch` and ensure the service remains active.
6. Send `start-video`, wait, then send `stop-video`.
7. Stop the service and confirm the notification disappears.

## Notes

- If local socket commands fail, verify the service is running and the command server is started.
- The service uses localhost-only sockets; it does not expose a network-facing API.
- If you later choose to support external start via `adb`, change `android:exported` on the service and/or add a permission guard.
