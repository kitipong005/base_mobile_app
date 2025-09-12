import 'package:flutter/material.dart' hide Text;
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/design_system/spacing.dart';
import '../../core/design_system/typography.dart';
import '../../features/example/bloc/example_bloc.dart';
import '../screens/showcase/design_system_screen.dart';
import '../screens/showcase/widgets_showcase_screen.dart';
import '../widgets/base/buttons/base_button.dart';
import '../widgets/base/layout/base_card.dart';
import '../widgets/base/layout/base_scaffold.dart';
import '../widgets/themed_widgets.dart';

class DeveloperPage extends StatefulWidget {
  const DeveloperPage({super.key});

  @override
  State<DeveloperPage> createState() => _DeveloperPageState();
}

class _DeveloperPageState extends State<DeveloperPage> {
  @override
  Widget build(BuildContext context) {
    return BaseScaffoldFactory.simple(
        title: 'Developer Tools',
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: SingleChildScrollView(
          padding: AppSpacing.paddingLG,
          child: BlocBuilder<ExampleBloc, ExampleState>(
            builder: (context, state) {
              if (state is ExampleInitial) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: BaseCardFactory.elevated(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.developer_mode,
                              size: 48,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            AppSpacing.vSpaceMD,
                            Text(
                              'Welcome to Developer Tools!',
                              style: AppTypography.h5.themed(context),
                              textAlign: TextAlign.center,
                            ),
                            AppSpacing.vSpaceXS,
                            const Text(
                              'Try the BLoC State Management demo below',
                              style: AppTypography.bodyMedium,
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                    AppSpacing.vSpaceXL,
                    BaseCardFactory.filled(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Current State: ExampleInitial',
                          ),
                          AppSpacing.vSpaceXS,
                          Text(
                            'Ready to start demo',
                            style: AppTypography.bodySmall.copyWith(
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    AppSpacing.vSpaceXL,
                    BaseCardFactory.outlined(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Developer Actions',
                            style: AppTypography.h6.themed(context),
                          ),
                          AppSpacing.vSpaceMD,
                          BaseButtonFactory.primary(
                            text: 'Demo BLoC State',
                            icon: Icons.play_circle,
                            width: double.infinity,
                            onPressed: () {
                              context
                                  .read<ExampleBloc>()
                                  .add(const LoadExample());
                            },
                          ),
                          AppSpacing.vSpaceSM,
                          BaseButtonFactory.secondary(
                            text: 'Widgets Showcase',
                            icon: Icons.widgets,
                            width: double.infinity,
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const WidgetsShowcaseScreen(),
                                ),
                              );
                            },
                          ),
                          AppSpacing.vSpaceSM,
                          BaseButtonFactory.outline(
                            text: 'Design System',
                            icon: Icons.palette,
                            width: double.infinity,
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const DesignSystemScreen(),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              } else if (state is ExampleLoading) {
                return Center(
                  child: BaseCardFactory.elevated(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircularProgressIndicator(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        AppSpacing.vSpaceLG,
                        const Text(
                          'BLoC State: Loading',
                          style: AppTypography.h5,
                          textAlign: TextAlign.center,
                        ),
                        AppSpacing.vSpaceXS,
                        const Text(
                          'Current State: ExampleLoading',
                          style: AppTypography.labelMedium,
                          textAlign: TextAlign.center,
                        ),
                        AppSpacing.vSpaceXS,
                        Text(
                          'Next State: ExampleLoaded (in 5 seconds)',
                          style: AppTypography.bodySmall.copyWith(
                            color: Theme.of(context).colorScheme.secondary,
                            fontStyle: FontStyle.italic,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        AppSpacing.vSpaceXS,
                        Text(
                          'Simulating async data loading...',
                          style: AppTypography.caption.alphaOnSurface(context, light: 0.6, dark: 0.8),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                );
              } else if (state is ExampleLoaded) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.check_circle,
                        color: Theme.of(context).colorScheme.primary,
                        size: 64,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        state.data,
                        style: AppTypography.h5,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'This is a demo of BLoC state management',
                        style: AppTypography.bodyMedium.alphaOnSurface(context, light: 0.6, dark: 0.8),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3)),
                        ),
                        child: Column(
                          children: [
                            Text(
                              'Current State: ExampleLoaded',
                              style: AppTypography.labelMedium.copyWith(
                                color: Theme.of(context).colorScheme.primary,
                                fontFamily: 'monospace',
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Data: "${state.data}"',
                              style: AppTypography.bodySmall.copyWith(
                                color: Theme.of(context).colorScheme.primary,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'State contains loaded data from async operation',
                              style: AppTypography.caption.copyWith(
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content:
                                  Text('BLoC State Demo: Snackbar triggered!'),
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        },
                        child: const Text('Show Snackbar Demo'),
                      ),
                      const SizedBox(height: 10),
                      TextButton(
                        onPressed: () {
                          // Reset to initial state
                          context.read<ExampleBloc>().add(const ResetExample());
                        },
                        child: const Text('Reset BLoC State'),
                      ),
                    ],
                  ),
                );
              } else if (state is ExampleError) {
                return Center(
                  child: Text('Error: ${state.message}'),
                );
              }
              return Container();
            },
          ),
        ));
  }
}
