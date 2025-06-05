package com.example.chatgptcompose.data.model

/**
 * Data class for making a request to the OpenAI Chat API.
 * 
 * @property model The model to use, e.g. "gpt-3.5-turbo"
 * @property messages The array of messages to send to the API
 * @property temperature Controls randomness of outputs (0.0 to 1.0)
 */
data class ChatRequest(
    val model: String = "gpt-3.5-turbo",
    val messages: List<ChatMessage>,
    val temperature: Double = 0.7
)
