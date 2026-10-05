# DesiPantry — South Asian Groceries & Catering Delivery (Australia)

Internal Reevake product. Fresh halal meat, authentic South Asian groceries and catering, delivered on demand. Launch region: Melbourne metro (then Sydney and Brisbane). Target launch: 1 December 2026. Stage: MVP planning and architecture.

## Vision
Australia's on-demand marketplace for authentic South Asian groceries, certified halal meat and traditional catering, empowering independent local merchants. Ordering works like Uber Eats; delivery is fulfilled by third-party couriers (Uber Direct and DoorDash Drive).

## Problem
- Customers can't find authentic South Asian groceries and caterers in one place; supermarkets lack regional items and fresh halal meat, and catering runs through WhatsApp/Facebook groups.
- Independent stores have no delivery fleet or online ordering.
- Mainstream apps charge 25–30% commission, pushing store prices up 20%+; ethnic competitors use slow scheduled windows instead of on-demand delivery.

## Users
Households, students and young professionals, event hosts (catering), store owners (grocers, halal butchers), caterers and home chefs, and platform admins. Primary segment: South Asian households, international students, young professionals and event customers in Melbourne.

## Cuisines and categories
Bangladeshi, Indian and Pakistani (high priority); Sri Lankan and Nepali/Bhutanese (medium); Maldivian, Afghan and other (low). Categories: pantry essentials, rice/flour/grains, lentils, spices, fresh and frozen meat and fish, halal products, frozen foods, snacks and sweets, bakery, ready meals, beverages, catering and bulk.

## MVP (Phase 1) — prove one complete loop: order → pay → fulfil → deliver → payout
Must: registration/login, address and location, store discovery and search, product catalogue, cart and checkout, live delivery quote, payments (card, Apple Pay, Google Pay), merchant order dashboard, courier dispatch and tracking, refunds and partial refunds.
Should: basic catering request and quote, basic promotions.
Phase 2: loyalty and subscriptions, recommendations, multi-store cart, scheduled recurring orders, advanced inventory sync, multi-language (Bangla, Hindi, Urdu, Tamil, Nepali).

## Apps
- Customer app (Flutter): 26 screens C1–C26. Navigation: Home · Browse · Catering · Orders · Profile; contextual cart; Apple-inspired light UI, restrained green accent, glass floating nav bar. Prototype store: Madina Halal Meats.
- Merchant portal (web, Next.js): M1–M14 — login/2FA, onboarding with ABN, dashboard, live orders, order detail, catalogue, inventory, hours, catering packages and quotes, promotions, payouts, reports, staff, support.
- Admin panel (web, Next.js): A1–A13 — roles/2FA, dashboard (GMV, margin), merchant approval, store/customer management, order monitoring and manual dispatch, courier provider monitor, refunds and disputes, commission, payouts and reconciliation, content, fraud flags, analytics, audit log.

## Stack decisions (from the document)
Mobile: Flutter + MapLibre GL (60/120fps map tracking). Web portals: Next.js/React. Backend: NestJS (live WebSockets). Database: PostgreSQL. Payments: Stripe Connect. Still open: backend platform (Supabase Sydney suggested), auth (Supabase Auth/OTP suggested), maps (Google Maps Platform suggested), push (FCM/APNs), email/SMS (Resend or SES/Twilio), file storage (S3-compatible + CDN), hosting (Vercel/Railway/AWS), monitoring (Sentry), CI/CD (GitHub Actions + EAS). Prefer Australian (Sydney) hosting for data residency.

## Delivery (Uber Direct + DoorDash Drive)
Both available in Melbourne; ~AUD 8.50 base (0–3 km) + ~1.40–1.50/km, ~AUD 11–11.50 + GST average; 22.7 kg per courier (split heavier orders); photo proof of delivery; tracking URL and webhooks; scheduled delivery supported. Selection: quote both concurrently, pick lowest fee incl. GST; if within AUD 0.50 pick fastest pickup ETA; force car vehicles; if no driver within 5 minutes or driver cancels, auto-dispatch to the other provider. All provider figures are placeholders to verify during onboarding.

## Payments
Customer pays the platform; store share, commission and delivery cost recorded separately; stores paid out via Stripe Connect. Revenue model: 4.5% store commission + 3% customer platform fee + delivery at live courier quote ($7.50 gross per $100 basket). Weight-priced items: +10% card pre-authorisation, exact capture after the store enters scale weights at packing. Refund rules per scenario (missing, damaged, late, wrong order, cancellations, catering cancellations, chargebacks) are defined in the documentation, section 13.3.

## Launch plan
Phases: validation → design → core build → payments and delivery → grocery and catering operations → testing and store submission → pilot (3–5 stores) → public launch. Go-to-market: win supply first (3–5 pilot stores), waitlist of 1,000–3,000 pre-launch, LAUNCH20 offer, community-led marketing (mosques, temples, university societies, festivals), Melbourne micro-influencers, AUD 20–40/day ads limited to delivery-zone suburbs.

## Open decisions to close
Brand name/tagline/logo; catering lead time, minimums, deposits and hot-food delivery; Connect account type and merchant of record; legal pack (ACL, Privacy Act, food safety, halal claims); budget and unit economics beyond gross revenue; team RACI. The 8-week runway to 1 December is shorter than the document's 13-week phase plan: treat 1 December as a pilot launch with 3–5 stores unless scope is cut further.
