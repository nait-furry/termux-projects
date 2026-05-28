package com.termux.camera.shell

import java.net.Socket

class ShellApi(
    private val host: String = "127.0.0.1",
    private val port: Int = 8989
) {
    fun send(command: String): String {
        return Socket(host, port).use { socket ->
            val writer = socket.getOutputStream().bufferedWriter()
            writer.write(command.trim())
            writer.newLine()
            writer.flush()
            socket.getInputStream().bufferedReader().readLine().orEmpty()
        }
    }
}
