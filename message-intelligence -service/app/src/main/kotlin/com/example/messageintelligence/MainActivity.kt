package com.example.messageintelligence

import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.activity.viewModels
import com.example.messageintelligence.ui.MessageIntelligenceApp
import com.example.messageintelligence.ui.theme.MessageIntelligenceTheme

class MainActivity : ComponentActivity() {
    private val viewModel: MainViewModel by viewModels()

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContent {
            MessageIntelligenceTheme {
                MessageIntelligenceApp(viewModel)
            }
        }
    }
}
