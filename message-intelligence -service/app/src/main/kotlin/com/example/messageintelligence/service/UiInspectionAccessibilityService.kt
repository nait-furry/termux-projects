package com.example.messageintelligence.service

import android.accessibilityservice.AccessibilityService
import android.view.accessibility.AccessibilityEvent
import android.util.Log

class UiInspectionAccessibilityService : AccessibilityService() {
    override fun onAccessibilityEvent(event: AccessibilityEvent) {
        Log.i("UiInspectionAccessibility", "Event type=${event.eventType} text=${event.text}")
    }

    override fun onInterrupt() {
        Log.i("UiInspectionAccessibility", "Accessibility service interrupted")
    }
}
