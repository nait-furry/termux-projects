# Complete Android Development Without Android Studio - Master Guide

## Executive Summary

This guide enables you to develop Android apps using **only command-line tools** and a lightweight text editor (VS Code, Vim, etc.) instead of Android Studio or IntelliJ, resulting in:

- **3GB vs 4-5GB** disk space (60% smaller)
- **<500MB vs 4GB** RAM usage (80% less memory)
- **Instant launch** vs 20-30 second IDE startup
- **Same capabilities**: Build, deploy, debug, and manage projects
- **Better for resource-constrained laptops**

---

## The Complete Sequence: From Nothing to Shipping an App

### Phase 1: Environment Setup (15 minutes, one-time)

```
Goal: Get your computer ready to build Android apps

Step 1: Install Java
  ↓
Step 2: Download Android SDK Tools
  ↓
Step 3: Configure Environment Variables
  ↓
Step 4: Install SDK Components (APIs, Build Tools)
  ↓
Step 5: Verify with ADB
  ↓
Result: Ready to build
```

**Commands**:

```bash
# Install Java 17
sudo apt-get install openjdk-17-jdk

# Create SDK directory
mkdir -p ~/Android/sdk

# Download cmdline-tools from:
# https://developer.android.com/studio/#command-tools
# Extract to ~/Android/sdk/cmdline-tools/latest/

# Add to ~/.bashrc (or ~/.zshrc)
export ANDROID_HOME=~/Android/sdk
export PATH=$ANDROID_HOME/cmdline-tools/latest/bin:$PATH
export PATH=$ANDROID_HOME/platform-tools:$PATH
source ~/.bashrc

# Install SDKs
yes | sdkmanager --licenses
sdkmanager "platform-tools" "build-tools;33.0.2" "platforms;android-33"

# Verify
adb version
adb devices
```

**What You Get**:

- ✅ Gradle (included in SDK)
- ✅ Android APIs (to compile against)
- ✅ Build tools (compilation, packaging)
- ✅ adb (to deploy to device)
- ✅ Everything needed

**Time**: 10-15 minutes (mostly downloads)

---

### Phase 2: Project Creation (1-2 minutes, repeatable)

```
Goal: Create a new Android project from scratch

Run creation script
  ↓
Creates directory structure
  ↓
Generates all necessary files
  ↓
Result: Ready-to-build project
```

**Command**:

```bash
# Download and make executable
wget -O create-android-project.sh <your-script-url>
chmod +x create-android-project.sh

# Create project
./create-android-project.sh MyApp com.example.myapp
cd MyApp

# Result: Complete project structure
ls -la
# ├── app/src/main/...
# ├── build.gradle
# ├── app/build.gradle
# ├── settings.gradle
# ├── gradlew (executable)
# └── gradle/
```

**What Gets Created**:

- ✅ AndroidManifest.xml
- ✅ MainActivity.kt (Kotlin)
- ✅ activity_main.xml (UI Layout)
- ✅ strings.xml, colors.xml, styles.xml (Resources)
- ✅ build.gradle (Project config)
- ✅ app/build.gradle (App config + dependencies)
- ✅ settings.gradle (Project structure)
- ✅ gradlew (Build wrapper)

**Time**: ~1 minute

---

### Phase 3: Development (varies by project)

```
Goal: Write your app code

Open editor
  ↓
Edit Kotlin files (app/src/main/java/.../*.kt)
  ↓
Edit XML layouts (app/src/main/res/layout/...)
  ↓
Edit resources (strings, colors, etc.)
  ↓
Edit manifest if needed
```

**Editor Options**:

```bash
# VS Code (recommended)
code MyApp

# Vim
vim app/src/main/java/com/example/myapp/MainActivity.kt

# Nano
nano app/src/main/res/layout/activity_main.xml
```

**Key Files to Edit**:

1. `app/src/main/java/com/example/myapp/MainActivity.kt` - Main app logic
2. `app/src/main/res/layout/activity_main.xml` - UI layout
3. `app/src/main/res/values/strings.xml` - App strings
4. `app/build.gradle` - Add dependencies here

**Example: Adding a library**:

