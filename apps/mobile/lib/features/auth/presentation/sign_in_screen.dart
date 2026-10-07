import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../core/config/app_config.dart';
import '../../../core/services/auth_service.dart';
import '../../shell/presentation/home_shell.dart';
import 'location_permission_screen.dart';

/// Blueprint `Sign In / Welcome Screen` / `Create account`.
///
/// The two designs are one screen with a segmented control, so they share
/// this widget and only the active mode differs. Wired controls:
///   * `Sign in` tab          -> switches to sign-in mode
///   * `Create account` tab   -> opens `Create account` (mode switch)
///   * `Continue with Apple`  -> Supabase API gateway (OAuth)
///   * `Continue with Google` -> Supabase API gateway (OAuth)
///   * `Forgot password?`     -> Supabase API gateway (reset email)
///   * `Sign in` submit       -> opens `Groceries & Catering Home`
///   * `Create account` submit-> opens `Location Permission`
///
/// Geometry below is transcribed from the approved Figma frame `A5 · Sign in`
/// (390x844): 16px gutters, a uniform 14px vertical rhythm, 56px buttons on a
/// 28 radius, 52px inputs on a 16 radius, and Inter throughout.
class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key, this.mode = AuthMode.signIn});

  static const String routeName = '/auth';

  final AuthMode mode;

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

enum AuthMode { signIn, createAccount }

/// Figma frames carry a 47px status bar. Where the platform reports no inset
/// (web), reserve that space anyway so the content sits where it does in the
/// approved design instead of jamming against the window edge.
double topInsetFor(BuildContext context) =>
    math.max(MediaQuery.of(context).padding.top, 47);

class _SignInScreenState extends State<SignInScreen> {
  late AuthMode _mode = widget.mode;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _name = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();

  bool _obscurePassword = true;
  bool _busy = false;
  String? _notice;

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  void _switchMode(AuthMode mode) {
    if (mode == _mode) return;
    setState(() {
      _mode = mode;
      _notice = null;
    });
  }

