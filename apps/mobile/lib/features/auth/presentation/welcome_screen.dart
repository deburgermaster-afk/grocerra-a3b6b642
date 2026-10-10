import 'package:flutter/material.dart';

import '../../../core/config/app_config.dart';
import '../../../core/services/auth_service.dart';
import 'auth_flow.dart';
import 'kit/auth_page.dart';
import 'kit/auth_theme.dart';
import 'kit/auth_widgets.dart';
import 'kit/motion.dart';
import 'kit/scenes.dart';
import 'sign_in_screen.dart';
import 'sign_up_screen.dart';

/// Get started: an illustrated collage of the service, the motto, and three
/// ways in - Apple, Google or email - all anchored to the bottom. The email
/// form lives on its own screen so this one stays clean.
class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  static const String routeName = '/welcome';

  Future<void> _social(
    BuildContext context,
    Future<AuthResult> Function() run,
  ) async {
    if (!AppConfig.oauthEnabled) {
      showAuthMessage(
        context,
        'Apple and Google sign-in are coming soon. Continue with email for now.',
      );
      return;
    }
    final AuthResult result = await run();
    if (!context.mounted) return;
    if (!result.ok) showAuthMessage(context, result.message, error: true);
  }

  @override
  Widget build(BuildContext context) {
    final AuthPalette p = AuthPalette.of(context);
    final TextStyle hero = AuthType.hero(p.ink).copyWith(fontSize: 34);

    return Scaffold(
      backgroundColor: p.background,
      body: Stack(
        children: <Widget>[
          const Positioned.fill(child: AuthBackdrop()),
          SafeArea(
            child: Column(
              children: <Widget>[
                const SizedBox(
                  height: 48,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: <Widget>[
                        Reveal(child: Wordmark(width: 118)),
                        Spacer(),
                        ThemeToggle(),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 4, 16, 0),
                    child: Scene(pieces: Scenes.welcome()),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 4, 20, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Reveal(
                        order: 4,
                        child: Text.rich(
                          TextSpan(
                            text: 'Fresh groceries and\ncatering, delivered\n',
                            children: <InlineSpan>[
                              TextSpan(
                                text: 'to you.',
                                style: AuthType.accent(p.accent, 34),
                              ),
                            ],
                          ),
                          style: hero,
                        ),
                      ),
                      const SizedBox(height: 18),
                      Reveal(
                        order: 5,
                        child: AuthButton(
                          label: 'Continue with Apple',
                          variant: AuthButtonVariant.secondary,
                          leading: const BrandMark.apple(),
                          onPressed: () =>
                              _social(context, AuthService.signInWithApple),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Reveal(
                        order: 6,
                        child: AuthButton(
                          label: 'Continue with Google',
                          variant: AuthButtonVariant.secondary,
                          leading: const BrandMark.google(),
                          onPressed: () =>
                              _social(context, AuthService.signInWithGoogle),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Reveal(
                        order: 7,
                        child: AuthButton(
                          label: 'Continue with email',
                          leading: Icon(
                            Icons.mail_outline_rounded,
                            size: 20,
                            color: p.onPrimary,
                          ),
                          onPressed: () => Navigator.of(
                            context,
                          ).push(AuthRoute<void>(page: const SignInScreen())),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Reveal(
                        order: 8,
                        child: AuthSwitchLine(
                          prompt: 'New to Grocerra?',
                          action: 'Create account',
                          onTap: () => Navigator.of(
                            context,
                          ).push(AuthRoute<void>(page: const SignUpScreen())),
                        ),
                      ),
                      // Demo builds only (GROCERRA_DEMO_MODE): walk the app
                      // without an account. Hidden once demo mode is off.
                      if (AppConfig.bypassAuthentication)
                        Center(
                          child: Pressable(
                            onTap: () => AuthFlow.goHome(context),
                            child: Padding(
                              padding: const EdgeInsets.all(6),
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
