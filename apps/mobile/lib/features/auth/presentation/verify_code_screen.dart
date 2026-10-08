import 'dart:async';

import 'package:flutter/material.dart';

import '../../../core/config/app_config.dart';
import '../../../core/services/auth_service.dart';
import 'auth_flow.dart';
import 'auth_success_screen.dart';
import 'kit/auth_page.dart';
import 'kit/auth_theme.dart';
import 'kit/auth_widgets.dart';
import 'kit/motion.dart';
import 'new_password_screen.dart';

/// "Verify Your Email" - the one-time code from a sign-up or password-reset
/// email. Supabase codes are six digits.
class VerifyCodeScreen extends StatefulWidget {
  const VerifyCodeScreen({
    super.key,
    required this.email,
    required this.recovery,
  });

  static const String routeName = '/auth/verify';

  /// Supabase email codes are 6 digits by default; projects can set up to
  /// 10, so accept up to 8 rather than assume.
  static const int codeLength = 6;
  static const int maxCodeLength = 8;

  final String email;

  /// True for a password reset, false for a new account.
  final bool recovery;

  @override
  State<VerifyCodeScreen> createState() => _VerifyCodeScreenState();
}

class _VerifyCodeScreenState extends State<VerifyCodeScreen> {
  final TextEditingController _code = TextEditingController();
  final GlobalKey<ShakeState> _shake = GlobalKey<ShakeState>();
  bool _busy = false;
  bool _error = false;
  int _cooldown = 30;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startCooldown();
    _code.addListener(() {
      if (_error) setState(() => _error = false);
      setState(() {});
    });
  }

  void _startCooldown() {
    _timer?.cancel();
    setState(() => _cooldown = 30);
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      if (!mounted) return;
      setState(() => _cooldown--);
      if (_cooldown <= 0) t.cancel();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _code.dispose();
    super.dispose();
  }

  Future<void> _verify() async {
    if (_busy || _code.text.length < VerifyCodeScreen.codeLength) return;
    FocusScope.of(context).unfocus();
    setState(() => _busy = true);

    final AuthResult result = AppConfig.bypassAuthentication
        ? await Future<AuthResult>.delayed(
            const Duration(milliseconds: 700),
            AuthResult.success,
          )
        : await AuthService.verifyCode(
            email: widget.email,
            code: _code.text,
            recovery: widget.recovery,
          );
    if (!mounted) return;
    setState(() => _busy = false);

    if (!result.ok) {
      setState(() => _error = true);
      _shake.currentState?.shake();
      showAuthMessage(context, result.message, error: true);
      _code.clear();
      return;
    }

    if (widget.recovery) {
      Navigator.of(context)
          .pushReplacement(AuthRoute<void>(page: const NewPasswordScreen()));
    } else {
      Navigator.of(context).pushAndRemoveUntil(
        FadeThroughRoute<void>(
          page: AuthSuccessScreen(
            title: 'Email verified',
            message: "You're all set. Let's find where to deliver.",
            action: 'Continue',
            onContinue: AuthFlow.goToSetup,
          ),
        ),
        (Route<dynamic> _) => false,
      );
    }
  }

  Future<void> _resend() async {
    final AuthResult result = AppConfig.bypassAuthentication
        ? const AuthResult.success()
        : await AuthService.resendCode(
            email: widget.email,
            recovery: widget.recovery,
          );
    if (!mounted) return;
    if (result.ok) {
      _startCooldown();
      showAuthMessage(context, 'A new code is on its way.');
    } else {
      showAuthMessage(context, result.message, error: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final AuthPalette p = AuthPalette.of(context);
    final bool ready = _code.text.length >= VerifyCodeScreen.codeLength;

    return AuthPage(
      title: widget.recovery ? 'Check your\nemail' : 'Verify your\nemail',
      subtitle: Text.rich(
        TextSpan(
          text: 'Enter the code we sent to ',
          children: <InlineSpan>[
            TextSpan(
              text: widget.email,
              style: AuthType.body(p.ink).copyWith(fontWeight: FontWeight.w600),
            ),
            const TextSpan(text: '.'),
          ],
        ),
      ),
      children: <Widget>[
        Shake(
          key: _shake,
          child: OtpInput(
            controller: _code,
            length: VerifyCodeScreen.codeLength,
            maxLength: VerifyCodeScreen.maxCodeLength,
            hasError: _error,
            onCompleted: (_) => _verify(),
          ),
        ),
        const SizedBox(height: 12),
        AnimatedSwitcher(
          duration: Motion.quick,
          child: _cooldown > 0
              ? Center(
                  key: const ValueKey<String>('wait'),
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Text(
                      'Resend code in 0:${_cooldown.toString().padLeft(2, '0')}',
                      style: AuthType.small(p.faint),
                    ),
                  ),
                )
              : AuthLink(
                  key: const ValueKey<String>('resend'),
                  label: 'Resend code',
                  underline: true,
                  onTap: _resend,
                ),
        ),
        const SizedBox(height: 12),
        AuthButton(
          label: 'Verify',
          loading: _busy,
          onPressed: ready ? _verify : null,
        ),
        const SizedBox(height: 12),
        Text(
          'No code? Check spam, or tap the link in the email instead.',
          textAlign: TextAlign.center,
          style: AuthType.small(p.faint),
        ),
      ],
    );
  }
}
