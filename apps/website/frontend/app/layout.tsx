import type { Metadata, Viewport } from "next";
import { ThemeProvider } from "./components/ThemeProvider";
import "./globals.css";

export const metadata: Metadata = {
  metadataBase: new URL("https://grocerra.com"),
  title: "Grocerra | Groceries and Fresh Meat Delivered in Australia",
  description: "Order groceries, fresh halal meat and catering from trusted local stores. Get live delivery quotes and track your order.",
  keywords: [
    "grocery delivery Australia",
    "fresh meat delivery Melbourne",
    "Halal meat delivery Melbourne",
    "Bangladeshi grocery online",
    "Indian grocery delivery",
    "Pakistani butchers Melbourne",
    "Sri Lankan spices Australia",
    "Nepali sweets delivery",
    "catering delivery Melbourne"
  ],
  authors: [{ name: "Grocerra Technologies Pty Ltd" }],
  openGraph: {
    title: "Grocerra | Groceries and Fresh Meat Delivered in Australia",
    description: "Order groceries, fresh halal meat and catering from trusted local stores. Get live delivery quotes and track your order.",
    url: "https://grocerra.com",
    siteName: "Grocerra",
    locale: "en_AU",
    type: "website"
  },
  twitter: {
    card: "summary_large_image",
    title: "Grocerra | Groceries and Fresh Meat Delivered in Australia",
    description: "Order groceries, fresh halal meat and catering from trusted local stores. Get live delivery quotes and track your order."
  },
  robots: {
    index: true,
    follow: true
  }
};

export const viewport: Viewport = {
  themeColor: "#16A34A",
  width: "device-width",
  initialScale: 1
};

export default function RootLayout({ children }: { children: React.ReactNode }) {
  return (
    <html lang="en-AU">
      <body>
        <ThemeProvider>
          {children}
        </ThemeProvider>
      </body>
    </html>
  );
}
