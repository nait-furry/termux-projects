package com.termux.camera.service

import android.Manifest
import android.annotation.SuppressLint
import android.content.ContentValues
import android.content.Context
import android.content.pm.PackageManager
import android.graphics.ImageFormat
import android.hardware.camera2.CameraAccessException
import android.hardware.camera2.CameraCaptureSession
import android.hardware.camera2.CameraCharacteristics
import android.hardware.camera2.CameraDevice
import android.hardware.camera2.CameraManager
import android.hardware.camera2.CameraMetadata
import android.hardware.camera2.CaptureRequest
import android.media.Image
import android.media.ImageReader
import android.net.Uri
import android.os.Build
import android.os.Environment
import android.os.Handler
import android.os.HandlerThread
import android.provider.MediaStore
import android.util.Log
import android.util.Size
import androidx.core.content.ContextCompat
import com.termux.camera.analysis.ExposureAnalyzer
import java.io.File
import java.io.FileOutputStream
import java.nio.ByteBuffer
import java.text.SimpleDateFormat
import java.util.Date
import java.util.Locale
import java.util.concurrent.CountDownLatch
import java.util.concurrent.TimeUnit
import java.util.concurrent.atomic.AtomicBoolean
import java.util.concurrent.atomic.AtomicInteger

class CameraController(private val context: Context) {

    private val cameraManager = context.getSystemService(Context.CAMERA_SERVICE) as CameraManager
    private val cameraThread = HandlerThread("CameraThread").also { it.start() }
    private val imageThread = HandlerThread("ImageProcessThread").also { it.start() }
    private val cameraHandler = Handler(cameraThread.looper)
    private val imageHandler = Handler(imageThread.looper)
    private val isOpening = AtomicBoolean(false)
    private val isCapturing = AtomicBoolean(false)
    private val isSwitching = AtomicBoolean(false)
    private val pendingCaptures = AtomicInteger(0)
    private val exposureAnalyzer = ExposureAnalyzer()
    private val videoRecorder = VideoRecorder(context)

    @Volatile private var cameraDevice: CameraDevice? = null
    @Volatile private var captureSession: CameraCaptureSession? = null
    @Volatile private var imageReader: ImageReader? = null
    @Volatile private var currentCameraId: String? = null
    @Volatile private var currentSize: Size = Size(1920, 1080)

    fun startCamera(front: Boolean = false): String {
        if (!hasCameraPermission()) return "missing CAMERA permission"
        if (!isOpening.compareAndSet(false, true)) return "camera is already opening"

        val cameraId = try {
            selectCamera(front)
        } catch (error: Exception) {
            isOpening.set(false)
            return "unable to select camera: ${error.message}"
        }

        cameraHandler.post {
            closeCameraLocked()
            currentCameraId = cameraId
            openCamera(cameraId)
        }
        return "opening ${if (front) "front" else "back"} camera"
    }

    fun stopCamera(): String {
        cameraHandler.post {
            closeCameraLocked()
            isOpening.set(false)
        }
        return "stopping camera"
    }

    fun switchCamera(): String {
        if (!isSwitching.compareAndSet(false, true)) return "camera switch already running"
        val current = currentCameraId
        val nextFront = current?.let { !isFrontCamera(it) } ?: true
        cameraHandler.post {
            try {
                closeCameraLocked()
                currentCameraId = selectCamera(nextFront)
                cameraHandler.postDelayed({
                    openCamera(currentCameraId!!)
                    isSwitching.set(false)
                }, CAMERA_REOPEN_DELAY_MS)
            } catch (error: Exception) {
                Log.e(TAG, "Unable to switch camera", error)
                isSwitching.set(false)
            }
        }
        return "switching camera"
    }

    fun captureBurst(count: Int = 5): String {
        val bounded = count.coerceIn(1, 50)
        pendingCaptures.addAndGet(bounded)
        cameraHandler.post {
            repeat(bounded) { index ->
                cameraHandler.postDelayed({ triggerStillCapture() }, index * BURST_INTERVAL_MS)
            }
        }
        return "queued $bounded captures"
    }

    fun startVideo(): String {
        if (videoRecorder.isRecording()) return "video recording already active"
        cameraHandler.post {
            val camera = cameraDevice ?: return@post
            try {
                val reader = imageReader ?: ImageReader.newInstance(
                    currentSize.width,
                    currentSize.height,
                    ImageFormat.JPEG,
                    5
                ).also { imageReader = it }
                val recorderSurface = videoRecorder.prepare(currentSize)
                captureSession?.close()
                camera.createCaptureSession(
                    listOf(reader.surface, recorderSurface),
                    object : CameraCaptureSession.StateCallback() {
                        override fun onConfigured(session: CameraCaptureSession) {
                            captureSession = session
                            val request = camera.createCaptureRequest(CameraDevice.TEMPLATE_RECORD).apply {
                                addTarget(recorderSurface)
                                set(CaptureRequest.CONTROL_MODE, CameraMetadata.CONTROL_MODE_AUTO)
                                set(
                                    CaptureRequest.CONTROL_AF_MODE,
                                    CaptureRequest.CONTROL_AF_MODE_CONTINUOUS_VIDEO
                                )
                                set(CaptureRequest.CONTROL_AE_MODE, CaptureRequest.CONTROL_AE_MODE_ON)
                            }.build()
                            session.setRepeatingRequest(request, null, cameraHandler)
                            Log.i(TAG, videoRecorder.start())
                        }

                        override fun onConfigureFailed(session: CameraCaptureSession) {
                            Log.e(TAG, "Video session configuration failed")
                            videoRecorder.release()
                        }
                    },
                    cameraHandler
                )
            } catch (error: Exception) {
                Log.e(TAG, "Unable to start video", error)
                videoRecorder.release()
            }
        }
        return "starting video recording"
    }

