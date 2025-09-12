import 'package:flutter/material.dart';
import '../../../../core/design_system/colors.dart';
import '../../../../core/design_system/typography.dart';
import '../../../../core/design_system/spacing.dart';
import '../buttons/base_button.dart';

enum BaseDialogSize { small, medium, large }
enum BaseDialogType { info, success, warning, error, confirmation }

class BaseDialog extends StatelessWidget {
  const BaseDialog({
    super.key,
    this.title,
    this.content,
    this.contentWidget,
    this.actions,
    this.type = BaseDialogType.info,
    this.size = BaseDialogSize.medium,
    this.icon,
    this.backgroundColor,
    this.shape,
    this.elevation,
    this.shadowColor,
    this.surfaceTintColor,
    this.insetPadding,
    this.clipBehavior = Clip.none,
    this.semanticLabel,
    this.barrierDismissible = true,
    this.barrierColor,
    this.barrierLabel,
    this.useSafeArea = true,
    this.useRootNavigator = true,
    this.routeSettings,
    this.anchorPoint,
    this.traversalEdgeBehavior,
  });

  final String? title;
  final String? content;
  final Widget? contentWidget;
  final List<Widget>? actions;
  final BaseDialogType type;
  final BaseDialogSize size;
  final Widget? icon;
  final Color? backgroundColor;
  final ShapeBorder? shape;
  final double? elevation;
  final Color? shadowColor;
  final Color? surfaceTintColor;
  final EdgeInsets? insetPadding;
  final Clip clipBehavior;
  final String? semanticLabel;
  final bool barrierDismissible;
  final Color? barrierColor;
  final String? barrierLabel;
  final bool useSafeArea;
  final bool useRootNavigator;
  final RouteSettings? routeSettings;
  final Offset? anchorPoint;
  final TraversalEdgeBehavior? traversalEdgeBehavior;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: _buildTitle(),
      content: _buildContent(),
      actions: actions,
      backgroundColor: backgroundColor ?? AppColors.surface,
      shape: shape ?? _getShape(),
      elevation: elevation ?? _getElevation(),
      shadowColor: shadowColor ?? AppColors.shadow,
      surfaceTintColor: surfaceTintColor ?? Colors.transparent,
      insetPadding: insetPadding ?? _getInsetPadding(),
      clipBehavior: clipBehavior,
      semanticLabel: semanticLabel,
      actionsPadding: AppSpacing.paddingMD,
      buttonPadding: AppSpacing.paddingSM,
      titlePadding: AppSpacing.paddingMD,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.sm,
      ),
    );
  }

  Widget? _buildTitle() {
    if (title == null && icon == null) return null;

    return Row(
      children: [
        if (icon != null || _getDefaultIcon() != null) ...[
          Container(
            padding: AppSpacing.paddingSM,
            decoration: BoxDecoration(
              color: _getIconBackgroundColor(),
              shape: BoxShape.circle,
            ),
            child: icon ?? _getDefaultIcon()!,
          ),
          AppSpacing.hSpaceMD,
        ],
        if (title != null)
          Expanded(
            child: Text(
              title!,
              style: AppTypography.h5.copyWith(
                color: _getTitleColor(),
              ),
            ),
          ),
      ],
    );
  }

  Widget? _buildContent() {
    if (contentWidget != null) {
      return SizedBox(
        width: _getDialogWidth(),
        child: contentWidget,
      );
    }

    if (content != null) {
      return SizedBox(
        width: _getDialogWidth(),
        child: Text(
          content!,
          style: AppTypography.bodyMedium,
        ),
      );
    }

    return null;
  }

  Widget? _getDefaultIcon() {
    switch (type) {
      case BaseDialogType.info:
        return const Icon(
          Icons.info_outline,
          color: AppColors.info,
          size: 24,
        );
      case BaseDialogType.success:
        return const Icon(
          Icons.check_circle_outline,
          color: AppColors.success,
          size: 24,
        );
      case BaseDialogType.warning:
        return const Icon(
          Icons.warning_outlined,
          color: AppColors.warning,
          size: 24,
        );
      case BaseDialogType.error:
        return const Icon(
          Icons.error_outline,
          color: AppColors.error,
          size: 24,
        );
      case BaseDialogType.confirmation:
        return const Icon(
          Icons.help_outline,
          color: AppColors.primary,
          size: 24,
        );
    }
  }

  Color _getIconBackgroundColor() {
    switch (type) {
      case BaseDialogType.info:
        return AppColors.infoLight.withValues(alpha: 0.1);
      case BaseDialogType.success:
        return AppColors.successLight.withValues(alpha: 0.1);
      case BaseDialogType.warning:
        return AppColors.warningLight.withValues(alpha: 0.1);
      case BaseDialogType.error:
        return AppColors.errorLight.withValues(alpha: 0.1);
      case BaseDialogType.confirmation:
        return AppColors.primaryLight.withValues(alpha: 0.1);
    }
  }

  Color _getTitleColor() {
    switch (type) {
      case BaseDialogType.error:
        return AppColors.error;
      case BaseDialogType.warning:
        return AppColors.warning;
      default:
        return AppColors.onSurface;
    }
  }

  ShapeBorder _getShape() {
    return RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppSpacing.radiusLG),
    );
  }

  double _getElevation() {
    switch (size) {
      case BaseDialogSize.small:
        return 4;
      case BaseDialogSize.medium:
        return 6;
      case BaseDialogSize.large:
        return 8;
    }
  }

  EdgeInsets _getInsetPadding() {
    switch (size) {
      case BaseDialogSize.small:
        return AppSpacing.paddingXL;
      case BaseDialogSize.medium:
        return AppSpacing.paddingLG;
      case BaseDialogSize.large:
        return AppSpacing.paddingMD;
    }
  }

  double _getDialogWidth() {
    switch (size) {
      case BaseDialogSize.small:
        return 300;
      case BaseDialogSize.medium:
        return 400;
      case BaseDialogSize.large:
        return 500;
    }
  }

  static Future<T?> show<T>({
    required BuildContext context,
    String? title,
    String? content,
    Widget? contentWidget,
    List<Widget>? actions,
    BaseDialogType type = BaseDialogType.info,
    BaseDialogSize size = BaseDialogSize.medium,
    Widget? icon,
    bool barrierDismissible = true,
    bool useRootNavigator = true,
    RouteSettings? routeSettings,
  }) {
    return showDialog<T>(
      context: context,
      barrierDismissible: barrierDismissible,
      useRootNavigator: useRootNavigator,
      routeSettings: routeSettings,
      builder: (context) => BaseDialog(
        title: title,
        content: content,
        contentWidget: contentWidget,
        actions: actions,
        type: type,
        size: size,
        icon: icon,
        barrierDismissible: barrierDismissible,
        useRootNavigator: useRootNavigator,
        routeSettings: routeSettings,
      ),
    );
  }
}

