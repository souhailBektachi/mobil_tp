package com.example.postviewercompose

import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.material.MaterialTheme
import androidx.compose.material.Surface
import androidx.compose.ui.Modifier
import androidx.lifecycle.viewmodel.compose.viewModel
import com.example.postviewercompose.ui.screen.PostListScreen
import com.example.postviewercompose.ui.viewmodel.MainViewModel

class MainActivity : ComponentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContent {
            PostViewerTheme {
                Surface(
                    modifier = Modifier.fillMaxSize(),
                    color = MaterialTheme.colors.background
                ) {
                    val mainViewModel: MainViewModel = viewModel()
                    PostListScreen(viewModel = mainViewModel)
                }
            }
        }
    }
}

@androidx.compose.runtime.Composable
fun PostViewerTheme(content: @androidx.compose.runtime.Composable () -> Unit) {
    MaterialTheme(
        colors = MaterialTheme.colors.copy(
            primary = androidx.compose.ui.graphics.Color(0xFF6200EE),
            primaryVariant = androidx.compose.ui.graphics.Color(0xFF3700B3),
            secondary = androidx.compose.ui.graphics.Color(0xFF03DAC5)
        ),
        content = content
    )
}
