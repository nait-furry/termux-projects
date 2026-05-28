package com.termux.camera.analysis

class ExposureAnalyzer {
    fun analyzeJpegBytes(bytes: ByteArray): ExposureScore {
        if (bytes.isEmpty()) return ExposureScore(0.0, true)
        val step = (bytes.size / SAMPLE_SIZE).coerceAtLeast(1)
        var count = 0
        var sum = 0.0
        var sumSquares = 0.0
        var index = 0
        while (index < bytes.size) {
            val value = bytes[index].toInt() and 0xFF
            sum += value
            sumSquares += value * value
            count += 1
            index += step
        }
        val mean = sum / count
        val variance = (sumSquares / count) - (mean * mean)
        return ExposureScore(variance, variance < OBSTRUCTION_VARIANCE_THRESHOLD)
    }

    companion object {
        private const val SAMPLE_SIZE = 4096
        private const val OBSTRUCTION_VARIANCE_THRESHOLD = 12.0
    }
}

data class ExposureScore(
    val variance: Double,
    val isLikelyObstructed: Boolean
)