    fun stopVideo(): String {
        cameraHandler.post {
            val result = videoRecorder.stop()
            Log.i(TAG, result)
            cameraDevice?.let { createCaptureSession(it) }
        }
        return "stopping video recording"
    }

    @SuppressLint("MissingPermission")
    private fun openCamera(cameraId: String) {
        try {
            cameraManager.openCamera(cameraId, cameraStateCallback, cameraHandler)
        } catch (error: CameraAccessException) {
            Log.e(TAG, "Unable to open camera $cameraId", error)
            isOpening.set(false)
        } catch (error: SecurityException) {
            Log.e(TAG, "Camera permission denied", error)
            isOpening.set(false)
        }
    }

    private val cameraStateCallback = object : CameraDevice.StateCallback() {
        override fun onOpened(camera: CameraDevice) {
            cameraDevice = camera
            isOpening.set(false)
            createCaptureSession(camera)
        }

        override fun onDisconnected(camera: CameraDevice) {
            camera.close()
            cameraDevice = null
            isOpening.set(false)
        }

        override fun onError(camera: CameraDevice, error: Int) {
            Log.e(TAG, "Camera error $error")
            camera.close()
            cameraDevice = null
            isOpening.set(false)
        }
    }

    private fun createCaptureSession(camera: CameraDevice) {
        val size = chooseJpegSize(camera.id)
        currentSize = size
        val reader = ImageReader.newInstance(size.width, size.height, ImageFormat.JPEG, 5)
        imageReader = reader
        reader.setOnImageAvailableListener({ source ->
            val image = source.acquireNextImage()
            imageHandler.post { saveImage(image) }
        }, imageHandler)

        val surfaces = listOf(reader.surface)
        camera.createCaptureSession(
            surfaces,
            object : CameraCaptureSession.StateCallback() {
                override fun onConfigured(session: CameraCaptureSession) {
                    captureSession = session
                }

                override fun onConfigureFailed(session: CameraCaptureSession) {
                    Log.e(TAG, "Camera session configuration failed")
                }
            },
            cameraHandler
        )
    }

    private fun triggerStillCapture() {
        if (!isCapturing.compareAndSet(false, true)) {
            cameraHandler.postDelayed({ triggerStillCapture() }, 150)
            return
        }
        val camera = cameraDevice
        val session = captureSession
        val reader = imageReader
        if (camera == null || session == null || reader == null) {
            isCapturing.set(false)
            return
        }

        val request = camera.createCaptureRequest(CameraDevice.TEMPLATE_STILL_CAPTURE).apply {
            addTarget(reader.surface)
            set(CaptureRequest.CONTROL_MODE, CameraMetadata.CONTROL_MODE_AUTO)
            set(CaptureRequest.CONTROL_AF_MODE, CaptureRequest.CONTROL_AF_MODE_CONTINUOUS_PICTURE)
            set(CaptureRequest.CONTROL_AF_TRIGGER, CameraMetadata.CONTROL_AF_TRIGGER_START)
            set(CaptureRequest.CONTROL_AE_MODE, CaptureRequest.CONTROL_AE_MODE_ON)
            set(CaptureRequest.JPEG_QUALITY, 90.toByte())
            set(CaptureRequest.NOISE_REDUCTION_MODE, CaptureRequest.NOISE_REDUCTION_MODE_FAST)
            set(CaptureRequest.EDGE_MODE, CaptureRequest.EDGE_MODE_FAST)
        }.build()

        try {
            session.capture(request, object : CameraCaptureSession.CaptureCallback() {
                override fun onCaptureCompleted(
                    session: CameraCaptureSession,
                    request: CaptureRequest,
                    result: android.hardware.camera2.TotalCaptureResult
                ) {
                    isCapturing.set(false)
                }

                override fun onCaptureFailed(
                    session: CameraCaptureSession,
                    request: CaptureRequest,
                    failure: android.hardware.camera2.CaptureFailure
                ) {
                    pendingCaptures.updateAndGet { value -> (value - 1).coerceAtLeast(0) }
                    isCapturing.set(false)
                }
            }, cameraHandler)
        } catch (error: Exception) {
            pendingCaptures.updateAndGet { value -> (value - 1).coerceAtLeast(0) }
            Log.e(TAG, "Still capture failed", error)
            isCapturing.set(false)
        }
    }

