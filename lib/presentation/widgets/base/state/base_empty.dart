import 'package:flutter/material.dart';
import '../../../../core/design_system/colors.dart';
import '../../../../core/design_system/typography.dart';
import '../../../../core/design_system/spacing.dart';

enum BaseEmptySize { small, medium, large }
enum BaseEmptyType { noData, noResults, noConnection, custom }

class BaseEmpty extends StatelessWidget {
  const BaseEmpty({
    super.key,
    this.type = BaseEmptyType.noData,
    this.size = BaseEmptySize.medium,
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
  });

  final BaseEmptyType type;
  final BaseEmptySize size;
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

  Widget _getDefaultIcon([bool isConstrained = false]) {
    IconData iconData;
    Color color = iconColor ?? _getDefaultIconColor();

    switch (type) {
      case BaseEmptyType.noData:
        iconData = Icons.inbox_outlined;
        break;
      case BaseEmptyType.noResults:
        iconData = Icons.search_off_outlined;
        break;
      case BaseEmptyType.noConnection:
        iconData = Icons.wifi_off_outlined;
        break;
      case BaseEmptyType.custom:
        iconData = Icons.help_outline;
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
      case BaseEmptyType.noData:
        return 'No Data Available';
      case BaseEmptyType.noResults:
        return 'No Results Found';
      case BaseEmptyType.noConnection:
        return 'No Connection';
      case BaseEmptyType.custom:
        return 'Empty State';
    }
  }

  String? _getSubtitle() {
    if (subtitle != null) return subtitle;

    switch (type) {
      case BaseEmptyType.noData:
        return 'There is no data to display at the moment.';
      case BaseEmptyType.noResults:
        return 'Try adjusting your search or filters to find what you\'re looking for.';
      case BaseEmptyType.noConnection:
        return 'Please check your internet connection and try again.';
      case BaseEmptyType.custom:
        return null;
    }
  }

  Color _getDefaultIconColor() {
    switch (type) {
      case BaseEmptyType.noData:
        return AppColors.neutral500;
      case BaseEmptyType.noResults:
        return AppColors.neutral500;
      case BaseEmptyType.noConnection:
        return AppColors.warning;
      case BaseEmptyType.custom:
        return AppColors.neutral500;
    }
  }

  Color _getIconBackgroundColor() {
    switch (type) {
      case BaseEmptyType.noData:
        return AppColors.neutral100;
      case BaseEmptyType.noResults:
        return AppColors.neutral100;
      case BaseEmptyType.noConnection:
        return AppColors.warningLight.withValues(alpha: 0.1);
      case BaseEmptyType.custom:
        return AppColors.neutral100;
    }
  }

  double _getIconSize() {
    switch (size) {
      case BaseEmptySize.small:
        return AppSpacing.iconLG;
      case BaseEmptySize.medium:
        return AppSpacing.iconXL;
      case BaseEmptySize.large:
        return AppSpacing.iconXXL;
    }
  }

  double _getIconContainerSize() {
    switch (size) {
      case BaseEmptySize.small:
        return AppSpacing.iconLG * 2;
      case BaseEmptySize.medium:
        return AppSpacing.iconXL * 2;
      case BaseEmptySize.large:
        return AppSpacing.iconXXL * 2;
    }
  }

  TextStyle _getTitleStyle() {
    switch (size) {
      case BaseEmptySize.small:
        return AppTypography.h6.copyWith(
          color: AppColors.onSurface,
        );
      case BaseEmptySize.medium:
        return AppTypography.h5.copyWith(
          color: AppColors.onSurface,
        );
      case BaseEmptySize.large:
        return AppTypography.h4.copyWith(
          color: AppColors.onSurface,
        );
    }
  }

  TextStyle _getSubtitleStyle() {
    switch (size) {
      case BaseEmptySize.small:
        return AppTypography.bodySmall.copyWith(
          color: AppColors.neutral600,
        );
      case BaseEmptySize.medium:
        return AppTypography.bodyMedium.copyWith(
          color: AppColors.neutral600,
        );
      case BaseEmptySize.large:
        return AppTypography.bodyLarge.copyWith(
          color: AppColors.neutral600,
        );
    }
  }

  EdgeInsetsGeometry _getPadding() {
    switch (size) {
      case BaseEmptySize.small:
        return AppSpacing.paddingMD;
      case BaseEmptySize.medium:
        return AppSpacing.paddingLG;
      case BaseEmptySize.large:
        return AppSpacing.paddingXL;
    }
  }
}

extension BaseEmptyFactory on BaseEmpty {
  static Widget noData({
    Key? key,
    BaseEmptySize size = BaseEmptySize.medium,
    String? title,
    String? subtitle,
    Widget? icon,
    String? actionLabel,
    VoidCallback? onActionPressed,
  }) {
    return BaseEmpty(
      key: key,
      type: BaseEmptyType.noData,
      size: size,
      title: title,
      subtitle: subtitle,
      icon: icon,
      actionLabel: actionLabel,
      onActionPressed: onActionPressed,
    );
  }

  static Widget noResults({
    Key? key,
    BaseEmptySize size = BaseEmptySize.medium,
    String? title,
    String? subtitle,
    Widget? icon,
    String? actionLabel,
    VoidCallback? onActionPressed,
  }) {
    return BaseEmpty(
      key: key,
      type: BaseEmptyType.noResults,
      size: size,
      title: title,
      subtitle: subtitle,
      icon: icon,
      actionLabel: actionLabel,
      onActionPressed: onActionPressed,
    );
  }

  static Widget noConnection({
    Key? key,
    BaseEmptySize size = BaseEmptySize.medium,
    String? title,
    String? subtitle,
    Widget? icon,
    String? actionLabel,
    VoidCallback? onActionPressed,
  }) {
    return BaseEmpty(
      key: key,
      type: BaseEmptyType.noConnection,
      size: size,
      title: title,
      subtitle: subtitle,
      icon: icon,
      actionLabel: actionLabel ?? 'Retry',
      onActionPressed: onActionPressed,
    );
  }

  static Widget custom({
    Key? key,
    BaseEmptySize size = BaseEmptySize.medium,
    required String title,
    String? subtitle,
    required Widget icon,
    String? actionLabel,
    VoidCallback? onActionPressed,
  }) {
    return BaseEmpty(
      key: key,
      type: BaseEmptyType.custom,
      size: size,
      title: title,
      subtitle: subtitle,
      icon: icon,
      actionLabel: actionLabel,
      onActionPressed: onActionPressed,
    );
  }
}