import 'package:flutter/material.dart';
import 'package:faseeh/presentation/theme/app_theme.dart';

class ProgressCard extends StatelessWidget {
  final String language;
  final double progress;
  final int wordsLearned;
  final int minutesPracticed;
  final VoidCallback onTap;

  const ProgressCard({
    Key? key,
    required this.language,
    required this.progress,
    required this.wordsLearned,
    required this.minutesPracticed,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: isDarkMode ? AppTheme.darkAccent : Colors.white,
        boxShadow: isDarkMode ? null : AppTheme.cardShadow,
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      language,
                      style: theme.textTheme.headlineMedium,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppTheme.robinsEggBlue.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '${(progress * 100).toInt()}%',
                        style: theme.textTheme.labelLarge?.copyWith(
                          color: AppTheme.robinsEggBlue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                LinearProgressIndicator(
                  value: progress,
                  backgroundColor: isDarkMode 
                      ? Colors.white.withOpacity(0.1) 
                      : Colors.grey.withOpacity(0.15),
                  valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.robinsEggBlue),
                  borderRadius: BorderRadius.circular(4),
                  minHeight: 8,
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildStat(
                      context: context,
                      value: wordsLearned.toString(),
                      label: 'Words',
                      icon: Icons.library_books_outlined,
                    ),
                    _buildStat(
                      context: context,
                      value: '$minutesPracticed min',
                      label: 'Practice',
                      icon: Icons.timer_outlined,
                    ),
                    OutlinedButton(
                      onPressed: onTap,
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      ),
                      child: const Text('Continue'),
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

  Widget _buildStat({
    required BuildContext context,
    required String value,
    required String label,
    required IconData icon,
  }) {
    final theme = Theme.of(context);
    
    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: theme.brightness == Brightness.dark 
              ? AppTheme.silver 
              : AppTheme.veniceBlue,
        ),
        const SizedBox(width: 4),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: theme.textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              label,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.brightness == Brightness.dark
                    ? AppTheme.silver.withOpacity(0.7)
                    : Colors.grey[600],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
