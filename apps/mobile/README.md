# Grocerra — user app (Flutter)

Customer app for **Grocerra**: fresh groceries and catering, delivered to you
(Melbourne pilot, 1 December 2026).

- **Blueprint:** Reevake `User App - Frontend` (app: User app), backend
  `User App - Backend`. Never build a screen against another app's backend.
- **Bundle id:** `com.grocerra.customer` (Android `applicationId`/`namespace`,
  iOS `PRODUCT_BUNDLE_IDENTIFIER`), display name **GROCERRA**.
- **SDK:** Flutter 3.47.6 stable (Dart 3.13.5) installed at `C:\flutter\bin`.

## Commands

```powershell
$env:Path += ";C:\flutter\bin"
cd C:\Users\whiffler\Desktop\GROCERRA\apps\mobile
flutter pub get
flutter analyze
flutter test
flutter run            # Chrome or a connected Android/iOS device
```

## Live app

Production: **https://grocerra-app.vercel.app** (Vercel project
`grocerra-app`, built from `main`). This is the app's canonical address
(`AppConfig.appUrl`): sign-up and password-reset email links send people
here from every build, except a local dev server on `localhost`. The
marketing site is separate, at https://grocerra.com.au (`AppConfig.siteUrl`).

Supabase › Authentication › URL configuration should match:

- **Site URL:** `https://grocerra-app.vercel.app`
- **Redirect URLs:** `https://grocerra-app.vercel.app/**` and
  `http://localhost:*/**`

## Web preview on Vercel

Every push builds this app for the web (`flutter build web`) on Vercel, so you get a live link to try it in a browser: a preview link for branches and PRs, and the production link for `main`. The build runs `vercel-build.sh` and starts as soon as `pubspec.yaml` exists. To use the same build locally: `flutter build web --release`.

## Deployment

The app lives at `apps/mobile/` because that is the path the approved blueprint
assigns it, and it is the root directory of the `grocerra-app` Vercel project.

- `vercel.json` — skips the build while `pubspec.yaml` is absent, runs
  `vercel-build.sh` and publishes `build/web` (with an SPA rewrite so deep
  links resolve).
- `vercel-build.sh` — the Vercel image has no Flutter SDK, so the script pins
  the same toolchain this project is developed against (3.47.6), then runs
  `pub get` + `flutter build web --release`.
- Supabase settings reach the bundle as `--dart-define`s read from either
  `config/vercel.defines.json` or Vercel project env vars
  (`SUPABASE_URL` / `SUPABASE_PUBLISHABLE_KEY`). Public values only — no
  secret is ever baked into the web bundle.

## Layout

```
lib/
  main.dart                  entry point (portrait lock, runs GrocerraApp)
  app.dart                   MaterialApp + light theme + root shell
  core/
    config/app_config.dart   build-time config via --dart-define (no secrets)
    theme/app_theme.dart     design tokens: white/grey surfaces, ink, green accent
    widgets/                 shared widgets
  features/
    shell/                   floating five-tab navigation (Home Browse Catering Orders Profile)
    home/                    Home screen (Groceries & Catering)
    browse/                  Browse: search + category grid
    catering/                Catering, quotes, catering orders
    orders/                  Orders, order details, live tracking
    profile/                 Profile, settings, legal, support
```

Each feature keeps `presentation/` now; `data/` and `domain/` are added per
feature when its backend wiring is implemented.

## Wiring to implement next

Blueprint controls per screen (navigation, backend calls, logic flows) live in
Reevake `screenWiring` for `User App - Frontend`. Screens are built against
Supabase (Sydney) via PostgREST/RPC and edge functions; auth is Supabase Auth.
Money is stored in AUD cents, prices GST-inclusive.

## Rules

- No secrets in this repo: config is injected with `--dart-define`, project
  secrets are loaded from Reevake straight into a single command's environment.
- `AGENTS.md` → `.reevake/agent.md` holds the Reevake workflow; both are
  excluded in `.git/info/exclude`.

## Sign-in flow and Supabase Auth

Welcome → Sign in / Sign up → Verify code → Location, plus Forgot password →
Verify code → Create new password. All of it runs on Supabase Auth (project
`grocera`, email provider), configured for web builds by
`config/vercel.defines.json` (project URL + publishable key; public values).

Two dashboard settings the flow relies on (Supabase › Authentication):

- **Email templates.** The app asks for the 6-digit code. Add `{{ .Token }}`
  to the *Confirm signup* and *Reset password* templates, or users only get
  a link (the link also works: it signs them in and the app opens
  *Create new password* for resets).
- **URL configuration.** Add the app's Vercel domains (and
  `http://localhost:*`) to the redirect allow-list so email links return
  to the app.

Apple and Google buttons show "coming soon" until those providers are
enabled and the build sets `GROCERRA_OAUTH_ENABLED=true`. The built-in
Supabase mailer only delivers to project team addresses and a few emails an
hour; connect SMTP (Resend) before real users sign up.
