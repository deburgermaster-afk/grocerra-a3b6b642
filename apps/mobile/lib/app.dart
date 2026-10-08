import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'core/config/app_config.dart';
import 'core/services/supabase_service.dart';
import 'core/theme/app_theme.dart';
import 'features/account/presentation/account_routes.dart';
import 'features/auth/presentation/delivery_address_screen.dart';
import 'features/auth/presentation/forgot_password_screen.dart';
import 'features/auth/presentation/kit/auth_theme.dart';
import 'features/auth/presentation/kit/motion.dart';
import 'features/auth/presentation/location_permission_screen.dart';
import 'features/auth/presentation/new_password_screen.dart';
import 'features/auth/presentation/onboarding_screen.dart';
import 'features/auth/presentation/sign_in_screen.dart';
import 'features/auth/presentation/sign_up_screen.dart';
import 'features/auth/presentation/splash_screen.dart';
import 'features/auth/presentation/welcome_screen.dart';
import 'features/catering/presentation/catering_routes.dart';
import 'features/search/presentation/search_routes.dart';
import 'features/shell/presentation/home_shell.dart';
import 'features/shop/presentation/shop_routes.dart';
import 'features/support/presentation/support_routes.dart';

/// Root widget of the Grocerra customer app.
///
/// Screen set and navigation follow the Reevake blueprint
/// `User App - Frontend` (app: User app): a light, Apple-inspired UI with a
/// restrained green accent and a floating five-tab navigation bar
/// (Home - Browse - Catering - Orders - Profile).
///
/// Route table mirrors the blueprint flow:
///   Splash -> Onboarding -> Welcome -> Sign In / Sign Up (-> Verify code)
///   -> Location Permission -> Delivery Address -> Home
/// with Forgot password -> Verify code -> New password off Sign In.
class GrocerraApp extends StatefulWidget {
  const GrocerraApp({super.key});

  @override
  State<GrocerraApp> createState() => _GrocerraAppState();
}

class _GrocerraAppState extends State<GrocerraApp> {
  final GlobalKey<NavigatorState> _navigator = GlobalKey<NavigatorState>();
  StreamSubscription<AuthState>? _auth;

  @override
  void initState() {
    super.initState();
    // Opening the link in a password-reset email (instead of typing the
    // code) signs the user in for recovery: take them straight to
    // "Create new password".
    //
    // When a session ends (signed out here or on another device, refresh
    // token revoked, account removed), leave the signed-in app and return
    // to Welcome so nothing keeps showing data that is no longer theirs.
    _auth = SupabaseService.authStateChanges.listen((AuthState state) {
      switch (state.event) {
        case AuthChangeEvent.passwordRecovery:
          _navigator.currentState?.push(
            AuthRoute<void>(page: const NewPasswordScreen()),
          );
        case AuthChangeEvent.signedOut:
          _navigator.currentState?.pushAndRemoveUntil(
            FadeThroughRoute<void>(page: const WelcomeScreen()),
            (Route<dynamic> _) => false,
          );
        default:
          break;
      }
    });
  }

  @override
  void dispose() {
    _auth?.cancel();
    super.dispose();
  }

  /// Auth-flow screens get their own dark / light palette and Geist type.
  static WidgetBuilder _scoped(Widget screen) =>
      (_) => AuthScope(child: screen);

  @override
  Widget build(BuildContext context) {
    // On web with hash routing, `defaultRouteName` includes the `#` prefix
    // (e.g. `/#/home`). Routes are registered without it, so strip it.
    String startRoute = ui.PlatformDispatcher.instance.defaultRouteName;
    if (startRoute.startsWith('/#')) {
      startRoute = startRoute.substring(1); // '/#/home' -> '/home'
    } else if (startRoute.startsWith('#')) {
      startRoute = startRoute.substring(1); // '#/home' -> '/home'
    }

    return MaterialApp(
      title: AppConfig.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      navigatorKey: _navigator,
      initialRoute: startRoute,
      routes: <String, WidgetBuilder>{
        // Flutter stacks every prefix of a deep link, so `/` is always
        // built even when the URL is `/auth`. Only render the
        // auto-advancing splash when it is the genuine entry point,
        // otherwise a deep link flashes the splash and then navigates
        // away from the screen that was requested.
        SplashScreen.routeName: _scoped(
          startRoute == SplashScreen.routeName
              ? const SplashScreen()
              : const ColoredBox(color: Color(0xFF0A0B0A)),
        ),
        OnboardingScreen.routeName: _scoped(const OnboardingScreen()),
        WelcomeScreen.routeName: _scoped(const WelcomeScreen()),
        SignInScreen.routeName: _scoped(const SignInScreen()),
        SignUpScreen.routeName: _scoped(const SignUpScreen()),
        ForgotPasswordScreen.routeName: _scoped(const ForgotPasswordScreen()),
        NewPasswordScreen.routeName: _scoped(const NewPasswordScreen()),
        LocationPermissionScreen.routeName: (_) =>
            const LocationPermissionScreen(),
        DeliveryAddressScreen.routeName: (_) => const DeliveryAddressScreen(),
        HomeShell.routeName: (_) => const HomeShell(),
        // Per-section routes. Each section owns its own map so the screen
        // passes can be built independently without editing this file.
        ...shopRoutes,
        ...cateringRoutes,
        ...searchRoutes,
        ...supportRoutes,
        ...accountRoutes,
      },
    );
  }
}
