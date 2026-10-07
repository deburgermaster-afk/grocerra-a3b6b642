import 'package:flutter/material.dart';

import '../../../core/config/app_config.dart';
import '../../../core/services/session_store.dart';
import '../../../core/services/supabase_service.dart';
import '../../auth/presentation/onboarding_screen.dart';
import '../../auth/presentation/sign_in_screen.dart';
import '../../shell/presentation/home_shell.dart';

/// Blueprint `Splash Screen` â€” "Displays the app logo on launch before
/// transitioning to the main screen."
///
/// Resolution order after the brand beat:
///   1. signed in            -> Home shell
///   2. onboarding not seen  -> Onboarding
///   3. otherwise            -> Sign In / Welcome
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  static const String routeName = '/';

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _advance();
  }

  Future<void> _advance() async {
    // Hold the brand beat long enough to be perceptible, per the design.
    await Future<void>.delayed(const Duration(milliseconds: 1200));
    if (!mounted) return;

    final bool signedIn = SupabaseService.session != null;
    final bool seenOnboarding = await SessionStore.onboardingSeen();
    if (!mounted) return;

    final Widget next = signedIn
        ? const HomeShell()
        : seenOnboarding
            ? const SignInScreen()
            : const OnboardingScreen();

    Navigator.of(context).pushReplacement(
      PageRouteBuilder<void>(
        pageBuilder: (_, _, _) => next,
        transitionsBuilder: (_, animation, _, child) =>
            FadeTransition(opacity: animation, child: child),
        transitionDuration: const Duration(milliseconds: 420),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFFFFFFFF),
      body: Center(
        child: Text(
          AppConfig.appName,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Color(0xFF111114),
            fontSize: 34,
            fontWeight: FontWeight.w700,
            letterSpacing: 6,
          ),
        ),
      ),
    );
  }
}
