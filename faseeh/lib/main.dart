import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:faseeh/presentation/screens/home_screen.dart';
import 'package:faseeh/presentation/screens/media_import_screen.dart';
import 'package:faseeh/presentation/screens/reader_player_screen.dart';
import 'package:faseeh/presentation/screens/dictionary_screen.dart';
import 'package:faseeh/presentation/screens/srs_review_screen.dart';
import 'package:faseeh/presentation/screens/settings_screen.dart';
import 'package:faseeh/presentation/screens/plugins_screen.dart';
import 'package:faseeh/presentation/screens/error_screen.dart';
import 'package:faseeh/presentation/screens/processing_screen.dart';
import 'package:faseeh/presentation/screens/results_screen.dart';
import 'package:faseeh/presentation/screens/video_player_screen.dart';
import 'package:faseeh/presentation/theme/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Add debug print to help diagnose issues
  debugPrint('Starting Faseeh app...');
  
  // Log all navigation events globally
  GoRouter.optionURLReflectsImperativeAPIs = true;
  
  // Catch Flutter errors
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
    debugPrint('Flutter error caught: ${details.exception}');
  };
  
  runApp(
    ProviderScope(
      child: FaseehApp(),
    ),
  );
}

// Theme mode provider to control light/dark mode
final themeModeProvider = StateProvider<ThemeMode>((ref) => ThemeMode.system);

// Router configuration with enhanced navigation and error handling
final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    // Keep only one error handler - using errorBuilder because it's more flexible
    errorBuilder: (context, state) {
      debugPrint('Navigation error to ${state.matchedLocation}');
      return ErrorScreen(error: state.error);
    },
    routes: [
      GoRoute(
        path: '/',
        name: 'home',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/media-import',
        name: 'media-import',
        builder: (context, state) => const MediaImportScreen(),
      ),
      GoRoute(
        path: '/reader',
        name: 'reader',
        builder: (context, state) {
          final params = state.extra as Map<String, dynamic>? ?? {};
          return ReaderPlayerScreen(
            mediaTitle: params['mediaTitle'],
            mediaType: params['mediaType'],
            isVideoContent: params['isVideoContent'] ?? false,
          );
        },
      ),
      GoRoute(
        path: '/dictionary',
        name: 'dictionary',
        builder: (context, state) => const DictionaryScreen(),
      ),
      GoRoute(
        path: '/srs-review',
        name: 'srs-review',
        builder: (context, state) => const SrsReviewScreen(),
      ),
      GoRoute(
        path: '/settings',
        name: 'settings',
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(
        path: '/plugins',
        name: 'plugins',
        builder: (context, state) => const PluginsScreen(),
      ),
      // Add new routes for processing and results screens
      GoRoute(
        path: '/processing',
        name: 'processing',
        builder: (context, state) {
          final params = state.extra as Map<String, dynamic>? ?? {};
          return ProcessingScreen(
            mediaType: params['mediaType'] ?? 'Unknown',
            mediaName: params['mediaName'] ?? 'Unknown file',
          );
        },
      ),
      GoRoute(
        path: '/results',
        name: 'results',
        builder: (context, state) {
          final params = state.extra as Map<String, dynamic>? ?? {};
          return ResultsScreen(
            mediaType: params['mediaType'] ?? 'Unknown',
            mediaName: params['mediaName'] ?? 'Unknown file',
          );
        },
      ),
      // Simplified video player route that always works
      GoRoute(
        path: '/video-player',
        name: 'video-player',
        builder: (context, state) {
          final Map<String, dynamic> params;
          try {
            params = state.extra as Map<String, dynamic>? ?? {};
          } catch (e) {
            debugPrint('Error parsing video player params: $e');
            // Default fallback params if there's an error
            return const VideoPlayerScreen(videoTitle: 'Default Video');
          }
          
          debugPrint('Video player route params: $params');
          return VideoPlayerScreen(
            videoTitle: params['videoTitle'] ?? 'Untitled Video',
            videoUrl: params['videoUrl'],
          );
        },
      ),
    ],
    // Add debug logging
    debugLogDiagnostics: true,
    // Remove the onException handler as it conflicts with errorBuilder
    // Custom redirect to handle invalid routes
    redirect: (BuildContext context, GoRouterState state) {
      // Log navigation for debugging
      debugPrint('Navigation: Attempting to access ${state.matchedLocation}');
      
      // If the route doesn't exist, redirect to home
      final bool routeExists = state.matchedLocation == '/' || 
                             state.matchedLocation == '/media-import' ||
                             state.matchedLocation == '/reader' ||
                             state.matchedLocation == '/dictionary' ||
                             state.matchedLocation == '/srs-review' ||
                             state.matchedLocation == '/settings' ||
                             state.matchedLocation == '/plugins' ||
                             state.matchedLocation == '/processing' ||
                             state.matchedLocation == '/results' ||
                             state.matchedLocation == '/video-player';
      
      return routeExists ? null : '/';
    },
  );
});

// Remove the NavigationObserver class since we can't use it this way with GoRouter

class FaseehApp extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final themeMode = ref.watch(themeModeProvider);
    
    return MaterialApp.router(
      title: 'Faseeh - Language Learning Toolkit',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      routerConfig: router,
      scrollBehavior: const MaterialScrollBehavior().copyWith(
        physics: const BouncingScrollPhysics(),
      ),
      // We could add observers here if needed
      // navigatorObservers: [NavigatorObserver()],
    );
  }
}