  void _showNotice(String message, {bool error = false}) {
    setState(() => _notice = message);
    if (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: const Color(0xFFDC2626),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Future<void> _submit() async {
    // Development/demo bypass - see `AppConfig.demoMode`. While the Supabase
    // auth backend is unconfigured the primary button continues the approved
    // flow instead of checking credentials. No UI changes and no session is
    // minted; passing `--dart-define=GROCERRA_DEMO_MODE=false` (or configuring
    // Supabase) restores the real path below untouched.
    final bool demo = AppConfig.bypassAuthentication;
    if (!demo && !_formKey.currentState!.validate()) return;
    setState(() {
      _busy = true;
      _notice = null;
    });

    if (demo) {
      // Show the approved loading state for a beat, then continue.
      await Future<void>.delayed(const Duration(milliseconds: 450));
      if (!mounted) return;
      setState(() => _busy = false);
      _continue();
      return;
    }

    final AuthResult result = _mode == AuthMode.signIn
        ? await AuthService.signIn(
            email: _email.text.trim(),
            password: _password.text,
          )
        : await AuthService.signUp(
            name: _name.text.trim(),
            email: _email.text.trim(),
            password: _password.text,
          );

    if (!mounted) return;
    setState(() => _busy = false);

    if (!result.ok) {
      _showNotice(result.message, error: true);
      return;
    }
    if (result.isPendingConfirmation) {
      // Account exists but the email is unconfirmed: stay here and wait.
      _showNotice(result.message);
      return;
    }

    _continue();
  }

  /// Leaves the sign-in screen the way a successful auth does.
  void _continue() {
    if (_mode == AuthMode.createAccount) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute<void>(builder: (_) => const LocationPermissionScreen()),
      );
    } else {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute<void>(builder: (_) => const HomeShell()),
        (Route<dynamic> route) => false,
      );
    }
  }

  Future<void> _oauth(Future<AuthResult> Function() run) async {
    if (!AppConfig.oauthEnabled) {
      _showNotice(
        'Google and Apple sign-in are not enabled on the Supabase project yet. '
        'Use email and password for now.',
        error: true,
      );
      return;
    }
    setState(() => _busy = true);
    final AuthResult result = await run();
    if (!mounted) return;
    setState(() => _busy = false);
    if (!result.ok) {
      _showNotice(result.message, error: true);
      return;
    }
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute<void>(builder: (_) => const HomeShell()),
      (Route<dynamic> route) => false,
    );
  }

  Future<void> _forgotPassword() async {
    if (_email.text.trim().isEmpty || !_email.text.contains('@')) {
      _showNotice('Enter your email above first, then tap Forgot password.', error: true);
      return;
    }
    setState(() => _busy = true);
    final AuthResult result = await AuthService.sendPasswordReset(
      email: _email.text.trim(),
    );
    if (!mounted) return;
    setState(() => _busy = false);
    _showNotice(result.message, error: !result.ok);
  }

  @override
  Widget build(BuildContext context) {
    final bool signingUp = _mode == AuthMode.createAccount;
    final double topInset = topInsetFor(context);

    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      body: SafeArea(
        top: false,
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            return SingleChildScrollView(
              // 9px under the reserved status bar puts the wordmark on the
              // Figma y=56 line; 53px at the foot lands the legal line at
              // Figma y=776.
              padding: EdgeInsets.fromLTRB(16, topInset + 9, 16, 53),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight - (topInset + 9) - 53,
                ),
                child: IntrinsicHeight(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        const Text(
                          AppConfig.appName,
                          style: TextStyle(
                            color: Color(0xFF000000),
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 2.52, // Figma: 14% of 18
                          ),
                        ),
                        const SizedBox(height: 9),
                        Text(
                          signingUp ? 'Create account' : 'Welcome back',
                          style: const TextStyle(
                            color: Color(0xFF000000),
                            fontSize: 30,
                            fontWeight: FontWeight.w700,
                            letterSpacing: -0.6, // Figma: -2% of 30
                          ),
                        ),
                        const SizedBox(height: 28),

                        _ModeSegment(mode: _mode, onChanged: _switchMode),
                        const SizedBox(height: 14),

                        FilledButton(
                          onPressed: _busy ? null : () => _oauth(AuthService.signInWithApple),
                          child: const Text('Continue with Apple'),
                        ),
                        const SizedBox(height: 14),

                        OutlinedButton(
                          onPressed: _busy ? null : () => _oauth(AuthService.signInWithGoogle),
                          style: OutlinedButton.styleFrom(
                            minimumSize: const Size.fromHeight(56),
                            foregroundColor: const Color(0xFF000000),
                            side: const BorderSide(color: Color(0xFFE6E6E6)),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(28),
                            ),
                            textStyle: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          child: const Text('Continue with Google'),
                        ),
                        const SizedBox(height: 14),

                        const _Divider(label: 'or'),
                        const SizedBox(height: 14),

                        if (signingUp) ...<Widget>[
                          const _FieldLabel('Full name'),
                          TextFormField(
                            controller: _name,
                            textCapitalization: TextCapitalization.words,
                            autofillHints: const <String>[AutofillHints.name],
                            validator: (String? value) =>
                                (value == null || value.trim().length < 2)
                                    ? 'Enter your name'
                                    : null,
                            decoration: const InputDecoration(hintText: 'Your name'),
                          ),
                          const SizedBox(height: 14),
                        ],

                        const _FieldLabel('Email'),
                        TextFormField(
                          controller: _email,
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          autofillHints: const <String>[AutofillHints.email],
                          validator: (String? value) {
                            final String v = (value ?? '').trim();
                            if (v.isEmpty || !v.contains('@') || !v.contains('.')) {
                              return 'Enter a valid email address';
                            }
                            return null;
                          },
                          decoration: const InputDecoration(hintText: 'you@example.com'),
                        ),
                        const SizedBox(height: 14),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            const _FieldLabel('Password', bottom: 0),
                            if (!signingUp)
                              GestureDetector(
                                onTap: _busy ? null : _forgotPassword,
                                child: const Text(
                                  'Forgot password?',
                                  style: TextStyle(
                                    color: Color(0xFF000000),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        TextFormField(
                          controller: _password,
                          obscureText: _obscurePassword,
                          textInputAction: TextInputAction.done,
                          autofillHints: signingUp
                              ? const <String>[AutofillHints.newPassword]
                              : const <String>[AutofillHints.password],
                          validator: (String? value) {
                            final String v = value ?? '';
                            if (signingUp) {
                              if (v.length < 8) return 'At least 8 characters';
                            } else if (v.isEmpty) {
                              return 'Enter your password';
                            }
                            return null;
                          },
                          onFieldSubmitted: (_) => _submit(),
                          decoration: InputDecoration(
                            hintText: signingUp ? 'At least 8 characters' : 'Enter your password',
                            suffixIcon: signingUp
                                ? TextButton(
                                    onPressed: () =>
                                        setState(() => _obscurePassword = !_obscurePassword),
                                    child: Text(
                                      _obscurePassword ? 'Show' : 'Hide',
                                      style: const TextStyle(
                                        color: Color(0xFF000000),
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  )
                                : null,
                          ),
                        ),

                        if (_notice != null) ...<Widget>[
                          const SizedBox(height: 14),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF3F3F3),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Text(
                              _notice!,
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontSize: 13, color: Color(0xFF000000)),
                            ),
                          ),
                        ],

                        const SizedBox(height: 14),
                        // Figma `Button · Sign in` is a solid black 56px CTA.
                        FilledButton(
                          onPressed: _busy ? null : _submit,
                          child: _busy
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(strokeWidth: 2),
                                )
                              : Text(signingUp ? 'Create account' : 'Sign in'),
                        ),

                        // Dev/demo escape hatch (not in Figma): lets a reviewer
                        // reach the app shell without credentials. Only wired
                        // when the demo bypass flag is on.
                        if (AppConfig.bypassAuthentication) ...<Widget>[
                          const SizedBox(height: 12),
                          OutlinedButton(
                            onPressed: () => Navigator.of(context)
                                .pushNamedAndRemoveUntil(HomeShell.routeName, (_) => false),
                            style: OutlinedButton.styleFrom(
                              minimumSize: const Size.fromHeight(56),
                              foregroundColor: const Color(0xFF111114),
                              side: const BorderSide(color: Color(0xFFE6E6E6)),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(28),
                              ),
                              textStyle: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            child: const Text('Explore as guest'),
                          ),
                        ],

                        // Push the legal line to the Figma y=776 baseline.
                        // Centred across the full 358px column: at 326.1px the
                        // string is a fraction too wide for a 326px box and
                        // would wrap, whereas centring here puts it at x=32 -
                        // exactly where the Figma text node sits - on one line.
                        const Spacer(),
                        const Text(
                          'By continuing you agree to our Terms and Privacy Policy.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF6B6B6B),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _ModeSegment extends StatelessWidget {
  const _ModeSegment({required this.mode, required this.onChanged});

  final AuthMode mode;
  final ValueChanged<AuthMode> onChanged;

  @override
  Widget build(BuildContext context) {
    // Figma `Segmented`: 48 tall, r24, 4px inset, `#f3f3f3` track.
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: const Color(0xFFF3F3F3),
        borderRadius: BorderRadius.circular(24),
      ),
      padding: const EdgeInsets.all(4),
      child: Row(
        children: <Widget>[
          _SegmentButton(
            label: 'Sign in',
            selected: mode == AuthMode.signIn,
            onTap: () => onChanged(AuthMode.signIn),
          ),
          const SizedBox(width: 4),
          _SegmentButton(
            label: 'Create account',
            selected: mode == AuthMode.createAccount,
            onTap: () => onChanged(AuthMode.createAccount),
          ),
        ],
      ),
    );
  }
}

class _SegmentButton extends StatelessWidget {
  const _SegmentButton({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    // Figma segment: 40 tall on a 20 radius; both states use 14/600 text and
    // pure black - selection is carried by the fill alone.
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          height: double.infinity,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: selected ? const Color(0xFF000000) : Colors.transparent,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            label,
            style: const TextStyle(
              color: Color(0xFF000000),
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ).copyWith(color: selected ? const Color(0xFFFFFFFF) : const Color(0xFF000000)),
          ),
        ),
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    // Figma `Divider · or`: 161px hairlines either side of a 12px `or`,
    // with a 12px gap and a 15px total height.
    return SizedBox(
      height: 15,
      child: Row(
        children: <Widget>[
          const Expanded(child: Divider(color: Color(0xFFE6E6E6))),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Color(0xFF6B6B6B),
              ),
            ),
          ),
          const Expanded(child: Divider(color: Color(0xFFE6E6E6))),
        ],
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  const _FieldLabel(this.text, {this.bottom = 6});

  final String text;
  final double bottom;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: bottom),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: Color(0xFF6B6B6B),
        ),
      ),
    );
  }
}
