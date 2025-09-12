import 'package:flutter/material.dart' hide Text;
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../features/auth/bloc/auth_bloc.dart';
import '../../features/auth/bloc/auth_event.dart';
import '../../features/auth/bloc/auth_state.dart';
import '../../features/theme/cubit/theme_cubit.dart';
import '../../core/design_system/typography.dart';
import '../../core/design_system/spacing.dart';
import '../widgets/base/layout/base_scaffold.dart';
import '../widgets/base/layout/base_card.dart';
import '../widgets/base/buttons/base_button.dart';
import '../widgets/base/feedback/base_dialog.dart';
import '../widgets/themed_widgets.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _notificationsEnabled = true;
  bool _biometricEnabled = false;
  String _selectedLanguage = 'English';

  @override
  Widget build(BuildContext context) {
    return BaseScaffoldFactory.simple(
      title: 'Settings',
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SingleChildScrollView(
        padding: AppSpacing.paddingLG,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Account Settings
            Text(
              'Account',
              style: AppTypography.h5.themed(context),
            ),
            AppSpacing.vSpaceSM,
            
            BaseCardFactory.outlined(
              child: Column(
                children: [
                  _buildSettingsTile(
                    icon: Icons.person,
                    iconColor: Theme.of(context).colorScheme.primary,
                    title: 'Profile Settings',
                    subtitle: 'Edit your personal information',
                    onTap: () {},
                  ),
                  Divider(color: Theme.of(context).dividerColor),
                  _buildSettingsTile(
                    icon: Icons.security,
                    iconColor: Theme.of(context).colorScheme.secondary,
                    title: 'Privacy & Security',
                    subtitle: 'Manage your account security',
                    onTap: () {},
                  ),
                  Divider(color: Theme.of(context).dividerColor),
                  _buildSettingsTile(
                    icon: Icons.lock,
                    iconColor: Theme.of(context).colorScheme.tertiary,
                    title: 'Change Password',
                    subtitle: 'Update your login password',
                    onTap: () {},
                  ),
                ],
              ),
            ),
            
            AppSpacing.vSpaceLG,
            
            // App Preferences
            Text(
              'Preferences',
              style: AppTypography.h5.themed(context),
            ),
            AppSpacing.vSpaceSM,
            
            BaseCardFactory.outlined(
              child: Column(
                children: [
                  _buildSwitchTile(
                    icon: Icons.notifications,
                    iconColor: Theme.of(context).colorScheme.primary,
                    title: 'Notifications',
                    subtitle: 'Enable push notifications',
                    value: _notificationsEnabled,
                    onChanged: (value) {
                      setState(() {
                        _notificationsEnabled = value;
                      });
                    },
                  ),
                  Divider(color: Theme.of(context).dividerColor),
                  BlocBuilder<ThemeCubit, ThemeState>(
                    builder: (context, themeState) {
                      return _buildThemeTile(
                        currentTheme: themeState.themeMode,
                        onThemeChanged: (themeMode) {
                          context.read<ThemeCubit>().setTheme(themeMode);
                        },
                      );
                    },
                  ),
                  Divider(color: Theme.of(context).dividerColor),
                  _buildSwitchTile(
                    icon: Icons.fingerprint,
                    iconColor: Theme.of(context).colorScheme.error,
                    title: 'Biometric Login',
                    subtitle: 'Use fingerprint or face ID',
                    value: _biometricEnabled,
                    onChanged: (value) {
                      setState(() {
                        _biometricEnabled = value;
                      });
                    },
                  ),
                  Divider(color: Theme.of(context).dividerColor),
                  _buildSettingsTile(
                    icon: Icons.language,
                    iconColor: Theme.of(context).colorScheme.secondary,
                    title: 'Language',
                    subtitle: _selectedLanguage,
                    onTap: () {
                      _showLanguageDialog();
                    },
                  ),
                ],
              ),
            ),
            
            AppSpacing.vSpaceLG,
            
            // Support & Information
            Text(
              'Support & Information',
              style: AppTypography.h5.themed(context),
            ),
            AppSpacing.vSpaceSM,
            
            BaseCardFactory.outlined(
              child: Column(
                children: [
                  _buildSettingsTile(
                    icon: Icons.help,
                    iconColor: Theme.of(context).colorScheme.primary,
                    title: 'Help & Support',
                    subtitle: 'Get help and contact support',
                    onTap: () {},
                  ),
                  Divider(color: Theme.of(context).dividerColor),
                  _buildSettingsTile(
                    icon: Icons.info,
                    iconColor: Theme.of(context).colorScheme.tertiary,
                    title: 'About',
                    subtitle: 'App version and information',
                    onTap: () {
                      _showAboutDialog();
                    },
                  ),
                  Divider(color: Theme.of(context).dividerColor),
                  _buildSettingsTile(
                    icon: Icons.privacy_tip,
                    iconColor: Theme.of(context).colorScheme.primary,
                    title: 'Privacy Policy',
                    subtitle: 'Read our privacy policy',
                    onTap: () {},
                  ),
                  Divider(color: Theme.of(context).dividerColor),
                  _buildSettingsTile(
                    icon: Icons.description,
                    iconColor: Theme.of(context).colorScheme.secondary,
                    title: 'Terms of Service',
                    subtitle: 'Read terms and conditions',
                    onTap: () {},
                  ),
                ],
              ),
            ),
            
            AppSpacing.vSpaceLG,
            
            // Logout Button
            BlocBuilder<AuthBloc, AuthState>(
              builder: (context, state) {
                final isLoading = state is AuthLoading;
                return BaseButtonFactory.danger(
                  text: isLoading ? 'Logging out...' : 'Logout',
                  icon: Icons.logout,
                  width: double.infinity,
                  isLoading: isLoading,
                  onPressed: isLoading ? null : () {
                    _showLogoutDialog();
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildSettingsTile({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: iconColor.withValues(alpha: 0.1),
        child: Icon(icon, color: iconColor),
      ),
      title: Text(
        title,
        style: AppTypography.bodyLarge,
      ),
      subtitle: Text(
        subtitle,
        style: AppTypography.bodySmall.alphaOnSurface(context, light: 0.6, dark: 0.8),
      ),
      trailing: Icon(
        Icons.chevron_right,
        color: Theme.of(context).brightness == Brightness.dark
            ? Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7)
            : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
      ),
      onTap: onTap,
    );
  }

  Widget _buildSwitchTile({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: iconColor.withValues(alpha: 0.1),
        child: Icon(icon, color: iconColor),
      ),
      title: Text(
        title,
        style: AppTypography.bodyLarge,
      ),
      subtitle: Text(
        subtitle,
        style: AppTypography.bodySmall.alphaOnSurface(context, light: 0.6, dark: 0.8),
      ),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: Theme.of(context).colorScheme.primary,
      ),
    );
  }

  Widget _buildThemeTile({
    required ThemeMode currentTheme,
    required ValueChanged<ThemeMode> onThemeChanged,
  }) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.1),
        child: Icon(Icons.dark_mode, color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7)),
      ),
      title: const Text(
        'Theme',
        style: AppTypography.bodyLarge,
      ),
      subtitle: Text(
        'Current: ${_getThemeDisplayName(currentTheme)}',
        style: AppTypography.bodySmall.alphaOnSurface(context, light: 0.6, dark: 0.8),
      ),
      trailing: DropdownButton<ThemeMode>(
        value: currentTheme,
        underline: const SizedBox.shrink(),
        items: [
          DropdownMenuItem(
            value: ThemeMode.light,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.light_mode, size: 16),
                const SizedBox(width: 8),
                Text('Light', style: AppTypography.bodySmall),
              ],
            ),
          ),
          DropdownMenuItem(
            value: ThemeMode.dark,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.dark_mode, size: 16),
                const SizedBox(width: 8),
                Text('Dark', style: AppTypography.bodySmall),
              ],
            ),
          ),
          DropdownMenuItem(
            value: ThemeMode.system,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.settings, size: 16),
                const SizedBox(width: 8),
                Text('System', style: AppTypography.bodySmall),
              ],
            ),
          ),
        ],
        onChanged: (ThemeMode? value) {
          if (value != null) {
            onThemeChanged(value);
          }
        },
      ),
    );
  }

  String _getThemeDisplayName(ThemeMode themeMode) {
    switch (themeMode) {
      case ThemeMode.light:
        return 'Light';
      case ThemeMode.dark:
        return 'Dark';
      case ThemeMode.system:
        return 'System';
    }
  }
  
  void _showLanguageDialog() async {
    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Select Language',
          style: AppTypography.h6.themed(context),
        ),
        backgroundColor: Theme.of(context).colorScheme.surface,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<String>(
              title: const Text(
                'English',
                style: AppTypography.bodyMedium,
              ),
              value: 'English',
              groupValue: _selectedLanguage,
              activeColor: Theme.of(context).colorScheme.primary,
              onChanged: (value) {
                Navigator.pop(context, value);
              },
            ),
            RadioListTile<String>(
              title: const Text(
                'Thai',
                style: AppTypography.bodyMedium,
              ),
              value: 'Thai',
              groupValue: _selectedLanguage,
              activeColor: Theme.of(context).colorScheme.primary,
              onChanged: (value) {
                Navigator.pop(context, value);
              },
            ),
          ],
        ),
      ),
    );
    
    if (result != null && mounted) {
      setState(() {
        _selectedLanguage = result;
      });
    }
  }
  
  void _showAboutDialog() {
    BaseDialogFactory.info(
      context: context,
      title: 'About Base Mobile',
      contentWidget: const Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Version: 1.0.0',
            style: AppTypography.bodyMedium,
          ),
          AppSpacing.vSpaceXS,
          Text(
            'Build: 100',
            style: AppTypography.bodyMedium,
          ),
          AppSpacing.vSpaceXS,
          Text(
            '© 2024 Base Mobile Company',
            style: AppTypography.bodyMedium,
          ),
          AppSpacing.vSpaceMD,
          Text(
            'A comprehensive HR management solution for modern workplaces.',
            style: AppTypography.bodySmall,
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