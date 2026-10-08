# Grocerra website

Public landing page for **https://grocerra.com.au** (Next.js, static). The
customer app is separate: it lives at https://grocerra-app.vercel.app
(`apps/mobile`).

- Run locally: `npm install && npm run dev`
- Deploys: every push to `main` deploys to production at
  https://grocerra.com.au through Vercel (project `grocerra-website`, root
  directory `apps/website`); `www.grocerra.com.au` redirects there. Other
  branches and PRs get a preview link.
- `grocerra.com` is attached to the same project but waits on DNS
  verification (TXT record on `_vercel.grocerra.com`).
- Edit the page in `app/page.tsx` and styles in `app/globals.css`.
