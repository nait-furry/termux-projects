package com.example.messageintelligence.data

object MessageProcessor {
    fun classify(body: String): MessageCategory {
        val text = body.lowercase()
        return when {
            text.contains("otp") || text.contains("verification code") || text.contains("code is") -> MessageCategory.OTP
            text.contains("bank") || text.contains("account") || text.contains("balance") || text.contains("payment") -> MessageCategory.BANKING
            text.contains("sale") || text.contains("offer") || text.contains("promo") || text.contains("subscribe") -> MessageCategory.MARKETING
            text.contains("meeting") || text.contains("group") || text.contains("call") -> MessageCategory.SOCIAL
            text.contains("alert") || text.contains("security") || text.contains("login") -> MessageCategory.SYSTEM
            else -> MessageCategory.PERSONAL
        }
    }

    fun extractOtp(body: String): String? {
        val regex = "\\b(\\d{4,8})\\b".toRegex()
        return regex.find(body)?.value
    }

    fun validateOtp(code: String): Boolean {
        return code.length in 4..8 && code.all { it.isDigit() }
    }
}
