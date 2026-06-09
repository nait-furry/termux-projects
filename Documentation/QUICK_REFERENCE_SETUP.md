# Android Development Environment Setup - Quick Reference

## One-Time Setup (10 minutes)

### 1. Install Java 17

```bash
# Ubuntu/Debian
sudo apt-get install openjdk-17-jdk

# macOS
brew install openjdk@17

# Verify
java -version  # Should show Java 17.x.x
```

### 2. Download Android SDK

```bash
# Create SDK directory
mkdir -p ~/Android/sdk

# Download from: https://developer.android.com/studio/#command-tools
# Extract to ~/Android/sdk/cmdline-tools/latest/

# Verify extraction
ls ~/Android/sdk/cmdline-tools/latest/bin/
```

### 3. Set Environment Variables

```bash
# Add to ~/.bashrc or ~/.zshrc
export ANDROID_HOME=~/Android/sdk
export PATH=$ANDROID_HOME/cmdline-tools/latest/bin:$PATH
export PATH=$ANDROID_HOME/platform-tools:$PATH

# Reload shell
source ~/.bashrc
```

### 4. Install SDK Components

```bash
# Accept licenses
yes | sdkmanager --licenses

# Install essentials (2-3 minutes)
sdkmanager "platform-tools"
sdkmanager "build-tools;33.0.2"
sdkmanager "platforms;android-33"

# Verify
sdkmanager --list_installed | head -5
```

### 5. Verify adb

```bash
adb version
# Should show: Android Debug Bridge version X.X.X

# Connect device (USB debugging enabled)
adb devices
```

---

## Create New Project (1 minute)

```bash
# Make script executable
chmod +x create-android-project.sh

# Create project
./create-android-project.sh MyCameraApp com.example.camera
cd MyCameraApp
```

**Result**: Complete Android project structure with Gradle build system ready to build.

---

## Build & Deploy (3 minutes)

### Build

```bash
# Debug APK
./gradlew assembleDebug
# Output: app/build/outputs/apk/debug/app-debug.apk

# Or build & install in one step
./gradlew installDebug
```

### Deploy

```bash
# Install on device
adb install app/build/outputs/apk/debug/app-debug.apk

# Or reinstall (replace existing)
adb install -r app/build/outputs/apk/debug/app-debug.apk

# Launch app
adb shell am start -n com.example.camera/.MainActivity
```

### Debug

```bash
# View logs
adb logcat -s "MyApp"

# Real-time logs while running
adb logcat | grep MyApp
```

---

## Key Directory Structure

```
MyCameraApp/
├── app/src/main/
│   ├── AndroidManifest.xml      ← App config & permissions
│   ├── java/com/example/camera/
│   │   └── MainActivity.kt       ← Main code (edit here)
│   └── res/
│       ├── layout/
│       │   └── activity_main.xml ← UI layout
│       └── values/
│           ├── strings.xml       ← App strings
│           ├── colors.xml        ← Colors
│           └── styles.xml        ← Themes
├── build.gradle                  ← Project config
├── app/build.gradle              ← App config & dependencies
├── settings.gradle               ← Project structure
└── gradlew                       ← Build tool (use instead of gradle)
```

---

## Most Common Commands

| Task                | Command                                    |
| ------------------- | ------------------------------------------ |
| Create project      | `./create-android-project.sh Name com.pkg` |
| Build debug APK     | `./gradlew assembleDebug`                  |
| Clean build         | `./gradlew clean`                          |
| Install on device   | `adb install app/.../app-debug.apk`        |
| Run app             | `adb shell am start -n pkg/.MainActivity`  |
| View logs           | `adb logcat -s TAG`                        |
| View file structure | `find . -name "*.kt" -o -name "*.xml"`     |

---

## Workflow: Edit → Build → Test

### Terminal 1: Build Loop

