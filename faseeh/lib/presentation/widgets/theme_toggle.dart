import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:faseeh/main.dart';
import 'package:faseeh/presentation/theme/app_theme.dart';

class ThemeToggle extends ConsumerWidget {
  const ThemeToggle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final isDarkMode = themeMode == ThemeMode.dark;

    return GestureDetector(
      onTap: () {
        ref.read(themeModeProvider.notifier).state = 
            isDarkMode ? ThemeMode.light : ThemeMode.dark;
      },
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.dark 
              ? Colors.white.withOpacity(0.1) 
              : Colors.grey.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (Widget child, Animation<double> animation) {
              return ScaleTransition(scale: animation, child: child);
            },
            child: Icon(
              isDarkMode ? Icons.light_mode : Icons.dark_mode,
              key: ValueKey<bool>(isDarkMode),
              color: isDarkMode ? AppTheme.robinsEggBlue : AppTheme.veniceBlue,
              size: 24,
            ),
          ),
        ),
      ),
    );
  }
}
