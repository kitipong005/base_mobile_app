import 'package:flutter/material.dart';
import '../../../../core/design_system/typography.dart';
import '../../../../core/design_system/spacing.dart';

enum BaseButtonType { primary, secondary, outline, text, danger }
enum BaseButtonSize { small, medium, large }

class BaseButton extends StatelessWidget {
  const BaseButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.type = BaseButtonType.primary,
    this.size = BaseButtonSize.medium,
    this.isLoading = false,
    this.isDisabled = false,
    this.icon,
    this.iconPosition = IconPosition.left,
    this.width,
    this.height,
    this.borderRadius,
    this.padding,
    this.elevation,
    this.textColor,
    this.backgroundColor,
    this.borderColor,
  });

  final String text;
  final VoidCallback? onPressed;
  final BaseButtonType type;
  final BaseButtonSize size;
  final bool isLoading;
  final bool isDisabled;
  final IconData? icon;
  final IconPosition iconPosition;
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;
  final EdgeInsets? padding;
  final double? elevation;
  final Color? textColor;
  final Color? backgroundColor;
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isEnabled = !isDisabled && !isLoading && onPressed != null;

    return SizedBox(
      width: width,
      height: height ?? _getButtonHeight(),
      child: _buildButton(context, theme, isEnabled),
    );
  }

  Widget _buildButton(BuildContext context, ThemeData theme, bool isEnabled) {
    switch (type) {
      case BaseButtonType.primary:
        return _buildElevatedButton(context, theme, isEnabled);
      case BaseButtonType.secondary:
        return _buildSecondaryButton(context, theme, isEnabled);
      case BaseButtonType.outline:
        return _buildOutlinedButton(context, theme, isEnabled);
      case BaseButtonType.text:
        return _buildTextButton(context, theme, isEnabled);
      case BaseButtonType.danger:
        return _buildDangerButton(context, theme, isEnabled);
    }
  }

  Widget _buildElevatedButton(BuildContext context, ThemeData theme, bool isEnabled) {
    return ElevatedButton(
      onPressed: isEnabled ? onPressed : null,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor ?? theme.colorScheme.primary,
        foregroundColor: textColor ?? theme.colorScheme.onPrimary,
        disabledBackgroundColor: theme.disabledColor,
        disabledForegroundColor: theme.colorScheme.onSurface.withValues(alpha: 0.38),
        elevation: elevation ?? 2,
        shadowColor: theme.shadowColor,
        shape: RoundedRectangleBorder(
          borderRadius: borderRadius ?? _getBorderRadius(),
        ),
        padding: padding ?? _getPadding(),
        textStyle: _getTextStyle(),
        minimumSize: Size(0, height ?? _getButtonHeight()),
      ),
      child: _buildButtonContent(context),
    );
  }

  Widget _buildSecondaryButton(BuildContext context, ThemeData theme, bool isEnabled) {
    return ElevatedButton(
      onPressed: isEnabled ? onPressed : null,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor ?? theme.colorScheme.secondary,
        foregroundColor: textColor ?? theme.colorScheme.onSecondary,
        disabledBackgroundColor: theme.colorScheme.surface,
        disabledForegroundColor: theme.colorScheme.onSurface.withValues(alpha: 0.38),
        elevation: elevation ?? 2,
        shadowColor: theme.shadowColor,
        shape: RoundedRectangleBorder(
          borderRadius: borderRadius ?? _getBorderRadius(),
        ),
        padding: padding ?? _getPadding(),
        textStyle: _getTextStyle(),
        minimumSize: Size(0, height ?? _getButtonHeight()),
      ),
      child: _buildButtonContent(context),
    );
  }

  Widget _buildOutlinedButton(BuildContext context, ThemeData theme, bool isEnabled) {
    return OutlinedButton(
      onPressed: isEnabled ? onPressed : null,
      style: OutlinedButton.styleFrom(
        foregroundColor: textColor ?? theme.colorScheme.primary,
        disabledForegroundColor: theme.colorScheme.onSurface.withValues(alpha: 0.38),
        backgroundColor: backgroundColor ?? Colors.transparent,
        side: BorderSide(
          color: borderColor ?? (isEnabled ? theme.colorScheme.primary : theme.colorScheme.outline),
          width: 1,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: borderRadius ?? _getBorderRadius(),
        ),
        padding: padding ?? _getPadding(),
        textStyle: _getTextStyle(),
        minimumSize: Size(0, height ?? _getButtonHeight()),
      ),
      child: _buildButtonContent(context),
    );
  }

  Widget _buildTextButton(BuildContext context, ThemeData theme, bool isEnabled) {
    return TextButton(
      onPressed: isEnabled ? onPressed : null,
      style: TextButton.styleFrom(
        foregroundColor: textColor ?? theme.colorScheme.primary,
        disabledForegroundColor: theme.colorScheme.onSurface.withValues(alpha: 0.38),
        backgroundColor: backgroundColor ?? Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: borderRadius ?? _getBorderRadius(),
        ),
        padding: padding ?? _getPadding(),
        textStyle: _getTextStyle(),
        minimumSize: Size(0, height ?? _getButtonHeight()),
      ),
      child: _buildButtonContent(context),
    );
  }

  Widget _buildDangerButton(BuildContext context, ThemeData theme, bool isEnabled) {
    return ElevatedButton(
      onPressed: isEnabled ? onPressed : null,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor ?? theme.colorScheme.error,
        foregroundColor: textColor ?? theme.colorScheme.onError,
        disabledBackgroundColor: theme.colorScheme.surface,
        disabledForegroundColor: theme.colorScheme.onSurface.withValues(alpha: 0.38),
        elevation: elevation ?? 2,
        shadowColor: theme.shadowColor,
        shape: RoundedRectangleBorder(
          borderRadius: borderRadius ?? _getBorderRadius(),
        ),
        padding: padding ?? _getPadding(),
        textStyle: _getTextStyle(),
        minimumSize: Size(0, height ?? _getButtonHeight()),
      ),
      child: _buildButtonContent(context),
    );
  }

  Widget _buildButtonContent(BuildContext context) {
    final theme = Theme.of(context);
    if (isLoading) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: _getIconSize(),
            height: _getIconSize(),
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(
                _getLoadingIndicatorColor(theme),
              ),
            ),
          ),
          if (text.isNotEmpty) ...[
            AppSpacing.hSpaceSM,
            Text(text),
          ],
        ],
      );
    }

    if (icon == null) {
      return Text(text);
    }

    final iconWidget = Icon(
      icon,
      size: _getIconSize(),
    );

    final textWidget = text.isEmpty ? const SizedBox.shrink() : Text(text);

    if (text.isEmpty) {
      return iconWidget;
    }

    return iconPosition == IconPosition.left
        ? Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              iconWidget,
              AppSpacing.hSpaceSM,
              textWidget,
            ],
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              textWidget,
              AppSpacing.hSpaceSM,
              iconWidget,
            ],
          );
  }

  double _getButtonHeight() {
    switch (size) {
      case BaseButtonSize.small:
        return AppSpacing.buttonHeightSM;
      case BaseButtonSize.medium:
        return AppSpacing.buttonHeightMD;
      case BaseButtonSize.large:
        return AppSpacing.buttonHeightLG;
    }
  }

  BorderRadius _getBorderRadius() {
    return AppSpacing.borderRadiusSM;
  }

  EdgeInsets _getPadding() {
    switch (size) {
      case BaseButtonSize.small:
        return AppSpacing.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.xs);
      case BaseButtonSize.medium:
        return AppSpacing.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.sm);
      case BaseButtonSize.large:
        return AppSpacing.symmetric(horizontal: AppSpacing.xl, vertical: AppSpacing.md);
    }
  }

  TextStyle _getTextStyle() {
    switch (size) {
      case BaseButtonSize.small:
        return AppTypography.buttonSmall;
      case BaseButtonSize.medium:
        return AppTypography.buttonMedium;
      case BaseButtonSize.large:
        return AppTypography.buttonLarge;
    }
  }

  double _getIconSize() {
    switch (size) {
      case BaseButtonSize.small:
        return AppSpacing.iconXS;
      case BaseButtonSize.medium:
        return AppSpacing.iconSM;
      case BaseButtonSize.large:
        return AppSpacing.iconMD;
    }
  }

  Color _getLoadingIndicatorColor(ThemeData theme) {
    switch (type) {
      case BaseButtonType.primary:
        return textColor ?? theme.colorScheme.onPrimary;
      case BaseButtonType.secondary:
        return textColor ?? theme.colorScheme.onSecondary;
      case BaseButtonType.outline:
        return textColor ?? theme.colorScheme.primary;
      case BaseButtonType.text:
        return textColor ?? theme.colorScheme.primary;
      case BaseButtonType.danger:
        return textColor ?? theme.colorScheme.onError;
    }
  }
}

