package com.termux.camera.analysis

class ObstructionDetector(
    private val analyzer: ExposureAnalyzer = ExposureAnalyzer()
) {
    fun isLikelyObstructed(jpegBytes: ByteArray): Boolean {
        return analyzer.analyzeJpegBytes(jpegBytes).isLikelyObstructed
    }
}
