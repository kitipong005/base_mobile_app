import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../core/di/injection.dart';
import '../core/config/app_config.dart';
import '../core/theme/app_theme.dart';
import '../features/auth/bloc/auth_bloc.dart';
import '../features/auth/bloc/auth_event.dart';
import '../features/auth/bloc/auth_state.dart';
import '../features/example/bloc/example_bloc.dart';
import '../features/theme/cubit/theme_cubit.dart';
import 'pages/login_page.dart';
import 'widgets/main_navigation.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => getIt<AuthBloc>()..add(CheckAuthStatus()),
        ),
        BlocProvider(
          create: (context) => getIt<ThemeCubit>(),
        ),
      ],
      child: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, themeState) {
          return MaterialApp(
            title: AppConfig.appName,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeState.themeMode,
            home: const AuthWrapper(),
            routes: {
              '/login': (context) => const LoginPage(),
              '/home': (context) => const AuthWrapper(),
            },
          );
        },
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  final int initialTabIndex;
  
  const AuthWrapper({super.key, this.initialTabIndex = 0});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthError) {
          // Only show SnackBar for actual authentication errors, not API errors
          if (state.message.contains('Login failed') || 
              state.message.contains('Logout failed') || 
              state.message.contains('unexpected error')) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        }
      },
      builder: (context, state) {
        if (state is AuthLoading || state is AuthInitial) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else if (state is AuthAuthenticated) {
          return MultiBlocProvider(
            providers: [
              BlocProvider(create: (context) => getIt<ExampleBloc>()),
            ],
            child: MainNavigation(initialTabIndex: initialTabIndex),
          );
        } else {
          return const LoginPage();
        }
      },
    );
  }
}