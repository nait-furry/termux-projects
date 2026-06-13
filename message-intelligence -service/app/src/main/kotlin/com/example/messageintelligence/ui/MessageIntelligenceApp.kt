package com.example.messageintelligence.ui

import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.padding
import androidx.compose.material3.Button
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.material3.OutlinedTextField
import androidx.compose.material3.Scaffold
import androidx.compose.material3.Surface
import androidx.compose.material3.Text
import androidx.compose.material3.TopAppBar
import androidx.compose.runtime.Composable
import androidx.compose.runtime.collectAsState
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.getValue
import androidx.compose.runtime.setValue
import androidx.compose.ui.Modifier
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.dp
import com.example.messageintelligence.MainViewModel
import com.example.messageintelligence.data.MessageCategory
import com.example.messageintelligence.data.MessageRecord
import com.example.messageintelligence.ui.theme.MessageIntelligenceTheme

@Composable
fun MessageIntelligenceApp(viewModel: MainViewModel) {
    val messages by viewModel.messages.collectAsState(initial = emptyList())
    val selectedCategory by viewModel.selectedCategory.collectAsState()

    MessageDashboard(
        messages = messages,
        selectedCategory = selectedCategory,
        onSelectCategory = { if (it == MessageCategory.UNKNOWN) viewModel.resetFilter() else viewModel.selectCategory(it) },
        onSimulateNotification = viewModel::simulateNotification,
        onSimulateSms = viewModel::simulateSms,
        onAddManualMessage = viewModel::addManualMessage
    )
}

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun MessageDashboard(
    messages: List<MessageRecord>,
    selectedCategory: MessageCategory,
    onSelectCategory: (MessageCategory) -> Unit,
    onSimulateNotification: () -> Unit,
    onSimulateSms: () -> Unit,
    onAddManualMessage: (String, String, String) -> Unit
) {
    var sender by remember { mutableStateOf("") }
    var title by remember { mutableStateOf("") }
    var body by remember { mutableStateOf("") }

    Scaffold(
        topBar = {
            TopAppBar(title = { Text("Message Intelligence Lab") })
        }
    ) { paddingValues ->
        Column(modifier = Modifier.padding(paddingValues).padding(16.dp)) {
            Text("Category filter: ${selectedCategory.name}")
            MessageFilterRow(selectedCategory, onSelectCategory)
            MessageActionRow(onSimulateNotification, onSimulateSms)
            ManualInputCard(
                sender = sender,
                title = title,
                body = body,
                onSenderChange = { sender = it },
                onTitleChange = { title = it },
                onBodyChange = { body = it },
                onSubmit = {
                    onAddManualMessage(sender, title, body)
                    sender = ""
                    title = ""
                    body = ""
                }
            )
            MessageList(messages)
        }
    }
}

@Composable
fun MessageFilterRow(selectedCategory: MessageCategory, onSelectCategory: (MessageCategory) -> Unit) {
    val categories = MessageCategory.values()
    Column {
        categories.forEach { category ->
            Button(
                onClick = { onSelectCategory(category) },
                modifier = Modifier.padding(vertical = 2.dp)
            ) {
                Text(category.name)
            }
        }
    }
}

@Composable
fun MessageActionRow(onSimulateNotification: () -> Unit, onSimulateSms: () -> Unit) {
    Column {
        Button(onClick = onSimulateNotification, modifier = Modifier.padding(vertical = 4.dp)) {
            Text("Simulate Notification")
        }
        Button(onClick = onSimulateSms, modifier = Modifier.padding(vertical = 4.dp)) {
            Text("Simulate SMS")
        }
    }
}

@Composable
fun ManualInputCard(
    sender: String,
    title: String,
    body: String,
    onSenderChange: (String) -> Unit,
    onTitleChange: (String) -> Unit,
    onBodyChange: (String) -> Unit,
    onSubmit: () -> Unit
) {
    Column(modifier = Modifier.padding(vertical = 8.dp)) {
        Text("Manual message entry")
        OutlinedTextField(value = sender, onValueChange = onSenderChange, label = { Text("Sender") })
        OutlinedTextField(value = title, onValueChange = onTitleChange, label = { Text("Title") })
        OutlinedTextField(value = body, onValueChange = onBodyChange, label = { Text("Body") })
        Button(onClick = onSubmit, modifier = Modifier.padding(top = 8.dp)) {
            Text("Add Manual Message")
        }
    }
}

@Composable
fun MessageList(messages: List<MessageRecord>) {
    Column(modifier = Modifier.fillMaxSize()) {
        messages.forEach { message ->
            MessageCard(message)
        }
    }
}

@Composable
fun MessageCard(message: MessageRecord) {
    Surface(modifier = Modifier.padding(vertical = 4.dp)) {
        Column(modifier = Modifier.padding(12.dp)) {
            Text(text = "${message.source} / ${message.category}", style = androidx.compose.material3.MaterialTheme.typography.labelLarge)
            Text(text = message.title ?: "No title", style = androidx.compose.material3.MaterialTheme.typography.titleMedium)
            Text(text = message.body, style = androidx.compose.material3.MaterialTheme.typography.bodyMedium)
            Text(text = message.sender ?: "Unknown sender", style = androidx.compose.material3.MaterialTheme.typography.labelSmall)
        }
    }
}

@Preview(showBackground = true)
@Composable
fun MessageDashboardPreview() {
    MessageIntelligenceTheme {
        MessageDashboard(
            messages = listOf(
                MessageRecord(source = com.example.messageintelligence.data.MessageSource.SMS, sender = "+123", title = "Test", body = "OTP 1234", timestamp = 0, category = MessageCategory.OTP)
            ),
            selectedCategory = MessageCategory.UNKNOWN,
            onSelectCategory = {},
            onSimulateNotification = {},
            onSimulateSms = {},
            onAddManualMessage = { _, _, _ -> }
        )
    }
}
