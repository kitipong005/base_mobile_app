import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/design_system/typography.dart';
import '../../../../core/design_system/spacing.dart';

enum BaseTextFieldType { text, email, password, phone, number, search }
enum BaseTextFieldSize { small, medium, large }

class BaseTextField extends StatefulWidget {
  const BaseTextField({
    super.key,
    this.controller,
    this.initialValue,
    this.focusNode,
    this.type = BaseTextFieldType.text,
    this.size = BaseTextFieldSize.medium,
    this.label,
    this.hintText,
    this.helperText,
    this.errorText,
    this.prefixIcon,
    this.suffixIcon,
    this.prefixText,
    this.suffixText,
    this.isRequired = false,
    this.isEnabled = true,
    this.isReadOnly = false,
    this.obscureText = false,
    this.maxLines = 1,
    this.minLines,
    this.maxLength,
    this.keyboardType,
    this.textInputAction,
    this.textCapitalization = TextCapitalization.none,
    this.inputFormatters,
    this.validator,
    this.onChanged,
    this.onSubmitted,
    this.onTap,
    this.onFocusChange,
    this.autofocus = false,
    this.fillColor,
    this.borderColor,
    this.focusedBorderColor,
    this.errorBorderColor,
    this.textColor,
    this.hintColor,
    this.labelColor,
    this.cursorColor,
    this.borderRadius,
    this.contentPadding,
  });

  final TextEditingController? controller;
  final String? initialValue;
  final FocusNode? focusNode;
  final BaseTextFieldType type;
  final BaseTextFieldSize size;
  final String? label;
  final String? hintText;
  final String? helperText;
  final String? errorText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final String? prefixText;
  final String? suffixText;
  final bool isRequired;
  final bool isEnabled;
  final bool isReadOnly;
  final bool obscureText;
  final int maxLines;
  final int? minLines;
  final int? maxLength;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final TextCapitalization textCapitalization;
  final List<TextInputFormatter>? inputFormatters;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final void Function(String)? onSubmitted;
  final void Function()? onTap;
  final void Function(bool)? onFocusChange;
  final bool autofocus;
  final Color? fillColor;
  final Color? borderColor;
  final Color? focusedBorderColor;
  final Color? errorBorderColor;
  final Color? textColor;
  final Color? hintColor;
  final Color? labelColor;
  final Color? cursorColor;
  final BorderRadius? borderRadius;
  final EdgeInsets? contentPadding;

  @override
  State<BaseTextField> createState() => _BaseTextFieldState();
}

