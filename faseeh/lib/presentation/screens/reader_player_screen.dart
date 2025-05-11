import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:faseeh/presentation/theme/app_theme.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:math' as math;

class ReaderPlayerScreen extends StatefulWidget {
  final String? mediaTitle;
  final String? mediaType;
  final bool isVideoContent;
  
  const ReaderPlayerScreen({
    Key? key, 
    this.mediaTitle,
    this.mediaType,
    this.isVideoContent = false,
  }) : super(key: key);

  @override
  State<ReaderPlayerScreen> createState() => _ReaderPlayerScreenState();
}

class _ReaderPlayerScreenState extends State<ReaderPlayerScreen> with SingleTickerProviderStateMixin {
  int _currentPage = 0;
  int _totalPages = 5;
  bool _showDictionary = false;
  bool _isPlaying = false;
  bool _isMuted = false;
  String _selectedWord = '';
  
  // For video content
  Duration _position = const Duration(seconds: 15);
  Duration _duration = const Duration(minutes: 2, seconds: 30);
  late AnimationController _playbackController;
  
  // Sample paragraphs for text content
  final List<String> _paragraphs = [
    'Learning a new language opens doors to different cultures and perspectives. Language acquisition involves understanding vocabulary, grammar, and cultural context.',
    'Regular practice is essential for mastering a language. Immersion techniques help build fluency and confidence in communication.',
    'Arabic is one of the most widely spoken languages in the world, with rich literary traditions and diverse dialects across multiple regions.',
    'Understanding key vocabulary terms is fundamental to language learning. Building a strong vocabulary foundation enables more complex language skills.',
    'Cultural context provides depth to language learning. Idioms, expressions, and cultural references enhance comprehension and proper usage.'
  ];
  
  // Sample captions/subtitles for video content
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
    