enum IconPosition { left, right }

// Static factory methods for common button types
extension BaseButtonFactory on BaseButton {
  static Widget primary({
    Key? key,
    required String text,
    required VoidCallback? onPressed,
    BaseButtonSize size = BaseButtonSize.medium,
    bool isLoading = false,
    bool isDisabled = false,
    IconData? icon,
    IconPosition iconPosition = IconPosition.left,
    double? width,
  }) {
    return BaseButton(
      key: key,
      text: text,
      onPressed: onPressed,
      type: BaseButtonType.primary,
      size: size,
      isLoading: isLoading,
      isDisabled: isDisabled,
      icon: icon,
      iconPosition: iconPosition,
      width: width,
    );
  }

  static Widget secondary({
    Key? key,
    required String text,
    required VoidCallback? onPressed,
    BaseButtonSize size = BaseButtonSize.medium,
    bool isLoading = false,
    bool isDisabled = false,
    IconData? icon,
    IconPosition iconPosition = IconPosition.left,
    double? width,
  }) {
    return BaseButton(
      key: key,
      text: text,
      onPressed: onPressed,
      type: BaseButtonType.secondary,
      size: size,
      isLoading: isLoading,
      isDisabled: isDisabled,
      icon: icon,
      iconPosition: iconPosition,
      width: width,
    );
  }

