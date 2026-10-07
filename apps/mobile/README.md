# Grocerra — user app (Flutter)

Customer app for **Grocerra**: South Asian groceries, certified halal meat and
catering delivered on demand (Melbourne pilot, 1 December 2026).

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

## Deployment

The app lives at `apps/mobile/` because that is the path the approved blueprint
assigns it, and it is the root directory of the `grocerra-app` Vercel project.

- `vercel.json` — runs `vercel-build.sh` and publishes `build/web`.
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
