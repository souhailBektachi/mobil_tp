import 'package:flutter/material.dart';
import 'package:faseeh/core/constants/assets_paths.dart';

class AppIconWidget extends StatelessWidget {
  final double size;
  
  const AppIconWidget({Key? key, this.size = 48.0}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Image.asset(
      AppAssets.appIcon,
      width: size,
      height: size,
    );
  }
}
