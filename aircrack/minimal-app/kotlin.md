

**minimal Kotlin implementation** that satisfies **true active scans via `WifiManager.startScan()`**: **foreground service + broadcast receiver + stdout bridge**
---

# Architecture Overview

```
Foreground Service
 ├── WifiManager.startScan()
 ├── BroadcastReceiver (SCAN_RESULTS_AVAILABLE_ACTION)
 ├── Serialize results → JSON
 └── Print to stdout (logcat + process output)
```

Why foreground service:

* Bypasses background scan throttling (partially)
* Keeps process alive
* Required for continuous scanning

---

# 1) Manifest (Critical Permissions)

```xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
    package="com.example.wifiscanner">

    <uses-permission android:name="android.permission.ACCESS_WIFI_STATE"/>
    <uses-permission android:name="android.permission.CHANGE_WIFI_STATE"/>
    <uses-permission android:name="android.permission.ACCESS_FINE_LOCATION"/>
    <uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION"/>
    <uses-permission android:name="android.permission.FOREGROUND_SERVICE"/>
    <uses-permission android:name="android.permission.POST_NOTIFICATIONS"/>

    <application>
        <service
            android:name=".WifiScanService"
            android:exported="false"
            android:foregroundServiceType="location" />
    </application>
</manifest>
```

⚠️ Notes:

* Location permission is **mandatory** for WiFi scans
* On Android 13+, you must request notification permission at runtime

---

# 2) Foreground Service Implementation

```kotlin
package com.example.wifiscanner

import android.app.*
import android.content.*
import android.net.wifi.WifiManager
import android.os.*
import android.util.Log
import org.json.JSONArray
import org.json.JSONObject

class WifiScanService : Service() {

    private lateinit var wifiManager: WifiManager
    private lateinit var receiver: BroadcastReceiver

    override fun onCreate() {
        super.onCreate()

        wifiManager = applicationContext.getSystemService(Context.WIFI_SERVICE) as WifiManager

        startForegroundService()

        receiver = object : BroadcastReceiver() {
            override fun onReceive(context: Context?, intent: Intent?) {
                val success = intent?.getBooleanExtra(WifiManager.EXTRA_RESULTS_UPDATED, false) ?: false
                if (success) {
                    handleScanResults()
                } else {
                    Log.e("WiFiScan", "Scan failed")
                }
            }
        }

        registerReceiver(receiver, IntentFilter(WifiManager.SCAN_RESULTS_AVAILABLE_ACTION))

        startActiveScanLoop()
    }

    private fun startForegroundService() {
        val channelId = "wifi_scan_channel"

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val channel = NotificationChannel(
                channelId,
                "WiFi Scanner",
                NotificationManager.IMPORTANCE_LOW
            )
            getSystemService(NotificationManager::class.java).createNotificationChannel(channel)
        }

        val notification = Notification.Builder(this, channelId)
            .setContentTitle("WiFi Scanning Active")
            .setContentText("Actively scanning nearby networks")
            .setSmallIcon(android.R.drawable.stat_notify_sync)
            .build()

        startForeground(1, notification)
    }

    private fun startActiveScanLoop() {
        Thread {
            while (true) {
                val success = wifiManager.startScan()
                Log.d("WiFiScan", "Scan triggered: $success")

                Thread.sleep(15000) // respect throttling (~15 sec)
            }
        }.start()
    }

    private fun handleScanResults() {
        val results = wifiManager.scanResults
        val jsonArray = JSONArray()

        for (result in results) {
            val obj = JSONObject()
            obj.put("ssid", result.SSID)
            obj.put("bssid", result.BSSID)
            obj.put("level", result.level)
            obj.put("frequency", result.frequency)
            obj.put("capabilities", result.capabilities)
            obj.put("timestamp", result.timestamp)

            jsonArray.put(obj)
        }

        val output = jsonArray.toString()

        // 2) Pipe to stdout (multiple channels)
        println(output)                  // stdout (if launched via shell)
        System.out.println(output)       // explicit stdout
        Log.d("WiFiScanJSON", output)    // logcat fallback
    }

    override fun onDestroy() {
        super.onDestroy()
        unregisterReceiver(receiver)
    }

    override fun onBind(intent: Intent?): IBinder? = null
}
```

---

# 3) Launching the Service from Termux

You need a way to start it externally.

### Option A: Using `am` (Activity Manager)

```bash
am start-foreground-service \
  -n com.example.wifiscanner/.WifiScanService
```

---

# 4) Capturing Output in Termux

Android apps don’t naturally stream stdout to shell like Linux binaries.

### Realistic pipeline:

#### Option 1 (Recommended): logcat bridge

```bash
logcat -s WiFiScanJSON
```

✔ Reliable
✔ Real-time
✔ No root required

---

#### Option 2: Pipe to file inside app (then read from Termux)

Modify:

```kotlin
val file = File(getExternalFilesDir(null), "scan.json")
file.appendText(output + "\n")
```

Then in Termux:

```bash
tail -f /sdcard/Android/data/com.example.wifiscanner/files/scan.json
```

---

# 5) Important Constraints (Don’t Ignore)

### Scan Throttling Still Applies

Even in foreground:

* Android limits scan frequency
* You **cannot spam `startScan()`**

Empirical safe interval:

```
15–20 seconds
```

---

### Hidden Networks

* Still require prior connection or directed probe
* `startScan()` won’t magically reveal all hidden SSIDs

---

### Screen OFF Behavior

Foreground service helps, but:

* Some OEMs still throttle aggressively
* Consider adding:

```kotlin
val pm = getSystemService(Context.POWER_SERVICE) as PowerManager
val wakeLock = pm.newWakeLock(PowerManager.PARTIAL_WAKE_LOCK, "WifiScan::Lock")
wakeLock.acquire()
```

---

# 6) Key Improvements You Can Add Next

If you want to push this further:

### A) Adaptive scan interval

* Increase frequency when movement detected

### B) Location fusion

* Integrate `FusedLocationProviderClient`

### C) Deduplication

* Hash BSSID + timestamp

### D) IPC to Termux

* Use local socket instead of logcat

---

# Bottom Line

What you now have:

* ✔ True active WiFi scanning (`startScan()`)
* ✔ Foreground execution (reduced throttling)
* ✔ Real-time output pipeline (logcat/stdout bridge)

What you *still cannot fully bypass*:

* Android scan throttling
* OEM battery optimizations

---

If you want, I can take this further into:

* A **Termux-controlled scanner daemon (socket-based IPC)**
* Or a **high-frequency recon system with movement-aware scanning**

Just say.
