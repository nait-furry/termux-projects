#!/bin/bash

# create-android-project.sh
# Automated script to create a minimal Android project from scratch
# Usage: ./create-android-project.sh <ProjectName> <PackageName>
# Example: ./create-android-project.sh MyCameraApp com.example.camera

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'  # No Color

# Input validation
if [ $# -lt 2 ]; then
    echo -e "${RED}Usage: $0 <ProjectName> <PackageName>${NC}"
    echo "Example: $0 MyCameraApp com.example.camera"
    exit 1
fi

PROJECT_NAME="$1"
PACKAGE_NAME="$2"
PROJECT_DIR="./$PROJECT_NAME"
PACKAGE_PATH=$(echo "$PACKAGE_NAME" | tr . /)

echo -e "${BLUE}╔════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║  Android Project Creator (No Studio)   ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════╝${NC}"
echo ""
echo -e "${YELLOW}Project Name:${NC} $PROJECT_NAME"
echo -e "${YELLOW}Package:${NC} $PACKAGE_NAME"
echo -e "${YELLOW}Directory:${NC} $PROJECT_DIR"
echo ""

# Step 1: Create directory structure
echo -e "${BLUE}[1/8]${NC} Creating directory structure..."
mkdir -p "$PROJECT_DIR"
cd "$PROJECT_DIR"

mkdir -p app/src/main/java/$PACKAGE_PATH
mkdir -p app/src/main/res/{values,layout,drawable,mipmap}
mkdir -p app/src/androidTest/java/$PACKAGE_PATH
mkdir -p app/src/test/java/$PACKAGE_PATH
mkdir -p gradle/wrapper

echo -e "${GREEN}✓${NC} Directories created"

# Step 2: Create AndroidManifest.xml
echo -e "${BLUE}[2/8]${NC} Creating AndroidManifest.xml..."
cat > app/src/main/AndroidManifest.xml << 'MANIFEST'
<?xml version="1.0" encoding="utf-8"?>
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
    package="__PACKAGE__">

    <uses-permission android:name="android.permission.INTERNET" />

    <application
        android:allowBackup="true"
        android:debuggable="true"
        android:icon="@mipmap/ic_launcher"
        android:label="@string/app_name"
        android:supportsRtl="true"
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

sed -i "s|__PACKAGE__|$PACKAGE_NAME|g" app/src/main/AndroidManifest.xml
echo -e "${GREEN}✓${NC} AndroidManifest.xml created"

# Step 3: Create MainActivity.kt
echo -e "${BLUE}[3/8]${NC} Creating MainActivity.kt..."
cat > app/src/main/java/$PACKAGE_PATH/MainActivity.kt << 'ACTIVITY'
package __PACKAGE__

import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle

class MainActivity : AppCompatActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)
    }
}
ACTIVITY

sed -i "s|__PACKAGE__|$PACKAGE_NAME|g" app/src/main/java/$PACKAGE_PATH/MainActivity.kt
echo -e "${GREEN}✓${NC} MainActivity.kt created"

# Step 4: Create layout XML
echo -e "${BLUE}[4/8]${NC} Creating layout resources..."
cat > app/src/main/res/layout/activity_main.xml << 'LAYOUT'
<?xml version="1.0" encoding="utf-8"?>
<LinearLayout xmlns:android="http://schemas.android.com/apk/res/android"
    android:layout_width="match_parent"
    android:layout_height="match_parent"
    android:orientation="vertical"
    android:gravity="center"
    android:padding="16dp">

    <TextView
        android:layout_width="wrap_content"
        android:layout_height="wrap_content"
        android:text="@string/hello_world"
        android:textSize="24sp"
        android:textStyle="bold" />

    <TextView
        android:layout_width="wrap_content"
        android:layout_height="wrap_content"
        android:text="@string/welcome_message"
        android:textSize="16sp"
        android:layout_marginTop="16dp" />

</LinearLayout>
LAYOUT

echo -e "${GREEN}✓${NC} Layout created"

# Step 5: Create strings.xml
echo -e "${BLUE}[5/8]${NC} Creating string resources..."
cat > app/src/main/res/values/strings.xml << 'STRINGS'
<?xml version="1.0" encoding="utf-8"?>
<resources>
    <string name="app_name">__PROJECT_NAME__</string>
    <string name="hello_world">Hello, World!</string>
    <string name="welcome_message">Welcome to your new Android app</string>
</resources>
STRINGS

sed -i "s|__PROJECT_NAME__|$PROJECT_NAME|g" app/src/main/res/values/strings.xml
echo -e "${GREEN}✓${NC} Strings created"

