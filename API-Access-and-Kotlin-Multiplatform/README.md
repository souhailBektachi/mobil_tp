# Android API Showcase: XML, Compose, Volley, Retrofit & OpenAI

This repository demonstrates various approaches to building Android applications that interact with web APIs. It includes three distinct apps showcasing traditional XML layouts with Volley, modern Jetpack Compose with Retrofit and MVVM, and an AI chat interface using OpenAI's API.

## Author

*   Souhail Bektachi

## Applications

Each application is a self-contained Android Studio project located in its respective subfolder.

### 1. WeatherAppXML

*   **Folder:** `WeatherAppXML/`
*   **Description:** A classic Android weather app using XML layouts. Fetches and displays current weather data from OpenWeatherMap.
*   **Key Technologies:** Android XML, Material Components, Volley, OpenWeatherMap API.
*   **Features:**
    *   Search weather by city.
    *   Displays temperature, humidity, weather description, and icons.
    *   Shows current date and time.
    *   Loading indicators and error handling.

### 2. PostViewerCompose

*   **Folder:** `PostViewerCompose/`
*   **Description:** A modern Android app using Jetpack Compose and MVVM. Fetches and displays a list of post titles from JSONPlaceholder.
*   **Key Technologies:** Jetpack Compose, MVVM, Retrofit, Gson, JSONPlaceholder API.
*   **Features:**
    *   Scrollable list of post titles.
    *   Reactive UI updates via `StateFlow`.
    *   Clean separation of concerns.

### 3. ChatGPTCompose

*   **Folder:** `ChatGPTCompose/`
*   **Description:** An AI chat application built with Jetpack Compose and MVVM. Interacts with the OpenAI GPT-3.5-turbo API.
*   **Key Technologies:** Jetpack Compose, MVVM, Retrofit, OkHttp, Gson, OpenAI API.
*   **Features:**
    *   Conversational chat interface.
    *   Visually distinct user and AI messages.
    *   Loading indicator for AI responses.
    *   Secure API key handling.

## Setup and Running Instructions

1.  **Clone the repository:**
    ```bash
    git clone https://github.com/your-username/your-repository-name.git # Replace with actual URL if available
    ```
2.  **Open in Android Studio:**
    *   Open Android Studio.
    *   Select "Open an Existing Project".
    *   Navigate to and open one of the application subfolders (e.g., `WeatherAppXML/`, `PostViewerCompose/`, or `ChatGPTCompose/`).
3.  **Sync and Build:**
    *   Allow Android Studio to sync Gradle files and build the project.
4.  **API Key for `ChatGPTCompose` (Required):**
    *   This application requires an OpenAI API key.
    *   Create a file named `local.properties` in the `ChatGPTCompose/` project directory (at the same level as the app's `build.gradle` file).
    *   Add your API key to `local.properties` as follows:
        ```properties
        # In ChatGPTCompose/local.properties
        OPENAI_API_KEY="YOUR_OPENAI_API_KEY_HERE"
        ```
    *   Replace `"YOUR_OPENAI_API_KEY_HERE"` with your actual OpenAI API key.
5.  **Run the App:**
    *   Select a run configuration and target device (emulator or physical device).
    *   Click the "Run" button.

## Technologies Showcased

*   **UI:** Android XML, Jetpack Compose, Material Components
*   **Networking:** Volley, Retrofit, OkHttp
*   **Data Serialization:** Gson
*   **Architecture:** Model-View-ViewModel (MVVM)
*   **APIs:** OpenWeatherMap, JSONPlaceholder, OpenAI GPT
*   **Languages:** Kotlin
*   **Build Tools:** Gradle
*   **Version Control:** Git
