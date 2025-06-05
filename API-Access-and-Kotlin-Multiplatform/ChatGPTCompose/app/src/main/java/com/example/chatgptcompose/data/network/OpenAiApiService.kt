package com.example.chatgptcompose.data.network

import com.example.chatgptcompose.data.model.ChatRequest
import com.example.chatgptcompose.data.model.ChatResponse
import retrofit2.http.Body
import retrofit2.http.POST

/**
 * Retrofit service interface for interacting with the OpenAI API.
 */
interface OpenAiApiService {
    
    /**
     * Send a chat completion request to the OpenAI API.
     * 
     * @param request The request body containing messages and model information
     * @return ChatResponse with the model's reply
     */
    @POST("v1/chat/completions")
    suspend fun getChatCompletion(@Body request: ChatRequest): ChatResponse
}
