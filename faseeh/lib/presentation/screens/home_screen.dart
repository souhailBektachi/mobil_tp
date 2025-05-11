import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:faseeh/presentation/theme/app_theme.dart';
import 'package:faseeh/presentation/widgets/feature_button.dart';
import 'package:faseeh/presentation/widgets/progress_card.dart';
import 'package:faseeh/presentation/widgets/theme_toggle.dart';
import 'package:faseeh/core/constants/assets_paths.dart';
// Import the screen classes to fix the constructor errors
import 'package:faseeh/presentation/screens/dictionary_screen.dart';
import 'package:faseeh/presentation/screens/reader_player_screen.dart';
import 'package:faseeh/presentation/screens/srs_review_screen.dart';
import 'package:faseeh/presentation/screens/media_import_screen.dart';
import 'package:faseeh/presentation/screens/settings_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    
    // Create gradient pairs for feature buttons
    final gradients = [
      const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [AppTheme.robinsEggBlue, AppTheme.veniceBlue],
      ),
      LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [AppTheme.veniceBlue, AppTheme.veniceBlue.withBlue(150)],
      ),
      LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Colors.orange.shade400, Colors.deepOrange.shade400],
      ),
      LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Colors.purple.shade400, Colors.deepPurple.shade600],
      ),
    ];

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            // Background with subtle gradient instead of image pattern
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  // Use a subtle gradient instead of image patterns
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      isDarkMode 
                          ? AppTheme.woodsmoke 
                          : Colors.white,
                      isDarkMode 
                          ? AppTheme.woodsmoke.withBlue(AppTheme.woodsmoke.blue + 5) 
                          : Colors.grey[50]!,
                    ],
                  ),
                ),
              ),
            ),
            
            // Subtle pattern overlay created programmatically
            Positioned.fill(
              child: Opacity(
                opacity: 0.03,
                child: CustomPaint(
                  painter: GridPatternPainter(
                    color: isDarkMode ? Colors.white : Colors.black,
                    lineWidth: 0.5,
                    spacing: 20,
                  ),
                ),
              ),
            ),
            
            CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                // App bar
                SliverAppBar(
                  floating: true,
                  title: const Row(
                    children: [
                      Text(
                        'Faseeh',
                        style: TextStyle(
                          fontFamily: AppTheme.primaryFontFamily,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 4),
                      Text(
                        'Learn',
                        style: TextStyle(
                          fontFamily: AppTheme.primaryFontFamily,
                          fontWeight: FontWeight.w300,
                          color: AppTheme.robinsEggBlue,
                        ),
                      ),
                    ],
                  ),
                  actions: [
                    // Add Video Player test button
                    IconButton(
                      icon: const Icon(Icons.video_library),
                      onPressed: () {
                        debugPrint('Navigating to video player from home screen');
                        context.go('/video-player', extra: {
                          'videoTitle': 'Sample Video Title'
                        });
                      },
                      tooltip: 'Test Video Player',
                    ),
                    
                    // Theme toggle
                    const ThemeToggle(),
                    
                    // Settings button
                    IconButton(
                      icon: const Icon(Icons.settings_outlined),
                      onPressed: () => context.push('/settings'),
                    ),
                  ],
                ),
                
                // Welcome and progress section
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Welcome message with animation
                        _buildWelcomeSection(context),
                      ],
                    ),
                  ),
                ),
                
                // Language progress
                SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text(
                          'Your Progress',
                          style: theme.textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      ProgressCard(
                        language: 'Arabic',
                        progress: 0.35,
                        wordsLearned: 124,
                        minutesPracticed: 45,
                        onTap: () {},
                      ),
                      // Add a "quick start" button for recently studied content
                      _buildQuickStartCard(context),
                    ],
                  ),
                ),
                
                // Features section
                SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16.0, 24.0, 16.0, 8.0),
                        child: Text(
                          'Features',
                          style: theme.textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      
                      // Dictionary feature
                      _buildDictionaryButton(context, gradients[0]),
                      
                      // Reader feature
                      _buildReaderButton(context, gradients[1]),
                      
                      // Flashcards feature
                      _buildFlashcardsButton(context, gradients[2]),
                      
                      // Import media feature
                      _buildMediaImportButton(context, gradients[3]),
                      
                      // Add an extra button specifically for the video player
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              debugPrint('Navigating to video player from featured button');
                              context.go('/video-player', extra: {
                                'videoTitle': 'Featured Video Player Demo'
                              });
                            },
                            borderRadius: BorderRadius.circular(16),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [Colors.red.shade400, Colors.deepOrange.shade700],
                                ),
                              ),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.play_circle_filled,
                                    color: Colors.white,
                                    size: 40,
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Watch Video Demo',
                                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          'Test our video player functionality',
                                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                            color: Colors.white.withOpacity(0.9),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Icon(
                                    Icons.chevron_right,
                                    color: Colors.white,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          debugPrint('Navigating to video player from FAB');
          context.go('/video-player', extra: {
            'videoTitle': 'Quick Access Video'
          });
        },
        backgroundColor: AppTheme.robinsEggBlue,
        child: const Icon(Icons.videocam),
      ),
    );
  }

  Widget _buildWelcomeSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(
        gradient: AppTheme.primaryGradient,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppTheme.robinsEggBlue.withOpacity(0.2),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome Back',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Continue your language journey',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => context.push('/srs-review'),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: AppTheme.veniceBlue,
                    backgroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                  child: const Text('Start Learning'),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          // Could add an illustration here
          Container(
            width: 80,
            height: 80,
            decoration: const BoxDecoration(
              color: Colors.white24,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.school_outlined,
              size: 40,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStartCard(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.robinsEggBlue.withOpacity(0.3),
          width: 2,
        ),
        color: theme.brightness == Brightness.dark
            ? Colors.black.withOpacity(0.3)
            : Colors.white,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: () => context.push('/reader'),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppTheme.robinsEggBlue.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.play_arrow_rounded,
                    color: AppTheme.robinsEggBlue,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Continue Reading',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Resume "Basic Arabic Conversations"',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.brightness == Brightness.dark
                              ? AppTheme.silver.withOpacity(0.7)
                              : Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Dictionary feature
  Widget _buildDictionaryButton(BuildContext context, LinearGradient gradient) {
    return FeatureButton(
      title: 'Dictionary',
      subtitle: 'Look up words and save them',
      icon: Icons.book_outlined,
      onTap: () {
        try {
          context.go('/dictionary');
        } catch (e) {
          print('Navigation error: $e');
          _showNavigationErrorDialog(context, 'dictionary');
        }
      },
      gradient: gradient,
    );
  }
  
  // Reader feature
  Widget _buildReaderButton(BuildContext context, LinearGradient gradient) {
    return FeatureButton(
      title: 'Reader',
      subtitle: 'Read and listen to content',
      icon: Icons.menu_book_outlined,
      onTap: () {
        try {
          context.go('/reader');
        } catch (e) {
          print('Navigation error: $e');
          _showNavigationErrorDialog(context, 'reader');
        }
      },
      gradient: gradient,
    );
  }
  
  // Flashcards feature
  Widget _buildFlashcardsButton(BuildContext context, LinearGradient gradient) {
    return FeatureButton(
      title: 'Flashcards',
      subtitle: 'Review your vocabulary',
      icon: Icons.flash_on,
      onTap: () {
        try {
          context.go('/srs-review');
        } catch (e) {
          print('Navigation error: $e');
          _showNavigationErrorDialog(context, 'flashcards');
        }
      },
      gradient: gradient,
    );
  }
  
  // Import media feature
  Widget _buildMediaImportButton(BuildContext context, LinearGradient gradient) {
    return FeatureButton(
      title: 'Import Media',
      subtitle: 'Add new content to learn from',
      icon: Icons.file_upload_outlined,
      onTap: () {
        try {
          context.go('/media-import');
        } catch (e) {
          print('Navigation error: $e');
          _showNavigationErrorDialog(context, 'media import');
        }
      },
      gradient: gradient,
    );
  }
  
  // Show a dialog when navigation fails
  void _showNavigationErrorDialog(BuildContext context, String destination) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Navigation Error'),
        content: Text('Could not navigate to $destination. Please try again.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}

// Custom painter to draw a subtle grid pattern
class GridPatternPainter extends CustomPainter {
  final Color color;
  final double lineWidth;
  final double spacing;

  GridPatternPainter({
    required this.color,
    required this.lineWidth,
    required this.spacing,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = lineWidth;

    // Draw horizontal lines
    for (double y = 0; y < size.height; y += spacing) {
      canvas.drawLine(
        Offset(0, y),
        Offset(size.width, y),
        paint,
      );
    }

    // Draw vertical lines
    for (double x = 0; x < size.width; x += spacing) {
      canvas.drawLine(
        Offset(x, 0),
        Offset(x, size.height),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
