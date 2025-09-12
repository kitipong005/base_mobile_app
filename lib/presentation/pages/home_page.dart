import 'package:flutter/material.dart' hide Text;
import '../../core/config/app_config.dart';
import '../../core/design_system/typography.dart';
import '../../core/design_system/spacing.dart';
import '../widgets/base/layout/base_scaffold.dart';
import '../widgets/base/layout/base_card.dart';
import '../widgets/base/buttons/base_button.dart';
import '../widgets/themed_widgets.dart'; // This gives us both ThemedText and auto-themed Text
import '../screens/showcase/widgets_showcase_screen.dart';
import '../screens/showcase/design_system_screen.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScaffoldFactory.simple(
      title: AppConfig.appName,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SingleChildScrollView(
        padding: AppSpacing.paddingLG,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            BaseCardFactory.elevated(
              child: Column(
                children: [
                  Icon(
                    Icons.home,
                    size: 64,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  AppSpacing.vSpaceMD,
                  ThemedText.h4('Welcome Home!'),
                  AppSpacing.vSpaceXS,
                  Text(
                    'Your beautiful home page built with base widgets',
                    style: AppTypography.bodyMedium, // Auto-themed!
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            AppSpacing.vSpaceXL,
            BaseCardFactory.outlined(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ThemedText.h5('Quick Actions'),
                  AppSpacing.vSpaceMD,
                  BaseButtonFactory.primary(
                    text: 'View Widget Showcase',
                    icon: Icons.widgets,
                    width: double.infinity,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const WidgetsShowcaseScreen(),
                        ),
                      );
                    },
                  ),
                  AppSpacing.vSpaceSM,
                  BaseButtonFactory.secondary(
                    text: 'Design System',
                    icon: Icons.palette,
                    width: double.infinity,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const DesignSystemScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            AppSpacing.vSpaceXL,
            BaseCardFactory.filled(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: Theme.of(context).colorScheme.primary,
                        size: 20,
                      ),
                      AppSpacing.hSpaceXS,
                      ThemedText.h6('About This App'),
                    ],
                  ),
                  AppSpacing.vSpaceMD,
                  Text(
                    'This is a Flutter app built with:',
                    style: AppTypography.bodyMedium, // Auto-themed!
                  ),
                  AppSpacing.vSpaceXS,
                  _buildFeatureItem(context, '🎨 Custom Design System'),
                  _buildFeatureItem(context, '🧩 Reusable Base Widgets'),
                  _buildFeatureItem(context, '🏗️ Clean Architecture'),
                  _buildFeatureItem(context, '📱 Material Design 3'),
                  _buildFeatureItem(context, '🔄 BLoC State Management'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureItem(BuildContext context, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.xs),
      child: ThemedText.bodySmall(
        text,
        lightAlpha: 0.7,
        darkAlpha: 0.9,
      ),
    );
  }
}
