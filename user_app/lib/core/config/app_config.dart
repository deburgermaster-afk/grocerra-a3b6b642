/// Build-time configuration.
///
/// Values are injected with `--dart-define=KEY=value`; nothing secret is
/// stored in this file or anywhere else in the repository.
abstract final class AppConfig {
  static const String appName = 'GROCERRA';

  /// Supabase project URL (ap-southeast-2 / Sydney), injected at build time.
  static const String apiBaseUrl = String.fromEnvironment(
    'GROCERRA_API_BASE_URL',
    defaultValue: '',
  );

  /// Public anon key for the Supabase API gateway, injected at build time.
  static const String supabaseAnonKey = String.fromEnvironment(
    'GROCERRA_SUPABASE_ANON_KEY',
    defaultValue: '',
  );

  /// Whether Google/Apple OAuth providers have been enabled on the Supabase
  /// project. They are **disabled today** (probed: `/auth/v1/settings`
  /// returns an empty `external_providers` list), so the buttons surface an
  /// explicit message instead of sending the user to a dead authorisation
  /// page. Flip this define once the providers are configured.
  static const bool oauthEnabled = bool.fromEnvironment(
    'GROCERRA_OAUTH_ENABLED',
    defaultValue: false,
  );

  /// Absolute redirect target for OAuth deep links, when enabled.
  static const String oauthRedirectUrl = String.fromEnvironment(
    'GROCERRA_OAUTH_REDIRECT',
    defaultValue: '',
  );

  static const Duration httpTimeout = Duration(seconds: 20);

  /// True when the Supabase gateway has been configured for this build.
  static bool get isSupabaseConfigured =>
      apiBaseUrl.isNotEmpty && supabaseAnonKey.isNotEmpty;
}
