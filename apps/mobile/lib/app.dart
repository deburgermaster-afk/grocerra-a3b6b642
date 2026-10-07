import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import 'core/config/app_config.dart';
import 'core/theme/app_theme.dart';
import 'features/account/presentation/account_routes.dart';
import 'features/auth/presentation/delivery_address_screen.dart';
import 'features/auth/presentation/location_permission_screen.dart';
import 'features/auth/presentation/onboarding_screen.dart';
import 'features/auth/presentation/sign_in_screen.dart';
import 'features/auth/presentation/splash_screen.dart';
import 'features/catering/presentation/catering_routes.dart';
import 'features/orders/presentation/orders_routes.dart';
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
///   Splash -> Onboarding -> Sign In / Create account -> Location Permission
///   -> Delivery Address -> Home
class GrocerraApp extends StatelessWidget {
  const GrocerraApp({super.key});

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
      initialRoute: startRoute,
      routes: <String, WidgetBuilder>{
        // Flutter stacks every prefix of a deep link, so `/` is always
        // built even when the URL is `/auth`. Only render the
        // auto-advancing splash when it is the genuine entry point,
        // otherwise a deep link flashes the splash and then navigates
        // away from the screen that was requested.
        SplashScreen.routeName: (_) => startRoute == SplashScreen.routeName
            ? const SplashScreen()
            : const ColoredBox(color: Color(0xFFFFFFFF)),
        OnboardingScreen.routeName: (_) => const OnboardingScreen(),
        SignInScreen.routeName: (_) => const SignInScreen(),
        LocationPermissionScreen.routeName: (_) => const LocationPermissionScreen(),
        DeliveryAddressScreen.routeName: (_) => const DeliveryAddressScreen(),
        HomeShell.routeName: (_) => const HomeShell(),
        // Per-section routes. Each section owns its own map so the screen
        // passes can be built independently without editing this file.
        ...shopRoutes,
        ...cateringRoutes,
        ...ordersRoutes,
        ...searchRoutes,
        ...supportRoutes,
        ...accountRoutes,
      },
    );
  }
}