class _BaseTextFieldState extends State<BaseTextField> {
  late FocusNode _focusNode;
  late TextEditingController _controller;
  bool _obscureText = false;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode ?? FocusNode();
    _controller = widget.controller ?? TextEditingController(text: widget.initialValue);
    _obscureText = widget.obscureText;
    
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  void _onFocusChange() {
    setState(() {
      _isFocused = _focusNode.hasFocus;
    });
    widget.onFocusChange?.call(_isFocused);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null) ...[
          _buildLabel(),
          AppSpacing.vSpaceXS,
        ],
        _buildTextField(),
        if (widget.helperText != null || widget.errorText != null) ...[
          AppSpacing.vSpaceXS,
          _buildHelperText(),
        ],
      ],
    );
  }

  Widget _buildLabel() {
    final theme = Theme.of(context);
    return RichText(
      text: TextSpan(
        text: widget.label!,
        style: AppTypography.labelMedium.copyWith(
          color: widget.labelColor ?? theme.colorScheme.onSurface,
        ),
        children: widget.isRequired
            ? [
                TextSpan(
                  text: ' *',
                  style: TextStyle(color: theme.colorScheme.error),
                ),
              ]
            : null,
      ),
    );
  }

  Widget _buildTextField() {
    return TextFormField(
      controller: _controller,
      focusNode: _focusNode,
      enabled: widget.isEnabled,
      readOnly: widget.isReadOnly,
      obscureText: _obscureText,
      maxLines: widget.maxLines,
      minLines: widget.minLines,
      maxLength: widget.maxLength,
      keyboardType: widget.keyboardType ?? _getKeyboardType(),
      textInputAction: widget.textInputAction,
      textCapitalization: widget.textCapitalization,
      inputFormatters: widget.inputFormatters ?? _getInputFormatters(),
      validator: widget.validator,
      onChanged: widget.onChanged,
      onFieldSubmitted: widget.onSubmitted,
      onTap: widget.onTap,
      autofocus: widget.autofocus,
      cursorColor: widget.cursorColor ?? Theme.of(context).colorScheme.primary,
      style: _getTextStyle().copyWith(
        color: widget.textColor ?? Theme.of(context).colorScheme.onSurface,
      ),
      decoration: InputDecoration(
        hintText: widget.hintText,
        hintStyle: _getTextStyle().copyWith(
          color: widget.hintColor ?? Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
        ),
        prefixIcon: widget.prefixIcon,
        suffixIcon: _buildSuffixIcon(),
        prefixText: widget.prefixText,
        suffixText: widget.suffixText,
        errorText: widget.errorText,
        filled: true,
        fillColor: widget.fillColor ?? Theme.of(context).colorScheme.surface,
        border: _buildBorder(),
        enabledBorder: _buildBorder(),
        focusedBorder: _buildFocusedBorder(),
        errorBorder: _buildErrorBorder(),
        focusedErrorBorder: _buildErrorBorder(focused: true),
        disabledBorder: _buildDisabledBorder(),
        contentPadding: widget.contentPadding ?? _getContentPadding(),
        counterText: widget.maxLength != null ? null : '',
      ),
    );
  }

  Widget? _buildSuffixIcon() {
    if (widget.type == BaseTextFieldType.password) {
      return IconButton(
        icon: Icon(
          _obscureText ? Icons.visibility_outlined : Icons.visibility_off_outlined,
          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
        ),
        onPressed: () {
          setState(() {
            _obscureText = !_obscureText;
          });
        },
      );
    }
    
    if (widget.type == BaseTextFieldType.search && _controller.text.isNotEmpty) {
      return IconButton(
        icon: Icon(
          Icons.clear,
          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
        ),
        onPressed: () {
          _controller.clear();
          widget.onChanged?.call('');
        },
      );
    }

    return widget.suffixIcon;
  }

  Widget _buildHelperText() {
    final theme = Theme.of(context);
    final text = widget.errorText ?? widget.helperText;
    final color = widget.errorText != null 
        ? theme.colorScheme.error 
        : theme.colorScheme.onSurface.withValues(alpha: 0.7);
    
    return Text(
      text!,
      style: AppTypography.bodySmall.copyWith(color: color),
    );
  }

  TextInputType? _getKeyboardType() {
    switch (widget.type) {
      case BaseTextFieldType.email:
        return TextInputType.emailAddress;
      case BaseTextFieldType.phone:
        return TextInputType.phone;
      case BaseTextFieldType.number:
        return TextInputType.number;
      case BaseTextFieldType.search:
        return TextInputType.text;
      case BaseTextFieldType.password:
      case BaseTextFieldType.text:
        return TextInputType.text;
    }
  }

  List<TextInputFormatter>? _getInputFormatters() {
    switch (widget.type) {
      case BaseTextFieldType.phone:
        return [
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(10),
        ];
      case BaseTextFieldType.number:
        return [
          FilteringTextInputFormatter.digitsOnly,
        ];
      default:
        return null;
    }
  }

  TextStyle _getTextStyle() {
    switch (widget.size) {
      case BaseTextFieldSize.small:
        return AppTypography.bodySmall;
      case BaseTextFieldSize.medium:
        return AppTypography.bodyMedium;
      case BaseTextFieldSize.large:
        return AppTypography.bodyLarge;
    }
  }

  EdgeInsets _getContentPadding() {
    switch (widget.size) {
      case BaseTextFieldSize.small:
        return AppSpacing.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.xs);
      case BaseTextFieldSize.medium:
        return AppSpacing.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.sm);
      case BaseTextFieldSize.large:
        return AppSpacing.symmetric(horizontal: AppSpacing.xl, vertical: AppSpacing.md);
    }
  }

  OutlineInputBorder _buildBorder() {
    return OutlineInputBorder(
      borderRadius: widget.borderRadius ?? AppSpacing.borderRadiusSM,
      borderSide: BorderSide(
        color: widget.borderColor ?? Theme.of(context).colorScheme.outline,
        width: 1,
      ),
    );
  }

  OutlineInputBorder _buildFocusedBorder() {
    return OutlineInputBorder(
      borderRadius: widget.borderRadius ?? AppSpacing.borderRadiusSM,
      borderSide: BorderSide(
        color: widget.focusedBorderColor ?? Theme.of(context).colorScheme.primary,
        width: 2,
      ),
    );
  }

  OutlineInputBorder _buildErrorBorder({bool focused = false}) {
    return OutlineInputBorder(
      borderRadius: widget.borderRadius ?? AppSpacing.borderRadiusSM,
      borderSide: BorderSide(
        color: widget.errorBorderColor ?? Theme.of(context).colorScheme.error,
        width: focused ? 2 : 1,
      ),
    );
  }

  OutlineInputBorder _buildDisabledBorder() {
    return OutlineInputBorder(
      borderRadius: widget.borderRadius ?? AppSpacing.borderRadiusSM,
      borderSide: BorderSide(
        color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.5),
        width: 1,
      ),
    );
  }
}

