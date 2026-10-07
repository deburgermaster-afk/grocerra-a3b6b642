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

  static const Duration httpTimeout = Duration(seconds: 20);
}
