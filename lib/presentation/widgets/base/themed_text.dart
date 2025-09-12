import 'package:flutter/material.dart';
import '../../../core/design_system/typography.dart';

/// Themed text widgets that automatically apply correct colors for light/dark mode
/// Use these for common text styles to ensure consistency
class ThemedText extends StatelessWidget {
  const ThemedText._();

  // Display Styles
  static Widget displayLarge(
    String text, {
    TextAlign? textAlign,
    int? maxLines,
    TextOverflow? overflow,
  }) =>
      Builder(
        builder: (context) => Text(
          text,
          style: AppTypography.displayLarge.themed(context),
          textAlign: textAlign,
          maxLines: maxLines,
          overflow: overflow,
        ),
      );

  static Widget displayMedium(
    String text, {
    TextAlign? textAlign,
    int? maxLines,
    TextOverflow? overflow,
  }) =>
      Builder(
        builder: (context) => Text(
          text,
          style: AppTypography.displayMedium.themed(context),
          textAlign: textAlign,
          maxLines: maxLines,
          overflow: overflow,
        ),
      );

  static Widget displaySmall(
    String text, {
    TextAlign? textAlign,
    int? maxLines,
    TextOverflow? overflow,
  }) =>
      Builder(
        builder: (context) => Text(
          text,
          style: AppTypography.displaySmall.themed(context),
          textAlign: textAlign,
          maxLines: maxLines,
          overflow: overflow,
        ),
      );

  // Headline Styles (h1-h6)
  static Widget h1(
    String text, {
    TextAlign? textAlign,
    int? maxLines,
    TextOverflow? overflow,
  }) =>
      Builder(
        builder: (context) => Text(
          text,
          style: AppTypography.h1.themed(context),
          textAlign: textAlign,
          maxLines: maxLines,
          overflow: overflow,
        ),
      );

  static Widget h2(
    String text, {
    TextAlign? textAlign,
    int? maxLines,
    TextOverflow? overflow,
  }) =>
      Builder(
        builder: (context) => Text(
          text,
          style: AppTypography.h2.themed(context),
          textAlign: textAlign,
          maxLines: maxLines,
          overflow: overflow,
        ),
      );

  static Widget h3(
    String text, {
    TextAlign? textAlign,
    int? maxLines,
    TextOverflow? overflow,
  }) =>
      Builder(
        builder: (context) => Text(
          text,
          style: AppTypography.h3.themed(context),
          textAlign: textAlign,
          maxLines: maxLines,
          overflow: overflow,
        ),
      );

  static Widget h4(
    String text, {
    TextAlign? textAlign,
    int? maxLines,
    TextOverflow? overflow,
  }) =>
      Builder(
        builder: (context) => Text(
          text,
          style: AppTypography.h4.themed(context),
          textAlign: textAlign,
          maxLines: maxLines,
          overflow: overflow,
        ),
      );

  static Widget h5(
    String text, {
    TextAlign? textAlign,
    int? maxLines,
    TextOverflow? overflow,
  }) =>
      Builder(
        builder: (context) => Text(
          text,
          style: AppTypography.h5.themed(context),
          textAlign: textAlign,
          maxLines: maxLines,
          overflow: overflow,
        ),
      );

  static Widget h6(
    String text, {
    TextAlign? textAlign,
    int? maxLines,
    TextOverflow? overflow,
  }) =>
      Builder(
        builder: (context) => Text(
          text,
          style: AppTypography.h6.themed(context),
          textAlign: textAlign,
          maxLines: maxLines,
          overflow: overflow,
        ),
      );

  // Body Styles
  static Widget bodyLarge(
    String text, {
    TextAlign? textAlign,
    int? maxLines,
    TextOverflow? overflow,
    double? lightAlpha,
    double? darkAlpha,
  }) =>
      Builder(
        builder: (context) => Text(
          text,
          style: lightAlpha != null && darkAlpha != null
              ? AppTypography.bodyLarge.alphaOnSurface(context, light: lightAlpha, dark: darkAlpha)
              : AppTypography.bodyLarge.themed(context),
          textAlign: textAlign,
          maxLines: maxLines,
          overflow: overflow,
        ),
      );

