import 'package:flutter/material.dart';
import 'package:faseeh/presentation/theme/app_theme.dart';
import 'package:go_router/go_router.dart';
import 'dart:math' as math;

class VideoPlayerScreen extends StatefulWidget {
  final String videoTitle;
  final String? videoUrl;
  
  const VideoPlayerScreen({
    Key? key,
    required this.videoTitle,
    this.videoUrl,
  }) : super(key: key);

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> with SingleTickerProviderStateMixin {
  // Mock video player state
  bool _isPlaying = false;
  bool _isMuted = false;
  Duration _position = const Duration(seconds: 15);
  Duration _duration = const Duration(minutes: 2, seconds: 30);
  
  // Animation controller for simulating video playback
  late AnimationController _playbackController;
  
  // Sample captions/subtitles to display
  final List<Map<String, dynamic>> _captions = [
    {
      'time': const Duration(seconds: 0),
      'text': 'This is a sample question extracted from the video.',
    },
    {
      'time': const Duration(seconds: 10),
      'text': 'The concept being discussed here involves language acquisition.',
    },
    {
      'time': const Duration(seconds: 20),
      'text': 'Notice how the speaker emphasizes key vocabulary terms.',
    },
    {
      'time': const Duration(seconds: 30),
      'text': 'This section introduces the main topic of the lecture.',
    },
  ];
  String _currentCaption = 'This is a sample question extracted from the video.';

  @override
  void initState() {
    super.initState();
    
    // Initialize animation controller for simulating playback
    _playbackController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    
    // Set up a periodic timer to update position when "playing"
    _startPositionTimer();
  }
  
  void _startPositionTimer() {
    Future.delayed(const Duration(milliseconds: 500), () {
      if (!mounted) return;
      
      // Update position if playing
      if (_isPlaying) {
        setState(() {
          _position = Duration(milliseconds: 
              math.min(_position.inMilliseconds + 500, _duration.inMilliseconds));
          
          // Update current caption based on video position
          _updateCurrentCaption();
        });
      }
      
      // Continue the timer
      _startPositionTimer();
    });
  }
  
  void _updateCurrentCaption() {
    final currentTime = _position;
    for (int i = _captions.length - 1; i >= 0; i--) {
      if (currentTime >= _captions[i]['time']) {
        _currentCaption = _captions[i]['text'];
        break;
      }
    }
  }

  @override
  void dispose() {
    _playbackController.dispose();
    super.dispose();
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    
    return [
      if (duration.inHours > 0) hours,
      minutes,
      seconds,
    ].join(':');
  }

  void _togglePlayPause() {
    setState(() {
      _isPlaying = !_isPlaying;
      
      if (_isPlaying) {
        _playbackController.repeat();
      } else {
        _playbackController.stop();
      }
    });
  }

  void _toggleMute() {
    setState(() {
      _isMuted = !_isMuted;
    });
  }

  void _seekTo(double value) {
    setState(() {
      _position = Duration(milliseconds: (value * _duration.inMilliseconds).round());
      _updateCurrentCaption();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Video Player'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/'),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.file_download_outlined),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Download feature coming soon'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (context) => _buildMoreOptionsSheet(context),
              );
            },
          ),
        ],
      ),
      // Fix: Replace Column with LayoutBuilder + SingleChildScrollView
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Video file info bar
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      color: isDarkMode
                          ? Colors.black.withOpacity(0.3)
                          : AppTheme.robinsEggBlue.withOpacity(0.1),
                      child: Row(
                        children: [
                          Icon(
                            Icons.video_file,
                            color: AppTheme.robinsEggBlue,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              widget.videoTitle,
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Text(
                            _formatDuration(_duration),
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: AppTheme.silver,
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    // Video player container - Fixed height
                    AspectRatio(
                      aspectRatio: 16 / 9,
                      child: Container(
                        color: Colors.black,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            // Simulated video content
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // Mock video frame
                                Icon(
                                  Icons.movie_outlined,
                                  size: 64,
                                  color: Colors.white.withOpacity(0.5),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'Sample Video',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            
                            // Play/pause overlay
                            if (!_isPlaying)
                              Container(
                                width: 64,
                                height: 64,
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.5),
                                  shape: BoxShape.circle,
                                ),
                                child: IconButton(
                                  icon: const Icon(
                                    Icons.play_arrow,
                                    size: 36,
                                    color: Colors.white,
                                  ),
                                  onPressed: _togglePlayPause,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                    
                    // Video controls
                    Container(
                      color: isDarkMode ? Colors.black : Colors.grey[200],
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Row(
                        children: [
                          // Play/Pause button
                          IconButton(
                            icon: Icon(
                              _isPlaying ? Icons.pause : Icons.play_arrow,
                              color: AppTheme.robinsEggBlue,
                            ),
                            onPressed: _togglePlayPause,
                          ),
                          
                          // Current position
                          Text(
                            _formatDuration(_position),
                            style: TextStyle(
                              color: isDarkMode ? Colors.white : Colors.black,
                            ),
                          ),
                          
                          // Seek bar
                          Expanded(
                            child: SliderTheme(
                              data: SliderTheme.of(context).copyWith(
                                activeTrackColor: AppTheme.robinsEggBlue,
                                inactiveTrackColor: AppTheme.silver.withOpacity(0.3),
                                thumbColor: AppTheme.robinsEggBlue,
                                thumbShape: const RoundSliderThumbShape(
                                  enabledThumbRadius: 6,
                                ),
                                overlayShape: const RoundSliderOverlayShape(
                                  overlayRadius: 12,
                                ),
                              ),
                              child: Slider(
                                value: _position.inMilliseconds / _duration.inMilliseconds,
                                onChanged: _seekTo,
                              ),
                            ),
                          ),
                          
                          // Total duration
                          Text(
                            _formatDuration(_duration),
                            style: TextStyle(
                              color: isDarkMode ? Colors.white : Colors.black,
                            ),
                          ),
                          
                          // Mute button
                          IconButton(
                            icon: Icon(
                              _isMuted ? Icons.volume_off : Icons.volume_up,
                              color: AppTheme.robinsEggBlue,
                            ),
                            onPressed: _toggleMute,
                          ),
                        ],
                      ),
                    ),
                    
                    // Divider
                    const Divider(height: 1),
                    
                    // Captions and Questions Section - Scrollable
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Caption section title
                          Text(
                            'Captions',
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          
                          // Caption content
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: isDarkMode
                                  ? Colors.black.withOpacity(0.3)
                                  : AppTheme.robinsEggBlue.withOpacity(0.05),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: AppTheme.robinsEggBlue.withOpacity(0.2),
                                width: 1,
                              ),
                            ),
                            child: Text(
                              _currentCaption,
                              style: theme.textTheme.bodyLarge,
                            ),
                          ),
                          
                          const SizedBox(height: 24),
                          
                          // Generated questions section
                          Text(
                            'Generated Questions',
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          
                          // Sample question cards
                          _buildQuestionCard(
                            context,
                            'What is the main topic discussed in this video?',
                            ['Language acquisition', 'Grammar rules', 'Cultural context', 'Vocabulary building'],
                            0,
                          ),
                          const SizedBox(height: 16),
                          _buildQuestionCard(
                            context,
                            'Which concept was emphasized by the speaker?',
                            ['Memorization', 'Practice', 'Cultural immersion', 'Key vocabulary'],
                            3,
                          ),

                          // Add spacing at bottom for better scrolling
                          const SizedBox(height: 32),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
      ),
    );
  }

  Widget _buildQuestionCard(
    BuildContext context,
    String question,
    List<String> options,
    int correctIndex,
  ) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isDarkMode
              ? Colors.grey[800]!
              : Colors.grey[300]!,
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              question,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            ...List.generate(options.length, (index) {
              return InkWell(
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        index == correctIndex
                            ? 'Correct!'
                            : 'Incorrect. The correct answer is "${options[correctIndex]}".',
                      ),
                      backgroundColor: index == correctIndex ? Colors.green : Colors.red,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isDarkMode
                        ? Colors.grey[900]
                        : Colors.grey[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Text(
                        '${String.fromCharCode(65 + index)}. ',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppTheme.veniceBlue,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(options[index]),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildMoreOptionsSheet(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.speed),
            title: const Text('Playback Speed'),
            trailing: DropdownButton<double>(
              value: 1.0,
              items: [0.5, 0.75, 1.0, 1.25, 1.5, 2.0].map((speed) {
                return DropdownMenuItem(
                  value: speed,
                  child: Text('${speed}x'),
                );
              }).toList(),
              onChanged: (value) {
                Navigator.pop(context);
              },
            ),
          ),
          ListTile(
            leading: const Icon(Icons.subtitles),
            title: const Text('Subtitles'),
            trailing: Switch(
              value: true,
              activeColor: AppTheme.robinsEggBlue,
              onChanged: (value) {
                // Toggle subtitles
                Navigator.pop(context);
              },
            ),
          ),
          ListTile(
            leading: const Icon(Icons.screen_share),
            title: const Text('Picture-in-Picture'),
            onTap: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Picture-in-Picture mode coming soon'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
