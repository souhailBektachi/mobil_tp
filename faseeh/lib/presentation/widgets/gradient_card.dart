import 'package:flutter/material.dart';
import 'package:faseeh/presentation/theme/app_theme.dart';

class GradientCard extends StatelessWidget {
  final Widget child;
  final Gradient? gradient;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;
  final double borderRadius;
  final VoidCallback? onTap;
  final double height;
  final double? width;
  final bool showShadow;
  final AlignmentGeometry alignment;

  const GradientCard({
    Key? key,
    required this.child,
    this.gradient,
    this.padding = const EdgeInsets.all(16),
    this.margin = const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
    this.borderRadius = 16,
    this.onTap,
    this.height = 120,
    this.width,
    this.showShadow = true,
    this.alignment = Alignment.center,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: margin,
      height: height,
      width: width,
      decoration: BoxDecoration(
        gradient: gradient ?? AppTheme.primaryGradient,
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: showShadow ? AppTheme.cardShadow : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(borderRadius),
          splashColor: Colors.white.withOpacity(0.1),
          highlightColor: Colors.white.withOpacity(0.05),
          child: Container(
            padding: padding,
            alignment: alignment,
            child: child,
          ),
        ),
      ),
    );
  }
}
