/// Constants for accessing app assets
class AppAssets {
  // Base asset paths
  static const String _images = 'assets/images/';
  static const String _icons = 'assets/icons/';
  static const String _audio = 'assets/audio/';
  static const String _data = 'assets/data/';

  // App branding
  static const String appLogo = '${_images}logo.png';
  static const String appLogoWhite = '${_images}logo_white.png';
  static const String splashBackground = '${_images}splash_background.png';
  static const String appIcon = '${_icons}app_icon.png';  
  
  // Feature icons
  static const String dictionaryIcon = '${_icons}dictionary.png';
  static const String flashcardIcon = '${_icons}flashcard.png';
  static const String readerIcon = '${_icons}reader.png';
  static const String settingsIcon = '${_icons}settings.png';

  // Audio files
  static const String notificationSound = '${_audio}notification.mp3';
  static const String successSound = '${_audio}success.mp3';

  // Data files
  static const String languageData = '${_data}languages.json';
  static const String wordsDatabase = '${_data}words_database.json';
}
