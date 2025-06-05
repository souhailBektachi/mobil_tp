package com.example.postviewercompose.ui.screen

import androidx.compose.foundation.layout.*
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.material.*
import androidx.compose.runtime.Composable
import androidx.compose.runtime.collectAsState
import androidx.compose.runtime.getValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.text.style.TextOverflow
import androidx.compose.ui.unit.dp
import com.example.postviewercompose.data.model.Post
import com.example.postviewercompose.ui.viewmodel.MainViewModel

/**
 * Composable for displaying a list of posts.
 *
 * @param viewModel The view model that manages post data and API interactions
 */
@Composable
fun PostListScreen(viewModel: MainViewModel) {
    val posts by viewModel.posts.collectAsState()
    val isLoading by viewModel.isLoading.collectAsState()
    val error by viewModel.error.collectAsState()
    
    Column(modifier = Modifier.fillMaxSize()) {
        // Title
        TopAppBar(
            title = { Text("Posts") },
            backgroundColor = MaterialTheme.colors.primary
        )
        
        // Content
        Box(modifier = Modifier.fillMaxSize()) {
            // Post list
            if (posts.isNotEmpty()) {
                LazyColumn(
                    modifier = Modifier.fillMaxSize(),
                    contentPadding = PaddingValues(16.dp)
                ) {
                    items(posts) { post ->
                        PostItem(post)
                        Divider()
                    }
                }
            }
            
            // Loading indicator
            if (isLoading) {
                CircularProgressIndicator(
                    modifier = Modifier.align(Alignment.Center)
                )
            }
            
            // Error message
            if (error != null) {
                Column(
                    modifier = Modifier
                        .align(Alignment.Center)
                        .padding(16.dp),
                    horizontalAlignment = Alignment.CenterHorizontally
                ) {
                    Text(
                        text = error ?: "Unknown error",
                        color = MaterialTheme.colors.error
                    )
                    Spacer(modifier = Modifier.height(8.dp))
                    Button(onClick = { viewModel.fetchPosts() }) {
                        Text("Retry")
                    }
                }
            }
            
            // Empty state
            if (!isLoading && error == null && posts.isEmpty()) {
                Text(
                    text = "No posts found",
                    modifier = Modifier
                        .align(Alignment.Center)
                        .padding(16.dp)
                )
            }
        }
    }
}

/**
 * Composable for displaying a single post item.
 *
 * @param post The post to display
 */
@Composable
fun PostItem(post: Post) {
    Column(
        modifier = Modifier
            .fillMaxWidth()
            .padding(vertical = 8.dp)
    ) {
        Text(
            text = post.title,
            style = MaterialTheme.typography.h6,
            maxLines = 2,
            overflow = TextOverflow.Ellipsis
        )
        Spacer(modifier = Modifier.height(4.dp))
        Text(
            text = post.body,
            style = MaterialTheme.typography.body2,
            maxLines = 3,
            overflow = TextOverflow.Ellipsis
        )
    }
}
