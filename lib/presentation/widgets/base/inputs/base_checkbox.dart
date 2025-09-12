import 'package:flutter/material.dart';
import '../../../../core/design_system/colors.dart';
import '../../../../core/design_system/typography.dart';
import '../../../../core/design_system/spacing.dart';

enum BaseCheckboxSize { small, medium, large }

class BaseCheckbox extends StatelessWidget {
  const BaseCheckbox({
    super.key,
    required this.value,
    required this.onChanged,
    this.size = BaseCheckboxSize.medium,
    this.label,
    this.isEnabled = true,
    this.isError = false,
    this.activeColor,
    this.checkColor,
    this.fillColor,
    this.focusColor,
    this.hoverColor,
    this.overlayColor,
    this.splashRadius,
    this.materialTapTargetSize,
    this.visualDensity,
    this.focusNode,
    this.autofocus = false,
    this.shape,
    this.side,
    this.tristate = false,
    this.isTristate = false,
  });

  final bool? value;
  final void Function(bool?)? onChanged;
  final BaseCheckboxSize size;
  final String? label;
  final bool isEnabled;
  final bool isError;
  final Color? activeColor;
  final Color? checkColor;
  final WidgetStateProperty<Color?>? fillColor;
  final Color? focusColor;
  final Color? hoverColor;
  final WidgetStateProperty<Color?>? overlayColor;
  final double? splashRadius;
  final MaterialTapTargetSize? materialTapTargetSize;
  final VisualDensity? visualDensity;
  final FocusNode? focusNode;
  final bool autofocus;
  final OutlinedBorder? shape;
  final BorderSide? side;
  final bool tristate;
  final bool isTristate;

  @override
  Widget build(BuildContext context) {
    if (label == null) {
      return _buildCheckbox();
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildCheckbox(),
        AppSpacing.hSpaceXS,
        Flexible(
          child: GestureDetector(
            onTap: isEnabled ? () => onChanged?.call(!(value ?? false)) : null,
            child: Text(
              label!,
              style: _getTextStyle().copyWith(
                color: isEnabled
                    ? (isError ? AppColors.error : AppColors.onSurface)
                    : AppColors.neutral400,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCheckbox() {
    return SizedBox(
      width: _getCheckboxSize(),
      height: _getCheckboxSize(),
      child: Checkbox(
        value: tristate || isTristate ? value : value ?? false,
        onChanged: isEnabled ? onChanged : null,
        tristate: tristate || isTristate,
        activeColor: activeColor ?? (isError ? AppColors.error : AppColors.primary),
        checkColor: checkColor ?? AppColors.onPrimary,
        fillColor: fillColor ?? _getFillColor(),
        focusColor: focusColor,
        hoverColor: hoverColor,
        overlayColor: overlayColor,
        splashRadius: splashRadius,
        materialTapTargetSize: materialTapTargetSize ?? MaterialTapTargetSize.shrinkWrap,
        visualDensity: visualDensity ?? _getVisualDensity(),
        focusNode: focusNode,
        autofocus: autofocus,
        shape: shape ?? _getShape(),
        side: side ?? _getSide(),
      ),
    );
  }

  TextStyle _getTextStyle() {
    switch (size) {
      case BaseCheckboxSize.small:
        return AppTypography.bodySmall;
      case BaseCheckboxSize.medium:
        return AppTypography.bodyMedium;
      case BaseCheckboxSize.large:
        return AppTypography.bodyLarge;
    }
  }

  double _getCheckboxSize() {
    switch (size) {
      case BaseCheckboxSize.small:
        return AppSpacing.iconXS;
      case BaseCheckboxSize.medium:
        return AppSpacing.iconSM;
      case BaseCheckboxSize.large:
        return AppSpacing.iconMD;
    }
  }

  VisualDensity _getVisualDensity() {
    switch (size) {
      case BaseCheckboxSize.small:
        return VisualDensity.compact;
      case BaseCheckboxSize.medium:
        return VisualDensity.standard;
      case BaseCheckboxSize.large:
        return VisualDensity.comfortable;
    }
  }

  OutlinedBorder _getShape() {
    return RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppSpacing.radiusXS),
    );
  }

  BorderSide _getSide() {
    return BorderSide(
      color: isError
          ? AppColors.borderError
          : (isEnabled ? AppColors.border : AppColors.neutral300),
      width: 2,
    );
  }

  WidgetStateProperty<Color?> _getFillColor() {
    return WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return isError ? AppColors.error : AppColors.primary;
      }
      if (states.contains(WidgetState.disabled)) {
        return AppColors.neutral200;
      }
      return Colors.transparent;
    });
  }
}

class BaseCheckboxList extends StatelessWidget {
  const BaseCheckboxList({
    super.key,
    required this.items,
    required this.selectedValues,
    required this.onChanged,
    this.size = BaseCheckboxSize.medium,
    this.isEnabled = true,
    this.isError = false,
    this.crossAxisAlignment = CrossAxisAlignment.start,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.spacing = AppSpacing.sm,
    this.direction = Axis.vertical,
  });

