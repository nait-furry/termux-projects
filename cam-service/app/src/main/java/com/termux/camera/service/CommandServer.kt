package com.termux.camera.service

import android.util.Log
import java.io.BufferedReader
import java.io.PrintWriter
import java.net.InetAddress
import java.net.InetSocketAddress
import java.net.ServerSocket
import java.net.Socket
import java.net.SocketException
import java.util.concurrent.Executors
import java.util.concurrent.atomic.AtomicBoolean

class CommandServer(private val controller: CameraController) {

    private val running = AtomicBoolean(false)
    private val executor = Executors.newSingleThreadExecutor { runnable ->
        Thread(runnable, "NetworkThread").apply { isDaemon = true }
    }
    private var serverSocket: ServerSocket? = null

    fun start() {
        if (!running.compareAndSet(false, true)) return
        executor.execute {
            try {
                serverSocket = ServerSocket().apply {
                    reuseAddress = true
                    bind(InetSocketAddress(InetAddress.getByName(HOST), PORT), BACKLOG)
                }
                while (running.get()) {
                    val socket = serverSocket?.accept() ?: break
                    handleSocket(socket)
                }
            } catch (error: SocketException) {
                if (running.get()) Log.e(TAG, "Command server socket error", error)
            } catch (error: Exception) {
                Log.e(TAG, "Command server failed", error)
            } finally {
                running.set(false)
                try {
                    serverSocket?.close()
                } catch (_: Exception) {
                }
                serverSocket = null
            }
        }
    }

    private fun handleSocket(socket: Socket) {
        socket.use {
            val reader: BufferedReader = it.getInputStream().bufferedReader()
            val writer = PrintWriter(it.getOutputStream(), true)
            val line = reader.readLine().orEmpty().trim()
            writer.println(handle(line))
        }
    }

    private fun handle(commandLine: String): String {
        val parts = commandLine.split(Regex("\\s+")).filter { it.isNotBlank() }
        return when (parts.firstOrNull()) {
            "start" -> {
                val front = parts.getOrNull(1) == "front"
                controller.startCamera(front)
            }
            "front" -> controller.startCamera(front = true)
            "back" -> controller.startCamera(front = false)
            "stop" -> controller.stopCamera()
            "switch" -> controller.switchCamera()
            "burst" -> controller.captureBurst(parts.getOrNull(1)?.toIntOrNull() ?: 5)
            "start-video" -> controller.startVideo()
            "stop-video" -> controller.stopVideo()
            "ping" -> "ok"
            "help", null -> HELP
            else -> "unknown command: ${parts.first()}"
        }
    }

    fun stop() {
        running.set(false)
        try {
            serverSocket?.close()
        } catch (_: Exception) {
        }
        executor.shutdownNow()
    }

    companion object {
        const val HOST = "127.0.0.1"
        const val PORT = 8989
        private const val BACKLOG = 4
        private const val TAG = "CommandServer"
        private val HELP = """
            commands: ping, start [front], front, back, stop, switch, burst [count], start-video, stop-video
        """.trimIndent()
    }
}
