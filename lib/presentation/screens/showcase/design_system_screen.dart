import 'package:flutter/material.dart';
import '../../widgets/base/layout/base_scaffold.dart';
import '../../widgets/base/layout/base_card.dart';
import '../../widgets/base/layout/base_container.dart';
import '../../../core/design_system/colors.dart';
import '../../../core/design_system/typography.dart';
import '../../../core/design_system/spacing.dart';

class DesignSystemScreen extends StatelessWidget {
  const DesignSystemScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScaffoldFactory.simple(
      title: 'Design System',
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SingleChildScrollView(
        padding: AppSpacing.paddingLG,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildOverviewSection(),
            AppSpacing.vSpaceXXL,
            _buildColorsSection(),
            AppSpacing.vSpaceXXL,
            _buildTypographySection(),
            AppSpacing.vSpaceXXL,
            _buildSpacingSection(),
            AppSpacing.vSpaceXXL,
            _buildComponentsSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildOverviewSection() {
    return BaseCardFactory.elevated(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Design System Overview', style: AppTypography.h4),
          AppSpacing.vSpaceMD,
          const Text(
            'Our design system provides a consistent visual language and user experience across the entire application. It includes color palettes, typography scales, spacing units, and reusable components.',
            style: AppTypography.bodyMedium,
          ),
          AppSpacing.vSpaceMD,
          _buildFeaturesList(),
        ],
      ),
    );
  }

