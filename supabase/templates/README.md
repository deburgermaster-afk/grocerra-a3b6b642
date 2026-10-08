# Supabase Auth email templates

Paste these into Supabase › Authentication › Emails › Templates
(project `grocera`). They show the **6-digit code** the app asks for
(`{{ .Token }}`), with the one-tap link as a fallback.

| Template | Subject | File |
|---|---|---|
| Confirm signup | `Your Grocerra code: {{ .Token }}` | `confirm_signup.html` |
| Reset password | `Reset your Grocerra password: {{ .Token }}` | `reset_password.html` |

The app expects 6 digits (`VerifyCodeScreen.codeLength`). If Supabase ›
Authentication › Providers › Email shows a different *Email OTP Length*,
set it to 6.

Emails are sent through Resend (SMTP) from `accounts@grocerra.com.au`; see the
root SETUP.md.
