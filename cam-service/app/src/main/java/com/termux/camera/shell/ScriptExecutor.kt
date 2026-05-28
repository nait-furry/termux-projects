package com.termux.camera.shell

import java.io.File

class ScriptExecutor(private val workingDirectory: File) {
    fun execute(script: String): String {
        val shell = if (File("/data/data/com.termux/files/usr/bin/bash").exists()) {
            "/data/data/com.termux/files/usr/bin/bash"
        } else {
            "/system/bin/sh"
        }
        val process = ProcessBuilder(shell, "-lc", script)
            .directory(workingDirectory)
            .redirectErrorStream(true)
            .start()
        val output = process.inputStream.bufferedReader().readText()
        val exitCode = process.waitFor()
        return "exit=$exitCode\n$output"
    }
}