```gradle
// In app/build.gradle, add to dependencies:
dependencies {
    implementation 'com.squareup.okhttp3:okhttp:4.10.0'
    implementation 'com.google.code.gson:gson:2.10.1'
}
```

**Time**: Project-dependent

---

### Phase 4: Build (30-60 seconds per build)

```
Goal: Compile Kotlin and resources into an APK

Run ./gradlew assembleDebug
  ↓
Gradle downloads dependencies
  ↓
Kotlin compiler compiles .kt files
  ↓
Resource compiler processes XML
  ↓
DEX converter creates Android bytecode
  ↓
Packager creates APK
  ↓
Result: app/build/outputs/apk/debug/app-debug.apk
```

**Command**:

```bash
# First build (slower, ~60-90 sec - downloads dependencies)
./gradlew assembleDebug

# Subsequent builds (faster, ~20-40 sec - incremental)
./gradlew assembleDebug

# Clean rebuild (if needed)
./gradlew clean assembleDebug

# Verbose output (debugging)
./gradlew assembleDebug --stacktrace
```

**Output**:

```
BUILD SUCCESSFUL

Build took 45 seconds
APK: app/build/outputs/apk/debug/app-debug.apk
Size: ~5-10 MB
```

**What Gradle Does**:

1. Downloads dependencies (first time only)
2. Compiles Kotlin → Java bytecode
3. Processes Android resources
4. Converts to DEX (Android format)
5. Packages everything into APK
6. Signs with debug key (auto-done)

**Time**: 20-60 seconds

---

### Phase 5: Deploy to Device (10-20 seconds)

```
Goal: Install APK on your Android device

Enable USB debugging on device
  ↓
Connect via USB
  ↓
Verify ADB can see device
  ↓
Install APK
  ↓
Result: App installed on device
```

**Commands**:

```bash
# Step 1: Enable USB debugging
# On your phone: Settings → Developer Options → USB Debugging (ON)

# Step 2: Connect and verify
adb devices
# Should list your device

# Step 3: Install
adb install app/build/outputs/apk/debug/app-debug.apk

# Step 4: Install with replacement (if already installed)
adb install -r app/build/outputs/apk/debug/app-debug.apk

# Or do build and install in one step:
./gradlew installDebug
```

**Time**: 10-20 seconds

---

### Phase 6: Run & Debug (realtime)

```
Goal: Launch app and monitor execution

Launch app
  ↓
View logs in real-time
  ↓
Monitor execution
  ↓
Fix issues
```

**Commands**:

```bash
# Launch app
adb shell am start -n com.example.myapp/.MainActivity

# View logs (filter by tag)
adb logcat -s "MyApp"

# View all logs
adb logcat

# Real-time combined build + install + run:
# Terminal 1
./gradlew assembleDebug && adb install -r app/build/outputs/apk/debug/app-debug.apk

# Terminal 2
adb logcat -s "MyApp"

# Terminal 3
code MyApp  (edit code here)
```

**Logcat Examples**:

```bash
# View only your app's logs
adb logcat -s "MyApp"

# View with timestamps
adb logcat -v threadtime

# Filter by log level (Error only)
adb logcat *:E

# Real-time follow
adb logcat | grep MyApp
```

**Time**: Realtime (logs stream as they happen)

---

### Phase 7: Iterate (repeat Phases 3-6)

```
Edit Code
  ↓
Build (./gradlew assembleDebug)
  ↓
Install (adb install -r ...)
  ↓
Run (adb shell am start ...)
  ↓
Check Logs (adb logcat)
  ↓
Fix Issues
  ↓
Back to Edit Code
```

**Faster Iteration Loop**:

```bash
#!/bin/bash
# save as dev-loop.sh

while true; do
    clear
    echo "Building..."
    ./gradlew assembleDebug --daemon || continue

    echo "Installing..."
    adb install -r app/build/outputs/apk/debug/app-debug.apk || continue

    echo "Launching..."
    adb shell am start -n com.example.myapp/.MainActivity

    echo "Logs (Ctrl+C to stop and rebuild)..."
    adb logcat -s "MyApp"
done
```

