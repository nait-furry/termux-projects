package com.example.messageintelligence.service

import android.service.notification.NotificationListenerService
import android.service.notification.StatusBarNotification
import android.util.Log

class MessageNotificationListener : NotificationListenerService() {
    override fun onNotificationPosted(sbn: StatusBarNotification) {
        val pkg = sbn.packageName ?: "unknown"
        val title = sbn.notification.extras.getString("android.title")
        val text = sbn.notification.extras.getCharSequence("android.text")?.toString()
        Log.i("MessageNotificationListener", "Notification from $pkg title=$title text=$text")
    }

    override fun onNotificationRemoved(sbn: StatusBarNotification) {
        Log.i("MessageNotificationListener", "Notification removed: ${sbn.packageName}")
    }
}
