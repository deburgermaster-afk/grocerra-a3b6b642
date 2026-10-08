import 'package:supabase_flutter/supabase_flutter.dart';

import '../config/app_config.dart';

/// Thin wrapper around the Supabase gateway.
///
/// The project's real sandbox is `SUPABASE_URL` + `SUPABASE_PUBLISHABLE_KEY`
/// (Sydney region). They are injected at build time through
/// `AppConfig`, never hard-coded.
///
/// When the build carries no configuration the service stays
/// *unconfigured* instead of crashing: every caller surfaces an explicit
/// "not configured" error to the UI so the gap is visible rather than
/// silently swallowed.
abstract final class SupabaseService {
  static bool _initialised = false;
  static Object? _initError;

  /// True when this build was given a Supabase URL and publishable key.
  static bool get isConfigured => AppConfig.isSupabaseConfigured;

  /// True when [init] completed without throwing.
  static bool get isReady => _initialised && _initError == null;

  /// Error captured by [init], if any. Surfaced verbatim in the UI.
  static Object? get initError => _initError;

  /// Boots the Supabase client if configuration is present.
  ///
  /// Never throws: a bad URL must not take the whole app down before the
  /// first frame, the failure is retained and reported on first use.
  static Future<void> init() async {
    if (!isConfigured) return;
    try {
      await Supabase.initialize(
        url: AppConfig.apiBaseUrl,
        publishableKey: AppConfig.supabaseAnonKey,
        // Sessions persist on the device and the access token refreshes
        // itself in the background; see SessionManager for launch handling.
        authOptions: const FlutterAuthClientOptions(
          authFlowType: AuthFlowType.pkce,
          persistSession: true,
          autoRefreshToken: true,
          detectSessionInUri: true,
        ),
      );
      _initialised = true;
    } catch (error) {
      _initError = error;
    }
  }

  /// The underlying client. Throws a descriptive error when unconfigured.
  static SupabaseClient get client {
    if (!isConfigured) {
      throw StateError(
        'Supabase is not configured for this build. '
        'Build with --dart-define=GROCERRA_API_BASE_URL=... and '
        '--dart-define=GROCERRA_SUPABASE_ANON_KEY=... .',
      );
    }
    if (_initError != null) {
      throw StateError('Supabase failed to initialise: $_initError');
    }
    return Supabase.instance.client;
  }

  static GoTrueClient get auth => client.auth;

  /// Current session, or null when signed out / unconfigured.
  static Session? get session {
    if (!isConfigured || !isReady) return null;
    return Supabase.instance.client.auth.currentSession;
  }

  /// Stream of auth changes; empty (no emissions) when unconfigured.
  static Stream<AuthState> get authStateChanges {
    if (!isConfigured || !isReady) return const Stream<AuthState>.empty();
    return Supabase.instance.client.auth.onAuthStateChange;
  }
}
