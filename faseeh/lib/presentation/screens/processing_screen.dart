import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:faseeh/presentation/theme/app_theme.dart';
import 'dart:math' as math;

class ProcessingScreen extends StatefulWidget {
  final String mediaType;
  final String mediaName;

  const ProcessingScreen({
    Key? key, 
    required this.mediaType, 
    required this.mediaName,
  }) : super(key: key);

  @override
  State<ProcessingScreen> createState() => _ProcessingScreenState();
}

class _ProcessingScreenState extends State<ProcessingScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  int _processingProgress = 0;
  final List<String> _processingSteps = [
    'Analyzing content...',
    'Extracting key concepts...',
    'Generating MCQs...',
    'Finalizing learning materials...',
  ];
  int _currentStepIndex = 0;
  
  @override
  void initState() {
    super.initState();
    
    // Animation controller for the loading animation
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
    
    // Start processing simulation
    _simulateProcessing();
  }
  
  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
  
  // Simulate background processing with step updates
  Future<void> _simulateProcessing() async {
    // Total processing time: ~5 seconds
    const totalDuration = 5;
    const stepInterval = 1250; // ms between step changes
    
    // Update progress bar periodically
    for (int i = 1; i <= 100; i++) {
      if (mounted) {
        await Future.delayed(Duration(milliseconds: (totalDuration * 1000) ~/ 100));
        setState(() {
          _processingProgress = i;
          if (i % 25 == 0 && _currentStepIndex < _processingSteps.length - 1) {
            _currentStepIndex++;
          }
        });
      }
    }
    
    // Navigate to results screen
    if (mounted) {
      await Future.delayed(const Duration(milliseconds: 300));
      context.go('/results', extra: {
        'mediaType': widget.mediaType, 
        'mediaName': widget.mediaName
      });
    }
  }
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Animation container
                SizedBox(
                  height: 120,
                  width: 120,
                  child: AnimatedBuilder(
                    animation: _animationController,
                    builder: (context, child) {
                      return CustomPaint(
                        painter: ProcessingPainter(
                          animation: _animationController.value,
                          isDarkMode: isDarkMode,
                        ),
                        child: Container(),
                      );
                    },
                  ),
                ),
                
                const SizedBox(height: 40),
                
                // Processing message
                Text(
                  'Hang tight!',
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppTheme.robinsEggBlue,
                  ),
                ),
                
                const SizedBox(height: 16),
                
                Text(
                  'We\'re analyzing your ${widget.mediaType.toLowerCase()} and generating your personalized MCQs.',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyLarge,
                ),
                
                const SizedBox(height: 32),
                
                // Current processing step
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: Text(
                    _processingSteps[_currentStepIndex],
                    key: ValueKey(_currentStepIndex),
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: AppTheme.veniceBlue,
                    ),
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // Progress bar
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: _processingProgress / 100,
                    backgroundColor: isDarkMode
                        ? Colors.grey[800]
                        : Colors.grey[200],
                    valueColor: AlwaysStoppedAnimation<Color>(AppTheme.robinsEggBlue),
                    minHeight: 8,
                  ),
                ),
                
                const SizedBox(height: 8),
                
                // Progress percentage
                Text(
                  '$_processingProgress%',
                  style: theme.textTheme.bodySmall,
                ),
                
                const SizedBox(height: 40),
                
                // Filename display
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: isDarkMode
                        ? Colors.black.withOpacity(0.3)
                        : AppTheme.robinsEggBlue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        _getIconForMediaType(widget.mediaType),
                        color: AppTheme.robinsEggBlue,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          widget.mediaName,
                          style: theme.textTheme.bodyMedium,
                          overflow: TextOverflow.ellipsis,
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
  
  IconData _getIconForMediaType(String type) {
    switch (type.toLowerCase()) {
      case 'pdf':
        return Icons.picture_as_pdf;
      case 'audio':
        return Icons.audiotrack;
      case 'video':
        return Icons.videocam;
      case 'text':
        return Icons.text_fields;
      case 'image':
        return Icons.image;
      case 'url':
        return Icons.link;
      default:
        return Icons.insert_drive_file;
    }
  }
}

class ProcessingPainter extends CustomPainter {
  final double animation;
  final bool isDarkMode;
  
  ProcessingPainter({required this.animation, required this.isDarkMode});
  
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppTheme.robinsEggBlue
      ..strokeWidth = 6.0
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    
    // Create a circular path
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width * 0.4;
    
    // Outer circle
    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..color = isDarkMode
            ? Colors.grey[800]!
            : Colors.grey[200]!
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3.0,
    );
    
    // Rotating arc
    final rect = Rect.fromCircle(center: center, radius: radius);
    final startAngle = math.pi * 2 * animation;
    final sweepAngle = math.pi;
    canvas.drawArc(rect, startAngle, sweepAngle, false, paint);
    
    // Inner dot
    final dotPaint = Paint()
      ..color = AppTheme.veniceBlue
      ..style = PaintingStyle.fill;
    
    final dotX = center.dx + radius * math.cos(startAngle + sweepAngle);
    final dotY = center.dy + radius * math.sin(startAngle + sweepAngle);
    canvas.drawCircle(Offset(dotX, dotY), 8, dotPaint);
  }
  
  @override
  bool shouldRepaint(covariant ProcessingPainter oldDelegate) =>
      animation != oldDelegate.animation;
}
