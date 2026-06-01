Refactor Implementation Status

Summary

This file maps items from `refactoring.md` to the current implementation and lists remaining work.

Implemented

- Removed dependency on a local TCP server in runtime code (no `CommandServer` used by the service).
- Broadcast-based control implemented via `app/src/main/java/com/termux/camera/service/CameraCommandReceiver.kt`.
- Manifest updated: receiver declared and exported in `app/src/main/AndroidManifest.xml`.
- Quick Settings tile implemented: `app/src/main/java/com/termux/camera/tiles/CameraTileService.kt` (fixed minor syntax bug).
- `CameraForegroundService` accepts internal action intents (start/stop/switch/capture/burst/video/settings).
- Lightweight settings UI implemented in `app/src/main/java/com/termux/camera/ui/SettingsActivity.kt`.
- Notification actions provide capture/switch/video/stop controls.
- Basic obstruction/exposure analysis code is present: `analysis/ObstructionDetector.kt` and `analysis/ExposureAnalyzer.kt`.
- Documentation updated to remove socket-based commands and to describe broadcast API (`README_SUMMARY.md`, `docs.md`, `template.md`).

Files removed / not present

- `CommandServer.kt` and any previous socket-based server are not present in the codebase root service package.
- No `scripts/camera-control.sh` wrapper is distributed in the project (documentation now recommends `am broadcast`).

Remaining / Recommended Work

- Automated tests: add unit/instrumentation tests for `CameraCommandReceiver` and `CameraForegroundService` action handling.
- Obstruction detection tuning: validate thresholds in `ObstructionDetector` (suggested threshold=5, frames=30) and schedule periodic re-evaluation.
- Settings persistence review: DataStore preferred; currently `CameraSettings` is used (verify persistence across reboots).
- Remove stale references elsewhere in repository (search for `127.0.0.1`, `CommandServer`, `scripts/camera-control.sh`) and update or delete if found.
- Optional: provide a small Termux wrapper script that sends `am broadcast` commands if the user wants convenience wrappers.

How to test broadcasts

1. Build and install the APK:

```bash
./gradlew assembleDebug
adb install -r app/build/outputs/apk/debug/app-debug.apk
```

2. Start the service (optional if you use `START` broadcast):

```bash
adb shell am start-foreground-service -n com.termux.camera/.service.CameraForegroundService
```

3. Send control broadcasts, for example:

```bash
adb shell am broadcast -a com.termux.camera.BURST --ei count 5
adb shell am broadcast -a com.termux.camera.CAPTURE
adb shell am broadcast -a com.termux.camera.SWITCH
adb shell am broadcast -a com.termux.camera.START_VIDEO
adb shell am broadcast -a com.termux.camera.STOP_VIDEO
```

If you want, I can proceed to:

- run a workspace-wide search and delete any remaining socket/server artifacts and wrapper scripts;
- add a small Termux wrapper that forwards arguments to `am broadcast`;
- tune and test obstruction detection thresholds and add unit tests.

Tell me which of the above you'd like me to do next.