  final List<BaseCheckboxItem> items;
  final List<String> selectedValues;
  final void Function(List<String>)? onChanged;
  final BaseCheckboxSize size;
  final bool isEnabled;
  final bool isError;
  final CrossAxisAlignment crossAxisAlignment;
  final MainAxisAlignment mainAxisAlignment;
  final double spacing;
  final Axis direction;

  @override
  Widget build(BuildContext context) {
    final checkboxes = items.map((item) => BaseCheckbox(
          value: selectedValues.contains(item.value),
          onChanged: (bool? value) {
            if (value == null) return;
            final newValues = List<String>.from(selectedValues);
            if (value) {
              newValues.add(item.value);
            } else {
              newValues.remove(item.value);
            }
            onChanged?.call(newValues);
          },
          label: item.label,
          size: size,
          isEnabled: isEnabled && item.isEnabled,
          isError: isError,
        )).toList();

    if (direction == Axis.vertical) {
      return Column(
        crossAxisAlignment: crossAxisAlignment,
        mainAxisAlignment: mainAxisAlignment,
        children: checkboxes
            .expand((checkbox) => [
                  checkbox,
                  if (checkbox != checkboxes.last) SizedBox(height: spacing),
                ])
            .toList(),
      );
    } else {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: mainAxisAlignment,
        children: checkboxes
            .expand((checkbox) => [
                  checkbox,
                  if (checkbox != checkboxes.last) SizedBox(width: spacing),
                ])
            .toList(),
      );
    }
  }
}

class BaseCheckboxItem {
  final String value;
  final String label;
  final bool isEnabled;

  const BaseCheckboxItem({
    required this.value,
    required this.label,
    this.isEnabled = true,
  });
}

extension BaseCheckboxFactory on BaseCheckbox {
  static Widget simple({
    Key? key,
    required bool value,
    required void Function(bool?)? onChanged,
    BaseCheckboxSize size = BaseCheckboxSize.medium,
    String? label,
    bool isEnabled = true,
    bool isError = false,
  }) {
    return BaseCheckbox(
      key: key,
      value: value,
      onChanged: onChanged,
      size: size,
      label: label,
      isEnabled: isEnabled,
      isError: isError,
    );
  }

  static Widget tristate({
    Key? key,
    required bool? value,
    required void Function(bool?)? onChanged,
    BaseCheckboxSize size = BaseCheckboxSize.medium,
    String? label,
    bool isEnabled = true,
    bool isError = false,
  }) {
    return BaseCheckbox(
      key: key,
      value: value,
      onChanged: onChanged,
      size: size,
      label: label,
      isEnabled: isEnabled,
      isError: isError,
      tristate: true,
    );
  }
}