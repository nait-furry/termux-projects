package com.example.messageintelligence.data

import java.util.UUID

enum class MessageSource {
    NOTIFICATION,
    SMS,
    ACCESSIBILITY,
    MANUAL
}

enum class MessageCategory {
    OTP,
    BANKING,
    SOCIAL,
    SYSTEM,
    MARKETING,
    PERSONAL,
    UNKNOWN
}

data class MessageRecord(
    val id: String = UUID.randomUUID().toString(),
    val source: MessageSource,
    val sender: String?,
    val title: String?,
    val body: String,
    val timestamp: Long,
    val category: MessageCategory
)
