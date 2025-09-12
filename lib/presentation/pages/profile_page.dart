import 'package:flutter/material.dart' hide Text;
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../features/auth/bloc/auth_bloc.dart';
import '../../features/auth/bloc/auth_event.dart';
import '../../features/auth/bloc/auth_state.dart';
import '../../data/repositories/auth_repository.dart';
import '../../core/di/injection.dart';
import '../../core/design_system/typography.dart';
import '../../core/design_system/spacing.dart';
import '../widgets/base/layout/base_scaffold.dart';
import '../widgets/themed_widgets.dart';
import '../widgets/base/layout/base_card.dart';
import '../widgets/base/buttons/base_button.dart';
import '../widgets/base/feedback/base_dialog.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return BaseScaffoldFactory.simple(
      title: 'Profile',
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          if (state is AuthAuthenticated) {
            final userData = getIt<AuthRepository>().getSavedUserData();
            
            if (userData != null) {
              return SingleChildScrollView(
                padding: AppSpacing.paddingLG,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Profile Header
                    SizedBox(
                      width: double.infinity,
                      child: BaseCardFactory.elevated(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              width: 120,
                              height: 120,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                              ),
                              child: Icon(
                                Icons.person,
                                size: 60,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                            AppSpacing.vSpaceMD,
                            Text(
                              userData.name ?? 'Unknown User',
                              style: AppTypography.h4.themed(context),
                              textAlign: TextAlign.center,
                            ),
                            AppSpacing.vSpaceXS,
                            Text(
                              userData.email,
                              style: AppTypography.bodyMedium.alphaOnSurface(context, light: 0.6, dark: 0.8),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                    
                    AppSpacing.vSpaceXL,
                    
                    // Profile Information Card
                    BaseCardFactory.outlined(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Profile Information',
                            style: AppTypography.h6.themed(context),
                          ),
                          AppSpacing.vSpaceMD,
                            _buildInfoRow('User ID', userData.id),
                            _buildInfoRow('Email', userData.email),
                            if (userData.name != null)
                              _buildInfoRow('Name', userData.name!),
                            if (userData.department != null)
                              _buildInfoRow('Department', userData.department!),
                            if (userData.position != null)
                              _buildInfoRow('Position', userData.position!),
                        ],
                      ),
                    ),
                    
                    AppSpacing.vSpaceXL,
                    
                    // Action Buttons
                    BaseButtonFactory.danger(
                      text: 'Logout',
                      icon: Icons.logout,
                      width: double.infinity,
                      onPressed: () {
                        _showLogoutDialog();
                      },
                    ),
                  ],
                ),
              );
            }
          }
          
          return Center(
            child: BaseCardFactory.elevated(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.person_off,
                    size: 64,
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7)
                        : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
                  ),
                  AppSpacing.vSpaceMD,
                  Text(
                    'No user data available',
                    style: AppTypography.h6.themed(context),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: AppTypography.labelMedium.alphaOnSurface(context, light: 0.6, dark: 0.8),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: AppTypography.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog() async {
    final result = await BaseDialogFactory.confirmation(
      context: context,
      title: 'Logout',
      content: 'Are you sure you want to logout?',
      confirmText: 'Logout',
    );
    
    if (result == true && mounted) {
      context.read<AuthBloc>().add(LogoutRequested());
    }
  }
}