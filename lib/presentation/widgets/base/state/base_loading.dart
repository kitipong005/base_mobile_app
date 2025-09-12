import 'package:flutter/material.dart';
import '../../../../core/design_system/colors.dart';
import '../../../../core/design_system/typography.dart';
import '../../../../core/design_system/spacing.dart';

enum BaseLoadingSize { small, medium, large }
enum BaseLoadingType { circular, linear, dots, spinner }

class BaseLoading extends StatefulWidget {
  const BaseLoading({
    super.key,
    this.type = BaseLoadingType.circular,
    this.size = BaseLoadingSize.medium,
    this.color,
    this.backgroundColor,
    this.strokeWidth,
    this.value,
    this.semanticsLabel,
    this.semanticsValue,
    this.message,
    this.messageStyle,
    this.spacing = AppSpacing.md,
    this.mainAxisAlignment = MainAxisAlignment.center,
    this.crossAxisAlignment = CrossAxisAlignment.center,
  });

  final BaseLoadingType type;
  final BaseLoadingSize size;
  final Color? color;
  final Color? backgroundColor;
  final double? strokeWidth;
  final double? value;
  final String? semanticsLabel;
  final String? semanticsValue;
  final String? message;
  final TextStyle? messageStyle;
  final double spacing;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;

  @override
  State<BaseLoading> createState() => _BaseLoadingState();
}

class _BaseLoadingState extends State<BaseLoading>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _animation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: widget.mainAxisAlignment,
      crossAxisAlignment: widget.crossAxisAlignment,
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildLoadingIndicator(),
        if (widget.message != null) ...[
          SizedBox(height: widget.spacing),
          Text(
            widget.message!,
            style: widget.messageStyle ?? _getMessageStyle(),
            textAlign: TextAlign.center,
          ),
        ],
      ],
    );
  }

  Widget _buildLoadingIndicator() {
    switch (widget.type) {
      case BaseLoadingType.circular:
        return _buildCircularIndicator();
      case BaseLoadingType.linear:
        return _buildLinearIndicator();
      case BaseLoadingType.dots:
        return _buildDotsIndicator();
      case BaseLoadingType.spinner:
        return _buildSpinnerIndicator();
    }
  }

  Widget _buildCircularIndicator() {
    return SizedBox(
      width: _getSize(),
      height: _getSize(),
      child: CircularProgressIndicator(
        value: widget.value,
        color: widget.color ?? AppColors.primary,
        backgroundColor: widget.backgroundColor,
        strokeWidth: widget.strokeWidth ?? _getStrokeWidth(),
        semanticsLabel: widget.semanticsLabel,
        semanticsValue: widget.semanticsValue,
      ),
    );
  }

  Widget _buildLinearIndicator() {
    return SizedBox(
      width: _getLinearWidth(),
      height: _getStrokeWidth(),
      child: LinearProgressIndicator(
        value: widget.value,
        color: widget.color ?? AppColors.primary,
        backgroundColor: widget.backgroundColor ?? AppColors.neutral200,
        semanticsLabel: widget.semanticsLabel,
        semanticsValue: widget.semanticsValue,
      ),
    );
  }

  Widget _buildDotsIndicator() {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(3, (index) {
            final delay = index * 0.2;
            final animValue = (_animation.value - delay).clamp(0.0, 1.0);
            final scale = 0.5 + (0.5 * Curves.easeInOut.transform(animValue));
            
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
              child: Transform.scale(
                scale: scale,
                child: Container(
                  width: _getDotSize(),
                  height: _getDotSize(),
                  decoration: BoxDecoration(
                    color: widget.color ?? AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            );
          }),
        );
      },
    );
  }

  Widget _buildSpinnerIndicator() {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.rotate(
          angle: _controller.value * 2 * 3.14159,
          child: Container(
            width: _getSize(),
            height: _getSize(),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: widget.backgroundColor ?? AppColors.neutral200,
                width: _getStrokeWidth(),
              ),
            ),
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border(
                  top: BorderSide(
                    color: widget.color ?? AppColors.primary,
                    width: _getStrokeWidth(),
                  ),
                  right: BorderSide.none,
                  bottom: BorderSide.none,
                  left: BorderSide.none,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  double _getSize() {
    switch (widget.size) {
      case BaseLoadingSize.small:
        return 16;
      case BaseLoadingSize.medium:
        return 24;
      case BaseLoadingSize.large:
        return 32;
    }
  }

  double _getLinearWidth() {
    switch (widget.size) {
      case BaseLoadingSize.small:
        return 100;
      case BaseLoadingSize.medium:
        return 150;
      case BaseLoadingSize.large:
        return 200;
    }
  }

  double _getStrokeWidth() {
    switch (widget.size) {
      case BaseLoadingSize.small:
        return 2;
      case BaseLoadingSize.medium:
        return 3;
      case BaseLoadingSize.large:
        return 4;
    }
  }

  double _getDotSize() {
    switch (widget.size) {
      case BaseLoadingSize.small:
        return 6;
      case BaseLoadingSize.medium:
        return 8;
      case BaseLoadingSize.large:
        return 10;
    }
  }

  TextStyle _getMessageStyle() {
    switch (widget.size) {
      case BaseLoadingSize.small:
        return AppTypography.bodySmall.copyWith(
          color: AppColors.neutral600,
        );
      case BaseLoadingSize.medium:
        return AppTypography.bodyMedium.copyWith(
          color: AppColors.neutral600,
        );
      case BaseLoadingSize.large:
        return AppTypography.bodyLarge.copyWith(
          color: AppColors.neutral600,
        );
    }
  }
}

class BaseLoadingOverlay extends StatelessWidget {
  const BaseLoadingOverlay({
    super.key,
    required this.isLoading,
    required this.child,
    this.loadingWidget,
    this.backgroundColor,
    this.barrierDismissible = false,
  });

  final bool isLoading;
  final Widget child;
  final Widget? loadingWidget;
  final Color? backgroundColor;
  final bool barrierDismissible;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (isLoading)
          Positioned.fill(
            child: Container(
              color: backgroundColor ?? AppColors.overlay,
              child: Center(
                child: loadingWidget ??
                    const BaseLoading(
                      type: BaseLoadingType.circular,
                      size: BaseLoadingSize.medium,
                      message: 'Loading...',
                    ),
              ),
            ),
          ),
      ],
    );
  }
}

