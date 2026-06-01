package com.termux.camera.tiles

import android.content.Intent
import android.os.Build
import android.service.quicksettings.Tile
import android.service.quicksettings.TileService
import com.termux.camera.service.CameraForegroundService

class CameraTileService : TileService() {

    override fun onStartListening() {
        super.onStartListening()
        updateTileState()
    }

    override fun onClick() {
        super.onClick()
        if (CameraForegroundService.isRunning) {
            stopService(Intent(this, CameraForegroundService::class.java))
        } else {
            val intent = Intent(this, CameraForegroundService::class.java)
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                startForegroundService(intent)
            } else {
                startService(intent)
            }
        }
        updateTileState()
    }

    private fun updateTileState() {
        val tile = qsTile ?: return
        if (CameraForegroundService.isRunning) {
            tile.state = Tile.STATE_ACTIVE
            tile.label = "Camera Service Running"
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
                tile.subtitle = "Stop Camera Service"
            }
        } else {
            tile.state = Tile.STATE_INACTIVE
            tile.label = "Camera Service Stopped"
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
                tile.subtitle = "Start Camera Service"
            }
        }
        tile.updateTile()
    }
}