Run it:

```bash
chmod +x dev-loop.sh
./dev-loop.sh
```

**Time**: 1-2 minutes per iteration

---

## Directory Structure Reference

```
MyApp/
├── app/                          # Main application module
│   ├── build.gradle             # App dependencies & config
│   ├── proguard-rules.pro        # Code obfuscation rules
│   └── src/
│       ├── main/
│       │   ├── AndroidManifest.xml          # App permissions & components
│       │   ├── java/com/example/myapp/
│       │   │   ├── MainActivity.kt          # ← EDIT: Main activity
│       │   │   ├── services/
│       │   │   │   └── MyService.kt
│       │   │   └── utils/
│       │   │       └── Extensions.kt
│       │   └── res/
│       │       ├── layout/
│       │       │   └── activity_main.xml    # ← EDIT: UI layout
│       │       ├── values/
│       │       │   ├── strings.xml          # ← EDIT: App strings
│       │       │   ├── colors.xml           # ← EDIT: Colors
│       │       │   └── styles.xml           # ← EDIT: Themes
│       │       ├── drawable/
│       │       ├── mipmap/
│       │       └── animator/
│       ├── test/java/...                    # Unit tests
│       └── androidTest/java/...             # Integration tests
│
├── gradle/                       # Gradle wrapper files
│   └── wrapper/
│       ├── gradle-wrapper.jar
│       └── gradle-wrapper.properties
│
├── build.gradle                  # Project-level config
├── settings.gradle               # Project structure
├── local.properties              # Local SDK path
├── gradlew                        # Unix build script (use this!)
├── gradlew.bat                   # Windows build script
└── build/                        # Generated (ignore)
    └── outputs/apk/debug/
        └── app-debug.apk        # ← Your built APK
```

**Files YOU Edit**:

- `MainActivity.kt` - App logic
- `activity_main.xml` - UI
- `strings.xml` - Text resources
- `app/build.gradle` - Dependencies
- `AndroidManifest.xml` - Permissions

**Files to Ignore**:

- `build/` - Generated
- `.gradle/` - Generated
- `*.apk` - Generated

---

## Essential Command Reference

| Task           | Command                                   | Time      |
| -------------- | ----------------------------------------- | --------- |
| Create project | `./create-android-project.sh Name pkg`    | 1 min     |
| Build          | `./gradlew assembleDebug`                 | 30-60 sec |
| Install        | `adb install -r app/.../app-debug.apk`    | 10 sec    |
| Run            | `adb shell am start -n pkg/.MainActivity` | 2 sec     |
| View logs      | `adb logcat -s TAG`                       | Realtime  |
| Clean build    | `./gradlew clean assembleDebug`           | 60-90 sec |
| Test           | `./gradlew test`                          | 30-60 sec |
| Release build  | `./gradlew assembleRelease`               | 60-90 sec |

---

## Project Templates

### Template 1: Minimal Activity

```kotlin
// MainActivity.kt
package com.example.myapp

import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle

class MainActivity : AppCompatActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)
    }
}
```

### Template 2: Foreground Service (For Camera/Recording)

```kotlin
// MyService.kt
package com.example.myapp

import android.app.Service
import android.content.Intent
import android.os.IBinder
import android.util.Log

class MyService : Service() {
    companion object {
        private const val TAG = "MyService"
    }

    override fun onCreate() {
        super.onCreate()
        Log.d(TAG, "Service created")
    }

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        Log.d(TAG, "Service started")
        return START_STICKY
    }

    override fun onBind(intent: Intent?): IBinder? = null
}
```

### Template 3: Kotlin Extensions

```kotlin
// Extensions.kt
package com.example.myapp.utils

import android.content.Context
import android.widget.Toast

fun Context.toast(message: String) {
    Toast.makeText(this, message, Toast.LENGTH_SHORT).show()
}

fun String.isValidEmail(): Boolean {
    return this.contains("@") && this.contains(".")
}
```

---

## Troubleshooting Quick Reference

