# Lightweight Android Development Without Android Studio

## Overview

This guide teaches you how to set up a **command-line only** Android development environment and create Android projects using:

- **Kotlin** as the language
- **Gradle/Gradlew** for building
- **Android SDK Tools** (minimal, CLI-based)
- **adb** for deployment
- **VS Code or Vim** as your editor

**Target**: Full Android development without the 4GB+ memory footprint of Android Studio.

---

## Part 1: Environment Setup

### 1.1 Install Prerequisites

**On Linux (Ubuntu/Debian)**:

```bash
# Java/Kotlin toolchain
sudo apt-get install openjdk-17-jdk openjdk-17-jdk-headless

# Build essentials
sudo apt-get install build-essential wget curl unzip

# Optional: Lightweight editor
sudo apt-get install vim neovim
# or install VS Code from https://code.visualstudio.com/

# Verify Java
java -version
javac -version
```

**On macOS**:

```bash
# Homebrew setup
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Java
brew install openjdk@17

# Lightweight editor
brew install vim neovim
```

**On Windows (WSL2 + Ubuntu)**:
Same as Linux above.

### 1.2 Install Android SDK (CLI Only)

**Download Command Line Tools**:

```bash
# Create SDK directory
mkdir -p ~/Android/sdk

# Download latest command-line tools
# Go to: https://developer.android.com/studio/#command-tools
# Download "Command line tools only" (not Android Studio)

cd ~/Downloads
# Extract
unzip cmdline-tools-linux-*.zip
mkdir -p ~/Android/sdk/cmdline-tools/latest
mv cmdline-tools/* ~/Android/sdk/cmdline-tools/latest/
```

**Set Environment Variables**:

```bash
# Add to ~/.bashrc or ~/.zshrc
export ANDROID_HOME=~/Android/sdk
export PATH=$ANDROID_HOME/cmdline-tools/latest/bin:$PATH
export PATH=$ANDROID_HOME/platform-tools:$PATH
export PATH=$ANDROID_HOME/tools:$PATH

# Reload
source ~/.bashrc  # or ~/.zshrc
```

**Install SDK Components**:

```bash
# Accept all licenses (required)
yes | sdkmanager --licenses

# Install minimum components needed
sdkmanager "platform-tools"
sdkmanager "build-tools;33.0.2"
sdkmanager "platforms;android-33"
sdkmanager "platforms;android-34"

# Optional: Emulator (skip if not needed)
sdkmanager "emulator"
sdkmanager "system-images;android-33;default;x86_64"

# Verify installation
sdkmanager --list_installed
```

**Verify adb**:

```bash
adb version
# Should show: Android Debug Bridge version X.X.X

# Connect device (enable USB debugging first)
adb devices
# Should list your device
```

### 1.3 Install Gradle (Optional, use Gradlew)

For most projects, **Gradlew** (Gradle Wrapper) is built-in and preferred. But if needed:

```bash
# Download Gradle (optional)
wget https://services.gradle.org/distributions/gradle-8.4-bin.zip
unzip gradle-8.4-bin.zip
sudo mv gradle-8.4 /opt/gradle

# Set PATH (add to ~/.bashrc)
export PATH="/opt/gradle/bin:$PATH"

gradle --version
```

**Note**: We'll use Gradlew in projects, so this is optional.

### 1.4 Install Kotlin Compiler (Optional)

```bash
# Via SDKMAN (easiest)
curl -s "https://get.sdkman.io" | bash
source "$HOME/.sdkman/bin/sdkman-init.sh"
sdk install kotlin

# Or via package manager
# Ubuntu
sudo apt-get install kotlin

# Verify
kotlinc -version
```

---

## Part 2: Project Structure

### 2.1 Minimal Project Layout

```
my-android-project/
├── app/                              # Main app module
│   └── src/
│       ├── main/
│       │   ├── AndroidManifest.xml   # App manifest
│       │   ├── java/
│       │   │   └── com/example/app/
│       │   │       ├── MainActivity.kt
│       │   │       └── services/
│       │   │           └── MyService.kt
│       │   └── res/
│       │       ├── values/
│       │       │   ├── strings.xml
│       │       │   ├── colors.xml
│       │       │   └── styles.xml
│       │       ├── layout/
│       │       │   └── activity_main.xml
│       │       └── drawable/
│       └── test/
│           └── java/...
│
├── gradle/
│   └── wrapper/
│       ├── gradle-wrapper.jar
│       └── gradle-wrapper.properties
│
├── build.gradle                      # Project-level config
├── app/build.gradle                  # App-level config
├── settings.gradle                   # Project settings
├── gradlew                           # Gradle wrapper (executable)
├── gradlew.bat                       # Gradle wrapper (Windows)
└── local.properties                  # Local SDK path (auto-generated)
```