    // Initialize animation controller for simulating video playback
    _playbackController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    
    if (widget.isVideoContent) {
      // Set up a periodic timer to update position when "playing"
      _startPositionTimer();
    }
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
  
  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    
    return '$minutes:$seconds';
  }

  void _toggleDictionary(String word) {
    setState(() {
      _selectedWord = word;
      _showDictionary = true;
    });
  }

  void _closeDictionary() {
    setState(() {
      _showDictionary = false;
    });
  }

  void _nextPage() {
    if (_currentPage < _totalPages - 1) {
      setState(() {
        _currentPage++;
      });
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      setState(() {
        _currentPage--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final mediaTitle = widget.mediaTitle ?? 'Language Learning Basics';
    
    return Scaffold(
      appBar: AppBar(
        title: Text(mediaTitle),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/'),
        ),
        actions: [
          IconButton(
            icon: Icon(widget.isVideoContent ? Icons.video_settings : Icons.text_format),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (context) => _buildSettingsSheet(context),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.bookmark_border),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Bookmark added'),
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
      body: Column(
        children: [
          // Progress indicator
          LinearProgressIndicator(
            value: widget.isVideoContent 
                ? _position.inMilliseconds / _duration.inMilliseconds
                : (_currentPage + 1) / _totalPages,
            backgroundColor: isDarkMode
                ? Colors.grey[800]
                : Colors.grey[300],
            valueColor: AlwaysStoppedAnimation<Color>(AppTheme.robinsEggBlue),
          ),
          
          // Main content area
          Expanded(
            child: widget.isVideoContent
                ? _buildVideoContent(context)
                : _buildTextContent(context),
          ),
          
          // Bottom navigation bar for text content
          if (!widget.isVideoContent)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: theme.scaffoldBackgroundColor,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 4,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios),
                    onPressed: _currentPage > 0 ? _previousPage : null,
                    color: _currentPage > 0 
                        ? AppTheme.robinsEggBlue 
                        : Colors.grey,
                  ),
                  Text(
                    '${_currentPage + 1} / $_totalPages',
                    style: theme.textTheme.bodyMedium,
                  ),
                  IconButton(
                    icon: const Icon(Icons.arrow_forward_ios),
                    onPressed: _currentPage < _totalPages - 1 ? _nextPage : null,
                    color: _currentPage < _totalPages - 1 
                        ? AppTheme.robinsEggBlue 
                        : Colors.grey,
                  ),
                ],
              ),
            ),
            
          // Video controls for video content  
          if (widget.isVideoContent)
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
        ],
      ),
      // Dictionary overlay
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Tap on words to see definitions'),
              behavior: SnackBarBehavior.floating,
            ),
          );
        },
        backgroundColor: AppTheme.robinsEggBlue,
        child: const Icon(Icons.help_outline),
      ),
    );
  }

  Widget _buildTextContent(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    
    return Stack(
      children: [
        SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              Text(
                'Chapter ${_currentPage + 1}: Introduction to Language Learning',
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppTheme.veniceBlue,
                ),
              ),
              const SizedBox(height: 24),
              
              // Content - make words tappable for dictionary
              RichText(
                text: TextSpan(
                  style: theme.textTheme.bodyLarge?.copyWith(
                    height: 1.6,
                    color: isDarkMode ? Colors.white : Colors.black87,
                  ),
                  children: _buildTappableText(_paragraphs[_currentPage]),
                ),
              ),
              
              const SizedBox(height: 48),
              
              // Practice section
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDarkMode
                      ? Colors.grey[900]
                      : Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppTheme.robinsEggBlue.withOpacity(0.3),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Practice Question',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppTheme.robinsEggBlue,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'What is a key factor in successful language acquisition?',
                      style: theme.textTheme.titleMedium,
                    ),
                    const SizedBox(height: 16),
                    _buildAnswerOption(context, 'Regular practice', true),
                    _buildAnswerOption(context, 'Using translation apps', false),
                    _buildAnswerOption(context, 'Memorizing grammar rules', false),
                    _buildAnswerOption(context, 'Reading complex literature', false),
                  ],
                ),
              ),
            ],
          ),
        ),
        
        // Dictionary overlay
        if (_showDictionary)
          _buildDictionaryOverlay(context),
      ],
    );
  }

  Widget _buildVideoContent(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    
    return Column(
      children: [
        // Video player container
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
                      widget.mediaTitle ?? 'Sample Video',
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
        
        // Caption area
        Container(
          padding: const EdgeInsets.all(16),
          color: isDarkMode 
              ? Colors.black.withOpacity(0.5) 
              : Colors.grey[100],
          child: Text(
            _currentCaption,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        
        // Video transcript and notes
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Video Transcript',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                
                // Show all captions as transcript
                ..._captions.map((caption) => Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: '${_formatDuration(caption['time'])}: ',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppTheme.robinsEggBlue,
                            fontFamily: theme.textTheme.bodyMedium?.fontFamily,
                          ),
                        ),
                        TextSpan(
                          text: caption['text'],
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: isDarkMode ? Colors.white : Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                )).toList(),
                
                const SizedBox(height: 24),
                
                // Video vocabulary section
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isDarkMode
                        ? Colors.grey[900]
                        : Colors.grey[100],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppTheme.robinsEggBlue.withOpacity(0.3),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Key Vocabulary',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppTheme.robinsEggBlue,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildVocabularyItem(context, 'acquisition', 'The process of gaining knowledge or skills'),
                      _buildVocabularyItem(context, 'vocabulary', 'The body of words used in a language'),
                      _buildVocabularyItem(context, 'fluency', 'Ability to speak or write a language smoothly and accurately'),
                      _buildVocabularyItem(context, 'immersion', 'Learning through deep involvement in the target language'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildVocabularyItem(BuildContext context, String word, String definition) {
    final theme = Theme.of(context);
    
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '• ',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: AppTheme.veniceBlue,
            ),
          ),
          Expanded(
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: '$word: ',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text: definition,
                    style: theme.textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<InlineSpan> _buildTappableText(String text) {
    final words = text.split(' ');
    return words.map((word) {
      final cleanedWord = word.replaceAll(RegExp(r'[^\w\s]'), '').toLowerCase();
      
      return WidgetSpan(
        child: GestureDetector(
          onTap: () => _toggleDictionary(cleanedWord),
          child: Text(
            '$word ',
            style: TextStyle(
              decoration: TextDecoration.underline,
              decorationStyle: TextDecorationStyle.dotted,
              decorationColor: Colors.grey.withOpacity(0.5),
            ),
          ),
        ),
      );
    }).toList();
  }

  Widget _buildAnswerOption(BuildContext context, String text, bool isCorrect) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    
    return InkWell(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              isCorrect ? 'Correct!' : 'Incorrect. Try again.',
            ),
            backgroundColor: isCorrect ? Colors.green : Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isDarkMode
              ? Colors.black.withOpacity(0.3)
              : Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: Colors.grey.withOpacity(0.3),
          ),
        ),
        child: Row(
          children: [
            Icon(
              Icons.radio_button_unchecked,
              color: AppTheme.robinsEggBlue,
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(text),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDictionaryOverlay(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    
    // Generate a fake definition
    final definition = _generateFakeDefinition(_selectedWord);
    
    return GestureDetector(
      onTap: _closeDictionary,
      child: Container(
        color: Colors.black.withOpacity(0.5),
        child: Center(
          child: Container(
            margin: const EdgeInsets.all(32),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: isDarkMode ? Colors.grey[900] : Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Dictionary',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppTheme.robinsEggBlue,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: _closeDictionary,
                      color: Colors.grey,
                    ),
                  ],
                ),
                const Divider(),
                const SizedBox(height: 16),
                Text(
                  _selectedWord,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Pronunciation: /${_selectedWord}/',
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  definition,
                  style: theme.textTheme.bodyMedium,
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildDictionaryButton(
                      context,
                      Icons.volume_up,
                      'Listen',
                      () {},
                    ),
                    _buildDictionaryButton(
                      context,
                      Icons.bookmark_border,
                      'Save',
                      () {},
                    ),
                    _buildDictionaryButton(
                      context,
                      Icons.flash_on,
                      'Learn',
                      () {},
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _generateFakeDefinition(String word) {
    final definitions = {
      'language': 'The system of words or signs that people use to express thoughts and feelings.',
      'acquisition': 'The process of gaining knowledge or a skill.',
      'vocabulary': 'The words used in a particular language or subject.',
      'grammar': 'The set of rules that explain how words are used in a language.',
      'fluency': 'The ability to speak or write a foreign language easily and accurately.',
      'immersion': 'A method of learning a language by being surrounded by it and using it all the time.',
      'practice': 'The act of doing something regularly to improve your skill.',
      'mastering': 'Becoming extremely skilled at something.',
      'culture': 'The customs, arts, social institutions, and achievements of a particular nation, people, or other social group.',
      'perspectives': 'Particular attitudes toward or ways of regarding something; points of view.',
    };
    
    return definitions[word] ?? 'This word is not in our dictionary yet.';
  }

  Widget _buildDictionaryButton(
    BuildContext context,
    IconData icon,
    String label,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Icon(
              icon,
              color: AppTheme.robinsEggBlue,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: AppTheme.robinsEggBlue,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsSheet(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.text_format),
            title: const Text('Font Size'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.remove),
                  onPressed: () {},
                ),
                const Text('Medium'),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {},
                ),
              ],
            ),
          ),
          if (widget.isVideoContent)
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
          if (widget.isVideoContent)
            ListTile(
              leading: const Icon(Icons.subtitles),
              title: const Text('Subtitles'),
              trailing: Switch(
                value: true,
                activeColor: AppTheme.robinsEggBlue,
                onChanged: (value) {
                  Navigator.pop(context);
                },
              ),
            ),
          ListTile(
            leading: const Icon(Icons.translate),
            title: const Text('Translation'),
            trailing: Switch(
              value: false,
              activeColor: AppTheme.robinsEggBlue,
              onChanged: (value) {
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMoreOptionsSheet(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.share),
            title: const Text('Share'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.download),
            title: const Text('Download for offline'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.file_download),
            title: const Text('Export notes'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.help_outline),
            title: const Text('Help'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
