import 'package:flutter/material.dart';
import '../../../../core/design_system/colors.dart';
import '../../../../core/design_system/spacing.dart';

enum BaseContainerSize { small, medium, large, xlarge, custom }
enum BaseContainerVariant { filled, outlined, elevated }

class BaseContainer extends StatelessWidget {
  const BaseContainer({
    super.key,
    this.child,
    this.variant = BaseContainerVariant.filled,
    this.size = BaseContainerSize.medium,
    this.width,
    this.height,
    this.minWidth,
    this.minHeight,
    this.maxWidth,
    this.maxHeight,
    this.padding,
    this.margin,
    this.alignment,
    this.color,
    this.borderColor,
    this.borderWidth,
    this.borderRadius,
    this.gradient,
    this.boxShadow,
    this.elevation,
    this.onTap,
    this.onLongPress,
    this.onDoubleTap,
    this.constraints,
  });

  final Widget? child;
  final BaseContainerVariant variant;
  final BaseContainerSize size;
  final double? width;
  final double? height;
  final double? minWidth;
  final double? minHeight;
  final double? maxWidth;
  final double? maxHeight;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final AlignmentGeometry? alignment;
  final Color? color;
  final Color? borderColor;
  final double? borderWidth;
  final BorderRadius? borderRadius;
  final Gradient? gradient;
  final List<BoxShadow>? boxShadow;
  final double? elevation;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final VoidCallback? onDoubleTap;
  final BoxConstraints? constraints;

  @override
  Widget build(BuildContext context) {
    Widget container = Container(
      width: width ?? _getWidth(),
      height: height ?? _getHeight(),
      constraints: constraints ?? _getConstraints(),
      margin: margin,
      padding: padding ?? _getPadding(),
      alignment: alignment,
      decoration: BoxDecoration(
        color: gradient == null ? (color ?? _getColor()) : null,
        gradient: gradient,
        border: _getBorder(),
        borderRadius: borderRadius ?? _getBorderRadius(),
        boxShadow: boxShadow ?? _getBoxShadow(),
      ),
      child: child,
    );

    if (onTap != null || onLongPress != null || onDoubleTap != null) {
      container = GestureDetector(
        onTap: onTap,
        onLongPress: onLongPress,
        onDoubleTap: onDoubleTap,
        child: container,
      );
    }

    return container;
  }

  double? _getWidth() {
    switch (size) {
      case BaseContainerSize.small:
        return AppSpacing.containerHeightSM;
      case BaseContainerSize.medium:
        return AppSpacing.containerHeightMD;
      case BaseContainerSize.large:
        return AppSpacing.containerHeightLG;
      case BaseContainerSize.xlarge:
        return AppSpacing.containerHeightXL;
      case BaseContainerSize.custom:
        return null;
    }
  }

  double? _getHeight() {
    switch (size) {
      case BaseContainerSize.small:
        return AppSpacing.containerHeightSM;
      case BaseContainerSize.medium:
        return AppSpacing.containerHeightMD;
      case BaseContainerSize.large:
        return AppSpacing.containerHeightLG;
      case BaseContainerSize.xlarge:
        return AppSpacing.containerHeightXL;
      case BaseContainerSize.custom:
        return null;
    }
  }

  BoxConstraints? _getConstraints() {
    if (constraints != null) return constraints;
    
    return BoxConstraints(
      minWidth: minWidth ?? 0,
      minHeight: minHeight ?? 0,
      maxWidth: maxWidth ?? double.infinity,
      maxHeight: maxHeight ?? double.infinity,
    );
  }

  EdgeInsetsGeometry _getPadding() {
    switch (size) {
      case BaseContainerSize.small:
        return AppSpacing.paddingSM;
      case BaseContainerSize.medium:
        return AppSpacing.paddingMD;
      case BaseContainerSize.large:
        return AppSpacing.paddingLG;
      case BaseContainerSize.xlarge:
        return AppSpacing.paddingXL;
      case BaseContainerSize.custom:
        return AppSpacing.paddingMD;
    }
  }

  Color _getColor() {
    switch (variant) {
      case BaseContainerVariant.filled:
        return AppColors.surface;
      case BaseContainerVariant.outlined:
        return Colors.transparent;
      case BaseContainerVariant.elevated:
        return AppColors.surface;
    }
  }

  Border? _getBorder() {
    switch (variant) {
      case BaseContainerVariant.filled:
        return null;
      case BaseContainerVariant.outlined:
        return Border.all(
          color: borderColor ?? AppColors.border,
          width: borderWidth ?? 1,
        );
      case BaseContainerVariant.elevated:
        return null;
    }
  }

