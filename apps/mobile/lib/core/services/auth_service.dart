import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../config/app_config.dart';
import 'supabase_service.dart';

/// Result of an auth attempt, always safe to show in the UI.
class AuthResult {
  const AuthResult._({
    required this.ok,
    required this.message,
    this.needsEmailConfirmation = false,
  });

  const AuthResult.success() : this._(ok: true, message: '');

  const AuthResult.failure(String message)
    : this._(ok: false, message: message);

  final bool ok;
  final String message;
  final bool needsEmailConfirmation;

  /// True when the account was created but must confirm the email first.
  bool get isPendingConfirmation => ok && needsEmailConfirmation;
}

/// Email/password + OAuth entry points, backed by Supabase Auth.
///
/// Errors from the gateway are mapped to user-facing copy so nothing from
/// the backend leaks as a raw exception, and the two sandbox realities are
/// called out honestly:
///   * email confirmation is ON (`mailer_autoconfirm = false`)
///   * Google/Apple providers are not enabled (see [AppConfig.oauthEnabled])
abstract final class AuthService {
  /// Where links in auth emails return to. On the web this is the page's own
  /// origin, so preview deployments work too; Supabase only honours it when
  /// it is on the project's redirect allow-list, else it uses the Site URL.
  static String? get _redirect => kIsWeb ? Uri.base.origin : null;

  static String _friendly(Object error) {
    if (error is AuthException) {
      final String message = error.message.toLowerCase();
      if (message.contains('invalid login')) {
        return 'That email and password combination is not correct.';
      }
      if (message.contains('email not confirmed')) {
        return 'Confirm your email first, then try signing in again.';
      }
      if (message.contains('already registered')) {
        return 'An account with that email already exists.';
      }
      if (message.contains('password should be')) {
        return 'Password must be at least 8 characters.';
      }
      if (message.contains('rate limit') || message.contains('too many')) {
        return 'Too many attempts. Wait a moment and try again.';
      }
      if (message.contains('user not found')) {
        return 'No account found for that email.';
      }
      if (message.contains('expired') ||
          (message.contains('invalid') && message.contains('token'))) {
        return 'That code is wrong or has expired. Check it, or send a new one.';
      }
      if (message.contains('different from the old')) {
        return 'Choose a password you have not used before.';
      }
      if (message.contains('not authorized')) {
        return 'Email sending is limited on this test project. '
            'Use an address on the project team, or set up SMTP in Supabase.';
      }
      if (message.contains('email') && message.contains('invalid')) {
        return 'Enter a valid email address.';
      }
      return error.message;
    }
    if (error is StateError) return error.message;
    return 'Something went wrong. Please try again.';
  }

  static Future<AuthResult> signIn({
    required String email,
    required String password,
  }) async {
    try {
      await SupabaseService.auth.signInWithPassword(
        email: email,
        password: password,
      );
      return const AuthResult.success();
    } catch (error) {
      return AuthResult.failure(_friendly(error));
    }
  }

  static Future<AuthResult> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final AuthResponse response = await SupabaseService.auth.signUp(
        email: email,
        password: password,
        data: <String, String>{'full_name': name},
        emailRedirectTo: _redirect,
      );
      // With confirmation ON the gateway returns no session; the account
      // exists but is unusable until the email link is clicked.
      final bool unconfirmed =
          response.session == null && response.user != null;
      if (unconfirmed) {
        return const AuthResult._(
          ok: true,
          message: 'Check your inbox to confirm your email, then sign in.',
          needsEmailConfirmation: true,
        );
      }
      return const AuthResult.success();
    } catch (error) {
      return AuthResult.failure(_friendly(error));
    }
  }

  static Future<AuthResult> sendPasswordReset({required String email}) async {
    try {
      await SupabaseService.auth.resetPasswordForEmail(
        email,
        redirectTo: _redirect,
      );
      return const AuthResult._(
        ok: true,
        message: 'We sent a code to that address.',
      );
    } catch (error) {
      return AuthResult.failure(_friendly(error));
    }
  }

  /// Confirms the one-time code from a sign-up or password-reset email.
  /// Success leaves the user signed in.
  static Future<AuthResult> verifyCode({
    required String email,
    required String code,
    required bool recovery,
  }) async {
    try {
      await SupabaseService.auth.verifyOTP(
        email: email,
        token: code,
        type: recovery ? OtpType.recovery : OtpType.signup,
      );
      return const AuthResult.success();
    } catch (error) {
      return AuthResult.failure(_friendly(error));
    }
  }

  /// Sends the sign-up or password-reset email again.
  static Future<AuthResult> resendCode({
    required String email,
    required bool recovery,
  }) async {
    if (recovery) return sendPasswordReset(email: email);
    try {
      await SupabaseService.auth.resend(
        type: OtpType.signup,
        email: email,
        emailRedirectTo: _redirect,
      );
      return const AuthResult._(ok: true, message: 'A new code is on its way.');
    } catch (error) {
      return AuthResult.failure(_friendly(error));
    }
  }

  /// Sets a new password for the signed-in (or just-recovered) user.
  static Future<AuthResult> updatePassword(String password) async {
    try {
      await SupabaseService.auth.updateUser(UserAttributes(password: password));
      return const AuthResult.success();
    } catch (error) {
      return AuthResult.failure(_friendly(error));
    }
  }

  static Future<AuthResult> signInWithGoogle() async {
    if (!SupabaseService.isConfigured) {
      return AuthResult.failure(
        SupabaseService.initError?.toString() ??
            'Supabase is not configured for this build.',
      );
    }
    try {
      await SupabaseService.auth.signInWithOAuth(
        OAuthProvider.google,
        redirectTo: AppConfig.oauthRedirectUrl.isNotEmpty
            ? AppConfig.oauthRedirectUrl
            : _redirect,
      );
      return const AuthResult.success();
    } catch (error) {
      return AuthResult.failure(_friendly(error));
    }
  }

  static Future<AuthResult> signInWithApple() async {
    if (!SupabaseService.isConfigured) {
      return AuthResult.failure(
        SupabaseService.initError?.toString() ??
            'Supabase is not configured for this build.',
      );
    }
    try {
      await SupabaseService.auth.signInWithOAuth(
        OAuthProvider.apple,
        redirectTo: AppConfig.oauthRedirectUrl.isNotEmpty
            ? AppConfig.oauthRedirectUrl
            : _redirect,
      );
      return const AuthResult.success();
    } catch (error) {
      return AuthResult.failure(_friendly(error));
    }
  }

  static Future<void> signOut() async {
    if (!SupabaseService.isConfigured || !SupabaseService.isReady) return;
    try {
      await SupabaseService.auth.signOut();
    } catch (_) {
      // Local session is already unusable; nothing to recover.
    }
  }
}