# Step 6: Create colors.xml
echo -e "${BLUE}[6/8]${NC} Creating color resources..."
cat > app/src/main/res/values/colors.xml << 'COLORS'
<?xml version="1.0" encoding="utf-8"?>
<resources>
    <color name="colorPrimary">#3F51B5</color>
    <color name="colorPrimaryDark">#303F9F</color>
    <color name="colorAccent">#FF4081</color>
    <color name="white">#FFFFFF</color>
    <color name="black">#000000</color>
</resources>
COLORS

echo -e "${GREEN}✓${NC} Colors created"

# Step 7: Create styles.xml
echo -e "${BLUE}[7/8]${NC} Creating style resources..."
cat > app/src/main/res/values/styles.xml << 'STYLES'
<?xml version="1.0" encoding="utf-8"?>
<resources>
    <style name="AppTheme" parent="Theme.AppCompat.Light.DarkActionBar">
        <item name="colorPrimary">@color/colorPrimary</item>
        <item name="colorPrimaryDark">@color/colorPrimaryDark</item>
        <item name="colorAccent">@color/colorAccent</item>
    </style>
</resources>
STYLES

echo -e "${GREEN}✓${NC} Styles created"

# Step 8: Create Gradle files
echo -e "${BLUE}[8/8]${NC} Creating Gradle build files..."

# Project-level build.gradle
cat > build.gradle << 'BUILD_PROJECT'
buildscript {
    ext {
        compileSdkVersion = 33
        buildToolsVersion = "33.0.2"
        minSdkVersion = 24
        targetSdkVersion = 33
        
        kotlinVersion = '1.9.0'
        gradleVersion = '8.1.0'
    }
    
    repositories {
        google()
        mavenCentral()
        gradlePluginPortal()
    }
    
    dependencies {
        classpath "com.android.tools.build:gradle:${gradleVersion}"
        classpath "org.jetbrains.kotlin:kotlin-gradle-plugin:${kotlinVersion}"
    }
}

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

task clean(type: Delete) {
    delete rootProject.buildDir
}
BUILD_PROJECT

# App-level build.gradle
cat > app/build.gradle << 'BUILD_APP'
apply plugin: 'com.android.application'
apply plugin: 'kotlin-android'

