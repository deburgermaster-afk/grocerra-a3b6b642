import 'package:flutter/material.dart';

import '../../../core/config/app_config.dart';
import '../../../core/services/auth_service.dart';
import 'kit/auth_page.dart';
import 'kit/auth_widgets.dart';
import 'kit/motion.dart';
import 'sign_in_screen.dart';
import 'verify_code_screen.dart';

/// "Forgot Password?" - emails a reset code, then moves to code entry.
class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key, this.initialEmail = ''});

  static const String routeName = '/auth/forgot-password';

  final String initialEmail;

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  late final TextEditingController _email = TextEditingController(
    text: widget.initialEmail,
  );
  final GlobalKey<ShakeState> _shake = GlobalKey<ShakeState>();
  String? _error;
  bool _busy = false;

  @override
  void dispose() {
    _email.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    FocusScope.of(context).unfocus();
    final String email = _email.text.trim();
    if (!isValidEmail(email)) {
      setState(() => _error = 'Enter a valid email address');
      _shake.currentState?.shake();
      return;
    }
    setState(() => _busy = true);

    final AuthResult result = AppConfig.bypassAuthentication
        ? await Future<AuthResult>.delayed(
            const Duration(milliseconds: 700),
            AuthResult.success,
          )
        : await AuthService.sendPasswordReset(email: email);
    if (!mounted) return;
    setState(() => _busy = false);

    if (!result.ok) {
      _shake.currentState?.shake();
      showAuthMessage(context, result.message, error: true);
      return;
    }
    Navigator.of(context).push(
      AuthRoute<void>(page: VerifyCodeScreen(email: email, recovery: true)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AuthPage(
      title: 'Forgot\nPassword?',
      subtitle: const Text(
        "Enter the email you signed up with and we'll send you a code to "
        'reset your password.',
      ),
      children: <Widget>[
        Shake(
          key: _shake,
          child: AuthField(
            controller: _email,
            hint: 'Email address',
            icon: Icons.mail_outline_rounded,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.send,
            autofillHints: const <String>[AutofillHints.email],
            error: _error,
            onSubmitted: (_) => _send(),
            onChanged: (_) {
              if (_error != null) setState(() => _error = null);
            },
          ),
        ),
        const SizedBox(height: 24),
        AuthButton(label: 'Send code', loading: _busy, onPressed: _send),
      ],
    );
  }
}