```bash
cd MyProject
while true; do
    ./gradlew assembleDebug && \
    adb install -r app/build/outputs/apk/debug/app-debug.apk && \
    adb shell am start -n com.example.myapp/.MainActivity
    read -p "Build again? (y/n) " -n 1 && echo || break
done
```

### Terminal 2: View Logs

```bash
adb logcat -s "MyApp"
```

### Terminal 3: Edit Code

```bash
code MyProject  # or vim, etc.
```

---

## Common Build Errors & Fixes

**Error**: `ANDROID_HOME not set`

```bash
echo $ANDROID_HOME
# If empty:
export ANDROID_HOME=~/Android/sdk
```

**Error**: `SDK not found`

```bash
# Verify SDK location
ls -la ~/Android/sdk/
# Should have: cmdline-tools, platform-tools, platforms, build-tools
```

**Error**: `Gradle build hangs`

```bash
# Kill and retry with more memory
pkill -f gradle
export GRADLE_OPTS="-Xmx2048m"
./gradlew assembleDebug
```

**Error**: `APK installation fails`

```bash
# Uninstall existing version first
adb uninstall com.example.myapp

# Then retry install
adb install app/build/outputs/apk/debug/app-debug.apk
```

**Error**: `Device not found`

```bash
# List devices
adb devices

# If empty:
# 1. Enable USB debugging on device
# 2. Reconnect USB
# 3. Authorize on device prompt
# 4. Try again
adb devices
```

---

## Project Specifications (Your Setup)

```
Language:           Kotlin
Build System:       Gradle + Gradlew (no need for Gradle separately)
Minimum SDK:        API 24 (Android 7.0)
Compile SDK:        API 33 (Android 13)
Build Tools:        33.0.2
JVM Target:         Java 11
IDE:                VS Code / Vim (lightweight)
Deployment:         ADB only
Testing:            adb + logcat
```

---

## File Locations After Setup

```
Home Directory:
├── Android/
│   ├── sdk/
│   │   ├── cmdline-tools/latest/  ← SDK tools
│   │   ├── platform-tools/        ← adb, etc.
│   │   ├── platforms/             ← Android APIs
│   │   └── build-tools/           ← Compilers
│   └── ndk/ (optional)
├── .bashrc or .zshrc              ← Environment variables
└── Projects/
    └── MyCameraApp/               ← Your projects

SDK Path: ~/Android/sdk
Default: Takes ~8GB total
Lightweight: Can be ~3GB if minimal components installed
```

---

## Advanced: Custom Gradle Tasks

Add to `app/build.gradle` to create custom tasks:

```gradle
// Quick install task
task quickInstall {
    dependsOn 'assembleDebug'
    doLast {
        exec {
            commandLine 'adb', 'install', '-r',
                'app/build/outputs/apk/debug/app-debug.apk'
        }
    }
}

// View logs task
task viewLogs {
    doLast {
        exec {
            commandLine 'adb', 'logcat', '-s', 'MyApp'
        }
    }
}
```

Then use:

```bash
./gradlew quickInstall
./gradlew viewLogs
```

---

## Resources

- [Gradle Documentation](https://docs.gradle.org/)
- [Kotlin for Android](https://kotlinlang.org/docs/android-overview.html)
- [Android Developer Docs](https://developer.android.com/docs)
- [ADB Command Reference](https://developer.android.com/studio/command-line/adb)
- [AndroidManifest Reference](https://developer.android.com/guide/topics/manifest/manifest-intro)

---

**Total Time Investment**:

- Initial setup: ~15-20 minutes (one-time)
- Per new project: ~1 minute (automated)
- Build cycle: 30-60 seconds (fast iteration)

Compare to Android Studio:

- Download: ~4-5GB
- Install: 10+ GB disk
- Launch: 20-30 seconds
- Memory: 4GB+ RAM

**This approach**:

- Download: ~3GB total
- Install: 3GB disk
- Launch: Instant (command-line)
- Memory: <500MB RAM
