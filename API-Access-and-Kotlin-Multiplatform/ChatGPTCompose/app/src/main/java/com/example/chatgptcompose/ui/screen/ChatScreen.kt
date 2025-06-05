package com.example.chatgptcompose.ui.screen

import androidx.compose.foundation.background
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.foundation.lazy.rememberLazyListState
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.foundation.text.KeyboardActions
import androidx.compose.foundation.text.KeyboardOptions
import androidx.compose.material.*
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Send
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.platform.LocalFocusManager
import androidx.compose.ui.res.colorResource
import androidx.compose.ui.text.input.ImeAction
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.unit.dp
import com.example.chatgptcompose.R
import com.example.chatgptcompose.data.model.ChatMessage
import com.example.chatgptcompose.ui.viewmodel.ChatViewModel
import kotlinx.coroutines.launch

/**
 * Main chat screen composable for displaying and interacting with the chatbot.
 *
 * @param viewModel The view model that manages chat state and API interactions
 */
@Composable
fun ChatScreen(viewModel: ChatViewModel) {
    val messages by viewModel.messages.collectAsState()
    val isLoading by viewModel.isLoading.collectAsState()
    val errorMessage by viewModel.errorMessage.collectAsState()
    
    var userInput by remember { mutableStateOf("") }
    val focusManager = LocalFocusManager.current
    val listState = rememberLazyListState()
    val coroutineScope = rememberCoroutineScope()
    
    // Scroll to bottom when messages change
    LaunchedEffect(messages) {
        if (messages.isNotEmpty()) {
            coroutineScope.launch {
                listState.animateScrollToItem(messages.size - 1)
            }
        }
    }

    Column(
        modifier = Modifier
            .fillMaxSize()
            .padding(16.dp)
    ) {
        // Title
        Text(
            text = "ChatGPT Compose",
            style = MaterialTheme.typography.h5,
            modifier = Modifier.padding(bottom = 16.dp)
        )
        
        // Messages list
        LazyColumn(
            state = listState,
            modifier = Modifier
                .weight(1f)
                .fillMaxWidth(),
            verticalArrangement = Arrangement.spacedBy(8.dp)
        ) {
            items(messages) { message ->
                MessageItem(message)
            }
            
            // Loading indicator
            if (isLoading) {
                item {
                    Row(
                        modifier = Modifier.fillMaxWidth(),
                        horizontalArrangement = Arrangement.Center
                    ) {
                        CircularProgressIndicator(
                            modifier = Modifier.padding(16.dp)
                        )
                    }
                }
            }
        }
        
        // Error message if any
        errorMessage?.let {
            Text(
                text = it,
                color = Color.Red,
                modifier = Modifier.padding(vertical = 8.dp)
            )
        }
        
        // Input field and send button
        Row(
            modifier = Modifier
                .fillMaxWidth()
                .padding(top = 8.dp),
            verticalAlignment = Alignment.CenterVertically
        ) {
            TextField(
                value = userInput,
                onValueChange = { userInput = it },
                placeholder = { Text("Type a message...") },
                modifier = Modifier
                    .weight(1f)
                    .padding(end = 8.dp),
                keyboardOptions = KeyboardOptions(imeAction = ImeAction.Send),
                keyboardActions = KeyboardActions(
                    onSend = {
                        if (userInput.isNotBlank() && !isLoading) {
                            viewModel.sendMessage(userInput)
                            userInput = ""
                            focusManager.clearFocus()
                        }
                    }
                ),
                singleLine = false,
                maxLines = 3
            )
            
            IconButton(
                onClick = {
                    if (userInput.isNotBlank() && !isLoading) {
                        viewModel.sendMessage(userInput)
                        userInput = ""
                        focusManager.clearFocus()
                    }
                },
                enabled = userInput.isNotBlank() && !isLoading
            ) {
                Icon(
                    imageVector = Icons.Filled.Send,
                    contentDescription = "Send message"
                )
            }
        }
    }
}

/**
 * Composable for displaying a single chat message.
 *
 * @param message The chat message to display
 */
@Composable
fun MessageItem(message: ChatMessage) {
    val isUserMessage = message.role == "user"
    val backgroundColor = if (isUserMessage) {
        colorResource(R.color.user_message_background)
    } else {
        colorResource(R.color.assistant_message_background)
    }
    
    Row(
        modifier = Modifier.fillMaxWidth(),
        horizontalArrangement = if (isUserMessage) Arrangement.End else Arrangement.Start
    ) {
        Box(
            modifier = Modifier
                .widthIn(max = 280.dp)
                .clip(
                    RoundedCornerShape(
                        topStart = 16.dp,
                        topEnd = 16.dp,
                        bottomStart = if (isUserMessage) 16.dp else 4.dp,
                        bottomEnd = if (isUserMessage) 4.dp else 16.dp
                    )
                )
                .background(backgroundColor)
                .padding(12.dp)
        ) {
            Text(
                text = message.content,
                color = Color.White,
                textAlign = if (isUserMessage) TextAlign.End else TextAlign.Start
            )
        }
    }
}
