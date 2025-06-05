# Project: API Access and Kotlin Multiplatform

This repository contains three distinct Android applications demonstrating different approaches to API access and UI development, along with an exploration of Kotlin Multiplatform (though the current app set focuses on Android native).

## General Setup

1.  [X] create a repository.
2.  [X] Each application is in its own subfolder and can be opened as a separate Android Studio project.
3.  [X] A root `.gitignore` file is provided for common Android development files.

---

## 1. WeatherAppXML

**Folder:** `WeatherAppXML/`

**Objective:** Recreate a basic Android weather application using the traditional XML View system and Volley for network requests. The app will display current weather information for a searched city using the OpenWeatherMap API.

**Key Features & Requirements:**

*   **UI:**
    *   Main screen built with XML layouts.
    *   Toolbar with a SearchView for city input.
    *   Display fields for:
        *   City Name
        *   Current Temperature (°C)
        *   Feels Like Temperature (°C)
        *   Humidity (%)
        *   Weather Description (e.g., "Clear sky")
        *   Current Date & Time (formatted)
        *   Weather condition icon (e.g., sunny, rainy, cloudy).
*   **Networking:**
    *   Use Volley library for making HTTP GET requests.
    *   Fetch weather data from OpenWeatherMap API:
        *   Endpoint: `http://api.openweathermap.org/data/2.5/weather`
        *   Parameters: `q={cityName}&appid={YOUR_API_KEY}&units=metric`
        *   **API Key:** `e457293228d5e1465f30bcbelaea456b` (as provided in the TP).
    *   Parse JSON response to extract relevant weather data.
*   **Data Handling:**
    *   Convert temperature from Kelvin to Celsius.
    *   Format date/time appropriately.
    *   Dynamically update weather icons based on the weather condition string (e.g., "Rain", "Clear", "Clouds").
*   **Permissions:**
    *   `android.permission.INTERNET`
*   **Error Handling:**
    *   Display a Toast message for network errors or if a city is not found.
    *   Show a ProgressBar during data fetching.
*   **Dependencies:**
    *   `com.android.volley:volley:1.2.1`
*   **Code Structure (based on provided TP):**
    *   `MainActivity.java`: Handles UI logic, Volley requests, and JSON parsing.
    *   `MeteoItem.java`: A simple POJO/data class for holding weather details.
    *   `activity_main.xml`: Layout file.
    *   `menu_main.xml`: Menu file for the search action.
    *   Drawable resources for weather icons (`clear.xml`, `cloudy.xml`, etc. - using XML drawables).

**Development Steps (for tracking):**

1.  [X] Initialize Android project (Empty Activity, XML).
2.  [X] Add Volley dependency.
3.  [X] Add INTERNET permission.
4.  [X] Design `activity_main.xml` layout.
5.  [X] Create `menu_main.xml` with SearchView.
6.  [X] Add placeholder weather drawable icons.
7.  [X] Implement `MeteoItem.java` model class.
8.  [X] Implement `MainActivity.java` logic:
    *   [X] Toolbar and View initialization.
    *   [X] `onCreateOptionsMenu` for SearchView setup.
    *   [X] `OnQueryTextListener` for search submission.
    *   [X] Volley request to OpenWeatherMap API.
    *   [X] JSON response parsing.
    *   [X] Update UI elements with fetched data.
    *   [X] Implement `setWeatherIcon()` method for dynamic icons.
    *   [X] Error handling (Toast messages and ProgressBar).


---

## 2. PostViewerCompose

**Folder:** `PostViewerCompose/`

**Objective:** Build an Android application using Jetpack Compose, MVVM architecture, and Retrofit. The app will fetch a list of posts from a public API (`https://jsonplaceholder.typicode.com/`) and display their titles in a scrollable list.

**Key Features & Requirements:**

*   **UI (Jetpack Compose):**
    *   A single screen displaying a list of post titles.
    *   Use `LazyColumn` for efficient list rendering.
*   **Architecture:**
    *   MVVM (Model-View-ViewModel).
*   **Networking:**
    *   Use Retrofit for type-safe HTTP requests.
    *   Use Gson converter for JSON parsing.
    *   Fetch data from: `https://jsonplaceholder.typicode.com/posts`.
*   **Data Handling:**
    *   `Post` data class to represent the structure of a post item.
    *   `ApiService` interface for Retrofit.
    *   `RetrofitInstance` singleton for Retrofit client setup.
*   **State Management:**
    *   `MainViewModel` to fetch and hold the list of posts.
    *   Use `StateFlow` to expose data to the Composable UI.
    *   Update UI reactively when data changes.
*   **Permissions:**
    *   `android.permission.INTERNET`
*   **Dependencies:**
    *   `com.squareup.retrofit2:retrofit:2.9.0`
    *   `com.squareup.retrofit2:converter-gson:2.9.0`
    *   `androidx.lifecycle:lifecycle-viewmodel-compose:2.7.0`
    *   `androidx.lifecycle:lifecycle-runtime-ktx:2.7.0` (for `viewModelScope`)
    *   Jetpack Compose dependencies (BoM, ui, material, tooling).
