package com.example.chatgptcompose.ui.viewmodel

import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.example.chatgptcompose.data.model.ChatMessage
import com.example.chatgptcompose.data.model.ChatRequest
import com.example.chatgptcompose.data.network.OpenAiRetrofitInstance
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.launch
import java.io.IOException

class ChatViewModel : ViewModel() {

    private val _messages = MutableStateFlow<List<ChatMessage>>(emptyList())
    val messages: StateFlow<List<ChatMessage>> = _messages.asStateFlow()

    private val _isLoading = MutableStateFlow(false)
    val isLoading: StateFlow<Boolean> = _isLoading.asStateFlow()

    private val _errorMessage = MutableStateFlow<String?>(null)
    val errorMessage: StateFlow<String?> = _errorMessage.asStateFlow()

    fun sendMessage(messageContent: String) {
        if (messageContent.isBlank()) return
        
        val userMessage = ChatMessage(role = "user", content = messageContent)
        _messages.value = _messages.value + userMessage
        
        _isLoading.value = true
        _errorMessage.value = null
        
        val chatHistory = _messages.value
        
        viewModelScope.launch {
            try {
                val request = ChatRequest(messages = chatHistory)
                val response = OpenAiRetrofitInstance.apiService.getChatCompletion(request)
                
                val assistantMessage = response.choices.firstOrNull()?.message
                if (assistantMessage != null) {
                    _messages.value = _messages.value + assistantMessage
                } else {
                    _errorMessage.value = "No response from assistant"
                }
            } catch (e: IOException) {
                _errorMessage.value = "Network error: ${e.message}"
            } catch (e: Exception) {
                _errorMessage.value = "Error: ${e.message}"
            } finally {
                _isLoading.value = false
            }
        }
    }

    fun clearChat() {
        _messages.value = emptyList()
        _errorMessage.value = null
    }
}
