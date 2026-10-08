import 'package:flutter/material.dart';

import 'auth_theme.dart';
import 'auth_widgets.dart';
import 'motion.dart';

/// Layout shared by the form screens (reference: "Login Experience").
///
/// `‹ Back` and the theme toggle on top, a large title, then the content,
/// each piece rising into place one after another. Content scrolls under the
/// keyboard; [footer] stays pinned to the bottom when there is room.
class AuthPage extends StatelessWidget {
  const AuthPage({
    super.key,
    required this.title,
    this.subtitle,
    required this.children,
    this.footer,
    this.showBack = true,
  });

  final String title;
  final Widget? subtitle;
  final List<Widget> children;
  final Widget? footer;
  final bool showBack;

  @override
  Widget build(BuildContext context) {
    final AuthPalette p = AuthPalette.of(context);
    int order = 0;
    Widget step(Widget child) => Reveal(order: order++, child: child);

    return Scaffold(
      backgroundColor: p.background,
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: <Widget>[
          const Positioned.fill(child: AuthBackdrop()),
          SafeArea(
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () => FocusScope.of(context).unfocus(),
              child: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints c) {
                  return SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(24, 4, 24, 24),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(minHeight: c.maxHeight - 28),
                      child: IntrinsicHeight(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            SizedBox(
                              height: 48,
                              child: Row(
                                children: <Widget>[
                                  if (showBack) const BackPill(),
                                  const Spacer(),
                                  const ThemeToggle(),
                                ],
                              ),
                            ),
                            const SizedBox(height: 28),
                            step(
                              Semantics(
                                header: true,
                                child: Text(
                                  title,
                                  style: AuthType.title(p.ink),
                                ),
                              ),
                            ),
                            if (subtitle != null) ...<Widget>[
                              const SizedBox(height: 14),
                              step(
                                DefaultTextStyle(
                                  style: AuthType.body(p.muted),
                                  child: subtitle!,
                                ),
                              ),
                            ],
                            const SizedBox(height: 32),
                            for (final Widget child in children) step(child),
                            if (footer != null) ...<Widget>[
                              const Spacer(),
                              const SizedBox(height: 24),
                              step(footer!),
                            ],
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// "Don't have an account? **Sign up**".
class AuthSwitchLine extends StatelessWidget {
  const AuthSwitchLine({
    super.key,
    required this.prompt,
    required this.action,
    required this.onTap,
  });

  final String prompt;
  final String action;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final AuthPalette p = AuthPalette.of(context);
    return Center(
      child: Pressable(
        semanticLabel: action,
        pressedScale: 0.94,
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          child: Text.rich(
            TextSpan(
              text: '$prompt ',
              style: AuthType.small(p.muted),
              children: <InlineSpan>[
                TextSpan(
                  text: action,
                  style: AuthType.small(p.ink)
                      .copyWith(fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Small centred text link ("Forgot password?", "Resend code").
class AuthLink extends StatelessWidget {
  const AuthLink({
    super.key,
    required this.label,
    required this.onTap,
    this.underline = false,
  });

  final String label;
  final VoidCallback? onTap;
  final bool underline;

  @override
  Widget build(BuildContext context) {
    final AuthPalette p = AuthPalette.of(context);
    return Center(
      child: Pressable(
        semanticLabel: label,
        pressedScale: 0.94,
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: AnimatedDefaultTextStyle(
            duration: Motion.quick,
            style: AuthType.small(onTap == null ? p.faint : p.muted).copyWith(
              decoration: underline ? TextDecoration.underline : null,
              decorationColor: p.muted,
            ),
            child: Text(label),
          ),
        ),
      ),
    );
  }
}

/// Shows a floating message in the flow's style.
void showAuthMessage(
  BuildContext context,
  String message, {
  bool error = false,
}) {
  final AuthPalette p = AuthPalette.of(context);
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        backgroundColor: error ? p.danger : p.ink,
        content: Text(message, style: AuthType.small(p.background)),
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        duration: const Duration(seconds: 4),
      ),
    );
}
