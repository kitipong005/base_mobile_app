import 'package:flutter/material.dart';
import '../../../../core/design_system/colors.dart';
import '../../../../core/design_system/spacing.dart';

enum BaseCardSize { small, medium, large }
enum BaseCardVariant { elevated, outlined, filled }

class BaseCard extends StatelessWidget {
  const BaseCard({
    super.key,
    required this.child,
    this.variant = BaseCardVariant.elevated,
    this.size = BaseCardSize.medium,
    this.color,
    this.shadowColor,
    this.surfaceTintColor,
    this.elevation,
    this.shape,
    this.borderOnForeground = true,
    this.margin,
    this.padding,
    this.clipBehavior,
    this.semanticContainer = true,
    this.onTap,
    this.onLongPress,
    this.borderColor,
    this.borderWidth,
  });

  final Widget child;
  final BaseCardVariant variant;
  final BaseCardSize size;
  final Color? color;
  final Color? shadowColor;
  final Color? surfaceTintColor;
  final double? elevation;
  final ShapeBorder? shape;
  final bool borderOnForeground;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final Clip? clipBehavior;
  final bool semanticContainer;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final Color? borderColor;
  final double? borderWidth;

  @override
  Widget build(BuildContext context) {
    Widget card = Card(
      color: color ?? _getCardColor(context),
      shadowColor: shadowColor ?? Theme.of(context).shadowColor,
      surfaceTintColor: surfaceTintColor ?? Colors.transparent,
      elevation: elevation ?? _getElevation(),
      shape: shape ?? _getShape(context),
      borderOnForeground: borderOnForeground,
      margin: margin ?? EdgeInsets.zero,
      clipBehavior: clipBehavior,
      semanticContainer: semanticContainer,
      child: Container(
        padding: padding ?? _getPadding(),
        child: child,
      ),
    );

    if (onTap != null || onLongPress != null) {
      card = InkWell(
        onTap: onTap,
        onLongPress: onLongPress,
        borderRadius: _getBorderRadius(),
        child: card,
      );
    }

    return card;
  }

  Color _getCardColor(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    switch (variant) {
      case BaseCardVariant.elevated:
        return theme.cardTheme.color ?? 
               (isDark ? theme.colorScheme.surfaceContainer : theme.colorScheme.surface);
      case BaseCardVariant.outlined:
        return theme.cardTheme.color ?? 
               (isDark ? theme.colorScheme.surfaceContainer : theme.colorScheme.surface);
      case BaseCardVariant.filled:
        return isDark 
            ? theme.colorScheme.surfaceContainerHighest 
            : theme.colorScheme.surface.withValues(alpha: 0.8);
    }
  }

  double _getElevation() {
    switch (variant) {
      case BaseCardVariant.elevated:
        return _getSizeElevation();
      case BaseCardVariant.outlined:
        return 0;
      case BaseCardVariant.filled:
        return 0;
    }
  }

  double _getSizeElevation() {
    switch (size) {
      case BaseCardSize.small:
        return 1;
      case BaseCardSize.medium:
        return 2;
      case BaseCardSize.large:
        return 4;
    }
  }

  ShapeBorder _getShape(BuildContext context) {
    switch (variant) {
      case BaseCardVariant.elevated:
        return RoundedRectangleBorder(
          borderRadius: _getBorderRadius(),
        );
      case BaseCardVariant.outlined:
        return RoundedRectangleBorder(
          borderRadius: _getBorderRadius(),
          side: BorderSide(
            color: borderColor ?? Theme.of(context).colorScheme.outline,
            width: borderWidth ?? 1,
          ),
        );
      case BaseCardVariant.filled:
        return RoundedRectangleBorder(
          borderRadius: _getBorderRadius(),
        );
    }
  }

  BorderRadius _getBorderRadius() {
    switch (size) {
      case BaseCardSize.small:
        return AppSpacing.borderRadiusSM;
      case BaseCardSize.medium:
        return AppSpacing.borderRadiusMD;
      case BaseCardSize.large:
        return AppSpacing.borderRadiusLG;
    }
  }

  EdgeInsetsGeometry _getPadding() {
    switch (size) {
      case BaseCardSize.small:
        return AppSpacing.paddingSM;
      case BaseCardSize.medium:
        return AppSpacing.paddingMD;
      case BaseCardSize.large:
        return AppSpacing.paddingLG;
    }
  }
}

class BaseCardHeader extends StatelessWidget {
  const BaseCardHeader({
    super.key,
    this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    this.padding,
    this.titleStyle,
    this.subtitleStyle,
  });

  final String? title;
  final String? subtitle;
  final Widget? leading;
  final Widget? trailing;
  final EdgeInsetsGeometry? padding;
  final TextStyle? titleStyle;
  final TextStyle? subtitleStyle;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? AppSpacing.paddingMD,
      child: Row(
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
                    style: titleStyle ?? Theme.of(context).textTheme.titleMedium,
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
      ),
    );
  }
}

class BaseCardActions extends StatelessWidget {
  const BaseCardActions({
    super.key,
    required this.children,
    this.alignment = MainAxisAlignment.end,
    this.padding,
  });

  final List<Widget> children;
  final MainAxisAlignment alignment;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? AppSpacing.paddingMD,
      child: Row(
        mainAxisAlignment: alignment,
        children: children
            .expand((widget) => [
                  widget,
                  if (widget != children.last) AppSpacing.hSpaceSM,
                ])
            .toList(),
      ),
    );
  }
}

extension BaseCardFactory on BaseCard {
  static Widget elevated({
    Key? key,
    required Widget child,
    BaseCardSize size = BaseCardSize.medium,
    Color? color,
    double? elevation,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    VoidCallback? onTap,
    VoidCallback? onLongPress,
  }) {
    return BaseCard(
      key: key,
      variant: BaseCardVariant.elevated,
      size: size,
      color: color,
      elevation: elevation,
      padding: padding,
      margin: margin,
      onTap: onTap,
      onLongPress: onLongPress,
      child: child,
    );
  }

  static Widget outlined({
    Key? key,
    required Widget child,
    BaseCardSize size = BaseCardSize.medium,
    Color? color,
    Color? borderColor,
    double? borderWidth,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    VoidCallback? onTap,
    VoidCallback? onLongPress,
  }) {
    return BaseCard(
      key: key,
      variant: BaseCardVariant.outlined,
      size: size,
      color: color,
      borderColor: borderColor,
      borderWidth: borderWidth,
      padding: padding,
      margin: margin,
      onTap: onTap,
      onLongPress: onLongPress,
      child: child,
    );
  }

  static Widget filled({
    Key? key,
    required Widget child,
    BaseCardSize size = BaseCardSize.medium,
    Color? color,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    VoidCallback? onTap,
    VoidCallback? onLongPress,
  }) {
    return BaseCard(
      key: key,
      variant: BaseCardVariant.filled,
      size: size,
      color: color,
      padding: padding,
      margin: margin,
      onTap: onTap,
      onLongPress: onLongPress,
      child: child,
    );
  }
}