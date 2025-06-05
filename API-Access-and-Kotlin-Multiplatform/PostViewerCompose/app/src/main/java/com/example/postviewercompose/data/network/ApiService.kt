package com.example.postviewercompose.data.network

import com.example.postviewercompose.data.model.Post
import retrofit2.http.GET

/**
 * Retrofit service interface for interacting with the JSONPlaceholder API.
 */
interface ApiService {
    
    /**
     * Get a list of posts from the API.
     * 
     * @return List of Post objects
     */
    @GET("posts")
    suspend fun getPosts(): List<Post>
}
