import type { Metadata } from "next";
import Link from "next/link";
import Header from "../components/Header";
import HowItWorks from "../components/HowItWorks";
import Footer from "../components/Footer";

export const metadata: Metadata = {
  title: "How It Works | Grocerra",
  description:
    "Learn how Grocerra connects you with local South Asian grocery stores, butchers, and caterers with live tracking and fast delivery.",
};

const TIMELINE_STEPS = [
  {
    step: "01",
    title: "Find a local store",
    desc: "Enter your delivery address to instantly see nearby South Asian grocery stores, specialty spice markets, and certified halal butchers available in your suburb.",
    detail: "Filter by dietary needs, South Asian regional cuisines (Indian, Pakistani, Bangladeshi, Sri Lankan), or customer ratings.",
  },
  {
    step: "02",
    title: "Add items to basket",
    desc: "Select fresh vegetables, basmati rice, lentils, imported snacks, and custom butcher meat cuts.",
    detail: "Real-time stock indicators ensure your favorite brands are in stock before you place an order.",
  },
  {
    step: "03",
    title: "See live delivery quote",
    desc: "Get upfront distance-based delivery calculation with no hidden surge fees before you confirm.",
    detail: "Clear breakdown of item prices, delivery quote, and estimated arrival timeframe.",
  },
  {
    step: "04",
    title: "Pay securely",
    desc: "Checkout using 256-bit encrypted secure payment methods including major credit cards, Apple Pay, and Google Pay.",
    detail: "Instant order confirmation sent to your phone with digital tax invoice.",
  },
  {
    step: "05",
    title: "Track courier in real time",
    desc: "Watch your courier on an interactive live map from the store pickup to your front doorstep.",
    detail: "Receive live SMS and app notifications at every stage: store packing, driver assigned, and doorstep arrival.",
  },
];

export default function HowItWorksPage() {
  return (
    <>
      <Header />

      <main className="min-h-screen bg-[var(--bg-main)]">
        {/* Breadcrumb Header */}
        <div className="border-b border-[var(--border-color)] bg-[var(--bg-card)] py-4">
          <div className="container">
            <nav aria-label="Breadcrumb" className="flex items-center gap-2 text-xs text-[var(--text-muted)]">
              <Link href="/" className="hover:text-[var(--green-primary)] transition-colors">
                Home
              </Link>
              <span>/</span>
              <span className="font-semibold text-[var(--text-main)]">How It Works</span>
            </nav>
          </div>
        </div>

        {/* Hero / Top Component: How It Works Section */}
        <HowItWorks />

        {/* Detailed Customer Timeline Section */}
        <section className="section-padding border-t border-[var(--border-color)] bg-[var(--bg-main)]">
          <div className="container">
            <div className="mx-auto max-w-3xl text-center">
              <span className="inline-flex rounded-full border border-[var(--border-color)] bg-[var(--green-soft)] px-3 py-1 text-xs font-bold uppercase tracking-wider text-[var(--green-primary)]">
                Step-by-Step Experience
              </span>
              <h2 className="mt-4 text-3xl font-extrabold text-[var(--text-main)] sm:text-4xl">
                Your journey from store shelf to kitchen counter
              </h2>
              <p className="mt-3 text-base text-[var(--text-muted)]">
                Here is exactly what happens behind the scenes when you order with Grocerra.
              </p>
            </div>

            <div className="relative mx-auto mt-12 max-w-4xl space-y-8 pl-6 sm:pl-10 lg:pl-12">
              {/* Vertical connecting timeline bar */}
              <div className="absolute top-4 bottom-4 left-3 w-0.5 bg-[var(--green-primary)]/30 sm:left-5 lg:left-6" />

              {TIMELINE_STEPS.map((item) => (
                <div key={item.step} className="group relative flex items-start gap-4 sm:gap-6">
                  {/* Circle Step Number indicator */}
                  <div className="relative z-10 flex size-9 shrink-0 items-center justify-center rounded-full border-2 border-[var(--green-primary)] bg-[var(--bg-card)] text-xs font-black text-[var(--green-primary)] shadow-sm transition-transform duration-300 group-hover:scale-110">
                    {item.step}
                  </div>

                  {/* Content Box */}
                  <div className="flex-1 rounded-2xl border border-[var(--border-card)] bg-[var(--bg-card)] p-6 shadow-sm transition-all duration-300 hover:border-[var(--green-primary)] hover:shadow-md">
                    <h3 className="text-xl font-bold text-[var(--text-main)]">{item.title}</h3>
                    <p className="mt-2 text-sm leading-6 text-[var(--text-main)]">{item.desc}</p>
                    <p className="mt-2 rounded-lg bg-[var(--bg-card-subtle)] p-3 text-xs text-[var(--text-muted)]">
                      💡 {item.detail}
                    </p>
                  </div>
                </div>
              ))}
            </div>
          </div>
        </section>

        {/* Short Catering Banner */}
        <section className="border-t border-[var(--border-color)] bg-[var(--bg-card-subtle)] py-12">
          <div className="container flex flex-col items-center justify-between gap-6 sm:flex-row">
            <div>
              <span className="text-xs font-bold uppercase tracking-wider text-[var(--green-primary)]">
                Event & Party Orders
              </span>
              <h3 className="mt-1 text-2xl font-extrabold text-[var(--text-main)]">
                Ordering for an event?
              </h3>
              <p className="mt-1 text-sm text-[var(--text-muted)]">
                Get custom quotes for large catering spreads, family gatherings, and bulk butcher orders.
              </p>
            </div>
            <Link href="/catering/request" className="btn-pill btn-green-accent shrink-0">
              Request Catering Quote →
            </Link>
          </div>
        </section>

        {/* FAQ Link Footer Section */}
        <section className="py-12 text-center border-t border-[var(--border-color)]">
          <div className="container">
            <p className="text-sm text-[var(--text-muted)]">
              Have questions about delivery fees, store hours, or minimum orders?{" "}
              <Link href="/help/faq" className="font-bold text-[var(--green-primary)] hover:underline">
                Visit our Help & FAQ center
              </Link>
            </p>
          </div>
        </section>
      </main>

      <Footer />
    </>
  );
}
