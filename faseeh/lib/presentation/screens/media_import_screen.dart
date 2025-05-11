import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:faseeh/presentation/theme/app_theme.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart' show kReleaseMode;
import 'dart:io';

class MediaImportScreen extends StatefulWidget {
  const MediaImportScreen({Key? key}) : super(key: key);

  @override
  State<MediaImportScreen> createState() => _MediaImportScreenState();
}

class _MediaImportScreenState extends State<MediaImportScreen> {
  final TextEditingController _urlController = TextEditingController();
  bool _isUrlValid = false;
  int _selectedTabIndex = 0;
  String? _selectedFileName;
  String? _selectedFileType;
  bool _isFileSelected = false;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _urlController.addListener(_validateUrl);
  }

  @override
  void dispose() {
    _urlController.dispose();
    super.dispose();
  }

  void _validateUrl() {
    final url = _urlController.text.trim();
    setState(() {
      // Very basic URL validation
      _isUrlValid = url.isNotEmpty &&
          (url.startsWith('http://') || url.startsWith('https://'));
    });
  }

  // Modified file picker with actual functionality
  Future<void> _pickFile(String type) async {
    XFile? pickedFile;
    
    try {
      switch (type) {
        case 'Image':
          pickedFile = await _picker.pickImage(
            source: ImageSource.gallery,
            imageQuality: 80,
          );
          break;
        case 'Video':
          pickedFile = await _picker.pickVideo(
            source: ImageSource.gallery,
            maxDuration: const Duration(minutes: 30),
          );
          break;
        case 'PDF':
        case 'Audio':
        case 'Text':
        default:
          // For other types, we'll create a simulated file selection that works
          setState(() {
            _selectedFileName = 'example_${type.toLowerCase()}_file.${_getFileExtension(type)}';
            _selectedFileType = type;
            _isFileSelected = true;
          });
          
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Selected $type file: $_selectedFileName'),
              backgroundColor: AppTheme.veniceBlue,
              behavior: SnackBarBehavior.floating,
              action: SnackBarAction(
                label: 'PROCESS',
                textColor: Colors.white,
                onPressed: () => _processSelectedFile(goToReaderAfter: true),
              ),
            ),
          );
          return;
      }

      // Handle the actual picked file
      if (pickedFile != null) {
        setState(() {
          // Fix: Use null-safe access operator and provide fallback
          _selectedFileName = pickedFile?.name ?? 'Selected ${type.toLowerCase()}';
          _selectedFileType = type;
          _isFileSelected = true;
        });
        
        // Display success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Selected $type: ${pickedFile?.name ?? 'file'}'),
            backgroundColor: AppTheme.veniceBlue,
            behavior: SnackBarBehavior.floating,
            action: SnackBarAction(
              label: 'PROCESS',
              textColor: Colors.white,
              onPressed: () => _processSelectedFile(goToReaderAfter: true),
            ),
          ),
        );
      }
    } catch (e) {
      // Show meaningful error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error selecting file: $e'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          action: SnackBarAction(
            label: 'RETRY',
            textColor: Colors.white,
            onPressed: () => _pickFile(type),
          ),
        ),
      );
    }
  }

  String _getFileExtension(String type) {
    switch (type) {
      case 'PDF':
        return 'pdf';
      case 'Audio':
        return 'mp3';
      case 'Video':
        return 'mp4';
      case 'Text':
        return 'txt';
      default:
        return 'file';
    }
  }

  // Process file with option to navigate to reader after processing
  void _processSelectedFile({bool goToReaderAfter = false}) {
    if (_selectedFileName == null) return;
    
    // For video files, navigate directly to video player
    if (_selectedFileType?.toLowerCase() == 'video') {
      debugPrint('Navigating to video player with file: $_selectedFileName');
      context.go('/video-player', extra: {
        'videoTitle': _selectedFileName ?? 'Unknown video',
      });
      return;
    }
    
    // For other file types, navigate to processing screen
    context.go('/processing', extra: {
      'mediaType': _selectedFileType ?? 'Unknown',
      'mediaName': _selectedFileName ?? 'Unknown file',
    });
  }

  // Improved URL import to handle video URLs specially
  void _mockUrlImport() {
    final url = _urlController.text.trim();
    if (_isUrlValid) {
      // Check if the URL appears to be a video link
      bool isVideoUrl = url.contains('youtube.com') || 
                         url.contains('youtu.be') || 
                         url.endsWith('.mp4') ||
                         url.contains('vimeo.com');
      
      if (isVideoUrl) {
        // For video URLs, go directly to video player
        debugPrint('Detected video URL, navigating to video player');
        context.go('/video-player', extra: {
          'videoTitle': 'Online Video',
          'videoUrl': url,
        });
        return;
      }
      
      // For other URLs, navigate to processing screen
      context.go('/processing', extra: {
        'mediaType': 'URL',
        'mediaName': url,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Import Media'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          // Use a more robust navigation approach
          onPressed: () {
            try {
              debugPrint('Navigating back to home screen');
              context.go('/');
            } catch (e) {
              debugPrint('Error navigating: $e');
              // Fallback navigation as a safety measure
              Navigator.of(context).canPop() 
                ? Navigator.of(context).pop() 
                : context.go('/');
            }
          },
        ),
        actions: [
          // Add a quick access button directly to video player for testing
          IconButton(
            icon: const Icon(Icons.videocam),
            onPressed: () => context.go('/video-player', extra: {
              'videoTitle': 'Sample Video',
            }),
            tooltip: 'Test Video Player',
          ),
        ],
      ),
      body: SafeArea(
        child: Stack(
          children: [
            // Background with subtle gradient
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
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
                opacity: 0.02,
                child: CustomPaint(
                  painter: GridPatternPainter(
                    color: isDarkMode ? Colors.white : Colors.black,
                    lineWidth: 0.5,
                    spacing: 20,
                  ),
                ),
              ),
            ),

            Column(
              children: [
                // Tab selection
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: isDarkMode 
                          ? Colors.black.withOpacity(0.3) 
                          : Colors.grey[100],
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        _buildTabButton(
                          index: 0, 
                          icon: Icons.upload_file, 
                          label: 'Manual Import',
                        ),
                        _buildTabButton(
                          index: 1, 
                          icon: Icons.link, 
                          label: 'URL Import',
                        ),
                      ],
                    ),
                  ),
                ),
                
                // Content area
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: _selectedTabIndex == 0 
                          ? _buildManualImportView() 
                          : _buildUrlImportView(),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabButton({
    required int index,
    required IconData icon,
    required String label,
  }) {
    final isSelected = _selectedTabIndex == index;
    final theme = Theme.of(context);
    
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedTabIndex = index;
          });
        },
        child: Container(
          height: 56,
          decoration: BoxDecoration(
            color: isSelected 
                ? AppTheme.robinsEggBlue 
                : Colors.transparent,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: isSelected 
                    ? Colors.white 
                    : theme.iconTheme.color,
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  color: isSelected 
                      ? Colors.white 
                      : theme.textTheme.bodyLarge?.color,
                  fontWeight: isSelected 
                      ? FontWeight.bold 
                      : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildManualImportView() {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      color: isDarkMode ? Colors.black.withOpacity(0.3) : Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Manual Import',
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Select files from your device to import',
              style: theme.textTheme.bodyMedium,
            ),
            
            if (_isFileSelected) _buildSelectedFileInfo(),

            const SizedBox(height: 24),
            
            _buildImportOption(
              icon: Icons.picture_as_pdf,
              title: 'PDF Document',
              description: 'Import PDFs for reading and translation',
              onTap: () => _pickFile('PDF'),
            ),
            
            const SizedBox(height: 16),
            
            _buildImportOption(
              icon: Icons.audiotrack,
              title: 'Audio File',
              description: 'Import audio for listening practice',
              onTap: () => _pickFile('Audio'),
            ),
            
            const SizedBox(height: 16),
            
            _buildImportOption(
              icon: Icons.videocam,
              title: 'Video File',
              description: 'Import videos with subtitles',
              onTap: () => _pickFile('Video'),
            ),
            
            const SizedBox(height: 16),
            
            _buildImportOption(
              icon: Icons.image,
              title: 'Image File',
              description: 'Import images for reference',
              onTap: () => _pickFile('Image'),
            ),
            
            const Spacer(),
            
            if (_isFileSelected)
              ElevatedButton(
                onPressed: () => _processSelectedFile(goToReaderAfter: true),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.robinsEggBlue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.check_circle_outline),
                    const SizedBox(width: 8),
                    Text(
                      'Process and Open in Reader',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              
            if (!_isFileSelected)
              Text(
                'Files will be processed locally on your device',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.textTheme.bodySmall?.color?.withOpacity(0.7),
                ),
                textAlign: TextAlign.center,
              ),
            
            // Allow direct access to the video player for testing
            if (!_isFileSelected && !kReleaseMode)
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: OutlinedButton.icon(
                  onPressed: () => context.go('/video-player', extra: {
                    'videoTitle': 'test_video.mp4',
                  }),
                  icon: const Icon(Icons.videocam),
                  label: const Text('Open Test Video Player'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppTheme.veniceBlue,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildUrlImportView() {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      color: isDarkMode ? Colors.black.withOpacity(0.3) : Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'URL Import',
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Paste a link to import content',
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 32),
            
            TextField(
              controller: _urlController,
              decoration: InputDecoration(
                hintText: 'Paste URL here (e.g., YouTube, article, etc.)',
                prefixIcon: const Icon(Icons.link),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                fillColor: isDarkMode 
                    ? Colors.black.withOpacity(0.3) 
                    : Colors.grey[100],
                filled: true,
              ),
              keyboardType: TextInputType.url,
            ),
            
            const SizedBox(height: 8),
            
            Text(
              'Supported platforms: YouTube, Wikipedia, News Sites, etc.',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.textTheme.bodySmall?.color?.withOpacity(0.7),
              ),
            ),
            
            const SizedBox(height: 24),
            
            ElevatedButton(
              onPressed: _isUrlValid ? _mockUrlImport : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.robinsEggBlue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.download),
                  const SizedBox(width: 8),
                  Text(
                    'Import Content',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            
            const Spacer(),
            
            // Platform support section
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildSupportedPlatform(Icons.play_circle_fill, 'YouTube'),
                _buildSupportedPlatform(Icons.article, 'Articles'),
                _buildSupportedPlatform(Icons.menu_book, 'Wikipedia'),
                _buildSupportedPlatform(Icons.public, 'Web'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImportOption({
    required IconData icon,
    required String title,
    required String description,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(
              color: AppTheme.robinsEggBlue.withOpacity(0.3),
              width: 2,
            ),
            borderRadius: BorderRadius.circular(12),
            color: isDarkMode 
                ? Colors.black.withOpacity(0.2) 
                : AppTheme.robinsEggBlue.withOpacity(0.05),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isDarkMode 
                      ? AppTheme.robinsEggBlue.withOpacity(0.2) 
                      : AppTheme.robinsEggBlue.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  color: AppTheme.robinsEggBlue,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: theme.textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSelectedFileInfo() {
    final theme = Theme.of(context);
    final bool isVideoFile = _selectedFileType?.toLowerCase() == 'video';
    
    return Container(
      margin: const EdgeInsets.only(top: 16, bottom: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.veniceBlue.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.veniceBlue.withOpacity(0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Selected File',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              // Add quick action button for videos
              if (isVideoFile)
                TextButton.icon(
                  icon: const Icon(Icons.play_circle_outline, size: 18),
                  label: const Text('Play Video'),
                  onPressed: () => context.go('/video-player', extra: {
                    'videoTitle': _selectedFileName ?? 'Unknown video',
                  }),
                  style: TextButton.styleFrom(
                    foregroundColor: AppTheme.robinsEggBlue,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(
                _getIconForFileType(_selectedFileType ?? ''),
                color: AppTheme.veniceBlue,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  _selectedFileName ?? '',
                  style: theme.textTheme.bodyMedium,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  setState(() {
                    _selectedFileName = null;
                    _selectedFileType = null;
                    _isFileSelected = false;
                  });
                },
                color: Colors.grey,
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  IconData _getIconForFileType(String type) {
    switch (type) {
      case 'PDF':
        return Icons.picture_as_pdf;
      case 'Audio':
        return Icons.audiotrack;
      case 'Video':
        return Icons.videocam;
      case 'Text':
        return Icons.text_fields;
      case 'Image':
        return Icons.image;
      default:
        return Icons.insert_drive_file;
    }
  }

  Widget _buildSupportedPlatform(IconData icon, String name) {
    final theme = Theme.of(context);
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        children: [
          Icon(
            icon,
            color: AppTheme.silver,
          ),
          const SizedBox(height: 4),
          Text(
            name,
            style: theme.textTheme.bodySmall,
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
