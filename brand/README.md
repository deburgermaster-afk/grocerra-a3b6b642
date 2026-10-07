# GROCERRA brand marks

Source: Reevake project files API — `GET /api/agent/project-files?projectId=a3b6b642-dcf7-4fee-a932-99340afdb790`,
file `GROCERRA.zip` (id `a08e5d43-f8bc-4982-b94a-f8d72e91016c`), extracted unmodified.
`preview.png` is a rendering contact sheet (light row on top, dark row below).

All six marks are 500 × 500 SVGs, 8 paths, brand green `#5ac426`, wordmark "GROCERRA".

| file | weight | background | wordmark |
|------|--------|------------|----------|
| `1.svg` | bold | cream `#f6f4f1` | black "GRO" + green "CERRA" |
| `2.svg` | bold | black `#000000` | white "GRO" + green "CERRA" |
| `3.svg` | bold | green `#5ac426` | white "GRO" + black "CERRA" |
| `4.svg` | light | black `#000000` | white "GRO" + green "CERRA" |
| `5.svg` | light | cream `#f6f4f1` | black "GRO" + green "CERRA" |
| `6.svg` | light | green `#5ac426` | white "GRO" + white "CERRA" |

## Figma is the visual source of truth

Authoritative marks and rules live in the Figma file `GROCERRA - APP - Flow`, frame
**`R1 · GROCERRA logo rules`** (`1:1925`): components `Logo / GROCERRA wordmark / L|M|S`
and `Logo / S monogram`.

Rules as written in Figma:

- Wordmark: **Inter Bold, uppercase, +14% tracking, black on light surfaces.**
- Clear space: one cap-height (the height of the "S") on every side.
- Minimum size: 64 px wide — use the S size at the smallest.
- The "S" monogram is for app-icon and avatar slots only.
- Never restretch, recolour, outline, or add shapes, gradients or a tagline.

**Open discrepancy:** these SVGs are two-tone (black/white + green), while the Figma
wordmark component renders solid black. Confirm with the design owner before shipping
either one into a screen.

Pending-approval screens per Figma: `07 · Checkout`, `08 · Payment`, `09 · Order
confirmation`, `10 · Order tracking`, and the catering frames (Catering hub,
Request a quote · Event and Details, Quote request sent).