extension BaseDialogFactory on BaseDialog {
  static Future<bool?> confirmation({
    required BuildContext context,
    String? title,
    String? content,
    Widget? contentWidget,
    String confirmText = 'Confirm',
    String cancelText = 'Cancel',
    BaseDialogSize size = BaseDialogSize.medium,
    Widget? icon,
    bool barrierDismissible = true,
  }) {
    return BaseDialog.show<bool>(
      context: context,
      title: title ?? 'Confirmation',
      content: content,
      contentWidget: contentWidget,
      type: BaseDialogType.confirmation,
      size: size,
      icon: icon,
      barrierDismissible: barrierDismissible,
      actions: [
        BaseButtonFactory.text(
          text: cancelText,
          onPressed: () => Navigator.of(context).pop(false),
          size: BaseButtonSize.medium,
        ),
        BaseButtonFactory.primary(
          text: confirmText,
          onPressed: () => Navigator.of(context).pop(true),
          size: BaseButtonSize.medium,
        ),
      ],
    );
  }

  static Future<void> info({
    required BuildContext context,
    String? title,
    String? content,
    Widget? contentWidget,
    String okText = 'OK',
    BaseDialogSize size = BaseDialogSize.medium,
    Widget? icon,
    bool barrierDismissible = true,
  }) {
    return BaseDialog.show<void>(
      context: context,
      title: title ?? 'Information',
      content: content,
      contentWidget: contentWidget,
      type: BaseDialogType.info,
      size: size,
      icon: icon,
      barrierDismissible: barrierDismissible,
      actions: [
        BaseButtonFactory.primary(
          text: okText,
          onPressed: () => Navigator.of(context).pop(),
          size: BaseButtonSize.medium,
        ),
      ],
    );
  }

  static Future<void> success({
    required BuildContext context,
    String? title,
    String? content,
    Widget? contentWidget,
    String okText = 'OK',
    BaseDialogSize size = BaseDialogSize.medium,
    Widget? icon,
    bool barrierDismissible = true,
  }) {
    return BaseDialog.show<void>(
      context: context,
      title: title ?? 'Success',
      content: content,
      contentWidget: contentWidget,
      type: BaseDialogType.success,
      size: size,
      icon: icon,
      barrierDismissible: barrierDismissible,
      actions: [
        BaseButtonFactory.primary(
          text: okText,
          onPressed: () => Navigator.of(context).pop(),
          size: BaseButtonSize.medium,
        ),
      ],
    );
  }

  static Future<void> warning({
    required BuildContext context,
    String? title,
    String? content,
    Widget? contentWidget,
    String okText = 'OK',
    BaseDialogSize size = BaseDialogSize.medium,
    Widget? icon,
    bool barrierDismissible = true,
  }) {
    return BaseDialog.show<void>(
      context: context,
      title: title ?? 'Warning',
      content: content,
      contentWidget: contentWidget,
      type: BaseDialogType.warning,
      size: size,
      icon: icon,
      barrierDismissible: barrierDismissible,
      actions: [
        BaseButtonFactory.primary(
          text: okText,
          onPressed: () => Navigator.of(context).pop(),
          size: BaseButtonSize.medium,
        ),
      ],
    );
  }

  static Future<void> error({
    required BuildContext context,
    String? title,
    String? content,
    Widget? contentWidget,
    String okText = 'OK',
    BaseDialogSize size = BaseDialogSize.medium,
    Widget? icon,
    bool barrierDismissible = true,
  }) {
    return BaseDialog.show<void>(
      context: context,
      title: title ?? 'Error',
      content: content,
      contentWidget: contentWidget,
      type: BaseDialogType.error,
      size: size,
      icon: icon,
      barrierDismissible: barrierDismissible,
      actions: [
        BaseButtonFactory.primary(
          text: okText,
          onPressed: () => Navigator.of(context).pop(),
          size: BaseButtonSize.medium,
        ),
      ],
    );
  }
}