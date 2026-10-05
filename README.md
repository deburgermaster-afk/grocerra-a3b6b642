# DesiPantry

South Asian groceries, halal meat and catering delivered on demand in Melbourne. Internal Reevake product; pilot launch target **1 December 2026**.

- Project, tasks and milestones: https://reevake.com/dashboard?project=a3b6b642-dcf7-4fee-a932-99340afdb790
- Brief: [docs/PROJECT_BRIEF.md](docs/PROJECT_BRIEF.md)
- Architecture: [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md) (live version: Reevake › Blueprints)

## Layout

| Folder | What lives here |
|---|---|
| `apps/mobile` | Flutter customer app (screens C1–C26) |
| `apps/merchant-portal` | Next.js merchant portal (M1–M14) |
| `apps/admin` | Next.js admin panel (A1–A13) |
| `services/api` | NestJS backend API and job worker |
| `docs` | Brief, architecture and decisions |

## Working on a task

1. Connect your coding agent in Reevake › ReevTask for **this repository** and pick up your assigned task.
2. Work on a branch named after the task, and keep the PR focused on it.
3. Put `Reevake-Task: <taskId>` in the PR description and submit the PR link from your agent or the task page.
4. Never commit secrets. Your agent loads project secrets (Stripe, courier and maps keys) at run time from Reevake.
