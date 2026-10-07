# Grocerra setup: services, environments and secrets

How Grocerra runs without servers, which accounts and keys it needs, and how keys get from the Reevake vault into your coding agent's commands. If this file disagrees with Reevake › Grocerra › Blueprints, the blueprint wins.

## 1. We run no servers

Every part runs on a managed platform. There is no NestJS service, no Redis, no Fly.io or Railway machine, and nothing that needs patching.

| Part | Runs on | Folder |
|---|---|---|
| Database: Postgres 17 + PostGIS | Supabase, Sydney (`ap-southeast-2`) | `supabase/migrations` |
| Auth (phone OTP, email), REST API, Realtime, file storage | Supabase | `supabase/` |
| Background jobs and schedules | Supabase Queues (`pgmq`) + `pg_cron` | `supabase/migrations` |
| Logic that touches money, couriers or secrets | Supabase Edge Functions (Deno) | `supabase/functions` |
| Customer app (iOS / Android) | Flutter, store builds | `apps/mobile` |
| Merchant portal and admin panel | Next.js on Vercel (team `xeroxitint`) | `apps/merchant-portal`, `apps/admin` |
| Map tiles | Protomaps PMTiles file on Cloudflare R2, drawn by MapLibre | — |
| Address search | Google Places, called from an Edge Function | `supabase/functions` |

Reads go straight from the app to Supabase under row-level security (RLS). Anything involving money, couriers or a secret key goes through an Edge Function. Everything else is a Postgres RPC.

## 2. Environments

| Environment | Supabase project | Who can deploy to it |
|---|---|---|
| **dev** | `grocera` (ref `dfktgmjkgspljdpsvbcl`, Sydney) | Any assignee's coding agent, using dev keys from the vault |
| **prod** | `grocerra-prod`, to be created on the Pro plan before the 1 Dec 2026 pilot | Company admin only |

Free Supabase projects pause after a week without traffic and have no daily backups. That is fine for dev but not for prod. Portal previews come from Vercel's Git integration: every branch push gets a preview URL without anyone holding a Vercel token.

## 3. How secrets work

The **Reevake project vault** is the only master copy of every key. Values are encrypted with AES-256-GCM in Reevake's database. Supabase and Vercel only hold runtime copies, which the admin pushes from the vault.

| Who | Can see values | Can do |
|---|---|---|
| Company admin | Yes | Add, replace, delete and reveal values; choose which keys agents can use; read the use log |
| Supervisor / employee | **No**: names, purpose and who added each key only | Add a *new* key; can't read or overwrite existing ones |
| Employee's coding agent | Only inside one command | Loads keys marked **agent usable** into one command's environment, only while the employee has an open task in Grocerra. Every use is logged as `secret.agent_used`. |

**The limit to know.** A key injected into a command on an employee's laptop could be read by that employee if they set out to. The vault blocks casual exposure and logs every use, but it can't stop a determined insider. So:

- **Agent usable = dev and sandbox keys only.** Use test or sandbox mode, restricted keys, and the dev Supabase project.
- **Production keys are stored with a `PROD_` prefix and agent use turned off.** Only the admin loads them.
- Rotate a key whenever someone leaves the project.

**Naming.** A vault name equals the environment variable the code reads (uppercase, `A–Z 0–9 _`). Production copies use the same name with `PROD_` in front. The sync step strips the prefix.

## 4. Key list

Where a key ends up at runtime:

- **EF**: Supabase Edge Function secret.
- **Auth**: Supabase dashboard › Auth settings.
- **Vercel**: Vercel environment variable.
- **App**: Flutter `--dart-define`.
- **CLI**: used only by commands, never deployed.

"Public" means the value is safe in a client bundle, but it still lives in the vault so there's one source.

