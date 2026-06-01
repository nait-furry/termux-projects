# Camera Service Operating Template

## Build

```bash
cd /home/fury/termux/cam-service
./gradlew assembleDebug
```

## Install

```bash
adb install -r app/build/outputs/apk/debug/app-debug.apk
```

Open **Camera Service** once and grant camera, microphone, and notification permissions.

## Start

```bash
adb shell am start-foreground-service -n com.termux.camera/.service.CameraForegroundService
```

Or add the **Camera Service** Quick Settings tile and tap it.

## Control

Use broadcast intents via `am broadcast` (ADB) or equivalent from Termux. Examples:

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

## Test

```bash
./gradlew testDebugUnitTest
./gradlew assembleDebug
```

Manual checks:

- Service starts and foreground notification appears.
- `ping` returns `ok`.
- `burst 3` saves JPEGs under `Pictures/CameraService`.
- `switch` changes front/back without crashing.
- `start-video` and `stop-video` create an MP4 in the app Movies directory.
- Service survives screen-off and app-swipe scenarios.
- Stop command removes the notification.