  static Widget outline({
    Key? key,
    required String text,
    required VoidCallback? onPressed,
    BaseButtonSize size = BaseButtonSize.medium,
    bool isLoading = false,
    bool isDisabled = false,
    IconData? icon,
    IconPosition iconPosition = IconPosition.left,
    double? width,
  }) {
    return BaseButton(
      key: key,
      text: text,
      onPressed: onPressed,
      type: BaseButtonType.outline,
      size: size,
      isLoading: isLoading,
      isDisabled: isDisabled,
      icon: icon,
      iconPosition: iconPosition,
      width: width,
    );
  }

  static Widget text({
    Key? key,
    required String text,
    required VoidCallback? onPressed,
    BaseButtonSize size = BaseButtonSize.medium,
    bool isLoading = false,
    bool isDisabled = false,
    IconData? icon,
    IconPosition iconPosition = IconPosition.left,
    double? width,
  }) {
    return BaseButton(
      key: key,
      text: text,
      onPressed: onPressed,
      type: BaseButtonType.text,
      size: size,
      isLoading: isLoading,
      isDisabled: isDisabled,
      icon: icon,
      iconPosition: iconPosition,
      width: width,
    );
  }

  static Widget danger({
    Key? key,
    required String text,
    required VoidCallback? onPressed,
    BaseButtonSize size = BaseButtonSize.medium,
    bool isLoading = false,
    bool isDisabled = false,
    IconData? icon,
    IconPosition iconPosition = IconPosition.left,
    double? width,
  }) {
    return BaseButton(
      key: key,
      text: text,
      onPressed: onPressed,
      type: BaseButtonType.danger,
      size: size,
      isLoading: isLoading,
      isDisabled: isDisabled,
      icon: icon,
      iconPosition: iconPosition,
      width: width,
    );
  }
}