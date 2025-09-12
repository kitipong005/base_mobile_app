import 'package:flutter/material.dart';
import 'colors.dart';

class AppTypography {
  // Private constructor
  AppTypography._();

  // Font Family
  static const String fontFamily = 'Roboto';

  // Font Weights
  static const FontWeight light = FontWeight.w300;
  static const FontWeight regular = FontWeight.w400;
  static const FontWeight medium = FontWeight.w500;
  static const FontWeight semiBold = FontWeight.w600;
  static const FontWeight bold = FontWeight.w700;

  // Text Styles - Headings
  static const TextStyle h1 = TextStyle(
    fontSize: 32,
    fontWeight: bold,
    fontFamily: fontFamily,
    color: AppColors.onBackground,
    height: 1.25,
    letterSpacing: -0.5,
  );

  static const TextStyle h2 = TextStyle(
    fontSize: 28,
    fontWeight: bold,
    fontFamily: fontFamily,
    color: AppColors.onBackground,
    height: 1.29,
    letterSpacing: -0.5,
  );

  static const TextStyle h3 = TextStyle(
    fontSize: 24,
    fontWeight: semiBold,
    fontFamily: fontFamily,
    color: AppColors.onBackground,
    height: 1.33,
    letterSpacing: -0.5,
  );

  static const TextStyle h4 = TextStyle(
    fontSize: 20,
    fontWeight: semiBold,
    fontFamily: fontFamily,
    color: AppColors.onBackground,
    height: 1.4,
    letterSpacing: -0.25,
  );

  static const TextStyle h5 = TextStyle(
    fontSize: 18,
    fontWeight: medium,
    fontFamily: fontFamily,
    color: AppColors.onBackground,
    height: 1.44,
    letterSpacing: -0.25,
  );

  static const TextStyle h6 = TextStyle(
    fontSize: 16,
    fontWeight: medium,
    fontFamily: fontFamily,
    color: AppColors.onBackground,
    height: 1.5,
    letterSpacing: 0,
  );

  // Text Styles - Body
  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16,
    fontWeight: regular,
    fontFamily: fontFamily,
    color: AppColors.onBackground,
    height: 1.5,
    letterSpacing: 0.15,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    fontWeight: regular,
    fontFamily: fontFamily,
    color: AppColors.onBackground,
    height: 1.43,
    letterSpacing: 0.25,
  );

  static const TextStyle bodySmall = TextStyle(
    fontSize: 12,
    fontWeight: regular,
    fontFamily: fontFamily,
    color: AppColors.neutral600,
    height: 1.33,
    letterSpacing: 0.4,
  );

  // Text Styles - Labels
  static const TextStyle labelLarge = TextStyle(
    fontSize: 14,
    fontWeight: medium,
    fontFamily: fontFamily,
    color: AppColors.onBackground,
    height: 1.43,
    letterSpacing: 0.1,
  );

  static const TextStyle labelMedium = TextStyle(
    fontSize: 12,
    fontWeight: medium,
    fontFamily: fontFamily,
    color: AppColors.onBackground,
    height: 1.33,
    letterSpacing: 0.5,
  );

  static const TextStyle labelSmall = TextStyle(
    fontSize: 11,
    fontWeight: medium,
    fontFamily: fontFamily,
    color: AppColors.neutral600,
    height: 1.45,
    letterSpacing: 0.5,
  );

  // Text Styles - Display
  static const TextStyle displayLarge = TextStyle(
    fontSize: 57,
    fontWeight: regular,
    fontFamily: fontFamily,
    color: AppColors.onBackground,
    height: 1.12,
    letterSpacing: -0.25,
  );

  static const TextStyle displayMedium = TextStyle(
    fontSize: 45,
    fontWeight: regular,
    fontFamily: fontFamily,
    color: AppColors.onBackground,
    height: 1.16,
    letterSpacing: 0,
  );

  static const TextStyle displaySmall = TextStyle(
    fontSize: 36,
    fontWeight: regular,
    fontFamily: fontFamily,
    color: AppColors.onBackground,
    height: 1.22,
    letterSpacing: 0,
  );

  // Text Styles - Button
  static const TextStyle buttonLarge = TextStyle(
    fontSize: 16,
    fontWeight: medium,
    fontFamily: fontFamily,
    color: AppColors.onPrimary,
    height: 1.25,
    letterSpacing: 0.1,
  );

  static const TextStyle buttonMedium = TextStyle(
    fontSize: 14,
    fontWeight: medium,
    fontFamily: fontFamily,
    color: AppColors.onPrimary,
    height: 1.43,
    letterSpacing: 0.1,
  );

  static const TextStyle buttonSmall = TextStyle(
    fontSize: 12,
    fontWeight: medium,
    fontFamily: fontFamily,
    color: AppColors.onPrimary,
    height: 1.33,
    letterSpacing: 0.1,
  );

  // Text Styles - Caption
  static const TextStyle caption = TextStyle(
    fontSize: 12,
    fontWeight: regular,
    fontFamily: fontFamily,
    color: AppColors.neutral500,
    height: 1.33,
    letterSpacing: 0.4,
  );

  static const TextStyle overline = TextStyle(
    fontSize: 10,
    fontWeight: regular,
    fontFamily: fontFamily,
    color: AppColors.neutral500,
    height: 1.6,
    letterSpacing: 1.5,
  );

  // Helper methods
  static TextStyle withColor(TextStyle style, Color color) {
    return style.copyWith(color: color);
  }

  static TextStyle withWeight(TextStyle style, FontWeight weight) {
    return style.copyWith(fontWeight: weight);
  }

  static TextStyle withSize(TextStyle style, double size) {
    return style.copyWith(fontSize: size);
  }

  // Theme Text Styles
  static TextTheme get textTheme => const TextTheme(
    displayLarge: displayLarge,
    displayMedium: displayMedium,
    displaySmall: displaySmall,
    headlineLarge: h1,
    headlineMedium: h2,
    headlineSmall: h3,
    titleLarge: h4,
    titleMedium: h5,
    titleSmall: h6,
    bodyLarge: bodyLarge,
    bodyMedium: bodyMedium,
    bodySmall: bodySmall,
    labelLarge: labelLarge,
    labelMedium: labelMedium,
    labelSmall: labelSmall,
  );
}

/// Extension to easily apply theme colors to text styles
extension AppTypographyTheme on TextStyle {
  /// Apply the theme's onSurface color to this text style
  TextStyle themed(BuildContext context) => copyWith(
    color: Theme.of(context).colorScheme.onSurface,
  );
  
  /// Apply the theme's primary color to this text style
  TextStyle primary(BuildContext context) => copyWith(
    color: Theme.of(context).colorScheme.primary,
  );
  
  /// Apply the theme's secondary color to this text style
  TextStyle secondary(BuildContext context) => copyWith(
    color: Theme.of(context).colorScheme.secondary,
  );
  
  /// Apply a custom color with alpha for light/dark mode
  TextStyle alphaOnSurface(BuildContext context, {double light = 0.6, double dark = 0.8}) => copyWith(
    color: Theme.of(context).brightness == Brightness.dark
        ? Theme.of(context).colorScheme.onSurface.withValues(alpha: dark)
        : Theme.of(context).colorScheme.onSurface.withValues(alpha: light),
  );
}