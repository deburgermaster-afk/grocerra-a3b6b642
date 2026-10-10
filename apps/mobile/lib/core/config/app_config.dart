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

  /// Canonical home of the customer app (Flutter web, Vercel project
  /// `grocerra-app`). Links in auth emails and OAuth callbacks land here,
  /// whichever build sent them.
  static const String appUrl = String.fromEnvironment(
    'GROCERRA_APP_URL',
    defaultValue: 'https://grocerra-app.vercel.app',
  );

  /// The public marketing site (Vercel project `grocerra-website`).
  static const String siteUrl = String.fromEnvironment(
    'GROCERRA_SITE_URL',
    defaultValue: 'https://grocerra.com.au',
  );

  /// Absolute redirect target for OAuth deep links, when enabled.
  static const String oauthRedirectUrl = String.fromEnvironment(
    'GROCERRA_OAUTH_REDIRECT',
    defaultValue: '',
  );

  /// Development / demo bypass for the Sign In screen.
  ///
  /// While the UI is being built this flag lets the primary "Sign In" button
  /// continue to the next approved screen without valid credentials, keeping
  /// the whole flow navigable in Chrome. It applies to **every** build by
  /// default — including the Vercel preview, which compiles the Supabase keys
  /// from config/vercel.defines.json in — so localhost and the deployed URL
  /// walk through sign-in identically.
  ///
  /// It is **not** a production authentication feature: it only short-circuits
  /// the sign-in step, it never mints a session, and it must be turned off for
  /// any real build with `--dart-define=GROCERRA_DEMO_MODE=false` (or by
  /// flipping GROCERRA_DEMO_MODE in config/vercel.defines.json). The real
  /// Supabase implementation in [signIn] stays intact and is used whenever this
  /// flag is off, so nothing has to be rebuilt to restore it.
  static const bool demoMode = bool.fromEnvironment(
    'GROCERRA_DEMO_MODE',
    defaultValue: true,
  );

  static const Duration httpTimeout = Duration(seconds: 20);

  /// True when the Supabase gateway has been configured for this build.
  static bool get isSupabaseConfigured =>
      apiBaseUrl.isNotEmpty && supabaseAnonKey.isNotEmpty;

  /// True when Sign In should skip the real credential check and continue.
  ///
  /// Driven purely by [demoMode] — NOT by the presence of Supabase keys.
  /// Keying off `isSupabaseConfigured` made the Vercel preview (which
  /// compiles config/vercel.defines.json in) enforce real credentials while
  /// a plain local `flutter run` walked through, so the two builds showed
  /// different sign-in flows. Both now follow [demoMode].
  static bool get bypassAuthentication => demoMode;
}
