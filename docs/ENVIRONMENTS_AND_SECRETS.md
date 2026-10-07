# Environments, secrets and deployment

How Sogrow (Grocera) is hosted, where every environment variable comes from, and how employees work with secrets they are never shown.

## Hosting

| Part | Folder | Host | Deploys when |
|---|---|---|---|
| Database, auth (OTP), storage, realtime | — | Supabase, project `grocera`, Sydney (`ap-southeast-2`) | Migrations run by the API's deploy step |
| Dev and task databases | — | Neon, Sydney, one branch per task | Created by ReevTask when a task starts |
| API and job worker (NestJS) | `services/api` | Railway | Push to `main` → production; PR → preview environment |
| Merchant portal (Next.js) | `apps/merchant-portal` | Vercel, project `grocera-merchant-portal` | Push to `main` → production; PR → preview URL |
| Admin panel (Next.js) | `apps/admin` | Vercel, project `grocera-admin` | Push to `main` → production; PR → preview URL |
| Customer app, web build (Flutter) | `apps/mobile` | Cloudflare Pages | Push to `main` |
| Customer app, iOS / Android (Flutter) | `apps/mobile` | App Store / Google Play | Tagged release (`mobile-v*`) via CI |

Every host is linked to this repository, so **merging to `main` deploys** and every pull request gets its own preview. Nobody deploys by hand and nobody needs host credentials to ship.

## Three kinds of values

| Kind | Examples | Where it may live |
|---|---|---|
| **Public** | Supabase URL, Supabase publishable key, Stripe publishable key, API base URL, Sentry DSN | Mobile app, browser bundles, `.env.example` placeholders |
| **Secret** | Database URLs, Supabase secret key, Stripe secret and webhook keys, Uber Direct / DoorDash keys, Resend key, FCM service account | `services/api` only, on the server |
| **Owner-only** | Production database password, Stripe live keys, courier live keys, host account tokens | Reevake › Project secrets (owner) and the host's encrypted env settings, nowhere else |

Rules (also in `docs/ARCHITECTURE.md`):

- Secrets never ship in the mobile app or the web bundles. In Next.js only `NEXT_PUBLIC_*` reaches the browser; in Flutter everything passed with `--dart-define` is readable from the binary.
- Never commit a real `.env`. `.gitignore` already blocks `.env` and `.env.*` (except `.env.example`) and `.reevake/`.
- Never paste a secret into a PR, issue, task comment, log line or chat.

## Where each value comes from

Each app has a `.env.example` listing the variable names it needs:

- `services/api/.env.example`: server secrets (database, Supabase secret key, Stripe, couriers, email, push)
- `apps/merchant-portal/.env.example` and `apps/admin/.env.example`: public `NEXT_PUBLIC_*` values only
- `apps/mobile/.env.example`: public values only, passed with `--dart-define-from-file`

| Environment | Database | Stripe / couriers | Source of the values |
|---|---|---|---|
| Local / task work | Neon branch for the task | Test mode / sandbox | Injected by ReevTask into your agent's run |
| Preview (PRs) | Neon preview branch | Test mode / sandbox | Host preview env (Vercel / Railway), set by the owner |
| Production | Supabase `grocera` (Sydney) | Live | Host production env, set by the owner |

## How employees get secrets through ReevTask

1. The owner stores every value in **Reevake › Project secrets** for this project. Only the project owner can view or edit them there.
2. You connect your coding agent in **Reevake › ReevTask** for this repository and pick up a task (see the root `README.md`).
3. When your agent runs on the task, ReevTask hands it the project's **development** values for that run only: the task's Neon branch, Stripe test keys and courier sandbox keys. They're scoped to this project and the task. Nothing is written to the repository, and you never open the owner's secrets page.
4. Production values are never handed to agents or employees. They only exist in Reevake › Project secrets and in the hosts' encrypted settings, which the deploy pipeline reads when `main` is deployed.

What this means in practice:

- You never need a production key to build, test or ship a feature: merge to `main` and the hosts deploy with their own stored values.
- Don't print, log, echo, copy or save injected values. Don't write them to a `.env` that you then share. The values you can see during a run are development-only and can be rotated by the owner at any time.
- If a feature needs a new variable, add the **name** to the right `.env.example` in your PR and mention it in the task. The owner adds the value in Reevake and on the host.
- If a secret leaks (committed, logged, pasted), tell the project owner immediately so it can be rotated.

> No system can stop someone from reading a value that runs on their own machine. That's why employees only ever get development and sandbox values, while production values stay in owner-only storage and on the hosts.

## Owner checklist

- [ ] Supabase `grocera`: copy the database password, the `sb_secret_` key and the pooler connection strings (Dashboard › Connect) into Reevake › Project secrets.
- [ ] Supabase Auth: enable phone OTP and add the Twilio credentials in Dashboard › Authentication (they're stored by Supabase, not by the app).
- [ ] Neon: create the `grocera` project in Sydney. Its `main` branch is the dev database; ReevTask branches it per task.
- [ ] Railway: create the `grocera` project, connect this repo with root directory `services/api`, turn on PR environments, and paste the server variables from `services/api/.env.example`.
- [ ] Vercel: create `grocera-merchant-portal` (root `apps/merchant-portal`) and `grocera-admin` (root `apps/admin`), region `syd1`, and add the `NEXT_PUBLIC_*` variables.
- [ ] Cloudflare Pages: connect this repo for the Flutter web build (`apps/mobile`, output `build/web`).
- [ ] Before the pilot: upgrade Supabase to Pro, and switch Stripe and couriers to live keys on production only.
