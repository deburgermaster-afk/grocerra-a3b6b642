import 'package:flutter/material.dart';

import 'auth_theme.dart';
import 'auth_widgets.dart';
import 'motion.dart';

/// Layout shared by the form screens.
///
/// Compact and thumb-first: a slim top bar (back, centred wordmark, theme
/// toggle), then everything else anchored to the bottom of the screen - the
/// title, a one-line subtitle, the form and the footer - with tight, even
/// spacing. Each piece rises into place in turn. When the keyboard opens the
/// content scrolls instead of squashing.
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
                    reverse: true,
                    padding: const EdgeInsets.fromLTRB(20, 4, 20, 16),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(minHeight: c.maxHeight - 20),
                      child: IntrinsicHeight(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            SizedBox(
                              height: 44,
                              child: Stack(
                                alignment: Alignment.center,
                                children: <Widget>[
                                  const Reveal(child: Wordmark(width: 120)),
                                  Row(
                                    children: <Widget>[
                                      if (showBack) const BackPill(),
                                      const Spacer(),
                                      const ThemeToggle(),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const Spacer(),
                            const SizedBox(height: 24),
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
                              const SizedBox(height: 8),
                              step(
                                DefaultTextStyle(
                                  style: AuthType.body(p.muted),
                                  child: subtitle!,
                                ),
                              ),
                            ],
                            const SizedBox(height: 20),
                            for (final Widget child in children) step(child),
                            if (footer != null) ...<Widget>[
                              const SizedBox(height: 14),
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
    this.alignment = Alignment.center,
  });

  final String label;
  final VoidCallback? onTap;
  final bool underline;
  final AlignmentGeometry alignment;

  @override
  Widget build(BuildContext context) {
    final AuthPalette p = AuthPalette.of(context);
    return Align(
      alignment: alignment,
      child: Pressable(
        semanticLabel: label,
        pressedScale: 0.94,
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
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
