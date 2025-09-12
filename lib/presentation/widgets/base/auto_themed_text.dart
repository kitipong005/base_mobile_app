import 'package:flutter/material.dart' as flutter;
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import '../../../core/design_system/typography.dart';

/// Custom Text widget that automatically applies theme colors
/// This allows developers to use familiar Text() syntax while ensuring proper theming
/// 
/// Usage:
/// ```dart
/// import 'auto_themed_text.dart' as themed;
/// 
/// themed.Text('Hello World')  // Auto themed with bodyMedium
/// themed.Text('Title', style: AppTypography.h4)  // Auto themed h4
/// ```
class Text extends StatelessWidget {
  final String data;
  final TextStyle? style;
  final StrutStyle? strutStyle;
  final TextAlign? textAlign;
  final TextDirection? textDirection;
  final Locale? locale;
  final bool? softWrap;
  final TextOverflow? overflow;
  final double? textScaleFactor;
  final TextScaler? textScaler;
  final int? maxLines;
  final String? semanticsLabel;
  final TextWidthBasis? textWidthBasis;
  final flutter.TextHeightBehavior? textHeightBehavior;
  final Color? selectionColor;

  const Text(
    this.data, {
    super.key,
    this.style,
    this.strutStyle,
    this.textAlign,
    this.textDirection,
    this.locale,
    this.softWrap,
    this.overflow,
    this.textScaleFactor,
    this.textScaler,
    this.maxLines,
    this.semanticsLabel,
    this.textWidthBasis,
    this.textHeightBehavior,
    this.selectionColor,
  });

  @override
  Widget build(BuildContext context) {
    // If no style provided, use default bodyMedium with theme color
    // If style is provided (like AppTypography.h4), automatically apply theme color
    final themedStyle = style != null 
        ? style!.themed(context)  // Apply theme color to the provided style
        : Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Theme.of(context).colorScheme.onSurface,
          );

    return flutter.Text(
      data,
      key: key,
      style: themedStyle,
      strutStyle: strutStyle,
      textAlign: textAlign,
      textDirection: textDirection,
      locale: locale,
      softWrap: softWrap,
      overflow: overflow,
      textScaler: textScaler ?? (textScaleFactor != null ? TextScaler.linear(textScaleFactor!) : TextScaler.noScaling),
      maxLines: maxLines,
      semanticsLabel: semanticsLabel,
      textWidthBasis: textWidthBasis,
      textHeightBehavior: textHeightBehavior,
      selectionColor: selectionColor,
    );
  }
}

/// Rich Text widget that automatically applies theme colors
class RichText extends StatelessWidget {
  final InlineSpan text;
  final TextAlign textAlign;
  final TextDirection? textDirection;
  final bool softWrap;
  final TextOverflow overflow;
  final double? textScaleFactor;
  final TextScaler? textScaler;
  final int? maxLines;
  final Locale? locale;
  final StrutStyle? strutStyle;
  final TextWidthBasis textWidthBasis;
  final flutter.TextHeightBehavior? textHeightBehavior;
  final Color? selectionColor;

  const RichText({
    super.key,
    required this.text,
    this.textAlign = TextAlign.start,
    this.textDirection,
    this.softWrap = true,
    this.overflow = TextOverflow.clip,
    this.textScaleFactor,
    this.textScaler,
    this.maxLines,
    this.locale,
    this.strutStyle,
    this.textWidthBasis = TextWidthBasis.parent,
    this.textHeightBehavior,
    this.selectionColor,
  });

  @override
  Widget build(BuildContext context) {
    return flutter.RichText(
      key: key,
      text: text,
      textAlign: textAlign,
      textDirection: textDirection,
      softWrap: softWrap,
      overflow: overflow,
      textScaler: textScaler ?? (textScaleFactor != null ? TextScaler.linear(textScaleFactor!) : TextScaler.noScaling),
      maxLines: maxLines,
      locale: locale,
      strutStyle: strutStyle,
      textWidthBasis: textWidthBasis,
      textHeightBehavior: textHeightBehavior,
      selectionColor: selectionColor,
    );
  }
}

/// Helper class for creating commonly used text styles
class TextStyles {
  const TextStyles._();

  /// Create a TextSpan with automatic theme color
  static TextSpan span(
    String text,
    BuildContext context, {
    TextStyle? style,
    List<InlineSpan>? children,
    GestureRecognizer? recognizer,
    String? semanticsLabel,
  }) {
    final themedStyle = style?.themed(context) ?? 
                       Theme.of(context).textTheme.bodyMedium?.copyWith(
                         color: Theme.of(context).colorScheme.onSurface,
                       );
    
    return TextSpan(
      text: text,
      style: themedStyle,
      children: children,
      recognizer: recognizer,
      semanticsLabel: semanticsLabel,
    );
  }

  /// Create a TextSpan with primary color
  static TextSpan primarySpan(
    String text,
    BuildContext context, {
    TextStyle? baseStyle,
    List<InlineSpan>? children,
    GestureRecognizer? recognizer,
    String? semanticsLabel,
  }) {
    final themedStyle = (baseStyle ?? AppTypography.bodyMedium).primary(context);
    
    return TextSpan(
      text: text,
      style: themedStyle,
      children: children,
      recognizer: recognizer,
      semanticsLabel: semanticsLabel,
    );
  }

  /// Create a TextSpan with alpha color for subtle text
  static TextSpan subtleSpan(
    String text,
    BuildContext context, {
    TextStyle? baseStyle,
    double lightAlpha = 0.6,
    double darkAlpha = 0.8,
    List<InlineSpan>? children,
    GestureRecognizer? recognizer,
    String? semanticsLabel,
  }) {
    final themedStyle = (baseStyle ?? AppTypography.bodySmall)
        .alphaOnSurface(context, light: lightAlpha, dark: darkAlpha);
    
    return TextSpan(
      text: text,
      style: themedStyle,
      children: children,
      recognizer: recognizer,
      semanticsLabel: semanticsLabel,
    );
  }
}