| Vault name | What it's for | Runtime | Agent usable (dev) |
|---|---|---|---|
| `SUPABASE_URL` | Project URL (public) | App, Vercel | Yes |
| `SUPABASE_PUBLISHABLE_KEY` | `sb_publishable_…` client key (public) | App, Vercel | Yes |
| `SUPABASE_SECRET_KEY` | `sb_secret_…`, bypasses RLS | EF (built in) | Yes |
| `SUPABASE_PROJECT_REF` | Project ref for CLI commands | CLI | Yes |
| `SUPABASE_DB_URL` | Postgres connection for `supabase db push` | CLI | Yes |
| `SUPABASE_ACCESS_TOKEN` | Deploy Edge Functions. Supabase tokens see **every** project the account can, so create it from a separate deploy account that only belongs to Grocerra | CLI | Yes |
| `STRIPE_PUBLISHABLE_KEY` | `pk_test_…` (public) | App, Vercel | Yes |
| `STRIPE_SECRET_KEY` | `sk_test_…`; use a restricted key where possible | EF | Yes |
| `STRIPE_WEBHOOK_SECRET` | Verifies Stripe webhooks | EF | Yes |
| `UBER_DIRECT_CUSTOMER_ID`, `UBER_DIRECT_CLIENT_ID`, `UBER_DIRECT_CLIENT_SECRET`, `UBER_DIRECT_WEBHOOK_SECRET` | Courier quotes, dispatch, tracking (sandbox) | EF | Yes |
| `DOORDASH_DEVELOPER_ID`, `DOORDASH_KEY_ID`, `DOORDASH_SIGNING_SECRET` | Failover courier (sandbox) | EF | Yes |
| `GOOGLE_MAPS_API_KEY` | Places autocomplete and geocoding, restricted to those APIs | EF | Yes |
| `PMTILES_URL` | Public URL of the tiles file on R2 | App, Vercel | Yes |
| `R2_ACCOUNT_ID`, `R2_ACCESS_KEY_ID`, `R2_SECRET_ACCESS_KEY` | Upload map tiles (rare) | CLI | No |
| `TWILIO_ACCOUNT_SID`, `TWILIO_AUTH_TOKEN`, `TWILIO_VERIFY_SERVICE_SID` | Phone OTP; Supabase Auth sends SMS through it (provider still to confirm) | Auth | No |
| `RESEND_API_KEY` | Receipts and tax invoices; sending-only key | EF | Yes |
| `FIREBASE_SERVICE_ACCOUNT_JSON` | Push notifications (FCM v1; APNs goes through Firebase) | EF | Yes (dev Firebase project) |
| `APNS_AUTH_KEY` | Apple push key, uploaded into Firebase; kept here as the record | — | No |
| `SENTRY_DSN` | Error reporting (public) | App, Vercel, EF | Yes |
| `SENTRY_AUTH_TOKEN` | Source map upload on release | CLI | No |
| `ABR_GUID` | ABN lookup when onboarding merchants | EF | Yes |
| `ANDROID_KEYSTORE_BASE64`, `ANDROID_KEYSTORE_PASSWORD`, `ANDROID_KEY_ALIAS` | Signing Play Store builds | CLI | No |
| `GOOGLE_PLAY_SERVICE_ACCOUNT_JSON` | Uploading Android builds | CLI | No |
| `APP_STORE_CONNECT_KEY_ID`, `APP_STORE_CONNECT_ISSUER_ID`, `APP_STORE_CONNECT_API_KEY` | Uploading iOS builds / TestFlight | CLI | No |
| `VERCEL_TOKEN` | Only if a manual deploy is ever needed. The team also hosts reevake.com, so never agent usable | CLI | No |
| `FIGMA_ACCESS_TOKEN` | Importing screens into blueprints | CLI | Yes |
| `PROD_*` | Production copy of any key above | as above | **No** |

Not needed: Neon (Supabase is the database), Fly.io, Railway and a NestJS host.

## 5. Using keys from VS Code (employees and agents)

One-time setup on your machine. Never put these in the repository.

1. In Reevake › ReevTask, connect your coding agent. That creates a token with the `secrets:use` scope.
2. Add both values to your shell profile or OS keychain:
   ```bash
   export REEVAKE_BASE_URL=https://reevake.com
   export REEVAKE_AGENT_TOKEN=…   # your personal token
   ```
3. See which keys you can use right now:
   ```bash
   curl -fsS "$REEVAKE_BASE_URL/api/agent/secrets?projectId=a3b6b642-dcf7-4fee-a932-99340afdb790" \
     -H "Authorization: Bearer $REEVAKE_AGENT_TOKEN"
   ```

Run a command with keys loaded:

```bash
scripts/with-secrets.sh SUPABASE_ACCESS_TOKEN SUPABASE_PROJECT_REF -- \
  bash -c 'supabase functions deploy --project-ref "$SUPABASE_PROJECT_REF"'

scripts/with-secrets.sh SUPABASE_DB_URL -- bash -c 'supabase db push --db-url "$SUPABASE_DB_URL"'

scripts/with-secrets.sh SUPABASE_URL SUPABASE_PUBLISHABLE_KEY STRIPE_PUBLISHABLE_KEY PMTILES_URL -- \
  bash -c 'cd apps/mobile && flutter run --dart-define=SUPABASE_URL="$SUPABASE_URL" --dart-define=SUPABASE_PUBLISHABLE_KEY="$SUPABASE_PUBLISHABLE_KEY" --dart-define=STRIPE_PUBLISHABLE_KEY="$STRIPE_PUBLISHABLE_KEY" --dart-define=PMTILES_URL="$PMTILES_URL"'
```

Wrap commands that use `$NAME` in `bash -c '…'` with single quotes. Otherwise your shell expands `$NAME` before the keys are loaded.

Windows (PowerShell):

```powershell
$s = Invoke-RestMethod -Method Post "$env:REEVAKE_BASE_URL/api/agent/secrets" -Headers @{Authorization="Bearer $env:REEVAKE_AGENT_TOKEN"} -ContentType "application/json" -Body '{"projectId":"a3b6b642-dcf7-4fee-a932-99340afdb790","names":["SUPABASE_DB_URL"]}'
$s.secrets.PSObject.Properties | ForEach-Object { Set-Item "env:$($_.Name)" $_.Value }
supabase db push --db-url $env:SUPABASE_DB_URL
$s.secrets.PSObject.Properties | ForEach-Object { Remove-Item "env:$($_.Name)" }
```

Rules for agents:

- Load keys only into the command that needs them.
- Never print, echo, log or commit a key.
- Never write a key to a file inside the repository, or put one in chat, a PR or a task submission.
- `.env*` files are git-ignored and only for your own machine. `.env.example` holds names only.
- Need a key that isn't listed? Add it under a new name in Reevake › Grocerra › Secrets. The admin decides whether agents can use it.

## 6. Production (admin only)

1. Store every production value as `PROD_<NAME>` with agent use off.
2. Push values to their runtime homes from the vault. Edge Function secrets go through `supabase secrets set --project-ref <prod ref>`; Vercel production variables go through `vercel env add`. Auth SMS settings go in the Supabase dashboard.
3. Deploy prod by running migrations and Edge Function deploys with `PROD_` keys. Merging to `main` deploys the portals through Vercel's Git integration.
4. Every reveal, save, delete and agent use appears in Reevake › Grocerra › Secrets › Log.
