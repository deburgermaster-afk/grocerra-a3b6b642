import type { Metadata, Viewport } from "next"
import "./globals.css"

export const metadata: Metadata = {
  metadataBase: new URL("https://grocerra.com.au"),
  title: "Grocerra — Fresh groceries and catering, delivered to you",
  description: "Fresh groceries and catering, delivered to you. Order from independent local stores and caterers, delivered on demand across Melbourne.",
  openGraph: { title: "Grocerra", description: "Fresh groceries and catering, delivered to you.", url: "https://grocerra.com.au", type: "website" },
}
export const viewport: Viewport = { themeColor: "#14532d", width: "device-width", initialScale: 1 }

export default function RootLayout({ children }: { children: React.ReactNode }) {
  return <html lang="en-AU"><body>{children}</body></html>
}