  BorderRadius _getBorderRadius() {
    switch (size) {
      case BaseContainerSize.small:
        return AppSpacing.borderRadiusSM;
      case BaseContainerSize.medium:
        return AppSpacing.borderRadiusMD;
      case BaseContainerSize.large:
        return AppSpacing.borderRadiusLG;
      case BaseContainerSize.xlarge:
        return AppSpacing.borderRadiusXL;
      case BaseContainerSize.custom:
        return AppSpacing.borderRadiusMD;
    }
  }

  List<BoxShadow>? _getBoxShadow() {
    if (variant != BaseContainerVariant.elevated) return null;
    
    final elevationValue = elevation ?? _getElevation();
    
    return [
      BoxShadow(
        color: AppColors.shadow,
        offset: Offset(0, elevationValue),
        blurRadius: elevationValue * 2,
        spreadRadius: 0,
      ),
    ];
  }

  double _getElevation() {
    switch (size) {
      case BaseContainerSize.small:
        return 1;
      case BaseContainerSize.medium:
        return 2;
      case BaseContainerSize.large:
        return 4;
      case BaseContainerSize.xlarge:
        return 6;
      case BaseContainerSize.custom:
        return 2;
    }
  }
}

class BaseSection extends StatelessWidget {
  const BaseSection({
    super.key,
    this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    this.children = const [],
    this.padding,
    this.spacing = AppSpacing.md,
    this.crossAxisAlignment = CrossAxisAlignment.start,
    this.titleStyle,
    this.subtitleStyle,
  });

  final String? title;
  final String? subtitle;
  final Widget? leading;
  final Widget? trailing;
  final List<Widget> children;
  final EdgeInsetsGeometry? padding;
  final double spacing;
  final CrossAxisAlignment crossAxisAlignment;
  final TextStyle? titleStyle;
  final TextStyle? subtitleStyle;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? AppSpacing.paddingMD,
      child: Column(
        crossAxisAlignment: crossAxisAlignment,
        children: [
          if (title != null || subtitle != null || leading != null || trailing != null)
            _buildHeader(context),
          if (children.isNotEmpty && (title != null || subtitle != null))
            SizedBox(height: spacing),
          ...children
              .expand((child) => [
                    child,
                    if (child != children.last) SizedBox(height: spacing),
                  ]),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        if (leading != null) ...[
          leading!,
          AppSpacing.hSpaceMD,
        ],
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (title != null)
                Text(
                  title!,
                  style: titleStyle ?? Theme.of(context).textTheme.titleLarge,
                ),
              if (subtitle != null) ...[
                AppSpacing.vSpaceXS,
                Text(
                  subtitle!,
                  style: subtitleStyle ?? Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.neutral600,
                  ),
                ),
              ],
            ],
          ),
        ),
        if (trailing != null) ...[
          AppSpacing.hSpaceMD,
          trailing!,
        ],
      ],
    );
  }
}

extension BaseContainerFactory on BaseContainer {
  static Widget filled({
    Key? key,
    Widget? child,
    BaseContainerSize size = BaseContainerSize.medium,
    double? width,
    double? height,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    Color? color,
    BorderRadius? borderRadius,
    VoidCallback? onTap,
  }) {
    return BaseContainer(
      key: key,
      variant: BaseContainerVariant.filled,
      size: size,
      width: width,
      height: height,
      padding: padding,
      margin: margin,
      color: color,
      borderRadius: borderRadius,
      onTap: onTap,
      child: child,
    );
  }

  static Widget outlined({
    Key? key,
    Widget? child,
    BaseContainerSize size = BaseContainerSize.medium,
    double? width,
    double? height,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    Color? color,
    Color? borderColor,
    double? borderWidth,
    BorderRadius? borderRadius,
    VoidCallback? onTap,
  }) {
    return BaseContainer(
      key: key,
      variant: BaseContainerVariant.outlined,
      size: size,
      width: width,
      height: height,
      padding: padding,
      margin: margin,
      color: color,
      borderColor: borderColor,
      borderWidth: borderWidth,
      borderRadius: borderRadius,
      onTap: onTap,
      child: child,
    );
  }

  static Widget elevated({
    Key? key,
    Widget? child,
    BaseContainerSize size = BaseContainerSize.medium,
    double? width,
    double? height,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    Color? color,
    double? elevation,
    BorderRadius? borderRadius,
    VoidCallback? onTap,
  }) {
    return BaseContainer(
      key: key,
      variant: BaseContainerVariant.elevated,
      size: size,
      width: width,
      height: height,
      padding: padding,
      margin: margin,
      color: color,
      elevation: elevation,
      borderRadius: borderRadius,
      onTap: onTap,
      child: child,
    );
  }
}