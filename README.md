# Grocerra

South Asian groceries, halal meat and catering delivered on demand in Melbourne. Internal Reevake product; pilot launch target **1 December 2026**.

- Project, tasks and milestones: https://reevake.com/dashboard?project=a3b6b642-dcf7-4fee-a932-99340afdb790
- Brief: [docs/PROJECT_BRIEF.md](docs/PROJECT_BRIEF.md)
- Setup, services and secrets: [SETUP.md](SETUP.md)
- Architecture: [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md) (live version: Reevake › Blueprints)

## Where things live

| What | URL | Vercel project | Deploys from |
|---|---|---|---|
| Customer app (Flutter web) | https://grocerra-app.vercel.app | `grocerra-app` (root `apps/mobile`) | `main` → production; every branch/PR → preview |
| Landing page | https://grocerra.com.au (`www.` redirects) | `grocerra-website` (root `apps/website`) | `main` → production |
| Backend | https://dfktgmjkgspljdpsvbcl.supabase.co | Supabase `grocera` (Sydney) | migrations / dashboard |

All app development, testing and auth email links point at
`grocerra-app.vercel.app`; only public marketing lives on the domain.

## Layout

| Folder | What lives here |
|---|---|
| `apps/mobile` | Flutter customer app (screens C1–C26) |
| `apps/merchant-portal` | Next.js merchant portal (M1–M14) |
| `apps/admin` | Next.js admin panel (A1–A13) |
| `supabase` | Database migrations, Edge Functions and config (no servers) |
| `docs` | Brief, architecture and decisions |

## Working on a task

1. Connect your coding agent in Reevake › ReevTask for **this repository** and pick up your assigned task.
2. Work on a branch named after the task, and keep the PR focused on it.
3. Put `Reevake-Task: <taskId>` in the PR description and submit the PR link from your agent or the task page.
4. Never commit secrets. Your agent loads project secrets (Stripe, courier and maps keys) at run time from Reevake; see [SETUP.md](SETUP.md).
