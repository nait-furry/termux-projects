package com.termux.camera.service

import android.os.Handler
import android.os.HandlerThread
import java.util.concurrent.atomic.AtomicBoolean

class BurstScheduler(private val controller: CameraController) {
    private val thread = HandlerThread("SchedulerThread").also { it.start() }
    private val handler = Handler(thread.looper)
    private val active = AtomicBoolean(false)

    fun start(intervalMs: Long, countPerBurst: Int) {
        if (!active.compareAndSet(false, true)) return
        val boundedInterval = intervalMs.coerceAtLeast(1_000L)
        val task = object : Runnable {
            override fun run() {
                if (!active.get()) return
                controller.captureBurst(countPerBurst)
                handler.postDelayed(this, boundedInterval)
            }
        }
        handler.post(task)
    }

    fun stop() {
        active.set(false)
        handler.removeCallbacksAndMessages(null)
    }

    fun shutdown() {
        stop()
        thread.quitSafely()
    }
}
