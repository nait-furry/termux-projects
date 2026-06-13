package com.example.messageintelligence.data

import java.time.Instant

class MessageRepository {
    private val history = mutableListOf<MessageRecord>()

    val messages: List<MessageRecord>
        get() = history.sortedByDescending { it.timestamp }

    init {
        history.addAll(sampleMessages())
    }

    fun addManualMessage(sender: String, title: String, body: String) {
        history.add(
            MessageRecord(
                source = MessageSource.MANUAL,
                sender = sender.ifBlank { "Unknown" },
                title = title.ifBlank { "Manual Entry" },
                body = body,
                timestamp = Instant.now().toEpochMilli(),
                category = MessageProcessor.classify(body)
            )
        )
    }

    fun addSimulation(source: MessageSource) {
        val example = when (source) {
            MessageSource.NOTIFICATION -> MessageRecord(
                source = MessageSource.NOTIFICATION,
                sender = "Bank App",
                title = "OTP Received",
                body = "Your KCB OTP is 563210. Valid for 5 minutes.",
                timestamp = Instant.now().toEpochMilli(),
                category = MessageProcessor.classify("Your KCB OTP is 563210. Valid for 5 minutes.")
            )
            MessageSource.SMS -> MessageRecord(
                source = MessageSource.SMS,
                sender = "+254712345678",
                title = "SMS Thread",
                body = "Delivery from Safaricom: Your account balance is KES 1,250.00.",
                timestamp = Instant.now().toEpochMilli(),
                category = MessageProcessor.classify("Delivery from Safaricom: Your account balance is KES 1,250.00.")
            )
            else -> MessageRecord(
                source = MessageSource.ACCESSIBILITY,
                sender = "WhatsApp",
                title = "Group Chat",
                body = "Jane: The meeting starts at 2 PM.",
                timestamp = Instant.now().toEpochMilli(),
                category = MessageProcessor.classify("Jane: The meeting starts at 2 PM.")
            )
        }

        history.add(example)
    }

    fun filterByCategory(category: MessageCategory): List<MessageRecord> {
        return if (category == MessageCategory.UNKNOWN) {
            messages
        } else {
            messages.filter { it.category == category }
        }
    }

    private fun sampleMessages(): List<MessageRecord> {
        return listOf(
            MessageRecord(
                source = MessageSource.NOTIFICATION,
                sender = "Signal",
                title = "New message",
                body = "Ali: Please review the transaction details.",
                timestamp = Instant.now().minusSeconds(3600).toEpochMilli(),
                category = MessageCategory.PERSONAL
            ),
            MessageRecord(
                source = MessageSource.SMS,
                sender = "+256701234567",
                title = "Verification",
                body = "Your payment code is 871245. Do not share it.",
                timestamp = Instant.now().minusSeconds(7200).toEpochMilli(),
                category = MessageCategory.OTP
            ),
            MessageRecord(
                source = MessageSource.ACCESSIBILITY,
                sender = "Email",
                title = "Security Alert",
                body = "Your login from a new device was successful.",
                timestamp = Instant.now().minusSeconds(10800).toEpochMilli(),
                category = MessageCategory.SYSTEM
            )
        )
    }
}