extension BaseLoadingFactory on BaseLoading {
  static Widget circular({
    Key? key,
    BaseLoadingSize size = BaseLoadingSize.medium,
    Color? color,
    double? value,
    String? message,
    double? strokeWidth,
  }) {
    return BaseLoading(
      key: key,
      type: BaseLoadingType.circular,
      size: size,
      color: color,
      value: value,
      message: message,
      strokeWidth: strokeWidth,
    );
  }

  static Widget linear({
    Key? key,
    BaseLoadingSize size = BaseLoadingSize.medium,
    Color? color,
    Color? backgroundColor,
    double? value,
    String? message,
  }) {
    return BaseLoading(
      key: key,
      type: BaseLoadingType.linear,
      size: size,
      color: color,
      backgroundColor: backgroundColor,
      value: value,
      message: message,
    );
  }

  static Widget dots({
    Key? key,
    BaseLoadingSize size = BaseLoadingSize.medium,
    Color? color,
    String? message,
  }) {
    return BaseLoading(
      key: key,
      type: BaseLoadingType.dots,
      size: size,
      color: color,
      message: message,
    );
  }

  static Widget spinner({
    Key? key,
    BaseLoadingSize size = BaseLoadingSize.medium,
    Color? color,
    Color? backgroundColor,
    String? message,
    double? strokeWidth,
  }) {
    return BaseLoading(
      key: key,
      type: BaseLoadingType.spinner,
      size: size,
      color: color,
      backgroundColor: backgroundColor,
      message: message,
      strokeWidth: strokeWidth,
    );
  }
}