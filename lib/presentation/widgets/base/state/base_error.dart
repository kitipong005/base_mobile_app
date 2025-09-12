import 'package:flutter/material.dart';
import '../../../../core/design_system/colors.dart';
import '../../../../core/design_system/typography.dart';
import '../../../../core/design_system/spacing.dart';

enum BaseErrorSize { small, medium, large }
enum BaseErrorType { network, server, validation, unknown, custom }

class BaseError extends StatelessWidget {
  const BaseError({
    super.key,
    this.error,
    this.type = BaseErrorType.unknown,
    this.size = BaseErrorSize.medium,
    this.icon,
    this.iconSize,
    this.iconColor,
    this.title,
    this.subtitle,
    this.titleStyle,
    this.subtitleStyle,
    this.action,
    this.actionLabel,
    this.onActionPressed,
    this.spacing = AppSpacing.lg,
    this.mainAxisAlignment = MainAxisAlignment.center,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.padding,
    this.showDetails = false,
    this.onShowDetails,
  });

  final Object? error;
  final BaseErrorType type;
  final BaseErrorSize size;
  final Widget? icon;
  final double? iconSize;
  final Color? iconColor;
  final String? title;
  final String? subtitle;
  final TextStyle? titleStyle;
  final TextStyle? subtitleStyle;
  final Widget? action;
  final String? actionLabel;
  final VoidCallback? onActionPressed;
  final double spacing;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;
  final EdgeInsetsGeometry? padding;
  final bool showDetails;
  final VoidCallback? onShowDetails;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? _getPadding(),
      child: LayoutBuilder(
        builder: (context, constraints) {
          // If height is constrained and small, use a more compact layout
          final isConstrained = constraints.maxHeight < 300 && constraints.maxHeight != double.infinity;
          final effectiveSpacing = isConstrained ? spacing / 2 : spacing;
          
          return SingleChildScrollView(
            child: Column(
              mainAxisAlignment: mainAxisAlignment,
              crossAxisAlignment: crossAxisAlignment,
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildIcon(isConstrained),
                SizedBox(height: effectiveSpacing),
                _buildTitle(),
                if (_getSubtitle() != null) ...[
                  SizedBox(height: effectiveSpacing / 2),
                  _buildSubtitle(),
                ],
                if (action != null || (actionLabel != null && onActionPressed != null)) ...[
                  SizedBox(height: effectiveSpacing),
                  _buildAction(),
                ],
                if (showDetails && error != null) ...[
                  SizedBox(height: effectiveSpacing / 2),
                  _buildDetailsButton(),
                ],
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildIcon([bool isConstrained = false]) {
    final defaultIcon = _getDefaultIcon(isConstrained);
    final effectiveIcon = icon ?? defaultIcon;

    final containerSize = isConstrained ? _getIconContainerSize() * 0.7 : _getIconContainerSize();

    return Container(
      width: containerSize,
      height: containerSize,
      decoration: BoxDecoration(
        color: _getIconBackgroundColor(),
        shape: BoxShape.circle,
      ),
      child: effectiveIcon,
    );
  }

  Widget _buildTitle() {
    final effectiveTitle = title ?? _getDefaultTitle();
    
    return Text(
      effectiveTitle,
      style: titleStyle ?? _getTitleStyle(),
      textAlign: TextAlign.center,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildSubtitle() {
    final effectiveSubtitle = _getSubtitle();
    if (effectiveSubtitle == null) return const SizedBox.shrink();

    return Text(
      effectiveSubtitle,
      style: subtitleStyle ?? _getSubtitleStyle(),
      textAlign: TextAlign.center,
      maxLines: 3,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildAction() {
    if (action != null) return action!;

    if (actionLabel != null && onActionPressed != null) {
      return ElevatedButton(
        onPressed: onActionPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.onPrimary,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.xl,
            vertical: AppSpacing.md,
          ),
        ),
        child: Text(
          actionLabel!,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      );
    }

    return const SizedBox.shrink();
  }

  Widget _buildDetailsButton() {
    return TextButton(
      onPressed: onShowDetails ?? _showErrorDetails,
      style: TextButton.styleFrom(
        foregroundColor: AppColors.neutral600,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.info_outline, size: 16),
          SizedBox(width: AppSpacing.xs),
          Flexible(
            child: Text(
              'Show Details',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  void _showErrorDetails() {
    if (error == null) return;
    
    // This would typically show a dialog with error details
    // For now, we'll just print the error
    debugPrint('Error Details: $error');
  }

  Widget _getDefaultIcon([bool isConstrained = false]) {
    IconData iconData;
    Color color = iconColor ?? _getDefaultIconColor();

    switch (type) {
      case BaseErrorType.network:
        iconData = Icons.wifi_off_outlined;
        break;
      case BaseErrorType.server:
        iconData = Icons.error_outline;
        break;
      case BaseErrorType.validation:
        iconData = Icons.warning_outlined;
        break;
      case BaseErrorType.unknown:
        iconData = Icons.help_outline;
        break;
      case BaseErrorType.custom:
        iconData = Icons.error_outline;
        break;
    }

    final effectiveIconSize = isConstrained ? (iconSize ?? _getIconSize()) * 0.7 : (iconSize ?? _getIconSize());

    return Icon(
      iconData,
      size: effectiveIconSize,
      color: color,
    );
  }

  String _getDefaultTitle() {
    switch (type) {
      case BaseErrorType.network:
        return 'Network Error';
      case BaseErrorType.server:
        return 'Server Error';
      case BaseErrorType.validation:
        return 'Validation Error';
      case BaseErrorType.unknown:
        return 'Something Went Wrong';
      case BaseErrorType.custom:
        return 'Error';
    }
  }

  String? _getSubtitle() {
    if (subtitle != null) return subtitle;

    switch (type) {
      case BaseErrorType.network:
        return 'Please check your internet connection and try again.';
      case BaseErrorType.server:
        return 'We\'re experiencing technical difficulties. Please try again later.';
      case BaseErrorType.validation:
        return 'Please check your input and try again.';
      case BaseErrorType.unknown:
        return 'An unexpected error occurred. Please try again.';
      case BaseErrorType.custom:
        return error?.toString();
    }
  }

  Color _getDefaultIconColor() {
    switch (type) {
      case BaseErrorType.network:
        return AppColors.warning;
      case BaseErrorType.server:
        return AppColors.error;
      case BaseErrorType.validation:
        return AppColors.warning;
      case BaseErrorType.unknown:
        return AppColors.error;
      case BaseErrorType.custom:
        return AppColors.error;
    }
  }

  Color _getIconBackgroundColor() {
    switch (type) {
      case BaseErrorType.network:
        return AppColors.warningLight.withValues(alpha: 0.1);
      case BaseErrorType.server:
        return AppColors.errorLight.withValues(alpha: 0.1);
      case BaseErrorType.validation:
        return AppColors.warningLight.withValues(alpha: 0.1);
      case BaseErrorType.unknown:
        return AppColors.errorLight.withValues(alpha: 0.1);
      case BaseErrorType.custom:
        return AppColors.errorLight.withValues(alpha: 0.1);
    }
  }

  double _getIconSize() {
    switch (size) {
      case BaseErrorSize.small:
        return AppSpacing.iconLG;
      case BaseErrorSize.medium:
        return AppSpacing.iconXL;
      case BaseErrorSize.large:
        return AppSpacing.iconXXL;
    }
  }

  double _getIconContainerSize() {
    switch (size) {
      case BaseErrorSize.small:
        return AppSpacing.iconLG * 2;
      case BaseErrorSize.medium:
        return AppSpacing.iconXL * 2;
      case BaseErrorSize.large:
        return AppSpacing.iconXXL * 2;
    }
  }

  TextStyle _getTitleStyle() {
    switch (size) {
      case BaseErrorSize.small:
        return AppTypography.h6.copyWith(
          color: _getDefaultIconColor(),
        );
      case BaseErrorSize.medium:
        return AppTypography.h5.copyWith(
          color: _getDefaultIconColor(),
        );
      case BaseErrorSize.large:
        return AppTypography.h4.copyWith(
          color: _getDefaultIconColor(),
        );
    }
  }

  TextStyle _getSubtitleStyle() {
    switch (size) {
      case BaseErrorSize.small:
        return AppTypography.bodySmall.copyWith(
          color: AppColors.neutral600,
        );
      case BaseErrorSize.medium:
        return AppTypography.bodyMedium.copyWith(
          color: AppColors.neutral600,
        );
      case BaseErrorSize.large:
        return AppTypography.bodyLarge.copyWith(
          color: AppColors.neutral600,
        );
    }
  }

  EdgeInsetsGeometry _getPadding() {
    switch (size) {
      case BaseErrorSize.small:
        return AppSpacing.paddingMD;
      case BaseErrorSize.medium:
        return AppSpacing.paddingLG;
      case BaseErrorSize.large:
        return AppSpacing.paddingXL;
    }
  }
}

extension BaseErrorFactory on BaseError {
  static Widget network({
    Key? key,
    BaseErrorSize size = BaseErrorSize.medium,
    String? title,
    String? subtitle,
    Widget? icon,
    String? actionLabel,
    VoidCallback? onActionPressed,
    bool showDetails = false,
  }) {
    return BaseError(
      key: key,
      type: BaseErrorType.network,
      size: size,
      title: title,
      subtitle: subtitle,
      icon: icon,
      actionLabel: actionLabel ?? 'Retry',
      onActionPressed: onActionPressed,
      showDetails: showDetails,
    );
  }

  static Widget server({
    Key? key,
    BaseErrorSize size = BaseErrorSize.medium,
    String? title,
    String? subtitle,
    Widget? icon,
    String? actionLabel,
    VoidCallback? onActionPressed,
    bool showDetails = false,
    Object? error,
  }) {
    return BaseError(
      key: key,
      type: BaseErrorType.server,
      size: size,
      title: title,
      subtitle: subtitle,
      icon: icon,
      actionLabel: actionLabel ?? 'Try Again',
      onActionPressed: onActionPressed,
      showDetails: showDetails,
      error: error,
    );
  }

  static Widget validation({
    Key? key,
    BaseErrorSize size = BaseErrorSize.medium,
    String? title,
    String? subtitle,
    Widget? icon,
    String? actionLabel,
    VoidCallback? onActionPressed,
    Object? error,
  }) {
    return BaseError(
      key: key,
      type: BaseErrorType.validation,
      size: size,
      title: title,
      subtitle: subtitle,
      icon: icon,
      actionLabel: actionLabel ?? 'Fix Issues',
      onActionPressed: onActionPressed,
      error: error,
    );
  }

  static Widget unknown({
    Key? key,
    BaseErrorSize size = BaseErrorSize.medium,
    String? title,
    String? subtitle,
    Widget? icon,
    String? actionLabel,
    VoidCallback? onActionPressed,
    bool showDetails = false,
    Object? error,
  }) {
    return BaseError(
      key: key,
      type: BaseErrorType.unknown,
      size: size,
      title: title,
      subtitle: subtitle,
      icon: icon,
      actionLabel: actionLabel ?? 'Try Again',
      onActionPressed: onActionPressed,
      showDetails: showDetails,
      error: error,
    );
  }

  static Widget custom({
    Key? key,
    BaseErrorSize size = BaseErrorSize.medium,
    required String title,
    String? subtitle,
    required Widget icon,
    String? actionLabel,
    VoidCallback? onActionPressed,
    bool showDetails = false,
    Object? error,
  }) {
    return BaseError(
      key: key,
      type: BaseErrorType.custom,
      size: size,
      title: title,
      subtitle: subtitle,
      icon: icon,
      actionLabel: actionLabel,
      onActionPressed: onActionPressed,
      showDetails: showDetails,
      error: error,
    );
  }
}