### 2.2 Manual Project Creation Script

Create a `create-android-project.sh` script to automate setup:

```bash
#!/bin/bash

# Usage: ./create-android-project.sh ProjectName com.example.app

PROJECT_NAME="${1:-MyApp}"
PACKAGE_NAME="${2:-com.example.myapp}"
PROJECT_DIR="./$PROJECT_NAME"

echo "Creating Android project: $PROJECT_NAME"
echo "Package: $PACKAGE_NAME"

# Create directory structure
mkdir -p "$PROJECT_DIR"
cd "$PROJECT_DIR"

# Create directories
mkdir -p app/src/main/java/$(echo $PACKAGE_NAME | tr . /)
mkdir -p app/src/main/res/{values,layout,drawable}
mkdir -p app/src/test/java
mkdir -p gradle/wrapper

# Create AndroidManifest.xml
cat > app/src/main/AndroidManifest.xml << 'MANIFEST'
<?xml version="1.0" encoding="utf-8"?>
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
    package="PACKAGE_PLACEHOLDER">

    <uses-permission android:name="android.permission.INTERNET" />

    <application
        android:allowBackup="true"
        android:debuggable="true"
        android:icon="@drawable/ic_launcher"
        android:label="@string/app_name"
        android:theme="@style/AppTheme">

        <activity
            android:name=".MainActivity"
            android:exported="true">
            <intent-filter>
                <action android:name="android.intent.action.MAIN" />
                <category android:name="android.intent.category.LAUNCHER" />
            </intent-filter>
        </activity>

    </application>

</manifest>
MANIFEST

# Replace package name
sed -i "s|PACKAGE_PLACEHOLDER|$PACKAGE_NAME|g" app/src/main/AndroidManifest.xml

# Create MainActivity.kt
cat > app/src/main/java/$(echo $PACKAGE_NAME | tr . /)/MainActivity.kt << 'ACTIVITY'
package PACKAGE_PLACEHOLDER

import android.app.Activity
import android.os.Bundle

class MainActivity : Activity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)
    }
}
ACTIVITY

sed -i "s|PACKAGE_PLACEHOLDER|$PACKAGE_NAME|g" app/src/main/java/$(echo $PACKAGE_NAME | tr . /)/MainActivity.kt

# Create layout XML
cat > app/src/main/res/layout/activity_main.xml << 'LAYOUT'
<?xml version="1.0" encoding="utf-8"?>
<LinearLayout xmlns:android="http://schemas.android.com/apk/res/android"
    android:layout_width="match_parent"
    android:layout_height="match_parent"
    android:orientation="vertical"
    android:padding="16dp">

    <TextView
        android:layout_width="match_parent"
        android:layout_height="wrap_content"
        android:text="@string/hello_world"
        android:textSize="18sp" />

</LinearLayout>
LAYOUT

# Create strings.xml
cat > app/src/main/res/values/strings.xml << 'STRINGS'
<?xml version="1.0" encoding="utf-8"?>
<resources>
    <string name="app_name">PROJECT_NAME_PLACEHOLDER</string>
    <string name="hello_world">Hello, World!</string>
</resources>
STRINGS

sed -i "s|PROJECT_NAME_PLACEHOLDER|$PROJECT_NAME|g" app/src/main/res/values/strings.xml

# Create colors.xml
cat > app/src/main/res/values/colors.xml << 'COLORS'
<?xml version="1.0" encoding="utf-8"?>
<resources>
    <color name="colorPrimary">#008577</color>
    <color name="colorPrimaryDark">#00574B</color>
    <color name="colorAccent">#D81B60</color>
</resources>
COLORS

# Create styles.xml
cat > app/src/main/res/values/styles.xml << 'STYLES'
<?xml version="1.0" encoding="utf-8"?>
<resources>
    <style name="AppTheme" parent="android:Theme.Material.Light.DarkActionBar">
        <item name="android:colorPrimary">@color/colorPrimary</item>
        <item name="android:colorPrimaryDark">@color/colorPrimaryDark</item>
        <item name="android:colorAccent">@color/colorAccent</item>
    </style>
</resources>
STYLES

# Create project-level build.gradle
cat > build.gradle << 'BUILD_PROJECT'
buildscript {
    repositories {
        google()
        mavenCentral()
    }
    dependencies {
        classpath 'com.android.tools.build:gradle:8.1.0'
        classpath 'org.jetbrains.kotlin:kotlin-gradle-plugin:1.9.0'
    }
}

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}
BUILD_PROJECT

# Create app-level build.gradle
cat > app/build.gradle << 'BUILD_APP'
apply plugin: 'com.android.application'
apply plugin: 'kotlin-android'

android {
    compileSdk 33

    defaultConfig {
        applicationId "PACKAGE_PLACEHOLDER"
        minSdk 24
        targetSdk 33
        versionCode 1
        versionName "1.0"
    }

    buildTypes {
        debug {
            debuggable true
        }
        release {
            minifyEnabled false
            proguardFiles getDefaultProguardFile('proguard-android-optimize.txt'), 'proguard-rules.pro'
        }
    }

    compileOptions {
        sourceCompatibility JavaVersion.VERSION_11
        targetCompatibility JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = '11'
    }
}

dependencies {
    implementation 'androidx.appcompat:appcompat:1.6.1'
    implementation 'androidx.core:core:1.10.1'
    implementation 'com.google.android.material:material:1.9.0'

    testImplementation 'junit:junit:4.13.2'
}
BUILD_APP

sed -i "s|PACKAGE_PLACEHOLDER|$PACKAGE_NAME|g" app/build.gradle

# Create settings.gradle
cat > settings.gradle << 'SETTINGS'
pluginManagement {
    repositories {
        google()
        gradlePluginPortal()
        mavenCentral()
    }
}

dependencyResolutionManagement {
    repositoriesMode.set(RepositoriesMode.FAIL_ON_PROJECT_REPOS)
    repositories {
        google()
        mavenCentral()
    }
}

rootProject.name = "PROJECT_NAME_PLACEHOLDER"
include ':app'
SETTINGS

sed -i "s|PROJECT_NAME_PLACEHOLDER|$PROJECT_NAME|g" settings.gradle

# Create gradle wrapper properties
cat > gradle/wrapper/gradle-wrapper.properties << 'WRAPPER'
distributionBase=GRADLE_USER_HOME
distributionPath=wrapper/dists
distributionUrl=https\://services.gradle.org/distributions/gradle-8.4-bin.zip
zipStoreBase=GRADLE_USER_HOME
zipStorePath=wrapper/dists
WRAPPER

# Download gradle wrapper (if you have curl)
# This step requires network access
echo "Downloading Gradle wrapper..."
cd ..
gradle_version="8.4"

# Alternative: manually copy gradlew files from existing project
# Or use this inline approach (requires curl):
# curl -L https://github.com/gradle/gradle/releases/download/v$gradle_version/gradle-$gradle_version-bin.zip -o gradle-wrapper.zip

# For now, create basic gradlew script
cat > "$PROJECT_DIR/gradlew" << 'GRADLEW'
#!/bin/bash
cd "$(dirname "$0")" || exit
exec ./gradlew "$@"
GRADLEW

chmod +x "$PROJECT_DIR/gradlew"

echo "✓ Android project created: $PROJECT_DIR"
echo "Next steps:"
echo "  1. cd $PROJECT_DIR"
echo "  2. ./gradlew build"
echo "  3. adb install app/build/outputs/apk/debug/app-debug.apk"
```

