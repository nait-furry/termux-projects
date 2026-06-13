package com.example.messageintelligence

import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.example.messageintelligence.data.MessageCategory
import com.example.messageintelligence.data.MessageRecord
import com.example.messageintelligence.data.MessageRepository
import com.example.messageintelligence.data.MessageSource
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.launch

class MainViewModel : ViewModel() {
    private val repository = MessageRepository()
    private val _messages = MutableStateFlow<List<MessageRecord>>(emptyList())
    val messages: StateFlow<List<MessageRecord>> = _messages.asStateFlow()
    private val _selectedCategory = MutableStateFlow(MessageCategory.UNKNOWN)
    val selectedCategory: StateFlow<MessageCategory> = _selectedCategory.asStateFlow()

    init {
        _messages.value = repository.messages
    }

    fun selectCategory(category: MessageCategory) {
        _selectedCategory.value = category
        _messages.value = repository.filterByCategory(category)
    }

    fun resetFilter() {
        _selectedCategory.value = MessageCategory.UNKNOWN
        _messages.value = repository.messages
    }

    fun simulateNotification() {
        viewModelScope.launch {
            repository.addSimulation(MessageSource.NOTIFICATION)
            _messages.value = repository.messages
        }
    }

    fun simulateSms() {
        viewModelScope.launch {
            repository.addSimulation(MessageSource.SMS)
            _messages.value = repository.messages
        }
    }

    fun addManualMessage(sender: String, title: String, body: String) {
        viewModelScope.launch {
            repository.addManualMessage(sender, title, body)
            _messages.value = repository.messages
        }
    }
}
