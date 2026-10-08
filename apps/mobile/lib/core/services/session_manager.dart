import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'supabase_service.dart';

/// Keeps people signed in, safely.
///
/// Supabase persists the session on the device (`localStorage` on the web,
/// shared preferences on phones) and refreshes the access token before it
/// expires while the app runs. This adds the decisions around that cache:
///
///  * **Launch.** A cached session that is still valid is used straight
///    away. An expired one is refreshed first. If the refresh token was
///    revoked or is invalid, the local session is cleared and the user signs
///    in again. If the device is simply offline, the cached session is kept
///    so the app still opens; Supabase refreshes it once the network is back.
///  * **Sign-in convenience.** The last email that signed in is remembered
///    so the sign-in form can be pre-filled. No password is ever stored.
abstract final class SessionManager {
  static const String _kLastEmail = 'grocerra.last_email';

  /// Refresh tokens that will expire within this window are refreshed now
  /// rather than racing the first API call.
  static const Duration _margin = Duration(seconds: 60);

  /// Resolves the cached session at launch. True when the user should land
  /// signed in.
  static Future<bool> restore() async {
    final Session? session = SupabaseService.session;
    if (session == null) return false;

    final int? expiresAt = session.expiresAt;
    final bool fresh =
        expiresAt != null &&
        DateTime.fromMillisecondsSinceEpoch(expiresAt * 1000)
            .isAfter(DateTime.now().add(_margin));
    if (fresh) return true;

    try {
      await SupabaseService.auth.refreshSession();
      return SupabaseService.session != null;
    } on AuthRetryableFetchException {
      // Offline or the auth server is unreachable: trust the cached session
      // for now. Calls that need the network will retry once it is back.
      return true;
    } on AuthException {
      // Refresh token revoked, reused or expired: this session is dead.
      await _clearLocal();
      return false;
    } catch (_) {
      return true;
    }
  }

  static Future<void> _clearLocal() async {
    try {
      await SupabaseService.auth.signOut(scope: SignOutScope.local);
    } catch (_) {
      // Already unusable; nothing more to clear.
    }
  }

  static Future<void> rememberEmail(String email) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString(_kLastEmail, email);
    } catch (_) {}
  }

  static Future<String?> lastEmail() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      return prefs.getString(_kLastEmail);
    } catch (_) {
      return null;
    }
  }

  /// The signed-in user's display name and email, for the profile.
  static ({String name, String email})? get account {
    final User? user = SupabaseService.session?.user;
    if (user == null) return null;
    final Object? name = user.userMetadata?['full_name'];
    return (
      name: name is String && name.trim().isNotEmpty
          ? name.trim()
          : (user.email ?? 'Grocerra customer').split('@').first,
      email: user.email ?? '',
    );
  }
}
