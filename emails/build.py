"""Builds the Grocerra Resend email templates (table-based, inline CSS).

Run: python3 emails/build.py  -> writes emails/templates/*.html
Variables use Resend's triple-brace syntax: {{{ORDER_ID}}}.
"""
from pathlib import Path

FONT = "-apple-system,BlinkMacSystemFont,'Segoe UI',Roboto,Helvetica,Arial,sans-serif"
INK, MUTED, LINE, GREEN, BG = "#0b0d0b", "#5b625c", "#e3e6e2", "#16a34a", "#f6f7f5"


def p(text, size=15, color=MUTED, bottom=16, weight=400):
    return (f'<p style="margin-top:0;margin-bottom:{bottom}px;font-family:{FONT};'
            f'font-size:{size}px;line-height:1.55;color:{color};font-weight:{weight}">{text}</p>')


def button(label, url):
    return f'''<table role="presentation" cellpadding="0" cellspacing="0" border="0" style="margin-top:8px;margin-bottom:8px">
  <tr><td bgcolor="{INK}" style="background-color:{INK};border-radius:26px">
    <a href="{url}" style="display:inline-block;padding-top:14px;padding-bottom:14px;padding-left:28px;padding-right:28px;font-family:{FONT};font-size:15px;line-height:20px;font-weight:600;color:#ffffff;text-decoration:none">{label}</a>
  </td></tr>
</table>'''


def rows(pairs, total=None):
    out = []
    for k, v in pairs:
        out.append(f'''<tr>
  <td style="padding-top:8px;padding-bottom:8px;font-family:{FONT};font-size:14px;line-height:20px;color:{MUTED}">{k}</td>
  <td align="right" style="padding-top:8px;padding-bottom:8px;font-family:{FONT};font-size:14px;line-height:20px;color:{INK}">{v}</td>
</tr>''')
    if total:
        out.append(f'''<tr>
  <td style="padding-top:12px;border-top:1px solid {LINE};font-family:{FONT};font-size:16px;line-height:22px;font-weight:700;color:{INK}">{total[0]}</td>
  <td align="right" style="padding-top:12px;border-top:1px solid {LINE};font-family:{FONT};font-size:16px;line-height:22px;font-weight:700;color:{INK}">{total[1]}</td>
</tr>''')
    return ('<table role="presentation" width="100%" cellpadding="0" cellspacing="0" border="0" '
            'style="margin-top:4px;margin-bottom:20px">' + "".join(out) + "</table>")


def badge(text):
    return (f'<table role="presentation" cellpadding="0" cellspacing="0" border="0" style="margin-bottom:14px"><tr>'
            f'<td bgcolor="#e8f6e1" style="background-color:#e8f6e1;border-radius:12px;padding-top:4px;padding-bottom:4px;'
            f'padding-left:10px;padding-right:10px;font-family:{FONT};font-size:12px;line-height:16px;font-weight:600;color:{GREEN}">'
            f'{text}</td></tr></table>')


def page(preheader, title, body, footer_note):
    return f'''<!DOCTYPE html>
<html lang="en-AU">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<title>{title}</title>
</head>
<body style="margin:0;padding:0;background-color:{BG}">
<div style="display:none;max-height:0;overflow:hidden;font-size:1px;line-height:1px;color:{BG}">{preheader}</div>
<table role="presentation" width="100%" cellpadding="0" cellspacing="0" border="0" bgcolor="{BG}" style="background-color:{BG}">
  <tr><td align="center" style="padding-top:32px;padding-bottom:32px;padding-left:16px;padding-right:16px">
    <table role="presentation" width="100%" cellpadding="0" cellspacing="0" border="0" style="max-width:560px">
      <tr><td style="padding-bottom:20px;padding-left:4px;font-family:{FONT};font-size:22px;line-height:28px;font-weight:600;letter-spacing:2px;color:{INK}">GRO<span style="color:#5ac426">CERRA</span></td></tr>
      <tr><td bgcolor="#ffffff" style="background-color:#ffffff;border:1px solid {LINE};border-radius:20px;padding-top:32px;padding-bottom:28px;padding-left:28px;padding-right:28px">
        <h1 style="margin-top:0;margin-bottom:12px;font-family:{FONT};font-size:24px;line-height:30px;font-weight:700;color:{INK}">{title}</h1>
        {body}
      </td></tr>
      <tr><td style="padding-top:20px;padding-left:4px;padding-right:4px;font-family:{FONT};font-size:12px;line-height:18px;color:#8b938d">
        {footer_note}<br>Grocerra · Fresh groceries and catering, delivered to you.
      </td></tr>
    </table>
  </td></tr>
</table>
</body>
</html>
'''


