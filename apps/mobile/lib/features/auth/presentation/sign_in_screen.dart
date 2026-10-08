import 'package:flutter/material.dart';

import '../../../core/config/app_config.dart';
import '../../../core/services/auth_service.dart';
import '../../../core/services/session_manager.dart';
import 'auth_flow.dart';
import 'forgot_password_screen.dart';
import 'kit/auth_page.dart';
import 'kit/auth_widgets.dart';
import 'kit/motion.dart';
import 'sign_up_screen.dart';
import 'verify_code_screen.dart';

/// "Hey, Welcome Back" - email and password sign-in against Supabase Auth,
/// with Apple / Google underneath.
class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key, this.initialEmail = ''});

  static const String routeName = '/auth';

  final String initialEmail;

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  late final TextEditingController _email = TextEditingController(
    text: widget.initialEmail,
  );
  final TextEditingController _password = TextEditingController();
  final GlobalKey<ShakeState> _shake = GlobalKey<ShakeState>();
  String? _emailError;
  String? _passwordError;
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    // Pre-fill whoever signed in last on this device.
    if (_email.text.isEmpty) {
      SessionManager.lastEmail().then((String? email) {
        if (mounted && email != null && _email.text.isEmpty) {
          _email.text = email;
        }
      });
    }
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  bool _validate() {
    final String email = _email.text.trim();
    setState(() {
      _emailError = isValidEmail(email) ? null : 'Enter a valid email address';
      _passwordError = _password.text.isEmpty ? 'Enter your password' : null;
    });
    final bool ok = _emailError == null && _passwordError == null;
    if (!ok) _shake.currentState?.shake();
    return ok;
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    if (!_validate()) return;
    setState(() => _busy = true);

    if (AppConfig.bypassAuthentication) {
      // Demo build without Supabase: keep the flow walkable.
      await Future<void>.delayed(const Duration(milliseconds: 700));
      if (mounted) AuthFlow.goHome(context);
      return;
    }

    final String email = _email.text.trim();
    final AuthResult result = await AuthService.signIn(
      email: email,
      password: _password.text,
    );
    if (!mounted) return;
    setState(() => _busy = false);

    if (result.ok) {
      AuthFlow.goHome(context);
      return;
    }
    if (result.message.startsWith('Confirm your email')) {
      // The account exists but was never confirmed: send them to the code.
      await AuthService.resendCode(email: email, recovery: false);
      if (!mounted) return;
      Navigator.of(context).push(
        AuthRoute<void>(page: VerifyCodeScreen(email: email, recovery: false)),
      );
      return;
    }
    _shake.currentState?.shake();
    showAuthMessage(context, result.message, error: true);
  }

  Future<void> _social(Future<AuthResult> Function() run) async {
    if (!AppConfig.oauthEnabled) {
      showAuthMessage(
        context,
        'Apple and Google sign-in are coming soon. '
        'Use your email for now.',
      );
      return;
    }
    final AuthResult result = await run();
    if (!mounted) return;
    if (!result.ok) showAuthMessage(context, result.message, error: true);
  }

  @override
  Widget build(BuildContext context) {
    return AuthPage(
      title: 'Hey,\nWelcome\nBack',
      footer: AuthSwitchLine(
        prompt: "Don't have an account?",
        action: 'Sign up',
        onTap: () => Navigator.of(context).pushReplacement(
          AuthRoute<void>(page: SignUpScreen(initialEmail: _email.text.trim())),
        ),
      ),
      children: <Widget>[
        Shake(
          key: _shake,
          child: AutofillGroup(
            child: Column(
              children: <Widget>[
                AuthField(
                  controller: _email,
                  hint: 'Email address',
                  icon: Icons.mail_outline_rounded,
                  keyboardType: TextInputType.emailAddress,
                  autofillHints: const <String>[AutofillHints.email],
                  error: _emailError,
                  onChanged: (_) {
                    if (_emailError != null) setState(() => _emailError = null);
                  },
                ),
                const SizedBox(height: 14),
                AuthField(
                  controller: _password,
                  hint: 'Password',
                  icon: Icons.lock_outline_rounded,
                  obscure: true,
                  textInputAction: TextInputAction.done,
                  autofillHints: const <String>[AutofillHints.password],
                  error: _passwordError,
                  onSubmitted: (_) => _submit(),
                  onChanged: (_) {
                    if (_passwordError != null) {
                      setState(() => _passwordError = null);
                    }
                  },
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 6),
        AuthLink(
          label: 'Forgot password?',
          onTap: () => Navigator.of(context).push(
            AuthRoute<void>(
              page: ForgotPasswordScreen(initialEmail: _email.text.trim()),
            ),
          ),
        ),
        const SizedBox(height: 18),
        AuthButton(label: 'Sign in', loading: _busy, onPressed: _submit),
        const SizedBox(height: 26),
        const OrDivider(),
        const SizedBox(height: 26),
        AuthButton(
          label: 'Continue with Apple',
          variant: AuthButtonVariant.secondary,
          leading: const BrandMark.apple(),
          onPressed: () => _social(AuthService.signInWithApple),
        ),
        const SizedBox(height: 12),
        AuthButton(
          label: 'Continue with Google',
          variant: AuthButtonVariant.secondary,
          leading: const BrandMark.google(),
          onPressed: () => _social(AuthService.signInWithGoogle),
        ),
      ],
    );
  }
}

/// Deliberately permissive: the server is the real judge.
bool isValidEmail(String value) =>
    RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(value);
