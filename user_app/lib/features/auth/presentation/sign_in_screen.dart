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
class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key, this.mode = AuthMode.signIn});

  static const String routeName = '/auth';

  final AuthMode mode;

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

enum AuthMode { signIn, createAccount }

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
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _busy = true;
      _notice = null;
    });

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

    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                const Text(
                  AppConfig.appName,
                  style: TextStyle(
                    color: Color(0xFF111114),
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 4,
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  signingUp ? 'Create account' : 'Welcome back',
                  style: const TextStyle(
                    color: Color(0xFF111114),
                    fontSize: 32,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.8,
                  ),
                ),
                const SizedBox(height: 24),

                // Segmented Sign in / Create account control.
                _ModeSegment(
                  mode: _mode,
                  onChanged: _switchMode,
                ),
                const SizedBox(height: 16),

                FilledButton(
                  onPressed: _busy ? null : () => _oauth(AuthService.signInWithApple),
                  child: const Text('Continue with Apple'),
                ),
                const SizedBox(height: 12),
                OutlinedButton(
                  onPressed: _busy ? null : () => _oauth(AuthService.signInWithGoogle),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size.fromHeight(54),
                    foregroundColor: const Color(0xFF111114),
                    side: const BorderSide(color: Color(0xFFE4E4E8)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                    textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  child: const Text('Continue with Google'),
                ),
                const SizedBox(height: 20),

                const _Divider(label: 'or'),
                const SizedBox(height: 20),

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
                  const SizedBox(height: 16),
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
                const SizedBox(height: 16),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    const _FieldLabel('Password'),
                    if (!signingUp)
                      GestureDetector(
                        onTap: _busy ? null : _forgotPassword,
                        child: const Text(
                          'Forgot password?',
                          style: TextStyle(
                            color: Color(0xFF111114),
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                  ],
                ),
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
                            onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                            child: Text(
                              _obscurePassword ? 'Show' : 'Hide',
                              style: const TextStyle(
                                color: Color(0xFF111114),
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          )
                        : null,
                  ),
                ),
                if (signingUp) const SizedBox(height: 8),

                if (_notice != null) ...<Widget>[
                  const SizedBox(height: 14),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F1F3),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      _notice!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 13, color: Color(0xFF111114)),
                    ),
                  ),
                ],

                const SizedBox(height: 24),
                FilledButton(
                  onPressed: _busy ? null : _submit,
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFFEFEFF1),
                    foregroundColor: const Color(0xFF111114),
                    minimumSize: const Size.fromHeight(54),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                    textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  child: _busy
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(signingUp ? 'Create account' : 'Sign in'),
                ),

                const SizedBox(height: 64),
                const Text(
                  'By continuing you agree to our Terms and Privacy Policy.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 13, color: Color(0xFF9A9AA3)),
                ),
              ],
            ),
          ),
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
    return Container(
      height: 52,
      decoration: BoxDecoration(
        color: const Color(0xFFF1F1F3),
        borderRadius: BorderRadius.circular(26),
      ),
      padding: const EdgeInsets.all(4),
      child: Row(
        children: <Widget>[
          _SegmentButton(
            label: 'Sign in',
            selected: mode == AuthMode.signIn,
            onTap: () => onChanged(AuthMode.signIn),
          ),
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
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          height: double.infinity,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: selected ? const Color(0xFF111114) : Colors.transparent,
            borderRadius: BorderRadius.circular(22),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: selected ? const Color(0xFFFFFFFF) : const Color(0xFF111114),
              fontSize: 15,
              fontWeight: selected ? FontWeight.w700 : FontWeight.w600,
            ),
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
    return Row(
      children: <Widget>[
        const Expanded(child: Divider(color: Color(0xFFE4E4E8))),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: Text(
            label,
            style: const TextStyle(fontSize: 13, color: Color(0xFF9A9AA3)),
          ),
        ),
        const Expanded(child: Divider(color: Color(0xFFE4E4E8))),
      ],
    );
  }
}

class _FieldLabel extends StatelessWidget {
  const _FieldLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        text,
        style: const TextStyle(fontSize: 13, color: Color(0xFF7A7A85)),
      ),
    );
  }
}