TEMPLATES = {
    "account-welcome": page(
        "Your Grocerra account is ready.",
        "Welcome to Grocerra, {{{CUSTOMER_NAME}}}",
        p("Your account is ready. Fresh groceries from local stores you trust, at your door in about an hour.")
        + p("Planning a party, a celebration or a family gathering? Request catering quotes in the app too.")
        + button("Start shopping", "{{{APP_URL}}}"),
        "You're receiving this because you created a Grocerra account."),
    "order-confirmation": page(
        "We've got your order {{{ORDER_ID}}}.",
        "Order confirmed",
        badge("Order {{{ORDER_ID}}}")
        + p("Thanks {{{CUSTOMER_NAME}}}! <strong style=\"color:#0b0d0b\">{{{STORE_NAME}}}</strong> is preparing your order. Estimated arrival: <strong style=\"color:#0b0d0b\">{{{ETA}}}</strong>.")
        + p("{{{ITEM_SUMMARY}}}", size=14, color=INK)
        + rows([("Subtotal", "{{{SUBTOTAL}}}"), ("Delivery", "{{{DELIVERY_FEE}}}")], total=("Total", "{{{TOTAL}}}"))
        + p("Delivering to {{{DELIVERY_ADDRESS}}}. Meat is charged at its estimated weight; anything packed under the estimate is refunded automatically.", size=13)
        + button("Track your order", "{{{TRACK_URL}}}"),
        "This is the receipt for your Grocerra order."),
    "order-update": page(
        "{{{STATUS_TITLE}}} - order {{{ORDER_ID}}}",
        "{{{STATUS_TITLE}}}",
        badge("Order {{{ORDER_ID}}}")
        + p("Hi {{{CUSTOMER_NAME}}}, {{{STATUS_MESSAGE}}}")
        + button("View order", "{{{TRACK_URL}}}"),
        "You're receiving this because you placed an order on Grocerra."),
    "merchant-new-order": page(
        "New order {{{ORDER_ID}}} - pick up by {{{PICKUP_BY}}}.",
        "New order to prepare",
        badge("Order {{{ORDER_ID}}}")
        + p("{{{MERCHANT_NAME}}}, a customer just ordered from you. Please accept and pack it so the courier can collect by <strong style=\"color:#0b0d0b\">{{{PICKUP_BY}}}</strong>.")
        + p("{{{ITEM_SUMMARY}}}", size=14, color=INK)
        + rows([], total=("Order value", "{{{ORDER_TOTAL}}}"))
        + button("Open in merchant portal", "{{{PORTAL_URL}}}"),
        "You're receiving this as a Grocerra partner store."),
    "merchant-welcome": page(
        "Welcome to Grocerra for merchants.",
        "Welcome aboard, {{{MERCHANT_NAME}}}",
        p("Hi {{{CONTACT_NAME}}}, your store is set up on Grocerra. Next steps:")
        + p("1. Add your products and prices<br>2. Set your opening hours and pickup details<br>3. Connect your payout account", color=INK)
        + p("Customers across Melbourne can order from you as soon as your store is live. We handle delivery, so there's no fleet to run.")
        + button("Set up your store", "{{{PORTAL_URL}}}"),
        "You're receiving this because your business joined Grocerra."),
}

out = Path(__file__).parent / "templates"
out.mkdir(exist_ok=True)
for name, html in TEMPLATES.items():
    (out / f"{name}.html").write_text(html)
print("\n".join(sorted(TEMPLATES)))
