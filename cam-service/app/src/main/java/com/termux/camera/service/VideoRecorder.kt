package com.termux.camera.service

import android.content.Context
import android.media.MediaRecorder
import android.os.Build
import android.os.Environment
import android.util.Size
import android.view.Surface
import java.io.File
import java.text.SimpleDateFormat
import java.util.Date
import java.util.Locale

class VideoRecorder(private val context: Context) {
    @Volatile private var recording = false
    private var recorder: MediaRecorder? = null
    private var outputFile: File? = null

    fun prepare(size: Size): Surface {
        release()
        val file = File(
            context.getExternalFilesDir(Environment.DIRECTORY_MOVIES),
            "cam_service_video_${timestamp()}.mp4"
        )
        outputFile = file
        val mediaRecorder = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
            MediaRecorder(context)
        } else {
            @Suppress("DEPRECATION")
            MediaRecorder()
        }
        mediaRecorder.apply {
            setAudioSource(MediaRecorder.AudioSource.MIC)
            setVideoSource(MediaRecorder.VideoSource.SURFACE)
            setOutputFormat(MediaRecorder.OutputFormat.MPEG_4)
            setOutputFile(file.absolutePath)
            setVideoEncodingBitRate(8_000_000)
            setVideoFrameRate(30)
            setVideoSize(size.width, size.height)
            setVideoEncoder(MediaRecorder.VideoEncoder.H264)
            setAudioEncoder(MediaRecorder.AudioEncoder.AAC)
            prepare()
        }
        recorder = mediaRecorder
        return mediaRecorder.surface
    }

    fun start(): String {
        recorder?.start()
        recording = true
        return "video recording started: ${outputFile?.absolutePath}"
    }

    fun stop(): String {
        val file = outputFile
        try {
            recorder?.stop()
        } catch (_: RuntimeException) {
        }
        release()
        recording = false
        return "video recording stopped: ${file?.absolutePath}"
    }

    fun isRecording(): Boolean = recording

    fun release() {
        try {
            recorder?.reset()
            recorder?.release()
        } catch (_: Exception) {
        }
        recorder = null
    }

    private fun timestamp(): String =
        SimpleDateFormat("yyyyMMdd_HHmmss", Locale.US).format(Date())
}