| Problem                     | Solution                                              |
| --------------------------- | ----------------------------------------------------- |
| `ANDROID_HOME not found`    | `export ANDROID_HOME=~/Android/sdk`                   |
| `adb: command not found`    | Check `$PATH` includes `$ANDROID_HOME/platform-tools` |
| `Gradle build fails`        | `./gradlew clean assembleDebug --stacktrace`          |
| `Device not detected`       | Enable USB debugging, check `adb devices`             |
| `APK install fails`         | `adb uninstall com.example.myapp` then retry          |
| `Build takes too long`      | `export GRADLE_DAEMON=true`, use `--daemon` flag      |
| `Kotlin not found`          | Check `build.gradle` has kotlin plugin                |
| `Cannot resolve dependency` | Run `./gradlew build --refresh-dependencies`          |

---

## Comparison: Your Approach vs Alternatives

| Feature            | Android Studio   | IntelliJ IDEA | **Your Setup**              |
| ------------------ | ---------------- | ------------- | --------------------------- |
| **Disk Space**     | 5-7 GB           | 3-5 GB        | **1.5-3 GB**                |
| **Memory Usage**   | 4-6 GB RAM       | 3-5 GB RAM    | **<500 MB**                 |
| **Startup Time**   | 20-30 sec        | 15-20 sec     | **Instant**                 |
| **Build Speed**    | Same             | Same          | **Same**                    |
| **Kotlin Support** | Full             | Full          | **Full**                    |
| **Gradle Support** | Full             | Full          | **Full**                    |
| **Testing**        | Yes              | Yes           | **Yes**                     |
| **Debugging**      | Advanced         | Advanced      | **Basic (logs)**            |
| **Best For**       | Complex projects | Large teams   | **Lightweight development** |

---

## Advanced: Gradle Customization

Add to `build.gradle` for custom behaviors:

```gradle
// Fast install task
task fastInstall {
    dependsOn 'assembleDebug'
    doLast {
        exec {
            commandLine 'adb', 'install', '-r',
                'app/build/outputs/apk/debug/app-debug.apk'
        }
    }
}

// View logs task
task showLogs {
    doLast {
        exec {
            commandLine 'adb', 'logcat', '-s', 'MyApp'
        }
    }
}

// Full dev cycle
task devCycle {
    dependsOn 'assembleDebug'
    dependsOn 'fastInstall'
    doLast {
        println("✓ Build, install, and ready to test!")
    }
}
```

Use:

```bash
./gradlew fastInstall
./gradlew showLogs
./gradlew devCycle
```

---

## Workflow Optimization Tips

### Tip 1: Use Gradle Daemon

```bash
export GRADLE_DAEMON=true
# Speeds up subsequent builds
```

### Tip 2: Parallel Build

```bash
export GRADLE_OPTS="-Xmx2048m -XX:+UseG1GC"
# Better memory management
```

### Tip 3: Skip Tests During Development

```bash
./gradlew assembleDebug -x test
# Faster builds when you don't need tests
```

### Tip 4: Incremental Builds

Gradle automatically only recompiles changed files. Clean build only when needed.

### Tip 5: Three Terminal Workflow

- **Terminal 1**: Build loop
- **Terminal 2**: Logcat stream
- **Terminal 3**: Code editor

---

## Next Steps After This Guide

1. **Phase 1**: Follow environment setup (15 min)
2. **Phase 2**: Run project creation script (1 min)
3. **Phase 3**: Start editing code (edit your first app)
4. **Phase 4-6**: Build → Deploy → Test cycle
5. **Phase 7**: Iterate until complete

**Expected Timeline**:

- Setup: 15 minutes
- First app: 30 minutes
- Comfortable: 2-3 apps

---

## Resources

- [Android Developer Docs](https://developer.android.com/docs)
- [Gradle Documentation](https://docs.gradle.org)
- [Kotlin for Android](https://kotlinlang.org/docs/android-overview.html)
- [ADB Reference](https://developer.android.com/studio/command-line/adb)

---

**Summary**: You now have everything needed to develop Android apps efficiently without heavy IDEs. The setup is minimal, the workflow is fast, and you maintain full control over your development environment.

Start with Phase 1 (setup), then Phase 2 (create a project), and you're ready to ship Android apps! 🚀
