import 'package:flutter/material.dart';

class AppTheme {
  // Brand Colors based on provided palette
  static const Color woodsmoke = Color(0xFF131414); // Dark background
  static const Color robinsEggBlue = Color(0xFF04DAC1); // Primary accent
  static const Color silver = Color(0xFFCACACA); // Light text/elements
  static const Color veniceBlue = Color(0xFF086F92); // Secondary accent
  
  // Additional complementary colors
  static const Color darkAccent = Color(0xFF0A2A33);
  static const Color lightAccent = Color(0xFFE0F7FA);
  static const Color successColor = Color(0xFF2E7D32);
  static const Color errorColor = Color(0xFFD32F2F);
  static const Color warningColor = Color(0xFFFFA000);
  
  // Typography
  static const String primaryFontFamily = 'Poppins';
  static const String secondaryFontFamily = 'Roboto';
  
  // Shadows and Effects
  static List<BoxShadow> cardShadow = [
    BoxShadow(
      color: woodsmoke.withOpacity(0.2),
      blurRadius: 10,
      offset: const Offset(0, 4),
    ),
  ];
  
  static List<BoxShadow> buttonShadow = [
    BoxShadow(
      color: robinsEggBlue.withOpacity(0.3),
      blurRadius: 8,
      offset: const Offset(0, 2),
    ),
  ];
  
  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [robinsEggBlue, veniceBlue],
  );
  
  static const LinearGradient darkGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [woodsmoke, darkAccent],
  );

  // Light theme
  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: ColorScheme(
      brightness: Brightness.light,
      primary: robinsEggBlue,
      onPrimary: Colors.white,
      secondary: veniceBlue,
      onSecondary: Colors.white,
      error: errorColor,
      onError: Colors.white,
      background: Colors.white,
      onBackground: woodsmoke,
      surface: Colors.white,
      onSurface: woodsmoke,
    ),
    scaffoldBackgroundColor: Colors.grey[50],
    textTheme: TextTheme(
      displayLarge: TextStyle(
        fontFamily: primaryFontFamily,
        fontWeight: FontWeight.w600,
        fontSize: 34,
        letterSpacing: -0.5,
        color: woodsmoke,
      ),
      displayMedium: TextStyle(
        fontFamily: primaryFontFamily,
        fontWeight: FontWeight.w600,
        fontSize: 28,
        letterSpacing: -0.5,
        color: woodsmoke,
      ),
      displaySmall: TextStyle(
        fontFamily: primaryFontFamily,
        fontWeight: FontWeight.w500,
        fontSize: 22,
        color: woodsmoke,
      ),
      headlineMedium: TextStyle(
        fontFamily: primaryFontFamily,
        fontWeight: FontWeight.w500,
        fontSize: 18,
        letterSpacing: 0.15,
        color: woodsmoke,
      ),
      bodyLarge: TextStyle(
        fontFamily: secondaryFontFamily,
        fontWeight: FontWeight.w400,
        fontSize: 16,
        color: woodsmoke.withOpacity(0.8),
      ),
      bodyMedium: TextStyle(
        fontFamily: secondaryFontFamily,
        fontWeight: FontWeight.w400,
        fontSize: 14,
        color: woodsmoke.withOpacity(0.8),
      ),
      labelLarge: TextStyle(
        fontFamily: primaryFontFamily,
        fontWeight: FontWeight.w500,
        fontSize: 14,
        letterSpacing: 0.1,
        color: woodsmoke,
      ),
    ),
    cardTheme: CardTheme(
      color: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.resolveWith<Color>(
          (states) {
            if (states.contains(MaterialState.pressed)) {
              return veniceBlue;
            }
            return robinsEggBlue;
          },
        ),
        foregroundColor: MaterialStateProperty.all(Colors.white),
        elevation: MaterialStateProperty.resolveWith<double>(
          (states) {
            if (states.contains(MaterialState.pressed)) return 0;
            return 2;
          },
        ),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        padding: MaterialStateProperty.all(
          const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        ),
        shadowColor: MaterialStateProperty.all(robinsEggBlue.withOpacity(0.5)),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: robinsEggBlue,
        side: const BorderSide(color: robinsEggBlue, width: 1.5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      ),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.white,
      elevation: 0,
      centerTitle: false,
      iconTheme: const IconThemeData(color: robinsEggBlue),
      titleTextStyle: TextStyle(
        fontFamily: primaryFontFamily,
        fontSize: 20,
        fontWeight: FontWeight.w500,
        color: woodsmoke,
      ),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
      selectedItemColor: robinsEggBlue,
      unselectedItemColor: silver,
      type: BottomNavigationBarType.fixed,
      elevation: 8,
    ),
    iconTheme: const IconThemeData(color: robinsEggBlue),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.grey[100],
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: robinsEggBlue, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    ),
  );

  // Dark theme
  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: ColorScheme(
      brightness: Brightness.dark,
      primary: robinsEggBlue,
      onPrimary: woodsmoke,
      secondary: veniceBlue,
      onSecondary: Colors.white,
      error: errorColor,
      onError: Colors.white,
      background: woodsmoke,
      onBackground: silver,
      surface: darkAccent,
      onSurface: silver,
    ),
    scaffoldBackgroundColor: woodsmoke,
    textTheme: TextTheme(
      displayLarge: TextStyle(
        fontFamily: primaryFontFamily,
        fontWeight: FontWeight.w600,
        fontSize: 34,
        letterSpacing: -0.5,
        color: Colors.white,
      ),
      displayMedium: TextStyle(
        fontFamily: primaryFontFamily,
        fontWeight: FontWeight.w600,
        fontSize: 28,
        letterSpacing: -0.5,
        color: Colors.white,
      ),
      displaySmall: TextStyle(
        fontFamily: primaryFontFamily,
        fontWeight: FontWeight.w500,
        fontSize: 22,
        color: Colors.white,
      ),
      headlineMedium: TextStyle(
        fontFamily: primaryFontFamily,
        fontWeight: FontWeight.w500,
        fontSize: 18,
        letterSpacing: 0.15,
        color: Colors.white,
      ),
      bodyLarge: TextStyle(
        fontFamily: secondaryFontFamily,
        fontWeight: FontWeight.w400,
        fontSize: 16,
        color: silver,
      ),
      bodyMedium: TextStyle(
        fontFamily: secondaryFontFamily,
        fontWeight: FontWeight.w400,
        fontSize: 14,
        color: silver,
      ),
      labelLarge: TextStyle(
        fontFamily: primaryFontFamily,
        fontWeight: FontWeight.w500,
        fontSize: 14,
        letterSpacing: 0.1,
        color: Colors.white,
      ),
    ),
    cardTheme: CardTheme(
      color: darkAccent,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.resolveWith<Color>(
          (states) {
            if (states.contains(MaterialState.pressed)) {
              return veniceBlue;
            }
            return robinsEggBlue;
          },
        ),
        foregroundColor: MaterialStateProperty.all(woodsmoke),
        elevation: MaterialStateProperty.resolveWith<double>(
          (states) {
            if (states.contains(MaterialState.pressed)) return 0;
            return 2;
          },
        ),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        padding: MaterialStateProperty.all(
          const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        ),
        shadowColor: MaterialStateProperty.all(robinsEggBlue.withOpacity(0.5)),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: robinsEggBlue,
        side: const BorderSide(color: robinsEggBlue, width: 1.5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      ),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: woodsmoke,
      elevation: 0,
      centerTitle: false,
      iconTheme: const IconThemeData(color: robinsEggBlue),
      titleTextStyle: TextStyle(
        fontFamily: primaryFontFamily,
        fontSize: 20,
        fontWeight: FontWeight.w500,
        color: Colors.white,
      ),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: darkAccent,
      selectedItemColor: robinsEggBlue,
      unselectedItemColor: silver,
      type: BottomNavigationBarType.fixed,
      elevation: 8,
    ),
    iconTheme: const IconThemeData(color: robinsEggBlue),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: darkAccent,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: robinsEggBlue, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    ),
  );
}
