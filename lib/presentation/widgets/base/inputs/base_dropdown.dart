import 'package:flutter/material.dart';
import '../../../../core/design_system/colors.dart';
import '../../../../core/design_system/typography.dart';
import '../../../../core/design_system/spacing.dart';

enum BaseDropdownSize { small, medium, large }

class BaseDropdownItem<T> {
  final T value;
  final String label;
  final Widget? icon;
  final bool isEnabled;

  const BaseDropdownItem({
    required this.value,
    required this.label,
    this.icon,
    this.isEnabled = true,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BaseDropdownItem<T> &&
          runtimeType == other.runtimeType &&
          value == other.value;

  @override
  int get hashCode => value.hashCode;
}

class BaseDropdown<T> extends StatelessWidget {
  const BaseDropdown({
    super.key,
    required this.items,
    required this.onChanged,
    this.value,
    this.size = BaseDropdownSize.medium,
    this.label,
    this.hintText,
    this.helperText,
    this.errorText,
    this.prefixIcon,
    this.isRequired = false,
    this.isEnabled = true,
    this.validator,
    this.fillColor,
    this.borderColor,
    this.focusedBorderColor,
    this.errorBorderColor,
    this.textColor,
    this.hintColor,
    this.labelColor,
    this.borderRadius,
    this.contentPadding,
    this.maxHeight = 300,
    this.isExpanded = true,
  });

  final List<BaseDropdownItem<T>> items;
  final void Function(T?)? onChanged;
  final T? value;
  final BaseDropdownSize size;
  final String? label;
  final String? hintText;
  final String? helperText;
  final String? errorText;
  final Widget? prefixIcon;
  final bool isRequired;
  final bool isEnabled;
  final String? Function(T?)? validator;
  final Color? fillColor;
  final Color? borderColor;
  final Color? focusedBorderColor;
  final Color? errorBorderColor;
  final Color? textColor;
  final Color? hintColor;
  final Color? labelColor;
  final BorderRadius? borderRadius;
  final EdgeInsets? contentPadding;
  final double maxHeight;
  final bool isExpanded;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          _buildLabel(),
          AppSpacing.vSpaceXS,
        ],
        _buildDropdown(context),
        if (helperText != null || errorText != null) ...[
          AppSpacing.vSpaceXS,
          _buildHelperText(),
        ],
      ],
    );
  }

  Widget _buildLabel() {
    return RichText(
      text: TextSpan(
        text: label!,
        style: AppTypography.labelMedium.copyWith(
          color: labelColor ?? AppColors.onSurface,
        ),
        children: isRequired
            ? [
                const TextSpan(
                  text: ' *',
                  style: TextStyle(color: AppColors.error),
                ),
              ]
            : null,
      ),
    );
  }

  Widget _buildDropdown(BuildContext context) {
    return DropdownButtonFormField<T>(
      value: value,
      items: items
          .map((item) => DropdownMenuItem<T>(
                value: item.value,
                enabled: item.isEnabled,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (item.icon != null) ...[
                      item.icon!,
                      AppSpacing.hSpaceSM,
                    ],
                    Expanded(
                      child: Text(
                        item.label,
                        style: _getTextStyle().copyWith(
                          color: item.isEnabled
                              ? textColor ?? AppColors.onSurface
                              : AppColors.neutral400,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ))
          .toList(),
      onChanged: isEnabled ? onChanged : null,
      validator: validator != null
          ? (value) => validator!(value)
          : null,
      isExpanded: isExpanded,
      hint: hintText != null
          ? Text(
              hintText!,
              style: _getTextStyle().copyWith(
                color: hintColor ?? AppColors.neutral500,
              ),
            )
          : null,
      style: _getTextStyle().copyWith(
        color: textColor ?? AppColors.onSurface,
      ),
      icon: const Icon(
        Icons.keyboard_arrow_down,
        color: AppColors.neutral600,
      ),
      iconSize: _getIconSize(),
      dropdownColor: AppColors.surface,
      elevation: 8,
      menuMaxHeight: maxHeight,
      decoration: InputDecoration(
        prefixIcon: prefixIcon,
        errorText: errorText,
        filled: true,
        fillColor: fillColor ?? AppColors.surface,
        border: _buildBorder(),
        enabledBorder: _buildBorder(),
        focusedBorder: _buildFocusedBorder(),
        errorBorder: _buildErrorBorder(),
        focusedErrorBorder: _buildErrorBorder(focused: true),
        disabledBorder: _buildDisabledBorder(),
        contentPadding: contentPadding ?? _getContentPadding(),
      ),
    );
  }

  Widget _buildHelperText() {
    final text = errorText ?? helperText;
    final color = errorText != null ? AppColors.error : AppColors.neutral600;
    
    return Text(
      text!,
      style: AppTypography.bodySmall.copyWith(color: color),
    );
  }

  TextStyle _getTextStyle() {
    switch (size) {
      case BaseDropdownSize.small:
        return AppTypography.bodySmall;
      case BaseDropdownSize.medium:
        return AppTypography.bodyMedium;
      case BaseDropdownSize.large:
        return AppTypography.bodyLarge;
    }
  }

  EdgeInsets _getContentPadding() {
    switch (size) {
      case BaseDropdownSize.small:
        return AppSpacing.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.xs);
      case BaseDropdownSize.medium:
        return AppSpacing.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.sm);
      case BaseDropdownSize.large:
        return AppSpacing.symmetric(horizontal: AppSpacing.xl, vertical: AppSpacing.md);
    }
  }

  double _getIconSize() {
    switch (size) {
      case BaseDropdownSize.small:
        return AppSpacing.iconXS;
      case BaseDropdownSize.medium:
        return AppSpacing.iconSM;
      case BaseDropdownSize.large:
        return AppSpacing.iconMD;
    }
  }

  OutlineInputBorder _buildBorder() {
    return OutlineInputBorder(
      borderRadius: borderRadius ?? AppSpacing.borderRadiusSM,
      borderSide: BorderSide(
        color: borderColor ?? AppColors.border,
        width: 1,
      ),
    );
  }

  OutlineInputBorder _buildFocusedBorder() {
    return OutlineInputBorder(
      borderRadius: borderRadius ?? AppSpacing.borderRadiusSM,
      borderSide: BorderSide(
        color: focusedBorderColor ?? AppColors.borderFocus,
        width: 2,
      ),
    );
  }

  OutlineInputBorder _buildErrorBorder({bool focused = false}) {
    return OutlineInputBorder(
      borderRadius: borderRadius ?? AppSpacing.borderRadiusSM,
      borderSide: BorderSide(
        color: errorBorderColor ?? AppColors.borderError,
        width: focused ? 2 : 1,
      ),
    );
  }

  OutlineInputBorder _buildDisabledBorder() {
    return OutlineInputBorder(
      borderRadius: borderRadius ?? AppSpacing.borderRadiusSM,
      borderSide: const BorderSide(
        color: AppColors.neutral300,
        width: 1,
      ),
    );
  }
}

extension BaseDropdownFactory on BaseDropdown {
  static BaseDropdown<T> create<T>({
    Key? key,
    required List<BaseDropdownItem<T>> items,
    required void Function(T?)? onChanged,
    T? value,
    BaseDropdownSize size = BaseDropdownSize.medium,
    String? label,
    String? hintText,
    String? helperText,
    String? errorText,
    Widget? prefixIcon,
    bool isRequired = false,
    bool isEnabled = true,
    String? Function(T?)? validator,
  }) {
    return BaseDropdown<T>(
      key: key,
      items: items,
      onChanged: onChanged,
      value: value,
      size: size,
      label: label,
      hintText: hintText,
      helperText: helperText,
      errorText: errorText,
      prefixIcon: prefixIcon,
      isRequired: isRequired,
      isEnabled: isEnabled,
      validator: validator,
    );
  }
}