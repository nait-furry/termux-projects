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

```bash
printf 'ping\n' | adb shell nc 127.0.0.1 8989
printf 'start\n' | adb shell nc 127.0.0.1 8989
printf 'front\n' | adb shell nc 127.0.0.1 8989
printf 'back\n' | adb shell nc 127.0.0.1 8989
printf 'switch\n' | adb shell nc 127.0.0.1 8989
printf 'burst 5\n' | adb shell nc 127.0.0.1 8989
printf 'start-video\n' | adb shell nc 127.0.0.1 8989
printf 'stop-video\n' | adb shell nc 127.0.0.1 8989
printf 'stop\n' | adb shell nc 127.0.0.1 8989
```

From Termux:

```bash
scripts/camera-control.sh start
scripts/camera-control.sh burst 5
scripts/camera-control.sh switch
scripts/camera-control.sh start-video
scripts/camera-control.sh stop-video
scripts/camera-control.sh stop
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
