class AppConstants {
  // App Info
  static const String appName = 'E-Commerce App';
  static const String appVersion = '1.0.0';
  
  // Storage Keys
  static const String themeKey = 'theme_mode';
  static const String languageKey = 'selected_language';
  static const String cartBoxKey = 'cart_box';
  static const String productsBoxKey = 'products_box';
  
  // UI Constants
  static const double defaultPadding = 16.0;
  static const double smallPadding = 8.0;
  static const double largePadding = 24.0;
  static const double cardRadius = 12.0;
  static const double buttonRadius = 8.0;
  
  // Grid Constants
  static const int mobileGridCrossAxisCount = 2;
  static const int tabletGridCrossAxisCount = 3;
  static const int desktopGridCrossAxisCount = 4;
  
  // Breakpoints
  static const double mobileBreakpoint = 600;
  static const double tabletBreakpoint = 1024;
  
  // Animation Durations
  static const Duration shortAnimationDuration = Duration(milliseconds: 200);
  static const Duration mediumAnimationDuration = Duration(milliseconds: 300);
  static const Duration longAnimationDuration = Duration(milliseconds: 500);
}
