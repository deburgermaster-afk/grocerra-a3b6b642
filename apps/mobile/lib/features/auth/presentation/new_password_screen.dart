import 'package:flutter/material.dart';

import '../../../core/config/app_config.dart';
import '../../../core/services/auth_service.dart';
import 'auth_flow.dart';
import 'auth_success_screen.dart';
import 'kit/auth_page.dart';
import 'kit/auth_widgets.dart';
import 'kit/motion.dart';

/// "Create New password" - reached once a reset code (or the reset link)
/// has signed the user in for recovery.
class NewPasswordScreen extends StatefulWidget {
  const NewPasswordScreen({super.key});

  static const String routeName = '/auth/new-password';

  @override
  State<NewPasswordScreen> createState() => _NewPasswordScreenState();
}

class _NewPasswordScreenState extends State<NewPasswordScreen> {
  final TextEditingController _password = TextEditingController();
  final TextEditingController _confirm = TextEditingController();
  final GlobalKey<ShakeState> _shake = GlobalKey<ShakeState>();
  String? _passwordError;
  String? _confirmError;
  bool _busy = false;

  @override
  void dispose() {
    _password.dispose();
    _confirm.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    FocusScope.of(context).unfocus();
    setState(() {
      _passwordError = _password.text.length < 8
          ? 'Use at least 8 characters'
          : null;
      _confirmError = _confirm.text != _password.text
          ? "Passwords don't match"
          : null;
    });
    if (_passwordError != null || _confirmError != null) {
      _shake.currentState?.shake();
      return;
    }
    setState(() => _busy = true);

    final AuthResult result = AppConfig.bypassAuthentication
        ? await Future<AuthResult>.delayed(
            const Duration(milliseconds: 700),
            AuthResult.success,
          )
        : await AuthService.updatePassword(_password.text);
    if (!mounted) return;
    setState(() => _busy = false);

    if (!result.ok) {
      _shake.currentState?.shake();
      showAuthMessage(context, result.message, error: true);
      return;
    }
    Navigator.of(context).pushAndRemoveUntil(
      FadeThroughRoute<void>(
        page: const AuthSuccessScreen(
          title: 'Password updated',
          message: 'Your new password is set and you are signed in.',
          action: 'Start shopping',
          onContinue: AuthFlow.goHome,
        ),
      ),
      (Route<dynamic> _) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AuthPage(
      title: 'Create a new\npassword',
      subtitle: const Text(
        'Your new password must be different from ones you have used before.',
      ),
      children: <Widget>[
        Shake(
          key: _shake,
          child: Column(
            children: <Widget>[
              AuthField(
                controller: _password,
                hint: 'New password',
                icon: Icons.lock_outline_rounded,
                obscure: true,
                autofillHints: const <String>[AutofillHints.newPassword],
                error: _passwordError,
                onChanged: (_) => setState(() => _passwordError = null),
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
                error: _confirmError,
                onSubmitted: (_) => _save(),
                onChanged: (_) {
                  if (_confirmError != null) {
                    setState(() => _confirmError = null);
                  }
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        AuthButton(label: 'Save', loading: _busy, onPressed: _save),
      ],
    );
  }
}
