# Grocerra emails (Resend)

All mail goes out through Resend on the verified domain `grocerra.com.au`.
Each kind of mail has its own sender, so customers recognise it and so
reputation, filtering and analytics stay separate.

| Sender | Used for | Sent by |
|---|---|---|
| `Grocerra <accounts@grocerra.com.au>` | Sign-up codes, password resets | Supabase Auth (SMTP via Resend), templates in `supabase/templates/` |
| `Grocerra <hello@grocerra.com.au>` | Welcome and customer account mail | Resend template `account-welcome` |
| `Grocerra Orders <orders@grocerra.com.au>` | Receipts and delivery updates | `order-confirmation`, `order-update` |
| `Grocerra for Merchants <merchants@grocerra.com.au>` | Store onboarding and new-order alerts | `merchant-welcome`, `merchant-new-order` |
| `support@grocerra.com.au` | Reply-to address for customer mail | (needs an inbox, see below) |

## Templates

Source of truth: `build.py` generates `templates/*.html` (table layout,
inline CSS, Resend `{{{VARIABLE}}}` placeholders). The same five are
published in Resend under these aliases:

| Alias | Variables |
|---|---|
| `account-welcome` | `CUSTOMER_NAME`, `APP_URL` |
| `order-confirmation` | `CUSTOMER_NAME`, `ORDER_ID`, `STORE_NAME`, `ETA`, `ITEM_SUMMARY`, `SUBTOTAL`, `DELIVERY_FEE`, `TOTAL`, `DELIVERY_ADDRESS`, `TRACK_URL` |
| `order-update` | `CUSTOMER_NAME`, `ORDER_ID`, `STATUS_TITLE`, `STATUS_MESSAGE`, `TRACK_URL` |
| `merchant-new-order` | `MERCHANT_NAME`, `ORDER_ID`, `PICKUP_BY`, `ITEM_SUMMARY`, `ORDER_TOTAL`, `PORTAL_URL` |
| `merchant-welcome` | `MERCHANT_NAME`, `CONTACT_NAME`, `PORTAL_URL` |

Send from an Edge Function with `RESEND_API_KEY` (never from the app):

```ts
await fetch("https://api.resend.com/emails", {
  method: "POST",
  headers: { Authorization: `Bearer ${Deno.env.get("RESEND_API_KEY")}`, "Content-Type": "application/json" },
  body: JSON.stringify({
    to: customer.email,
    template: { id: "order-confirmation", variables: { ORDER_ID: "GR-10482", /* ... */ } },
  }),
})
```

To change a design: edit `build.py`, run `python3 emails/build.py`, then
update the Resend template with the new HTML and publish it.

## Receiving mail

Sending works with the three Resend DNS records. Replies to `support@` /
`merchants@` need an inbox: either turn on receiving for the domain in
Resend (adds an MX record) or use a mailbox provider; the root domain
currently publishes `v=spf1 -all` and has no MX, so replies would bounce.
