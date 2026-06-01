# Camera Service Debug Report

## 1. Permission Denial (ADB Start Failure)
**Symptom:**
`W ActivityManager: Permission Denial: Accessing service com.termux.camera/.service.CameraForegroundService from pid=21118, uid=2000 that is not exported from uid 10068`

**Analysis:**
The `CameraForegroundService` is declared as `android:exported="false"` in `AndroidManifest.xml`. This prevents external processes, including the ADB shell (UID 2000), from starting the service directly using `am start-foreground-service`.

**Recommendation:**
- Start the service from the app's "Start" button or the Quick Settings tile.
- If ADB support is required, set `android:exported="true"` and add a custom permission to guard the service.

---

## 2. CommandServer Startup Failures
**Symptom:**
`E CommandServer: at com.termux.camera.service.CommandServer.start${'$'}lambda${'$'}2(CommandServer.kt:25)`

**Analysis:**
Errors are occurring during `ServerSocket` initialization in `CommandServer.kt`.
```kotlin
executor.execute {
    try {
        serverSocket = ServerSocket(PORT, 4, InetAddress.getByName(HOST)) // Line 25-26
```
The logs suggest an exception is caught here. Most likely cause is `java.net.BindException: Address already in use` if a previous instance of the service didn't release the port correctly or is still in `TIME_WAIT`.

**Recommendation:**
- Ensure `serverSocket?.close()` is called effectively in `stop()`.
- Consider adding `serverSocket.reuseAddress = true` before binding if possible (though `ServerSocket` constructor binds immediately; use `bind()` separately for more control).

---

## 3. Unsafe Thread Shutdown in CameraController
**Symptom:**
`W MessageQueue: at ... CameraController.closeCameraLocked(CameraController.kt:327)`

**Analysis:**
The `shutdown()` method in `CameraController.kt` quits the handler threads immediately after posting a cleanup task.
```kotlin
fun shutdown() {
    cameraHandler.post { closeCameraLocked() }
    cameraThread.quitSafely()
    imageThread.quitSafely()
}
```
If `closeCameraLocked()` or the Camera2 API internal cleanup tries to post more messages to `cameraHandler`, they will be rejected because the looper is stopping.

**Recommendation:**
Refactor `shutdown()` to ensure cleanup completes before quitting threads:
```kotlin
fun shutdown() {
    cameraHandler.post {
        closeCameraLocked()
        cameraThread.quitSafely()
        imageThread.quitSafely()
    }
}
```

---

## 4. Hardware/HAL Level Issues
**Symptom:**
`E Camera2-Metadata: acquire: Failed to validate metadata structure 0x0`

**Analysis:**
These are low-level Android/HAL errors. They often occur during state transitions (opening/closing/switching).

**Recommendation:**
- Add slight delays between camera close and reopen during a `switchCamera` operation.
- Verify that `captureSession` is fully closed before attempting to open a new one.

---

## 5. Log Summary
- **App Startup:** Successful.
- **Service Creation:** Triggered via UI/Tile.
- **Camera Access:** Successful (Camera 0 opened), but followed by HAL metadata warnings.
- **Cleanup:** Triggering threading warnings.
