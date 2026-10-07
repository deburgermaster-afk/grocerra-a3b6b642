import type { Metadata, Viewport } from "next"
import "./globals.css"

export const metadata: Metadata = {
  metadataBase: new URL("https://grocerra.com"),
  title: "Grocerra — South Asian groceries, halal meat & catering delivered in Melbourne",
  description: "Order authentic South Asian groceries, fresh halal meat and catering from independent local stores, delivered on demand across Melbourne.",
  openGraph: { title: "Grocerra", description: "South Asian groceries, halal meat and catering, delivered on demand in Melbourne.", url: "https://grocerra.com", type: "website" },
}
export const viewport: Viewport = { themeColor: "#14532d", width: "device-width", initialScale: 1 }

export default function RootLayout({ children }: { children: React.ReactNode }) {
  return <html lang="en-AU"><body>{children}</body></html>
}
