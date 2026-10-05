# Sogrow architecture

The source of truth is the **Sogrow app stack** blueprint in Reevake (Blueprints tab). This file is a snapshot for the repository.

## Components

| Component | Technology | Folder |
|---|---|---|
| Customer app (iOS / Android) | Flutter + MapLibre GL | `apps/mobile` |
| Merchant portal | Next.js | `apps/merchant-portal` |
| Admin panel | Next.js | `apps/admin` |
| Backend API and job worker | NestJS + PostgreSQL (Sydney) | `services/api` |
| Payments | Stripe Connect | `services/api` (PaymentProvider) |
| Delivery | Uber Direct + DoorDash Drive | `services/api` (DeliveryProvider) |

## Core tables

- **users**: id, phone, email, role, created_at
- **customer_addresses**: id, user_id → users.id, line1, unit, suburb, state, postcode, instructions, lat, lng
- **stores**: id, name, abn, kind, halal_certified, status, stripe_account_id, delivery_radius_km, lat, lng
- **store_users**: id, store_id → stores.id, user_id → users.id, role
- **store_hours**: id, store_id → stores.id, weekday, opens, closes, closed_on
- **categories**: id, store_id → stores.id, name, sort
- **products**: id, store_id → stores.id, category_id → categories.id, name, is_halal, is_vegetarian, allergens
- **product_variants**: id, product_id → products.id, label, price_cents, weight_grams, priced_by_weight
- **inventory**: id, variant_id → product_variants.id, quantity, low_stock_threshold
- **orders**: id, customer_id → users.id, store_id → stores.id, address_id → customer_addresses.id, status, subtotal_cents, platform_fee_cents, commission_cents, delivery_fee_cents, total_cents
- **order_items**: id, order_id → orders.id, variant_id → product_variants.id, quantity, unit_price_cents, substitution_pref, final_weight_grams
- **order_status_events**: id, order_id → orders.id, status, actor, created_at
- **payments**: id, order_id → orders.id, stripe_payment_intent, authorised_cents, captured_cents, status
- **refunds**: id, payment_id → payments.id, amount_cents, reason, liable_party, status
- **store_payouts**: id, store_id → stores.id, period_start, period_end, amount_cents, stripe_transfer_id
- **delivery_quotes**: id, order_id → orders.id, provider, fee_cents, eta_minutes, expires_at
- **deliveries**: id, order_id → orders.id, quote_id → delivery_quotes.id, provider, external_id, status, tracking_url, proof_photo_url
- **delivery_events**: id, delivery_id → deliveries.id, provider_event, payload, received_at
- **promotions**: id, code, kind, value_cents, funded_by, starts_at, ends_at
- **promotion_redemptions**: id, promotion_id → promotions.id, order_id → orders.id, user_id → users.id
- **support_tickets**: id, order_id → orders.id, user_id → users.id, kind, status, photo_url
- **catering_requests**: id, customer_id → users.id, address_id → customer_addresses.id, event_type, event_date, guests, budget_cents, dietary, status
- **catering_quotes**: id, request_id → catering_requests.id, store_id → stores.id, total_cents, deposit_cents, status
- **catering_packages**: id, store_id → stores.id, name, price_per_guest_cents, min_guests
- **reviews**: id, order_id → orders.id, user_id → users.id, store_id → stores.id, rating

## Planned API routes

- `POST /auth/otp` — users (public)
- `GET /stores` — stores
- `GET /stores/:id/products` — products
- `POST /carts/:id/checkout` — orders
- `POST /delivery-quotes` — delivery_quotes
- `POST /payments/intents` — payments
- `GET /orders/:id/tracking` — deliveries
- `POST /orders/:id/issues` — support_tickets
- `POST /refunds` — refunds
- `POST /catering/requests` — catering_requests
- `POST /catering/quotes/:id/accept` — catering_quotes
- `GET /merchant/orders` — orders
- `PATCH /merchant/orders/:id` — orders
- `PUT /merchant/inventory/:variantId` — inventory
- `POST /admin/payout-runs` — store_payouts
- `POST /webhooks/stripe` — payments
- `POST /webhooks/uber-direct` — delivery_events
- `POST /webhooks/doordash` — delivery_events

## Rules that matter

- Money is stored in AUD cents; prices are shown GST-inclusive.
- Secrets never ship in the mobile app or web bundles. Webhooks are signature-verified and idempotent.
- Courier selection, failover, refund liability and weight-based capture follow `docs/PROJECT_BRIEF.md`.
