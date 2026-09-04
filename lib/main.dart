import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme.dart';
import 'providers/auth_provider.dart';
import 'presentation/screens/login_screen.dart';
import 'presentation/screens/guest_dashboard_screen.dart';
import 'presentation/screens/main_nav_screen.dart';
import 'presentation/widgets/app_preloader.dart';

import 'package:flutter/foundation.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  
  FlutterError.onError = (FlutterErrorDetails details) {
    if (kDebugMode) {
      debugPrint('[FlutterError] ${details.exceptionAsString()}');
    }
  };

  PlatformDispatcher.instance.onError = (error, stack) {
    if (kDebugMode) {
      debugPrint('[PlatformError] $error');
    }
    return true; // prevent crash
  };

  runApp(
    const ProviderScope(
      child: GConnectMobileApp(),
    ),
  );
}

class GConnectMobileApp extends ConsumerWidget {
  const GConnectMobileApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);

    return MaterialApp(
      title: 'G-Connect Mobile',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      themeMode: ThemeMode.light, // Single Mode: Enforce clean Light Mode
      home: _resolveHomeScreen(authState),
    );
  }

  Widget _resolveHomeScreen(AuthState state) {
    if (state.isLoading) {
      return const AppPreloader(
        message: 'Menyiapkan sistem telemetri',
      );
    }

    if (state.isAuthenticated) {
      return const MainNavScreen();
    }

    if (state.isGuest) {
      return const GuestDashboardScreen();
    }

    return const LoginScreen();
  }
}
