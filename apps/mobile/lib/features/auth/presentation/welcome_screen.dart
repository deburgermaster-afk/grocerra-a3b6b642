import 'package:flutter/material.dart';

import '../../../core/config/app_config.dart';
import 'auth_flow.dart';
import 'kit/auth_theme.dart';
import 'kit/auth_widgets.dart';
import 'kit/motion.dart';
import 'kit/scenes.dart';
import 'sign_in_screen.dart';
import 'sign_up_screen.dart';

/// Get started (reference: "Manage Tasks, Master Time."). An illustrated
/// collage of the whole service floats above the headline, then Create
/// account and Sign in.
class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  static const String routeName = '/welcome';

  @override
  Widget build(BuildContext context) {
    final AuthPalette p = AuthPalette.of(context);
    final TextStyle hero = AuthType.hero(p.ink).copyWith(fontSize: 38);

    return Scaffold(
      backgroundColor: p.background,
      body: Stack(
        children: <Widget>[
          const Positioned.fill(child: AuthBackdrop()),
          SafeArea(
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 52,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: <Widget>[
                        const Reveal(child: Wordmark(width: 118)),
                        const Spacer(),
                        const ThemeToggle(),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                    child: Scene(pieces: Scenes.welcome()),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 8, 24, 20),
                  child: Column(
                    children: <Widget>[
                      Reveal(
                        order: 4,
                        child: Text.rich(
                          TextSpan(
                            text: 'Halal groceries,\ndelivered ',
                            children: <InlineSpan>[
                              TextSpan(
                                text: 'fresh.',
                                style: AuthType.accent(p.accent, 38),
                              ),
                            ],
                          ),
                          textAlign: TextAlign.center,
                          style: hero,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Reveal(
                        order: 5,
                        child: Text(
                          'Meat, spices, rice and catering from Melbourne '
                          'stores you trust, at your door in minutes.',
                          textAlign: TextAlign.center,
                          style: AuthType.body(p.muted),
                        ),
                      ),
                      const SizedBox(height: 28),
                      Reveal(
                        order: 6,
                        child: AuthButton(
                          label: 'Create account',
                          onPressed: () => Navigator.of(
                            context,
                          ).push(AuthRoute<void>(page: const SignUpScreen())),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Reveal(
                        order: 7,
                        child: AuthButton(
                          label: 'Sign in',
                          variant: AuthButtonVariant.secondary,
                          onPressed: () => Navigator.of(
                            context,
                          ).push(AuthRoute<void>(page: const SignInScreen())),
                        ),
                      ),
                      // Demo builds only (no Supabase config): walk the app
                      // without an account. Never shown once auth is wired.
                      if (AppConfig.bypassAuthentication)
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Pressable(
                            onTap: () => AuthFlow.goHome(context),
                            child: Padding(
                              padding: const EdgeInsets.all(8),
                              child: Text(
                                'Explore as guest',
                                style: AuthType.small(p.muted),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