Save this as `create-android-project.sh`:

```bash
chmod +x create-android-project.sh
./create-android-project.sh MyCamera com.example.camera
```

---

## Part 3: Gradle Configuration Deep Dive

### 3.1 Project-Level build.gradle

**Purpose**: Shared build configuration for all modules

```gradle
buildscript {
    ext {
        kotlinVersion = '1.9.0'
        gradleVersion = '8.1.0'
    }

    repositories {
        google()           // Google's Maven repository
        mavenCentral()     // Central Maven repository
        gradlePluginPortal()
    }

    dependencies {
        // Android Gradle Plugin - needed to build Android apps
        classpath "com.android.tools.build:gradle:${gradleVersion}"

        // Kotlin Gradle Plugin - needed to compile Kotlin
        classpath "org.jetbrains.kotlin:kotlin-gradle-plugin:${kotlinVersion}"
    }
}

// Apply plugins to all subprojects
allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

// Optional: Project-wide properties
ext {
    compileSdkVersion = 33
    minSdkVersion = 24
    targetSdkVersion = 33
}
```

### 3.2 App-Level build.gradle

**Purpose**: Configuration specific to the app module

```gradle
plugins {
    id 'com.android.application'
    id 'kotlin-android'
}

android {
    namespace "com.example.myapp"  // Package name
    compileSdk 33                   // API level to compile against

    defaultConfig {
        applicationId "com.example.myapp"
        minSdk 24                   // Minimum Android version (API 24 = Android 7.0)
        targetSdk 33                // Target Android version
        versionCode 1               // Internal version
        versionName "1.0"           // User-visible version

        testInstrumentationRunner "androidx.test.runner.AndroidJUnitRunner"
    }

    buildTypes {
        debug {
            debuggable true
            minifyEnabled false
        }
        release {
            debuggable false
            minifyEnabled true        // Code shrinking (ProGuard)
            proguardFiles getDefaultProguardFile('proguard-android-optimize.txt'), 'proguard-rules.pro'
        }
    }

    compileOptions {
        sourceCompatibility JavaVersion.VERSION_11
        targetCompatibility JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = '11'
    }

    // Enable view binding
    buildFeatures {
        viewBinding true
    }
}

dependencies {
    // AndroidX core libraries
    implementation 'androidx.core:core:1.10.1'
    implementation 'androidx.appcompat:appcompat:1.6.1'

    // Material Design (UI components)
    implementation 'com.google.android.material:material:1.9.0'

    // Kotlin standard library
    implementation "org.jetbrains.kotlin:kotlin-stdlib:1.9.0"

    // Lifecycle components
    implementation 'androidx.lifecycle:lifecycle-runtime-ktx:2.6.1'
    implementation 'androidx.lifecycle:lifecycle-common:2.6.1'

    // Testing
    testImplementation 'junit:junit:4.13.2'
    androidTestImplementation 'androidx.test.ext:junit:1.1.5'
    androidTestImplementation 'androidx.test.espresso:espresso-core:3.5.1'
}
```