    private fun saveImage(image: Image) {
        try {
            if (pendingCaptures.get() <= 0) return
            val buffer: ByteBuffer = image.planes[0].buffer
            val bytes = ByteArray(buffer.remaining())
            buffer.get(bytes)
            val name = "cam_service_${timestamp()}.jpg"
            val result = writeJpeg(name, bytes)
            pendingCaptures.updateAndGet { value -> (value - 1).coerceAtLeast(0) }
            Log.i(TAG, "Saved $result")

            val score = exposureAnalyzer.analyzeJpegBytes(bytes)
            if (score.isLikelyObstructed) {
                Log.w(TAG, "Capture looks obstructed: variance=${score.variance}")
            }
        } finally {
            image.close()
        }
    }

    private fun writeJpeg(name: String, bytes: ByteArray): Uri? {
        return if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
            val values = ContentValues().apply {
                put(MediaStore.Images.Media.DISPLAY_NAME, name)
                put(MediaStore.Images.Media.MIME_TYPE, "image/jpeg")
                put(MediaStore.Images.Media.RELATIVE_PATH, "Pictures/CameraService")
                put(MediaStore.Images.Media.IS_PENDING, 1)
            }
            val uri = context.contentResolver.insert(
                MediaStore.Images.Media.EXTERNAL_CONTENT_URI,
                values
            ) ?: return null
            context.contentResolver.openOutputStream(uri)?.use { it.write(bytes) }
            values.clear()
            values.put(MediaStore.Images.Media.IS_PENDING, 0)
            context.contentResolver.update(uri, values, null, null)
            uri
        } else {
            val dir = File(
                Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_PICTURES),
                "CameraService"
            )
            dir.mkdirs()
            FileOutputStream(File(dir, name)).use { it.write(bytes) }
            null
        }
    }

    private fun closeCameraLocked() {
        try {
            captureSession?.stopRepeating()
        } catch (_: Exception) {
        }
        try {
            captureSession?.close()
        } catch (_: Exception) {
        }
        try {
            cameraDevice?.close()
        } catch (_: Exception) {
        }
        try {
            imageReader?.close()
        } catch (_: Exception) {
        }
        videoRecorder.release()
        captureSession = null
        cameraDevice = null
        imageReader = null
    }

    private fun selectCamera(front: Boolean): String {
        for (id in cameraManager.cameraIdList) {
            val chars = cameraManager.getCameraCharacteristics(id)
            val facing = chars.get(CameraCharacteristics.LENS_FACING)
            if (front && facing == CameraCharacteristics.LENS_FACING_FRONT) return id
            if (!front && facing == CameraCharacteristics.LENS_FACING_BACK) return id
        }
        return cameraManager.cameraIdList.first()
    }

    private fun isFrontCamera(id: String): Boolean {
        return cameraManager.getCameraCharacteristics(id)
            .get(CameraCharacteristics.LENS_FACING) == CameraCharacteristics.LENS_FACING_FRONT
    }

    private fun chooseJpegSize(cameraId: String): Size {
        val chars = cameraManager.getCameraCharacteristics(cameraId)
        val sizes = chars.get(CameraCharacteristics.SCALER_STREAM_CONFIGURATION_MAP)
            ?.getOutputSizes(ImageFormat.JPEG)
            ?.toList()
            .orEmpty()
        return sizes
            .filter { it.width <= 1920 && it.height <= 1080 }
            .maxByOrNull { it.width * it.height }
            ?: sizes.maxByOrNull { it.width * it.height }
            ?: Size(1920, 1080)
    }

    private fun hasCameraPermission(): Boolean {
        return ContextCompat.checkSelfPermission(context, Manifest.permission.CAMERA) ==
            PackageManager.PERMISSION_GRANTED
    }

    fun shutdown() {
        val cleanupDone = CountDownLatch(1)
        val cleanupPosted = cameraHandler.post {
            try {
                closeCameraLocked()
            } finally {
                cleanupDone.countDown()
                cameraThread.quitSafely()
                imageThread.quitSafely()
            }
        }
        if (!cleanupPosted) {
            cameraThread.quitSafely()
            imageThread.quitSafely()
            return
        }
        try {
            cleanupDone.await(SHUTDOWN_WAIT_MS, TimeUnit.MILLISECONDS)
        } catch (_: InterruptedException) {
            Thread.currentThread().interrupt()
        }
    }

    private fun timestamp(): String =
        SimpleDateFormat("yyyyMMdd_HHmmss_SSS", Locale.US).format(Date())

    companion object {
        private const val TAG = "CameraController"
        private const val BURST_INTERVAL_MS = 250L
        private const val CAMERA_REOPEN_DELAY_MS = 300L
        private const val SHUTDOWN_WAIT_MS = 1_500L
    }
}