android {
    compileSdk rootProject.ext.compileSdkVersion
    buildToolsVersion rootProject.ext.buildToolsVersion
    
    defaultConfig {
        applicationId "__PACKAGE__"
        minSdk rootProject.ext.minSdkVersion
        targetSdk rootProject.ext.targetSdkVersion
        versionCode 1
        versionName "1.0.0"
        
        testInstrumentationRunner "androidx.test.runner.AndroidJUnitRunner"
    }
    
    buildTypes {
        debug {
            debuggable true
            minifyEnabled false
        }
        release {
            minifyEnabled true
            shrinkResources true
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
    
    buildFeatures {
        viewBinding true
    }
}

dependencies {
    // AndroidX
    implementation 'androidx.appcompat:appcompat:1.6.1'
    implementation 'androidx.core:core:1.10.1'
    implementation 'androidx.constraintlayout:constraintlayout:2.1.4'
    
    // Material Design
    implementation 'com.google.android.material:material:1.9.0'
    
    // Kotlin
    implementation "org.jetbrains.kotlin:kotlin-stdlib:${rootProject.ext.kotlinVersion}"
    
    // Lifecycle
    implementation 'androidx.lifecycle:lifecycle-runtime-ktx:2.6.1'
    implementation 'androidx.lifecycle:lifecycle-common:2.6.1'
    
    // Testing
    testImplementation 'junit:junit:4.13.2'
    androidTestImplementation 'androidx.test.ext:junit:1.1.5'
    androidTestImplementation 'androidx.test.espresso:espresso-core:3.5.1'
}
BUILD_APP

sed -i "s|__PACKAGE__|$PACKAGE_NAME|g" app/build.gradle

# Settings.gradle
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

rootProject.name = "__PROJECT_NAME__"
include ':app'
SETTINGS

sed -i "s|__PROJECT_NAME__|$PROJECT_NAME|g" settings.gradle

# Gradle wrapper properties
cat > gradle/wrapper/gradle-wrapper.properties << 'WRAPPER'
distributionBase=GRADLE_USER_HOME
distributionPath=wrapper/dists
distributionUrl=https\://services.gradle.org/distributions/gradle-8.4-bin.zip
zipStoreBase=GRADLE_USER_HOME
zipStorePath=wrapper/dists
WRAPPER

# Create local.properties template
cat > local.properties << 'LOCAL'
# SDK configuration (auto-generated if not present)
sdk.dir=~/Android/sdk
ndk.dir=~/Android/ndk
LOCAL

# Create gradlew script
cat > gradlew << 'GRADLEW'
#!/bin/sh

#
# Copyright 2015 the original author or authors.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      https://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

##############################################################################
##
##  Gradle start up script for UN*X
##
##############################################################################

# Attempt to set APP_HOME
# Resolve links: $0 may be a symlink
PRG="$0"
# Need this for relative symlinks.
while [ -h "$PRG" ] ; do
    ls -ld "$PRG"
    LINK=`ls -l "$PRG" | awk '{print $NF}'`
    case $LINK in
        /*) PRG="$LINK" ;;
        *) PRG=`dirname "$PRG"`"/$LINK" ;;
    esac
done
SAVED="`pwd`"
cd "`dirname \"$PRG\"`/" >/dev/null
APP_HOME="`pwd -P`"
cd "$SAVED" >/dev/null

APP_NAME="Gradle"
APP_BASE_NAME=`basename "$0"`

# Add default JVM options
DEFAULT_JVM_OPTS='"-Xmx64m" "-Xms64m"'

# Use the maximum available, or set a fatalError
MAX_FD="maximum"

warn () {
    echo "$*"
}

die () {
    echo
    echo "$*"
    echo
    exit 1
}

# OS specific support (must be 'true' or 'false').
cygwin=false
msys=false
darwin=false
nonstop=false
case "`uname`" in
  CYGWIN* )
    cygwin=true
    ;;
  Darwin* )
    darwin=true
    ;;
  MSYS* | MINGW* )
    msys=true
    ;;
  NONSTOP* )
    nonstop=true
    ;;
esac

CLASSPATH=$APP_HOME/gradle/wrapper/gradle-wrapper.jar

# Determine the Java command to use to start the JVM.
if [ -n "$JAVA_HOME" ] ; then
    if [ -x "$JAVA_HOME/jre/sh/java" ] ; then
        JAVA_CMD="$JAVA_HOME/jre/sh/java"
    else
        JAVA_CMD="$JAVA_HOME/bin/java"
    fi
    if [ ! -x "$JAVA_CMD" ] ; then
        die "ERROR: JAVA_HOME is set to an invalid directory: $JAVA_HOME"
    fi
else
    JAVA_CMD="java"
    command -v java >/dev/null 2>&1 || die "ERROR: JAVA_HOME is not set and no 'java' command could be found in your PATH."
fi

# Increase the maximum file descriptors if we can.
if [ "$cygwin" = "false" -a "$darwin" = "false" -a "$nonstop" = "false" ] ; then
    MAX_FD_LIMIT=`ulimit -H -n`
    if [ $? -eq 0 ] ; then
        if [ "$MAX_FD" = "maximum" -o "$MAX_FD" = "max" ] ; then
            MAX_FD="$MAX_FD_LIMIT"
        fi
        ulimit -n $MAX_FD
        if [ $? -ne 0 ] ; then
            warn "Could not set maximum file descriptor limit: $MAX_FD"
        fi
    else
        warn "Could not query maximum file descriptor limit: $MAX_FD_LIMIT"
    fi
fi

# For Darwin, add options to specify how the application appears in the dock
if $darwin; then
    DEFAULT_JVM_OPTS="$DEFAULT_JVM_OPTS \"-Xdock:name=$APP_NAME\" \"-Xdock:icon=$APP_HOME/media/gradle.icns\""
fi

# For Cygwin or MSYS, switch paths to Windows format before running java
if [ "$cygwin" = "true" -o "$msys" = "true" ] ; then
    APP_HOME=`cygpath --path --mixed "$APP_HOME"`
    CLASSPATH=`cygpath --path --mixed "$CLASSPATH"`
    JAVACMD=`cygpath --unix "$JAVACMD"`
    for var in JAVA_HOME JAVA_TOOL_OPTIONS JVM_OPTS_APPEND; do
        if [ -n "`eval \\$var`" ] ; then
            eval `echo "$var"=\"`cygpath --path --mixed \\`eval \\$var\\``\"`
        fi
    done
fi

# Collect all arguments for the java command, stacking in reverse order:
#   * args from the command line
#   * the main class name
#   * -classpath
#   * -D...system properties
#   * -- anything after that is passed to the java application

# Prepend a `-D` option if necessary
eval "set -- $(printf '%\s' "$DEFAULT_JVM_OPTS") $@"

# Collect all arguments for the java command
JAVA_OPTS=(
    -Dorg.gradle.appname="$APP_BASE_NAME"
    "${@}"
)

exec "$JAVA_CMD" "${JAVA_OPTS[@]}"
GRADLEW

chmod +x gradlew

# Create gradlew.bat for Windows
cat > gradlew.bat << 'GRADLEWBAT'
@rem
@rem Copyright 2015 the original author or authors.
@rem
@rem Licensed under the Apache License, Version 2.0 (the "License");
@rem you may not use this file except in compliance with the License.
@rem You may obtain a copy of the License at
@rem
@rem      https://www.apache.org/licenses/LICENSE-2.0
@rem
@rem Unless required by applicable law or agreed to in writing, software
@rem distributed under the License is distributed on an "AS IS" BASIS,
@rem WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
@rem See the License for the specific language governing permissions and
@rem limitations under the License.
@rem

@if "%DEBUG%" == "" @echo off
@rem ##########################################################################
@rem
@rem  Gradle startup script for Windows
@rem
@rem ##########################################################################

@rem Set local scope for the variables with windows NT shell
if "%OS%"=="Windows_NT" setlocal

set DIRNAME=%~dp0
if "%DIRNAME%" == "" set DIRNAME=.
set APP_BASE_NAME=%~n0
set APP_HOME=%DIRNAME%

@rem Resolve any "." and ".." in APP_HOME to make it shorter.
for %%i in ("%APP_HOME%") do set APP_HOME=%%~fi

@rem Add default JVM options that users can override in this batch script.
set DEFAULT_JVM_OPTS="-Xmx64m" "-Xms64m"

@rem Find java.exe
if defined JAVA_HOME goto findJavaFromJavaHome

set JAVA_EXE=java.exe
%JAVA_EXE% -version >nul 2>&1
if "%ERRORLEVEL%" == "0" goto execute

echo.
echo ERROR: JAVA_HOME is not set and no 'java' command could be found in your PATH.
echo.
echo Please set the JAVA_HOME variable in your environment to match the
echo location of your Java installation.

goto fail

:findJavaFromJavaHome
set JAVA_HOME=%JAVA_HOME:"=%
set JAVA_EXE=%JAVA_HOME%/bin/java.exe

if exist "%JAVA_EXE%" goto execute

echo.
echo ERROR: JAVA_HOME is defined but it is not found at "%JAVA_HOME%"
echo.
echo Please check your JAVA_HOME variable in your environment to match the
echo location of your Java installation.

goto fail

:execute
@rem Setup the command line

set CLASSPATH=%APP_HOME%\gradle\wrapper\gradle-wrapper.jar

@rem Execute Gradle
"%JAVA_EXE%" %DEFAULT_JVM_OPTS% %JAVA_OPTS% %GRADLE_OPTS% "-Dorg.gradle.appname=%APP_BASE_NAME%" -classpath "%CLASSPATH%" org.gradle.wrapper.GradleWrapperMain %*

:end
@endlocal & set ERROR_CODE=%ERRORLEVEL%

if not "%SILENT%"=="true" echo.
if "%ERROR_CODE%"=="0" goto mainEnd

:fail
rem Set variable ERRORLEVEL for exit codes used by Java/Gradle specifically.
rem  > 0 if the build failed with an error
rem  < 0 if the build was interrupted
rem  = 0 if the build succeeded with a warning or is still running.

if not "%ERROR_CODE%"=="0" goto end

set ERROR_CODE=1

:mainEnd
if "%1"=="" goto end

:end
@endlocal & goto :eof
GRADLEWBAT

# Create proguard rules
cat > app/proguard-rules.pro << 'PROGUARD'
# Proguard config for release builds
-keepattributes SourceFile,LineNumberTable
-keep public class * extends android.app.Activity
-keep public class * extends android.app.Service
-keep public class * extends android.content.BroadcastReceiver
-keep public class * extends android.content.ContentProvider
-keep public class * extends android.app.backup.BackupAgent
-keep public class * extends android.preference.Preference
-keep public class * extends android.view.View
-keep public class * extends android.app.Fragment
PROGUARD

echo -e "${GREEN}✓${NC} Gradle files created"

# Print summary
echo ""
echo -e "${GREEN}╔════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║  ✓ Project Created Successfully!       ║${NC}"
echo -e "${GREEN}╚════════════════════════════════════════╝${NC}"
echo ""
echo -e "${YELLOW}Next steps:${NC}"
echo "  1. cd $PROJECT_DIR"
echo "  2. ./gradlew build              # Build project"
echo "  3. ./gradlew assembleDebug      # Build debug APK"
echo "  4. adb install app/build/outputs/apk/debug/app-debug.apk"
echo ""
echo -e "${YELLOW}Development workflow:${NC}"
echo "  • Edit code in: app/src/main/java/$PACKAGE_PATH/"
echo "  • Edit layouts in: app/src/main/res/layout/"
echo "  • Edit strings in: app/src/main/res/values/"
echo ""
echo -e "${YELLOW}View generated files:${NC}"
cd ..
find "$PROJECT_NAME" -type f | head -20
echo ""