### 3.3 Key Gradle Tasks

```bash
# Navigate to project directory
cd MyApp

# Build debug APK
./gradlew assembleDebug
# Output: app/build/outputs/apk/debug/app-debug.apk

# Build release APK (requires signing)
./gradlew assembleRelease

# Clean build directory
./gradlew clean

# Run tests
./gradlew test

# Build and install on connected device
./gradlew installDebug

# Check dependencies
./gradlew dependencies

# View available tasks
./gradlew tasks

# Build with verbose output (debugging)
./gradlew assembleDebug --stacktrace

# Run specific task from module
./gradlew app:build
```

---

## Part 4: Building & Deployment

### 4.1 Complete Build Workflow

```bash
# Step 1: Clean
./gradlew clean

# Step 2: Build debug APK
./gradlew assembleDebug

# Verify APK was created
ls -lh app/build/outputs/apk/debug/

# Step 3: Connect device (USB debugging enabled)
adb devices

# Step 4: Install APK
adb install app/build/outputs/apk/debug/app-debug.apk

# Step 5: Launch app
adb shell am start -n com.example.myapp/.MainActivity

# Step 6: View logs
adb logcat -s MyApp
```

### 4.2 Advanced: Build Signing

**For release builds, you need a keystore:**

```bash
# Generate keystore (one-time)
keytool -genkey -v -keystore my-app.keystore \
    -keyalg RSA -keysize 2048 -validity 10000 \
    -alias my-key-alias -storepass mypassword -keypass mykeypass

# Add to build.gradle:
android {
    ...
    signingConfigs {
        release {
            storeFile file('my-app.keystore')
            storePassword 'mypassword'
            keyAlias 'my-key-alias'
            keyPassword 'mykeypass'
        }
    }

    buildTypes {
        release {
            signingConfig signingConfigs.release
            minifyEnabled true
            proguardFiles getDefaultProguardFile('proguard-android-optimize.txt'), 'proguard-rules.pro'
        }
    }
}

# Build signed APK
./gradlew assembleRelease
# Output: app/build/outputs/apk/release/app-release.apk
```

### 4.3 Debugging with adb

