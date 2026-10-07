import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'core/config/app_config.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/presentation/delivery_address_screen.dart';
import 'features/auth/presentation/location_permission_screen.dart';
import 'features/auth/presentation/onboarding_screen.dart';
import 'features/auth/presentation/sign_in_screen.dart';
import 'features/auth/presentation/splash_screen.dart';
import 'features/shell/presentation/home_shell.dart';

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
    // The route this session actually started on. On web that is the
    // deep-linked path (`/auth`, `/home`, ...); on mobile it is `/`.
    final String startRoute = ui.PlatformDispatcher.instance.defaultRouteName;

    return MaterialApp(
      title: AppConfig.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      initialRoute: startRoute,
      builder: (BuildContext context, Widget? child) {
        if (child == null) return const SizedBox.shrink();
        return LayoutBuilder(
          builder: (BuildContext ctx, BoxConstraints constraints) {
            if (kIsWeb && constraints.maxWidth > 520) {
              return Scaffold(
                backgroundColor: const Color(0xFF0F172A),
                body: Center(
                  child: Container(
                    constraints: const BoxConstraints(
                      maxWidth: 430,
                      maxHeight: 932,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(40),
                      boxShadow: const <BoxShadow>[
                        BoxShadow(
                          color: Color(0x66000000),
                          blurRadius: 36,
                          offset: Offset(0, 12),
                        ),
                      ],
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: child,
                  ),
                ),
              );
            }
            return child;
          },
        );
      },
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
      },
    );
  }
}