*   **Code Structure:**
    *   `data/model/Post.kt`: Data class.
    *   `data/network/ApiService.kt`: Retrofit service interface.
    *   `data/network/RetrofitInstance.kt`: Retrofit singleton.
    *   `ui/viewmodel/MainViewModel.kt`: ViewModel.
    *   `ui/screen/PostListScreen.kt`: Composable screen.
    *   `MainActivity.kt`: Entry point, sets up Compose UI.

**Development Steps (for tracking):**

1.  [X] Initialize Android project (Empty Compose Activity).
2.  [X] Add Retrofit, Gson, ViewModel-Compose dependencies.
3.  [X] Add INTERNET permission.
4.  [X] Create `Post.kt` data class.
5.  [X] Create `ApiService.kt` interface.
6.  [X] Create `RetrofitInstance.kt` singleton.
7.  [X] Implement `MainViewModel.kt` to fetch and expose posts.
8.  [X] Create `PostListScreen.kt` Composable to display post titles in a `LazyColumn`.
9.  [X] Integrate `PostListScreen` into `MainActivity.kt`.


---

## 3. ChatGPTCompose

**Folder:** `ChatGPTCompose/`

**Objective:** Develop an Android chat application using Jetpack Compose, MVVM, and Retrofit to interact with the OpenAI GPT-3.5-turbo API. Users can send messages and receive responses from the AI in a chat interface.

**Key Features & Requirements:**

*   **UI (Jetpack Compose):**
    *   Chat interface:
        *   Scrollable area (`LazyColumn`) to display sent and received messages.
        *   Differentiate user messages from AI messages (e.g., alignment, background color).
        *   Text input field for users to type messages.
        *   Send button.
    *   Loading indicator while waiting for AI response.
*   **Architecture:**
    *   MVVM (Model-View-ViewModel).
*   **Networking:**
    *   Use Retrofit for API calls to OpenAI.
    *   Use OkHttp for adding an authorization interceptor.
    *   API Endpoint: OpenAI Chat Completions API (`v1/chat/completions`).
    *   Model: `gpt-3.5-turbo`.
*   **Authentication:**
    *   Securely handle OpenAI API Key.
        *   Store API key in `local.properties` (which is gitignored).
        *   Access the key in code via `BuildConfig`.
    *   Include `Authorization: Bearer YOUR_API_KEY` header in API requests using an OkHttp Interceptor.
*   **Data Handling:**
    *   Data classes for OpenAI API request (`ChatRequest`, `ChatMessage`) and response (`ChatResponse`, `Choice`).
    *   `OpenAiApiService.kt`: Retrofit service interface.
    *   `OpenAiRetrofitInstance.kt`: Retrofit singleton with authentication interceptor.
*   **State Management:**
    *   `ChatViewModel.kt` to manage:
        *   List of chat messages (`ChatMessage` objects with "user" or "assistant" roles).
        *   Loading state.
    *   Update UI reactively.
*   **Permissions:**
    *   `android.permission.INTERNET`
*   **Dependencies:**
    *   `com.squareup.retrofit2:retrofit:2.9.0`
    *   `com.squareup.retrofit2:converter-gson:2.9.0`
    *   `androidx.lifecycle:lifecycle-viewmodel-compose:2.7.0`
    *   `androidx.lifecycle:lifecycle-runtime-ktx:2.7.0`
    *   `com.squareup.okhttp3:okhttp:4.11.0`
    *   `com.squareup.okhttp3:logging-interceptor:4.11.0`
    *   Jetpack Compose dependencies.
*   **Code Structure:**
    *   `data/model/`: Data classes for API (e.g., `ChatMessage.kt`, `ChatRequest.kt`, `ChatResponse.kt`).
    *   `data/network/OpenAiApiService.kt`: Retrofit service.
    *   `data/network/OpenAiRetrofitInstance.kt`: Retrofit singleton with auth.
    *   `ui/viewmodel/ChatViewModel.kt`: ViewModel for chat logic.
    *   `ui/screen/ChatScreen.kt`: Composable chat UI.
    *   `MainActivity.kt`: Entry point.

**Development Steps (for tracking):**

1.  [X] Initialize Android project (Empty Compose Activity).
2.  [X] Add Retrofit, Gson, OkHttp, ViewModel-Compose dependencies.
3.  [X] Configure API key access via `local.properties` and `BuildConfig`.
4.  [X] Add INTERNET permission.
5.  [X] Define data classes for OpenAI API (request and response).
6.  [X] Create `OpenAiApiService.kt` interface.
7.  [X] Create `OpenAiRetrofitInstance.kt` with Auth Interceptor.
8.  [X] Implement `ChatViewModel.kt` to manage chat messages, loading state, and API calls.
9.  [X] Create `ChatScreen.kt` Composable for the chat UI (message list, input field, send button).
10. [X] Integrate `ChatScreen` into `MainActivity.kt`.
