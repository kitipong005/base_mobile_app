import 'package:flutter/material.dart';
import '../../../../core/design_system/colors.dart';
import '../../../../core/design_system/typography.dart';
import '../../../../core/design_system/spacing.dart';

enum BaseSnackbarType { info, success, warning, error }
enum BaseSnackbarPosition { top, bottom }
enum BaseSnackbarBehavior { fixed, floating }

class BaseSnackbar extends StatelessWidget {
  const BaseSnackbar({
    super.key,
    required this.message,
    this.action,
    this.actionLabel,
    this.onActionPressed,
    this.type = BaseSnackbarType.info,
    this.position = BaseSnackbarPosition.bottom,
    this.behavior = BaseSnackbarBehavior.floating,
    this.duration = const Duration(seconds: 4),
    this.showCloseIcon = false,
    this.onClose,
    this.backgroundColor,
    this.textColor,
    this.actionColor,
    this.elevation,
    this.shape,
    this.margin,
    this.padding,
    this.width,
  });

  final String message;
  final Widget? action;
  final String? actionLabel;
  final VoidCallback? onActionPressed;
  final BaseSnackbarType type;
  final BaseSnackbarPosition position;
  final BaseSnackbarBehavior behavior;
  final Duration duration;
  final bool showCloseIcon;
  final VoidCallback? onClose;
  final Color? backgroundColor;
  final Color? textColor;
  final Color? actionColor;
  final double? elevation;
  final ShapeBorder? shape;
  final EdgeInsets? margin;
  final EdgeInsets? padding;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      margin: margin ?? _getMargin(),
      decoration: BoxDecoration(
        color: backgroundColor ?? _getBackgroundColor(),
        borderRadius: BorderRadius.circular(AppSpacing.radiusSM),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            offset: const Offset(0, 2),
            blurRadius: elevation ?? 4,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Padding(
        padding: padding ?? AppSpacing.paddingMD,
        child: Row(
          children: [
            _buildIcon(),
            AppSpacing.hSpaceSM,
            Expanded(
              child: Text(
                message,
                style: AppTypography.bodyMedium.copyWith(
                  color: textColor ?? _getTextColor(),
                ),
              ),
            ),
            if (action != null) ...[
              AppSpacing.hSpaceSM,
              action!,
            ] else if (actionLabel != null && onActionPressed != null) ...[
              AppSpacing.hSpaceSM,
              TextButton(
                onPressed: onActionPressed,
                style: TextButton.styleFrom(
                  foregroundColor: actionColor ?? _getActionColor(),
                  padding: AppSpacing.paddingSM,
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(
                  actionLabel!,
                  style: AppTypography.labelMedium.copyWith(
                    color: actionColor ?? _getActionColor(),
                  ),
                ),
              ),
            ],
            if (showCloseIcon) ...[
              AppSpacing.hSpaceSM,
              IconButton(
                onPressed: onClose,
                icon: const Icon(
                  Icons.close,
                  size: 20,
                ),
                style: IconButton.styleFrom(
                  foregroundColor: textColor ?? _getTextColor(),
                  padding: EdgeInsets.zero,
                  minimumSize: const Size(24, 24),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildIcon() {
    IconData iconData;
    Color iconColor;

    switch (type) {
      case BaseSnackbarType.info:
        iconData = Icons.info_outline;
        iconColor = AppColors.info;
        break;
      case BaseSnackbarType.success:
        iconData = Icons.check_circle_outline;
        iconColor = AppColors.success;
        break;
      case BaseSnackbarType.warning:
        iconData = Icons.warning_outlined;
        iconColor = AppColors.warning;
        break;
      case BaseSnackbarType.error:
        iconData = Icons.error_outline;
        iconColor = AppColors.error;
        break;
    }

    return Icon(
      iconData,
      color: iconColor,
      size: 20,
    );
  }

  Color _getBackgroundColor() {
    switch (type) {
      case BaseSnackbarType.info:
        return AppColors.neutral800;
      case BaseSnackbarType.success:
        return AppColors.successDark;
      case BaseSnackbarType.warning:
        return AppColors.warningDark;
      case BaseSnackbarType.error:
        return AppColors.errorDark;
    }
  }

  Color _getTextColor() {
    return AppColors.onPrimary;
  }

  Color _getActionColor() {
    switch (type) {
      case BaseSnackbarType.info:
        return AppColors.primaryLight;
      case BaseSnackbarType.success:
        return AppColors.successLight;
      case BaseSnackbarType.warning:
        return AppColors.warningLight;
      case BaseSnackbarType.error:
        return AppColors.errorLight;
    }
  }

  EdgeInsets _getMargin() {
    switch (behavior) {
      case BaseSnackbarBehavior.fixed:
        return EdgeInsets.zero;
      case BaseSnackbarBehavior.floating:
        return AppSpacing.paddingMD;
    }
  }

  static void show({
    required BuildContext context,
    required String message,
    Widget? action,
    String? actionLabel,
    VoidCallback? onActionPressed,
    BaseSnackbarType type = BaseSnackbarType.info,
    Duration duration = const Duration(seconds: 4),
    bool showCloseIcon = false,
    VoidCallback? onClose,
  }) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.hideCurrentSnackBar();

    scaffold.showSnackBar(
      SnackBar(
        content: BaseSnackbar(
          message: message,
          action: action,
          actionLabel: actionLabel,
          onActionPressed: onActionPressed,
          type: type,
          showCloseIcon: showCloseIcon,
          onClose: onClose,
        ),
        duration: duration,
        backgroundColor: Colors.transparent,
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        padding: EdgeInsets.zero,
      ),
    );
  }
}

extension BaseSnackbarFactory on BaseSnackbar {
  static void info({
    required BuildContext context,
    required String message,
    String? actionLabel,
    VoidCallback? onActionPressed,
    Duration duration = const Duration(seconds: 4),
    bool showCloseIcon = false,
  }) {
    BaseSnackbar.show(
      context: context,
      message: message,
      actionLabel: actionLabel,
      onActionPressed: onActionPressed,
      type: BaseSnackbarType.info,
      duration: duration,
      showCloseIcon: showCloseIcon,
    );
  }

  static void success({
    required BuildContext context,
    required String message,
    String? actionLabel,
    VoidCallback? onActionPressed,
    Duration duration = const Duration(seconds: 4),
    bool showCloseIcon = false,
  }) {
    BaseSnackbar.show(
      context: context,
      message: message,
      actionLabel: actionLabel,
      onActionPressed: onActionPressed,
      type: BaseSnackbarType.success,
      duration: duration,
      showCloseIcon: showCloseIcon,
    );
  }

  static void warning({
    required BuildContext context,
    required String message,
    String? actionLabel,
    VoidCallback? onActionPressed,
    Duration duration = const Duration(seconds: 4),
    bool showCloseIcon = false,
  }) {
    BaseSnackbar.show(
      context: context,
      message: message,
      actionLabel: actionLabel,
      onActionPressed: onActionPressed,
      type: BaseSnackbarType.warning,
      duration: duration,
      showCloseIcon: showCloseIcon,
    );
  }

  static void error({
    required BuildContext context,
    required String message,
    String? actionLabel,
    VoidCallback? onActionPressed,
    Duration duration = const Duration(seconds: 4),
    bool showCloseIcon = false,
  }) {
    BaseSnackbar.show(
      context: context,
      message: message,
      actionLabel: actionLabel,
      onActionPressed: onActionPressed,
      type: BaseSnackbarType.error,
      duration: duration,
      showCloseIcon: showCloseIcon,
    );
  }
}