extension BaseTextFieldFactory on BaseTextField {
  static Widget text({
    Key? key,
    TextEditingController? controller,
    String? initialValue,
    FocusNode? focusNode,
    BaseTextFieldSize size = BaseTextFieldSize.medium,
    String? label,
    String? hintText,
    String? helperText,
    String? errorText,
    Widget? prefixIcon,
    Widget? suffixIcon,
    bool isRequired = false,
    bool isEnabled = true,
    bool isReadOnly = false,
    int maxLines = 1,
    int? maxLength,
    String? Function(String?)? validator,
    void Function(String)? onChanged,
    void Function(String)? onSubmitted,
    void Function()? onTap,
  }) {
    return BaseTextField(
      key: key,
      controller: controller,
      initialValue: initialValue,
      focusNode: focusNode,
      type: BaseTextFieldType.text,
      size: size,
      label: label,
      hintText: hintText,
      helperText: helperText,
      errorText: errorText,
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      isRequired: isRequired,
      isEnabled: isEnabled,
      isReadOnly: isReadOnly,
      maxLines: maxLines,
      maxLength: maxLength,
      validator: validator,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      onTap: onTap,
    );
  }

  static Widget email({
    Key? key,
    TextEditingController? controller,
    String? initialValue,
    FocusNode? focusNode,
    BaseTextFieldSize size = BaseTextFieldSize.medium,
    String? label,
    String? hintText,
    String? helperText,
    String? errorText,
    Widget? prefixIcon,
    bool isRequired = false,
    bool isEnabled = true,
    String? Function(String?)? validator,
    void Function(String)? onChanged,
    void Function(String)? onSubmitted,
  }) {
    return BaseTextField(
      key: key,
      controller: controller,
      initialValue: initialValue,
      focusNode: focusNode,
      type: BaseTextFieldType.email,
      size: size,
      label: label,
      hintText: hintText ?? 'Enter email address',
      helperText: helperText,
      errorText: errorText,
      prefixIcon: prefixIcon ?? const Icon(Icons.email_outlined),
      isRequired: isRequired,
      isEnabled: isEnabled,
      validator: validator,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
    );
  }

  static Widget password({
    Key? key,
    TextEditingController? controller,
    String? initialValue,
    FocusNode? focusNode,
    BaseTextFieldSize size = BaseTextFieldSize.medium,
    String? label,
    String? hintText,
    String? helperText,
    String? errorText,
    Widget? prefixIcon,
    bool isRequired = false,
    bool isEnabled = true,
    String? Function(String?)? validator,
    void Function(String)? onChanged,
    void Function(String)? onSubmitted,
  }) {
    return BaseTextField(
      key: key,
      controller: controller,
      initialValue: initialValue,
      focusNode: focusNode,
      type: BaseTextFieldType.password,
      size: size,
      label: label,
      hintText: hintText ?? 'Enter password',
      helperText: helperText,
      errorText: errorText,
      prefixIcon: prefixIcon ?? const Icon(Icons.lock_outlined),
      isRequired: isRequired,
      isEnabled: isEnabled,
      obscureText: true,
      validator: validator,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
    );
  }

