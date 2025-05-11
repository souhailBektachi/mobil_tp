import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:faseeh/presentation/theme/app_theme.dart';

class ResultsScreen extends StatelessWidget {
  final String mediaType;
  final String mediaName;
  
  const ResultsScreen({
    Key? key,
    required this.mediaType,
    required this.mediaName,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    
    // Generate dummy MCQs based on media type
    final mcqs = _generateDummyMCQs(mediaType);
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Generated MCQs'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => context.go('/'),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.save_alt),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('MCQs saved to your library'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.share),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Sharing functionality coming soon'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Media info section
            Container(
              padding: const EdgeInsets.all(16),
              color: isDarkMode
                  ? Colors.black.withOpacity(0.3)
                  : AppTheme.robinsEggBlue.withOpacity(0.1),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppTheme.robinsEggBlue.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      _getIconForMediaType(mediaType),
                      color: AppTheme.robinsEggBlue,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          mediaName,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          '${mcqs.length} questions generated',
                          style: theme.textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                  OutlinedButton.icon(
                    onPressed: () => context.go('/reader'),
                    icon: Icon(Icons.menu_book_outlined),
                    label: Text('Study'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppTheme.robinsEggBlue,
                    ),
                  ),
                ],
              ),
            ),
            
            // Generated MCQs
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 16),
                itemCount: mcqs.length,
                itemBuilder: (context, index) {
                  final mcq = mcqs[index];
                  return _buildMCQCard(context, mcq, index);
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: theme.scaffoldBackgroundColor,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: ElevatedButton(
          onPressed: () => context.go('/srs-review'),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.robinsEggBlue,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Text(
            'Start Review Session',
            style: theme.textTheme.titleMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
  
  Widget _buildMCQCard(BuildContext context, Map<String, dynamic> mcq, int index) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    
    return Card(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
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
            // Question number and topic
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppTheme.robinsEggBlue,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'Q${index + 1}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  mcq['topic'],
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.silver,
                  ),
                ),
                const Spacer(),
                Icon(
                  Icons.star_border,
                  size: 20,
                  color: AppTheme.silver,
                ),
              ],
            ),
            
            const SizedBox(height: 12),
            
            // Question text
            Text(
              mcq['question'],
              style: theme.textTheme.titleMedium,
            ),
            
            const SizedBox(height: 16),
            
            // Answer options
            ...List.generate(mcq['options'].length, (optionIndex) {
              final option = mcq['options'][optionIndex];
              final isCorrect = optionIndex == mcq['correctIndex'];
              
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
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: isDarkMode
                        ? Colors.grey[900]
                        : Colors.grey[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Text(
                        '${String.fromCharCode(65 + optionIndex)}. ',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppTheme.veniceBlue,
                        ),
                      ),
                      Expanded(
                        child: Text(option),
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
  
  List<Map<String, dynamic>> _generateDummyMCQs(String mediaType) {
    // Generate different example questions based on media type
    if (mediaType.toLowerCase() == 'pdf' || mediaType.toLowerCase() == 'text') {
      return [
        {
          'question': 'What is the main theme discussed in the third paragraph?',
          'topic': 'Reading Comprehension',
          'options': [
            'Economic development',
            'Cultural differences',
            'Environmental impact',
            'Historical context'
          ],
          'correctIndex': 2,
        },
        {
          'question': 'Which of the following words is a synonym for "ubiquitous" as used in the text?',
          'topic': 'Vocabulary',
          'options': [
            'Rare',
            'Widespread',
            'Unusual',
            'Confined'
          ],
          'correctIndex': 1,
        },
        {
          'question': 'According to the passage, what caused the shift in public opinion?',
          'topic': 'Critical Analysis',
          'options': [
            'Government intervention',
            'Media coverage',
            'Scientific research',
            'Economic factors'
          ],
          'correctIndex': 3,
        },
      ];
    } else if (mediaType.toLowerCase() == 'audio' || mediaType.toLowerCase() == 'video') {
      return [
        {
          'question': 'What was the main argument presented by the speaker?',
          'topic': 'Listening Comprehension',
          'options': [
            'Technology should be regulated',
            'Sustainability requires innovation',
            'Education needs reform',
            'Global cooperation is essential'
          ],
          'correctIndex': 1,
        },
        {
          'question': 'Which phrase was repeatedly used to emphasize the key point?',
          'topic': 'Key Expressions',
          'options': [
            '"Beyond our control"',
            '"Time and again"',
            '"Simply put"',
            '"In this context"'
          ],
          'correctIndex': 2,
        },
        {
          'question': 'What tone did the speaker primarily use during the presentation?',
          'topic': 'Communication Style',
          'options': [
            'Authoritative',
            'Persuasive',
            'Cautious',
            'Skeptical'
          ],
          'correctIndex': 1,
        },
      ];
    } else {
      return [
        {
          'question': 'What concept is being represented by the visual elements?',
          'topic': 'Visual Analysis',
          'options': [
            'Balance',
            'Contrast',
            'Hierarchy',
            'Rhythm'
          ],
          'correctIndex': 0,
        },
        {
          'question': 'Which of these statements best describes the content?',
          'topic': 'Content Analysis',
          'options': [
            'It provides historical context',
            'It explains a complex process',
            'It compares different viewpoints',
            'It presents statistical data'
          ],
          'correctIndex': 1,
        },
        {
          'question': 'What is the primary purpose of this media?',
          'topic': 'Purpose Identification',
          'options': [
            'To entertain',
            'To inform',
            'To persuade',
            'To instruct'
          ],
          'correctIndex': 3,
        },
      ];
    }
  }
}