```bash
# View all logs
adb logcat

# Filter logs by tag
adb logcat -s "MyAppTag"

# Real-time logs while running app
adb logcat | grep MyApp

# Clear logcat
adb logcat -c

# Logcat with detailed format
adb logcat -v threadtime

# Capture crash logs
adb logcat *:E > crash.log

# Debug app (requires debuggable=true in manifest)
adb shell am start -D -n com.example.myapp/.MainActivity
# Then attach debugger (Android Studio only)

# Push/Pull files
adb push local_file /data/local/tmp/remote_file
adb pull /data/local/tmp/remote_file local_file

# Access device shell
adb shell
```

---

## Part 5: Kotlin-Specific Setup

### 5.1 Kotlin Project Structure

```
app/src/main/java/com/example/myapp/
├── MainActivity.kt           # Activity
├── services/
│   └── MyService.kt          # Service
├── ui/
│   └── fragments/
│       └── HomeFragment.kt
├── data/
│   ├── models/
│   │   └── User.kt          # Data classes
│   └── repository/
│       └── UserRepository.kt
└── utils/
    └── Extensions.kt        # Helper functions
```

### 5.2 Minimal Kotlin Activity

```kotlin
package com.example.myapp

import android.app.Activity
import android.os.Bundle
import androidx.appcompat.app.AppCompatActivity
import com.example.myapp.databinding.ActivityMainBinding

class MainActivity : AppCompatActivity() {
    private lateinit var binding: ActivityMainBinding

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        binding = ActivityMainBinding.inflate(layoutInflater)
        setContentView(binding.root)

        // Your code here
    }
}
```

### 5.3 Minimal Kotlin Service

```kotlin
package com.example.myapp.services

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

---

## Part 6: Project Creation Workflow

### 6.1 Step-by-Step: Creating a New Project

```
STEP 1: Setup
  └─ Run create-android-project.sh script

STEP 2: Navigate & Sync
  └─ cd MyProject
  └─ ./gradlew build  (downloads dependencies, compiles)

STEP 3: Edit Code
  └─ Use VS Code / Vim for editing
  └─ Edit AndroidManifest.xml
  └─ Edit MainActivity.kt
  └─ Edit XML layouts

STEP 4: Test Locally
  └─ ./gradlew test

STEP 5: Build Debug APK
  └─ ./gradlew assembleDebug

STEP 6: Install on Device
  └─ adb install app/build/outputs/apk/debug/app-debug.apk

STEP 7: Run & Debug
  └─ adb shell am start -n com.example.myapp/.MainActivity
  └─ adb logcat -s MyApp

STEP 8: Iterate
  └─ Edit code
  └─ Build: ./gradlew assembleDebug
  └─ Install: adb install -r app/build/outputs/apk/debug/app-debug.apk
  └─ Test: adb logcat
```

### 6.2 Daily Development Workflow

```bash
#!/bin/bash
# dev-workflow.sh - Quick development loop

PROJECT_DIR="$1"
cd "$PROJECT_DIR" || exit

while true; do
    echo "=== Build & Deploy ==="

    # Clean and build
    ./gradlew clean assembleDebug

    if [ $? -ne 0 ]; then
        echo "Build failed!"
        read -p "Press Enter to retry..."
        continue
    fi

    # Install
    echo "Installing APK..."
    adb install -r app/build/outputs/apk/debug/app-debug.apk

    # Start activity
    echo "Launching app..."
    adb shell am start -n com.example.myapp/.MainActivity

    # Stream logs
    echo "=== Logs ==="
    timeout 30 adb logcat -s "MyApp" || true

    read -p "Build again? (y/n) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        break
    fi
