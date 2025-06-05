package com.example.chatgptcompose.data.model

/**
 * Represents a message in the chat conversation.
 * 
 * @property role The role of the message sender: "user" or "assistant"
 * @property content The content of the message
 */
data class ChatMessage(
    val role: String,
    val content: String
)