  Widget _buildFeaturesList() {
    const features = [
      'Consistent color palette with semantic colors',
      'Typography scale based on Material Design',
      '8px grid system for spacing and sizing',
      'Reusable component library',
      'Dark and light theme support',
      'Accessibility-first approach',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: features.map((feature) => Padding(
        padding: const EdgeInsets.only(bottom: AppSpacing.xs),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(
              Icons.check_circle,
              color: AppColors.success,
              size: 16,
            ),
            AppSpacing.hSpaceXS,
            Expanded(
              child: Text(
                feature,
                style: AppTypography.bodySmall,
              ),
            ),
          ],
        ),
      )).toList(),
    );
  }

  Widget _buildColorsSection() {
    return BaseCardFactory.elevated(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Color Palette', style: AppTypography.h4),
          AppSpacing.vSpaceMD,
          const Text(
            'Our color system is built around primary and secondary colors, with neutral colors for backgrounds and text.',
            style: AppTypography.bodyMedium,
          ),
          AppSpacing.vSpaceLG,
          
          _buildColorCategory('Primary Colors', [
            const ColorInfo('Primary', AppColors.primary, AppColors.onPrimary),
            const ColorInfo('Primary Dark', AppColors.primaryDark, AppColors.onPrimary),
            const ColorInfo('Primary Light', AppColors.primaryLight, AppColors.onSurface),
          ]),
          AppSpacing.vSpaceLG,
          
          _buildColorCategory('Secondary Colors', [
            const ColorInfo('Secondary', AppColors.secondary, AppColors.onSecondary),
            const ColorInfo('Secondary Dark', AppColors.secondaryDark, AppColors.onSecondary),
            const ColorInfo('Secondary Light', AppColors.secondaryLight, AppColors.onSurface),
          ]),
          AppSpacing.vSpaceLG,
          
          _buildColorCategory('Semantic Colors', [
            const ColorInfo('Success', AppColors.success, AppColors.onPrimary),
            const ColorInfo('Warning', AppColors.warning, AppColors.onSurface),
            const ColorInfo('Error', AppColors.error, AppColors.onError),
            const ColorInfo('Info', AppColors.info, AppColors.onPrimary),
          ]),
          AppSpacing.vSpaceLG,
          
          _buildNeutralColors(),
        ],
      ),
    );
  }

  Widget _buildColorCategory(String title, List<ColorInfo> colors) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: AppTypography.h6),
        AppSpacing.vSpaceSM,
        LayoutBuilder(
          builder: (context, constraints) {
            return Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              children: colors.map((colorInfo) => SizedBox(
                width: (constraints.maxWidth - AppSpacing.sm * 2) / 3,
                child: _buildColorSwatch(colorInfo),
              )).toList(),
            );
          },
        ),
      ],
    );
  }

  Widget _buildColorSwatch(ColorInfo colorInfo) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return BaseContainerFactory.outlined(
          size: BaseContainerSize.custom,
          width: null, // Let it adapt to available space
          height: 80,
          padding: EdgeInsets.zero,
          borderColor: AppColors.border,
          child: Column(
            children: [
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: colorInfo.color,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(AppSpacing.radiusSM),
                      topRight: Radius.circular(AppSpacing.radiusSM),
                    ),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.palette,
                      color: colorInfo.onColor,
                      size: 20,
                    ),
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                padding: AppSpacing.paddingXS,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(AppSpacing.radiusSM),
                    bottomRight: Radius.circular(AppSpacing.radiusSM),
                  ),
                ),
                child: Column(
                  children: [
                    Text(
                      colorInfo.name,
                      style: AppTypography.labelSmall,
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      _colorToHex(colorInfo.color),
                      style: AppTypography.overline.copyWith(
                        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildNeutralColors() {
    const neutralColors = [
      ColorInfo('Neutral 900', AppColors.neutral900, AppColors.onPrimary),
      ColorInfo('Neutral 800', AppColors.neutral800, AppColors.onPrimary),
      ColorInfo('Neutral 700', AppColors.neutral700, AppColors.onPrimary),
      ColorInfo('Neutral 600', AppColors.neutral600, AppColors.onPrimary),
      ColorInfo('Neutral 500', AppColors.neutral500, AppColors.onSurface),
      ColorInfo('Neutral 400', AppColors.neutral400, AppColors.onSurface),
      ColorInfo('Neutral 300', AppColors.neutral300, AppColors.onSurface),
      ColorInfo('Neutral 200', AppColors.neutral200, AppColors.onSurface),
      ColorInfo('Neutral 100', AppColors.neutral100, AppColors.onSurface),
      ColorInfo('Neutral 50', AppColors.neutral50, AppColors.onSurface),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Neutral Colors', style: AppTypography.h6),
        AppSpacing.vSpaceSM,
        LayoutBuilder(
          builder: (context, constraints) {
            final crossAxisCount = constraints.maxWidth > 600 ? 5 : 
                                 constraints.maxWidth > 400 ? 3 : 2;
            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: AppSpacing.sm,
                mainAxisSpacing: AppSpacing.sm,
                childAspectRatio: 1.5,
              ),
              itemCount: neutralColors.length,
              itemBuilder: (context, index) => _buildColorSwatch(neutralColors[index]),
            );
          },
        ),
      ],
    );
  }

  Widget _buildTypographySection() {
    return BaseCardFactory.elevated(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Typography', style: AppTypography.h4),
          AppSpacing.vSpaceMD,
          const Text(
            'Our typography system uses a modular scale based on Material Design guidelines.',
            style: AppTypography.bodyMedium,
          ),
          AppSpacing.vSpaceLG,
          
          _buildTypographyCategory('Display Styles', [
            const TypographyInfo('Display Large', AppTypography.displayLarge, '57px / 64px'),
            const TypographyInfo('Display Medium', AppTypography.displayMedium, '45px / 52px'),
            const TypographyInfo('Display Small', AppTypography.displaySmall, '36px / 44px'),
          ]),
          AppSpacing.vSpaceLG,
          
          _buildTypographyCategory('Headline Styles', [
            const TypographyInfo('Headline 1', AppTypography.h1, '32px / 40px'),
            const TypographyInfo('Headline 2', AppTypography.h2, '28px / 36px'),
            const TypographyInfo('Headline 3', AppTypography.h3, '24px / 32px'),
            const TypographyInfo('Headline 4', AppTypography.h4, '20px / 28px'),
            const TypographyInfo('Headline 5', AppTypography.h5, '18px / 26px'),
            const TypographyInfo('Headline 6', AppTypography.h6, '16px / 24px'),
          ]),
          AppSpacing.vSpaceLG,
          
          _buildTypographyCategory('Body Styles', [
            const TypographyInfo('Body Large', AppTypography.bodyLarge, '16px / 24px'),
            const TypographyInfo('Body Medium', AppTypography.bodyMedium, '14px / 20px'),
            const TypographyInfo('Body Small', AppTypography.bodySmall, '12px / 16px'),
          ]),
          AppSpacing.vSpaceLG,
          
          _buildTypographyCategory('Label Styles', [
            const TypographyInfo('Label Large', AppTypography.labelLarge, '14px / 20px'),
            const TypographyInfo('Label Medium', AppTypography.labelMedium, '12px / 16px'),
            const TypographyInfo('Label Small', AppTypography.labelSmall, '11px / 16px'),
          ]),
        ],
      ),
    );
  }

  Widget _buildTypographyCategory(String title, List<TypographyInfo> styles) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: AppTypography.h6),
        AppSpacing.vSpaceSM,
        ...styles.map((info) => _buildTypographyExample(info)),
      ],
    );
  }

  Widget _buildTypographyExample(TypographyInfo info) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      padding: AppSpacing.paddingMD,
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(AppSpacing.radiusSM),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  info.name, 
                  style: AppTypography.labelMedium,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              AppSpacing.hSpaceXS,
              Text(info.spec, style: AppTypography.labelSmall.copyWith(
                color: AppColors.neutral600,
              )),
            ],
          ),
          AppSpacing.vSpaceXS,
          Text(
            'The quick brown fox jumps over the lazy dog',
            style: info.style,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildSpacingSection() {
    return BaseCardFactory.elevated(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Spacing System', style: AppTypography.h4),
          AppSpacing.vSpaceMD,
          const Text(
            'Our spacing system is based on an 8px grid system for consistent layouts.',
            style: AppTypography.bodyMedium,
          ),
          AppSpacing.vSpaceLG,
          
          _buildSpacingGrid(),
          AppSpacing.vSpaceLG,
          
          const Text('Usage Examples', style: AppTypography.h6),
          AppSpacing.vSpaceSM,
          _buildSpacingExamples(),
        ],
      ),
    );
  }

  Widget _buildSpacingGrid() {
    const spacingValues = [
      SpacingInfo('None', 0, AppSpacing.none),
      SpacingInfo('XS', 4, AppSpacing.xs),
      SpacingInfo('SM', 8, AppSpacing.sm),
      SpacingInfo('MD', 12, AppSpacing.md),
      SpacingInfo('LG', 16, AppSpacing.lg),
      SpacingInfo('XL', 20, AppSpacing.xl),
      SpacingInfo('XXL', 24, AppSpacing.xxl),
      SpacingInfo('XXXL', 32, AppSpacing.xxxl),
    ];

    return Column(
      children: spacingValues.map((info) => Container(
        margin: const EdgeInsets.only(bottom: AppSpacing.sm),
        child: Row(
          children: [
            SizedBox(
              width: 60,
              child: Text(info.name, style: AppTypography.labelMedium),
            ),
            SizedBox(
              width: 40,
              child: Text('${info.pixels}px', style: AppTypography.bodySmall),
            ),
            AppSpacing.hSpaceMD,
            Container(
              width: info.value,
              height: 16,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ],
        ),
      )).toList(),
    );
  }

  Widget _buildSpacingExamples() {
    return Column(
      children: [
        _buildSpacingExample('Padding SM', AppSpacing.paddingSM),
        AppSpacing.vSpaceMD,
        _buildSpacingExample('Padding MD', AppSpacing.paddingMD),
        AppSpacing.vSpaceMD,
        _buildSpacingExample('Padding LG', AppSpacing.paddingLG),
      ],
    );
  }

  Widget _buildSpacingExample(String title, EdgeInsets padding) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: AppTypography.labelMedium),
        AppSpacing.vSpaceXS,
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.border),
            borderRadius: BorderRadius.circular(AppSpacing.radiusSM),
          ),
          child: Container(
            padding: padding,
            decoration: BoxDecoration(
              color: AppColors.primaryLight.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppSpacing.radiusSM),
            ),
            child: Container(
              padding: AppSpacing.paddingSM,
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(AppSpacing.radiusXS),
              ),
              child: const Text('Content Area', style: AppTypography.bodySmall),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildComponentsSection() {
    return BaseCardFactory.elevated(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Component Library', style: AppTypography.h4),
          AppSpacing.vSpaceMD,
          const Text(
            'Our component library provides consistent, reusable UI elements that follow our design system.',
            style: AppTypography.bodyMedium,
          ),
          AppSpacing.vSpaceLG,
          
          _buildComponentGrid(),
        ],
      ),
    );
  }

  Widget _buildComponentGrid() {
    const components = [
      ComponentInfo('Buttons', Icons.smart_button, 'Primary, Secondary, Outline, Text, Danger'),
      ComponentInfo('Inputs', Icons.input, 'Text Field, Dropdown, Checkbox, Radio'),
      ComponentInfo('Cards', Icons.credit_card, 'Elevated, Outlined, Filled variants'),
      ComponentInfo('Navigation', Icons.navigation, 'App Bar, Bottom Navigation, Tabs'),
      ComponentInfo('Feedback', Icons.feedback, 'Dialogs, Snackbars, Alerts'),
      ComponentInfo('State', Icons.hourglass_empty, 'Loading, Empty, Error states'),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = constraints.maxWidth > 500 ? 2 : 1;
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: AppSpacing.md,
            mainAxisSpacing: AppSpacing.md,
            childAspectRatio: crossAxisCount == 1 ? 3.0 : 1.2,
          ),
          itemCount: components.length,
          itemBuilder: (context, index) => _buildComponentCard(components[index]),
        );
      },
    );
  }

  Widget _buildComponentCard(ComponentInfo info) {
    return BaseContainerFactory.outlined(
      padding: AppSpacing.paddingMD,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isNarrow = constraints.maxWidth < 200;
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                info.icon,
                size: isNarrow ? 24 : 32,
                color: AppColors.primary,
              ),
              AppSpacing.vSpaceSM,
              Text(
                info.name,
                style: isNarrow ? AppTypography.labelMedium : AppTypography.labelLarge,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              AppSpacing.vSpaceXS,
              Flexible(
                child: Text(
                  info.description,
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.neutral600,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: isNarrow ? 3 : 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  String _colorToHex(Color color) {
    return '#${color.toARGB32().toRadixString(16).padLeft(8, '0').substring(2).toUpperCase()}';
  }
}

class ColorInfo {
  final String name;
  final Color color;
  final Color onColor;

  const ColorInfo(this.name, this.color, this.onColor);
}

class TypographyInfo {
  final String name;
  final TextStyle style;
  final String spec;

  const TypographyInfo(this.name, this.style, this.spec);
}

class SpacingInfo {
  final String name;
  final int pixels;
  final double value;

  const SpacingInfo(this.name, this.pixels, this.value);
}

class ComponentInfo {
  final String name;
  final IconData icon;
  final String description;

  const ComponentInfo(this.name, this.icon, this.description);
}