  static Widget phone({
    Key? key,
    TextEditingController? controller,
    String? initialValue,
    FocusNode? focusNode,
    BaseTextFieldSize size = BaseTextFieldSize.medium,
    String? label,
    String? hintText,
    String? helperText,
    String? errorText,
    Widget? prefixIcon,
    bool isRequired = false,
    bool isEnabled = true,
    String? Function(String?)? validator,
    void Function(String)? onChanged,
    void Function(String)? onSubmitted,
  }) {
    return BaseTextField(
      key: key,
      controller: controller,
      initialValue: initialValue,
      focusNode: focusNode,
      type: BaseTextFieldType.phone,
      size: size,
      label: label,
      hintText: hintText ?? 'Enter phone number',
      helperText: helperText,
      errorText: errorText,
      prefixIcon: prefixIcon ?? const Icon(Icons.phone_outlined),
      isRequired: isRequired,
      isEnabled: isEnabled,
      validator: validator,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
    );
  }

  static Widget search({
    Key? key,
    TextEditingController? controller,
    String? initialValue,
    FocusNode? focusNode,
    BaseTextFieldSize size = BaseTextFieldSize.medium,
    String? hintText,
    bool isEnabled = true,
    void Function(String)? onChanged,
    void Function(String)? onSubmitted,
  }) {
    return BaseTextField(
      key: key,
      controller: controller,
      initialValue: initialValue,
      focusNode: focusNode,
      type: BaseTextFieldType.search,
      size: size,
      hintText: hintText ?? 'Search...',
      prefixIcon: const Icon(Icons.search_outlined),
      isEnabled: isEnabled,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
    );
  }

  static Widget number({
    Key? key,
    TextEditingController? controller,
    String? initialValue,
    FocusNode? focusNode,
    BaseTextFieldSize size = BaseTextFieldSize.medium,
    String? label,
    String? hintText,
    String? helperText,
    String? errorText,
    Widget? prefixIcon,
    bool isRequired = false,
    bool isEnabled = true,
    int? maxLength,
    String? Function(String?)? validator,
    void Function(String)? onChanged,
    void Function(String)? onSubmitted,
  }) {
    return BaseTextField(
      key: key,
      controller: controller,
      initialValue: initialValue,
      focusNode: focusNode,
      type: BaseTextFieldType.number,
      size: size,
      label: label,
      hintText: hintText ?? 'Enter number',
      helperText: helperText,
      errorText: errorText,
      prefixIcon: prefixIcon,
      isRequired: isRequired,
      isEnabled: isEnabled,
      maxLength: maxLength,
      validator: validator,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
    );
  }

  static Widget multiline({
    Key? key,
    TextEditingController? controller,
    String? initialValue,
    FocusNode? focusNode,
    BaseTextFieldSize size = BaseTextFieldSize.medium,
    String? label,
    String? hintText,
    String? helperText,
    String? errorText,
    bool isRequired = false,
    bool isEnabled = true,
    int maxLines = 3,
    int? minLines,
    int? maxLength,
    String? Function(String?)? validator,
    void Function(String)? onChanged,
    void Function(String)? onSubmitted,
  }) {
    return BaseTextField(
      key: key,
      controller: controller,
      initialValue: initialValue,
      focusNode: focusNode,
      type: BaseTextFieldType.text,
      size: size,
      label: label,
      hintText: hintText,
      helperText: helperText,
      errorText: errorText,
      isRequired: isRequired,
      isEnabled: isEnabled,
      maxLines: maxLines,
      minLines: minLines,
      maxLength: maxLength,
      validator: validator,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
    );
  }
}