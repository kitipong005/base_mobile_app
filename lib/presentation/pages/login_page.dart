import 'package:flutter/material.dart' hide Text;
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../features/auth/bloc/auth_bloc.dart';
import '../../features/auth/bloc/auth_event.dart';
import '../../features/auth/bloc/auth_state.dart';
import '../../core/design_system/typography.dart';
import '../../core/design_system/spacing.dart';
import '../widgets/base/layout/base_scaffold.dart';
import '../widgets/themed_widgets.dart';
import '../widgets/base/layout/base_card.dart';
import '../widgets/base/buttons/base_button.dart';
import '../widgets/base/inputs/base_text_field.dart';
import '../widgets/base/feedback/base_snackbar.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffoldFactory.withoutAppBar(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthError) {
              BaseSnackbarFactory.error(
                context: context,
                message: state.message,
              );
            }
          },
          builder: (context, state) {
            return Center(
              child: SingleChildScrollView(
                padding: AppSpacing.paddingLG,
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      BaseCardFactory.elevated(
                        child: Column(
                          children: [
                            Icon(
                              Icons.login,
                              size: 64,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            AppSpacing.vSpaceLG,
                            Text(
                              'Base Mobile',
                              style: AppTypography.h3.themed(context),
                            ),
                            AppSpacing.vSpaceXS,
                            Text(
                              'Sign in to continue',
                              style: AppTypography.bodyMedium.alphaOnSurface(context, light: 0.6, dark: 0.8),
                            ),
                            AppSpacing.vSpaceXL,
                            BaseTextFieldFactory.email(
                              controller: _emailController,
                              label: 'Email',
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your email';
                                }
                                if (!value.contains('@')) {
                                  return 'Please enter a valid email';
                                }
                                return null;
                              },
                            ),
                            AppSpacing.vSpaceMD,
                            BaseTextFieldFactory.password(
                              controller: _passwordController,
                              label: 'Password',
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your password';
                                }
                                return null;
                              },
                            ),
                            AppSpacing.vSpaceXL,
                            BaseButtonFactory.primary(
                              text: 'Login',
                              icon: Icons.login,
                              width: double.infinity,
                              isLoading: state is AuthLoading,
                              onPressed: state is AuthLoading
                                  ? null
                                  : () {
                                      if (_formKey.currentState!.validate()) {
                                        context.read<AuthBloc>().add(
                                              LoginRequested(
                                                email: _emailController.text.trim(),
                                                password: _passwordController.text,
                                              ),
                                            );
                                      }
                                    },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
    );
  }
}