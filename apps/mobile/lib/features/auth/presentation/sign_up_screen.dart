import 'package:flutter/material.dart';

import '../../../core/config/app_config.dart';
import '../../../core/services/auth_service.dart';
import 'auth_flow.dart';
import 'kit/auth_page.dart';
import 'kit/auth_widgets.dart';
import 'kit/motion.dart';
import 'sign_in_screen.dart';
import 'verify_code_screen.dart';

/// "Let's get Started" - creates the Supabase account, then hands over to
/// email verification.
class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key, this.initialEmail = ''});

  static const String routeName = '/auth/sign-up';

  final String initialEmail;

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _name = TextEditingController();
  late final TextEditingController _email = TextEditingController(
    text: widget.initialEmail,
  );
  final TextEditingController _password = TextEditingController();
  final TextEditingController _confirm = TextEditingController();
  final GlobalKey<ShakeState> _shake = GlobalKey<ShakeState>();
  final Map<String, String?> _errors = <String, String?>{};
  bool _busy = false;

  @override
  void dispose() {
    for (final TextEditingController c in <TextEditingController>[
      _name,
      _email,
      _password,
      _confirm,
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  bool _validate() {
    setState(() {
      _errors
        ..clear()
        ..['name'] = _name.text.trim().isEmpty ? 'Tell us your name' : null
        ..['email'] = isValidEmail(_email.text.trim())
            ? null
            : 'Enter a valid email address'
        ..['password'] = _password.text.length < 8
            ? 'Use at least 8 characters'
            : null
        ..['confirm'] = _confirm.text != _password.text
            ? "Passwords don't match"
            : null;
    });
    final bool ok = _errors.values.every((String? e) => e == null);
    if (!ok) _shake.currentState?.shake();
    return ok;
  }

  void _clear(String key) {
    if (_errors[key] != null) setState(() => _errors[key] = null);
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    if (!_validate()) return;
    final String email = _email.text.trim();
    setState(() => _busy = true);

    if (AppConfig.bypassAuthentication) {
      await Future<void>.delayed(const Duration(milliseconds: 700));
      if (!mounted) return;
      setState(() => _busy = false);
      _toVerify(email);
      return;
    }

    final AuthResult result = await AuthService.signUp(
      name: _name.text.trim(),
      email: email,
      password: _password.text,
    );
    if (!mounted) return;
    setState(() => _busy = false);

    if (!result.ok) {
      _shake.currentState?.shake();
      showAuthMessage(context, result.message, error: true);
    } else if (result.isPendingConfirmation) {
      _toVerify(email);
    } else {
      // Project has auto-confirm on: the account is live already.
      AuthFlow.goToSetup(context);
    }
  }

  void _toVerify(String email) {
    Navigator.of(context).push(
      AuthRoute<void>(page: VerifyCodeScreen(email: email, recovery: false)),
    );
  }

  Future<void> _social(Future<AuthResult> Function() run) async {
    if (!AppConfig.oauthEnabled) {
      showAuthMessage(
        context,
        'Apple and Google sign-up are coming soon. Use your email for now.',
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
      title: "Let's get\nstarted",
      subtitle: const Text('Create your account with your email.'),
      footer: AuthSwitchLine(
        prompt: 'Already have an account?',
        action: 'Sign in',
        onTap: () => Navigator.of(context).pushReplacement(
          AuthRoute<void>(page: SignInScreen(initialEmail: _email.text.trim())),
        ),
      ),
      children: <Widget>[
        Shake(
          key: _shake,
          child: AutofillGroup(
            child: Column(
              children: <Widget>[
                AuthField(
                  controller: _name,
                  hint: 'Full name',
                  icon: Icons.person_outline_rounded,
                  keyboardType: TextInputType.name,
                  autofillHints: const <String>[AutofillHints.name],
                  error: _errors['name'],
                  onChanged: (_) => _clear('name'),
                ),
                const SizedBox(height: 10),
                AuthField(
                  controller: _email,
                  hint: 'Email address',
                  icon: Icons.mail_outline_rounded,
                  keyboardType: TextInputType.emailAddress,
                  autofillHints: const <String>[AutofillHints.email],
                  error: _errors['email'],
                  onChanged: (_) => _clear('email'),
                ),
                const SizedBox(height: 10),
                AuthField(
                  controller: _password,
                  hint: 'Password',
                  icon: Icons.lock_outline_rounded,
                  obscure: true,
                  autofillHints: const <String>[AutofillHints.newPassword],
                  error: _errors['password'],
                  onChanged: (_) {
                    _clear('password');
                    setState(() {});
                  },
                ),
                PasswordStrength(password: _password.text),
                const SizedBox(height: 10),
                AuthField(
                  controller: _confirm,
                  hint: 'Confirm password',
                  icon: Icons.lock_outline_rounded,
                  obscure: true,
                  textInputAction: TextInputAction.done,
                  autofillHints: const <String>[AutofillHints.newPassword],
                  error: _errors['confirm'],
                  onSubmitted: (_) => _submit(),
                  onChanged: (_) => _clear('confirm'),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        AuthButton(label: 'Sign up', loading: _busy, onPressed: _submit),
        const SizedBox(height: 14),
        const OrDivider(),
        const SizedBox(height: 14),
        AuthButton(
          label: 'Continue with Apple',
          variant: AuthButtonVariant.secondary,
          leading: const BrandMark.apple(),
          onPressed: () => _social(AuthService.signInWithApple),
        ),
        const SizedBox(height: 10),
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