  static Widget bodyMedium(
    String text, {
    TextAlign? textAlign,
    int? maxLines,
    TextOverflow? overflow,
    double? lightAlpha,
    double? darkAlpha,
  }) =>
      Builder(
        builder: (context) => Text(
          text,
          style: lightAlpha != null && darkAlpha != null
              ? AppTypography.bodyMedium.alphaOnSurface(context, light: lightAlpha, dark: darkAlpha)
              : AppTypography.bodyMedium.themed(context),
          textAlign: textAlign,
          maxLines: maxLines,
          overflow: overflow,
        ),
      );

  static Widget bodySmall(
    String text, {
    TextAlign? textAlign,
    int? maxLines,
    TextOverflow? overflow,
    double? lightAlpha,
    double? darkAlpha,
  }) =>
      Builder(
        builder: (context) => Text(
          text,
          style: lightAlpha != null && darkAlpha != null
              ? AppTypography.bodySmall.alphaOnSurface(context, light: lightAlpha, dark: darkAlpha)
              : AppTypography.bodySmall.themed(context),
          textAlign: textAlign,
          maxLines: maxLines,
          overflow: overflow,
        ),
      );

  // Label Styles
  static Widget labelLarge(
    String text, {
    TextAlign? textAlign,
    int? maxLines,
    TextOverflow? overflow,
    double? lightAlpha,
    double? darkAlpha,
  }) =>
      Builder(
        builder: (context) => Text(
          text,
          style: lightAlpha != null && darkAlpha != null
              ? AppTypography.labelLarge.alphaOnSurface(context, light: lightAlpha, dark: darkAlpha)
              : AppTypography.labelLarge.themed(context),
          textAlign: textAlign,
          maxLines: maxLines,
          overflow: overflow,
        ),
      );

  static Widget labelMedium(
    String text, {
    TextAlign? textAlign,
    int? maxLines,
    TextOverflow? overflow,
    double? lightAlpha,
    double? darkAlpha,
  }) =>
      Builder(
        builder: (context) => Text(
          text,
          style: lightAlpha != null && darkAlpha != null
              ? AppTypography.labelMedium.alphaOnSurface(context, light: lightAlpha, dark: darkAlpha)
              : AppTypography.labelMedium.themed(context),
          textAlign: textAlign,
          maxLines: maxLines,
          overflow: overflow,
        ),
      );

  static Widget labelSmall(
    String text, {
    TextAlign? textAlign,
    int? maxLines,
    TextOverflow? overflow,
    double? lightAlpha,
    double? darkAlpha,
  }) =>
      Builder(
        builder: (context) => Text(
          text,
          style: lightAlpha != null && darkAlpha != null
              ? AppTypography.labelSmall.alphaOnSurface(context, light: lightAlpha, dark: darkAlpha)
              : AppTypography.labelSmall.themed(context),
          textAlign: textAlign,
          maxLines: maxLines,
          overflow: overflow,
        ),
      );

  // Special colored text
  static Widget primary(
    String text, {
    TextStyle? baseStyle,
    TextAlign? textAlign,
    int? maxLines,
    TextOverflow? overflow,
  }) =>
      Builder(
        builder: (context) => Text(
          text,
          style: (baseStyle ?? AppTypography.bodyMedium).primary(context),
          textAlign: textAlign,
          maxLines: maxLines,
          overflow: overflow,
        ),
      );

  static Widget secondary(
    String text, {
    TextStyle? baseStyle,
    TextAlign? textAlign,
    int? maxLines,
    TextOverflow? overflow,
  }) =>
      Builder(
        builder: (context) => Text(
          text,
          style: (baseStyle ?? AppTypography.bodyMedium).secondary(context),
          textAlign: textAlign,
          maxLines: maxLines,
          overflow: overflow,
        ),
      );

  // Caption style (commonly used for subtle text)
  static Widget caption(
    String text, {
    TextAlign? textAlign,
    int? maxLines,
    TextOverflow? overflow,
    double lightAlpha = 0.6,
    double darkAlpha = 0.8,
  }) =>
      Builder(
        builder: (context) => Text(
          text,
          style: AppTypography.caption.alphaOnSurface(context, light: lightAlpha, dark: darkAlpha),
          textAlign: textAlign,
          maxLines: maxLines,
          overflow: overflow,
        ),
      );

  @override
  Widget build(BuildContext context) {
    throw UnimplementedError('ThemedText should not be instantiated. Use static methods instead.');
  }
}