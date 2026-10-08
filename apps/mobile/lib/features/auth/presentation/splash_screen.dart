import 'package:flutter/material.dart';

import '../../../core/services/session_store.dart';
import '../../../core/services/supabase_service.dart';
import 'auth_flow.dart';
import 'kit/auth_theme.dart';
import 'kit/auth_widgets.dart';
import 'kit/motion.dart';
import 'onboarding_screen.dart';
import 'welcome_screen.dart';

/// Launch screen: the GROCERRA wordmark resolves out of the dark, a green
/// rule draws under it, then the app moves on.
///
///   1. signed in            -> Home
///   2. onboarding not seen  -> Onboarding
///   3. otherwise            -> Welcome (Get started)
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  static const String routeName = '/';

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1300),
  )..forward();

  @override
  void initState() {
    super.initState();
    _advance();
  }

  Future<void> _advance() async {
    await AuthThemeMode.load();
    await Future<void>.delayed(const Duration(milliseconds: 1500));
    if (!mounted) return;

    if (SupabaseService.session != null) {
      AuthFlow.goHome(context);
      return;
    }
    final bool seen = await SessionStore.onboardingSeen();
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      FadeThroughRoute<void>(
        page: seen ? const WelcomeScreen() : const OnboardingScreen(),
      ),
    );
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AuthPalette p = AuthPalette.of(context);
    final Animation<double> mark = CurvedAnimation(
      parent: _c,
      curve: const Interval(0, 0.6, curve: Motion.enter),
    );
    final Animation<double> rule = CurvedAnimation(
      parent: _c,
      curve: const Interval(0.45, 1, curve: Motion.enter),
    );

    return Scaffold(
      backgroundColor: p.background,
      body: Stack(
        children: <Widget>[
          const Positioned.fill(child: AuthBackdrop()),
          Center(
            child: Semantics(
              label: 'GROCERRA',
              child: AnimatedBuilder(
                animation: _c,
                builder: (BuildContext context, Widget? _) => Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Opacity(
                      opacity: mark.value,
                      child: Transform.scale(
                        scale: 0.92 + 0.08 * mark.value,
                        child: ShaderMask(
                          // A soft edge sweeps left to right, unveiling the mark.
                          blendMode: BlendMode.dstIn,
                          shaderCallback: (Rect r) => LinearGradient(
                            colors: const <Color>[
                              Colors.white,
                              Colors.transparent,
                            ],
                            stops: <double>[
                              (mark.value * 1.3 - 0.15).clamp(0.0, 1.0),
                              (mark.value * 1.3).clamp(0.0, 1.0),
                            ],
                          ).createShader(r),
                          child: const Wordmark(width: 220),
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                    Container(
                      width: 56 * rule.value,
                      height: 3,
                      decoration: BoxDecoration(
                        color: p.accent,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
