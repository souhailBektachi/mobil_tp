package com.example.postviewercompose.data.model

/**
 * Data class representing a post from the JSONPlaceholder API.
 * 
 * @property userId The ID of the user who created the post
 * @property id The unique identifier for the post
 * @property title The title of the post
 * @property body The content of the post
 */
data class Post(
    val userId: Int,
    val id: Int,
    val title: String,
    val body: String
)
