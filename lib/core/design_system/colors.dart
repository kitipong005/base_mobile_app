import 'package:flutter/material.dart';

class AppColors {
  // Private constructor
  AppColors._();

  // Primary Colors
  static const Color primary = Color(0xFF2196F3);
  static const Color primaryDark = Color(0xFF1976D2);
  static const Color primaryLight = Color(0xFF64B5F6);

  // Secondary Colors
  static const Color secondary = Color(0xFF9C27B0);
  static const Color secondaryDark = Color(0xFF7B1FA2);
  static const Color secondaryLight = Color(0xFFBA68C8);

  // Neutral Colors
  static const Color neutral900 = Color(0xFF212121);
  static const Color neutral800 = Color(0xFF424242);
  static const Color neutral700 = Color(0xFF616161);
  static const Color neutral600 = Color(0xFF757575);
  static const Color neutral500 = Color(0xFF9E9E9E);
  static const Color neutral400 = Color(0xFFBDBDBD);
  static const Color neutral300 = Color(0xFFE0E0E0);
  static const Color neutral200 = Color(0xFFEEEEEE);
  static const Color neutral100 = Color(0xFFF5F5F5);
  static const Color neutral50 = Color(0xFFFAFAFA);

  // Semantic Colors
  static const Color success = Color(0xFF4CAF50);
  static const Color successDark = Color(0xFF388E3C);
  static const Color successLight = Color(0xFF81C784);

  static const Color warning = Color(0xFFFF9800);
  static const Color warningDark = Color(0xFFF57C00);
  static const Color warningLight = Color(0xFFFFB74D);

  static const Color error = Color(0xFFF44336);
  static const Color errorDark = Color(0xFFD32F2F);
  static const Color errorLight = Color(0xFFEF5350);

  static const Color info = Color(0xFF2196F3);
  static const Color infoDark = Color(0xFF1976D2);
  static const Color infoLight = Color(0xFF64B5F6);

  // Background Colors
  static const Color background = Color(0xFFFFFFFF);
  static const Color backgroundDark = Color(0xFF121212);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceDark = Color(0xFF1E1E1E);

  // Text Colors
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color onSecondary = Color(0xFFFFFFFF);
  static const Color onBackground = Color(0xFF212121);
  static const Color onSurface = Color(0xFF212121);
  static const Color onError = Color(0xFFFFFFFF);

  // Border Colors
  static const Color border = Color(0xFFE0E0E0);
  static const Color borderFocus = Color(0xFF2196F3);
  static const Color borderError = Color(0xFFF44336);

  // Shadow Colors
  static const Color shadow = Color(0x1A000000);
  static const Color shadowLight = Color(0x0D000000);
  static const Color shadowDark = Color(0x26000000);

  // Overlay Colors
  static const Color overlay = Color(0x80000000);
  static const Color overlayLight = Color(0x40000000);

  // Gradient Colors
  static const List<Color> primaryGradient = [
    Color(0xFF2196F3),
    Color(0xFF21CBF3),
  ];

  static const List<Color> secondaryGradient = [
    Color(0xFF9C27B0),
    Color(0xFFE91E63),
  ];

  // Dark Theme Colors
  static const Color primaryDarkMode = Color(0xFF90CAF9);
  static const Color primaryDarkModeDark = Color(0xFF42A5F5);
  static const Color primaryDarkModeLight = Color(0xFFBBDEFB);

  static const Color secondaryDarkMode = Color(0xFFCE93D8);
  static const Color secondaryDarkModeDark = Color(0xFFAB47BC);
  static const Color secondaryDarkModeLight = Color(0xFFE1BEE7);

  // Dark Theme Background Colors
  static const Color backgroundDarkMode = Color(0xFF0F0F0F);
  static const Color surfaceDarkMode = Color(0xFF1A1A1A);
  static const Color surfaceVariantDarkMode = Color(0xFF2A2A2A);

  // Dark Theme Text Colors
  static const Color onPrimaryDarkMode = Color(0xFF000000);
  static const Color onSecondaryDarkMode = Color(0xFF000000);
  static const Color onBackgroundDarkMode = Color(0xFFF5F5F5);
  static const Color onSurfaceDarkMode = Color(0xFFF5F5F5);

  // Dark Theme Neutral Colors (High contrast for better readability)
  static const Color neutral900DarkMode = Color(0xFFF5F5F5);
  static const Color neutral800DarkMode = Color(0xFFE0E0E0);
  static const Color neutral700DarkMode = Color(0xFFC5C5C5);
  static const Color neutral600DarkMode = Color(0xFFA8A8A8);
  static const Color neutral500DarkMode = Color(0xFF8A8A8A);
  static const Color neutral400DarkMode = Color(0xFF6C6C6C);
  static const Color neutral300DarkMode = Color(0xFF3A3A3A);
  static const Color neutral200DarkMode = Color(0xFF2A2A2A);
  static const Color neutral100DarkMode = Color(0xFF1A1A1A);
  static const Color neutral50DarkMode = Color(0xFF0F0F0F);

  // Dark Theme Border Colors
  static const Color borderDarkMode = Color(0xFF525252);
  static const Color borderFocusDarkMode = Color(0xFF90CAF9);
  static const Color borderErrorDarkMode = Color(0xFFEF5350);

  // Dark Theme Shadow Colors
  static const Color shadowDarkMode = Color(0x4D000000);
  static const Color shadowLightDarkMode = Color(0x26000000);
  static const Color shadowDarkDarkMode = Color(0x66000000);

  // Dark Theme Overlay Colors
  static const Color overlayDarkMode = Color(0x80000000);
  static const Color overlayLightDarkMode = Color(0x40000000);

  // Helper methods
  static Color withOpacity(Color color, double opacity) {
    return color.withValues(alpha: opacity);
  }

  static Color lighten(Color color, [double amount = 0.1]) {
    final hsl = HSLColor.fromColor(color);
    return hsl.withLightness((hsl.lightness + amount).clamp(0.0, 1.0)).toColor();
  }

  static Color darken(Color color, [double amount = 0.1]) {
    final hsl = HSLColor.fromColor(color);
    return hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0)).toColor();
  }
}