done
```

Usage:

```bash
chmod +x dev-workflow.sh
./dev-workflow.sh MyProject
```

---

## Part 7: Essential Command Reference

### 7.1 Gradle Commands (Most Used)

| Command                     | Purpose                   |
| --------------------------- | ------------------------- |
| `./gradlew build`           | Build everything          |
| `./gradlew assembleDebug`   | Build debug APK           |
| `./gradlew assembleRelease` | Build release APK         |
| `./gradlew clean`           | Clean build directory     |
| `./gradlew test`            | Run unit tests            |
| `./gradlew installDebug`    | Build & install debug APK |
| `./gradlew tasks`           | List all available tasks  |
| `./gradlew dependencies`    | Show dependency tree      |

### 7.2 ADB Commands (Most Used)

| Command                         | Purpose                     |
| ------------------------------- | --------------------------- |
| `adb devices`                   | List connected devices      |
| `adb install <apk>`             | Install APK                 |
| `adb install -r <apk>`          | Install, replacing existing |
| `adb shell am start <activity>` | Launch activity             |
| `adb logcat`                    | Stream device logs          |
| `adb push <local> <remote>`     | Copy file to device         |
| `adb pull <remote> <local>`     | Copy file from device       |
| `adb shell`                     | Access device shell         |

### 7.3 SDK Manager Commands

| Command                       | Purpose                       |
| ----------------------------- | ----------------------------- |
| `sdkmanager --list_installed` | Show installed SDK components |
| `sdkmanager "platform-tools"` | Install specific component    |
| `sdkmanager --licenses`       | Accept SDK licenses           |
| `sdkmanager --update`         | Update all components         |

---

## Part 8: Minimal Project Template

### Save This as `minimal-project-template.zip`

```
minimal-project/
├── app/
│   ├── build.gradle
│   └── src/main/
│       ├── AndroidManifest.xml
│       ├── java/com/example/app/
│       │   └── MainActivity.kt
│       └── res/
│           ├── layout/activity_main.xml
│           └── values/strings.xml
├── gradle/wrapper/
│   ├── gradle-wrapper.jar
│   └── gradle-wrapper.properties
├── build.gradle
├── settings.gradle
├── gradlew
└── gradlew.bat
```

To use:

```bash
# Copy template
cp -r minimal-project my-new-app
cd my-new-app

# Customize
sed -i 's/com\.example\.app/com.mycompany.myapp/g' **/*.gradle
sed -i 's/com\.example\.app/com.mycompany.myapp/g' app/src/main/**/*

# Build
./gradlew build
```

---

## Part 9: Troubleshooting

### 9.1 Common Issues

**Issue**: `ANDROID_HOME not set`

```bash
echo $ANDROID_HOME
# If empty, set it:
export ANDROID_HOME=~/Android/sdk
```

**Issue**: `Command 'sdkmanager' not found`

```bash
export PATH=$ANDROID_HOME/cmdline-tools/latest/bin:$PATH
```

**Issue**: `Gradle build hangs`

```bash
# Use offline mode
./gradlew build --offline

# Or increase memory
export GRADLE_OPTS="-Xmx2048m"
./gradlew build
```

**Issue**: `APK install fails`

```bash
# Uninstall existing version
adb uninstall com.example.myapp

# Try again
adb install app/build/outputs/apk/debug/app-debug.apk
```

**Issue**: `Kotlin compilation fails`

```bash
# Clean and rebuild
./gradlew clean build --stacktrace

# Update Kotlin version in build.gradle
```

---

## Part 10: Resource List

### 10.1 Essential Documentation

- [Android Developer Docs](https://developer.android.com/docs)
- [Gradle Documentation](https://docs.gradle.org/)
- [Kotlin for Android](https://kotlinlang.org/docs/android-overview.html)
- [Android Manifest Reference](https://developer.android.com/guide/topics/manifest/manifest-intro)

### 10.2 Useful Tools

```bash
# View APK contents
unzip -l app/build/outputs/apk/debug/app-debug.apk

# Inspect DEX file
# (requires dex-dump or Android SDK tools)

# Generate ProGuard mappings
# (for release builds with obfuscation)

# Quick JSON formatter for build output
cat gradle.json | jq '.'
```

---

## Summary: Complete Development Cycle

```bash
# INITIAL SETUP (one-time)
export ANDROID_HOME=~/Android/sdk
export PATH=$ANDROID_HOME/cmdline-tools/latest/bin:$PATH
export PATH=$ANDROID_HOME/platform-tools:$PATH
sdkmanager --licenses && sdkmanager "platform-tools" "build-tools;33.0.2" "platforms;android-33"

# CREATE PROJECT
chmod +x create-android-project.sh
./create-android-project.sh MyApp com.example.myapp
cd MyApp

# DEVELOP
# Edit code with vim/VS Code
# - app/src/main/java/com/example/myapp/MainActivity.kt
# - app/src/main/res/layout/activity_main.xml
# - app/src/main/AndroidManifest.xml

# BUILD & TEST
./gradlew clean assembleDebug

# DEPLOY
adb devices
adb install app/build/outputs/apk/debug/app-debug.apk

# RUN
adb shell am start -n com.example.myapp/.MainActivity
adb logcat -s MyApp

# ITERATE
# Edit code → Build → Install → Test → Repeat
```

---

**Version**: 1.0  
**Purpose**: Lightweight Android development without Android Studio  
**Tested**: Ubuntu 22.04, Java 17, Gradle 8.4, API 33
