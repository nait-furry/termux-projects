# Camera Service

Android Kotlin Camera2 template implementing the `project.md` brief:

- Foreground camera service with persistent notification
- Front/back switching
- JPEG burst capture to `Pictures/CameraService`
- Quick Settings tile start/stop control
- Localhost command server on `127.0.0.1:8989`
- Termux shell wrapper
- Minimal script console activity
- Camera obstruction/exposure analysis helpers
- H264/AAC video recording through `MediaRecorder`

Android privacy indicators and foreground-service disclosures are enforced by the OS and cannot be removed.

## Project Structure

```text
app/src/main/java/com/termux/camera/
  analysis/     Exposure and obstruction helpers
  service/      Foreground service, Camera2 controller, command server
  shell/        Local socket and script execution helpers
  tiles/        Quick Settings tile
  ui/           Minimal console and settings activities
scripts/        Termux command wrapper
```

## Requirements

- Android Studio, or Android SDK command-line tools
- JDK 17
- Gradle 8.7 or Android Studio's bundled Gradle support
- Android device or emulator with a camera
- Runtime permissions: Camera, microphone, notifications on Android 13+

The checked-in `gradlew` delegates to a real Gradle wrapper jar if one is generated. If not, it falls back to the installed `gradle` command. Generate the wrapper with:

```bash
cd cam-service
gradle wrapper --gradle-version 8.7
```

## Build

```bash
cd cam-service
./gradlew assembleDebug
```

The debug APK will be created at:

```text
app/build/outputs/apk/debug/app-debug.apk
```

## Install

```bash
adb install -r app/build/outputs/apk/debug/app-debug.apk
```

Open **Camera Service** once and grant permissions before starting the foreground service from shell or the Quick Settings tile.

## Start and Stop

Start the service:

```bash
adb shell am start-foreground-service -n com.termux.camera/.service.CameraForegroundService
```

Stop the service:

```bash
adb shell am stopservice -n com.termux.camera/.service.CameraForegroundService
```

You can also add the **Camera Service** Quick Settings tile and tap it to start or stop the service.

## Local Commands

The service listens only on localhost:

```text
127.0.0.1:8989
```

From an Android shell or Termux session:

```bash
printf 'ping\n' | nc 127.0.0.1 8989
printf 'start\n' | nc 127.0.0.1 8989
printf 'front\n' | nc 127.0.0.1 8989
printf 'back\n' | nc 127.0.0.1 8989
printf 'switch\n' | nc 127.0.0.1 8989
printf 'burst 10\n' | nc 127.0.0.1 8989
printf 'start-video\n' | nc 127.0.0.1 8989
printf 'stop-video\n' | nc 127.0.0.1 8989
printf 'stop\n' | nc 127.0.0.1 8989
```

The Termux wrapper is:

```bash
chmod +x scripts/camera-control.sh
scripts/camera-control.sh burst 5
```

## Test

Run the local build checks:

```bash
./gradlew testDebugUnitTest
./gradlew assembleDebug
```

Manual device test matrix:

```text
1. Launch the app and grant camera, microphone, and notification permissions.
2. Start the service from the app, ADB, or Quick Settings tile.
3. Send `ping`; expect `ok`.
4. Send `burst 3`; expect three JPEG files in Pictures/CameraService.
5. Send `switch`; expect no crash and continued service notification.
6. Send `start-video`, wait a few seconds, then send `stop-video`.
7. Turn screen off and repeat `burst 3`.
8. Swipe the app away and confirm the foreground service remains active.
9. Stop the service and confirm the notification disappears.
```

## Notes

- The camera runs without a preview surface; captures use an `ImageReader` surface.
- Burst count is bounded to `1..50`.
- The command socket is local only. Do not expose it to a network interface.
- Video recordings are written to the app-specific external Movies directory.
