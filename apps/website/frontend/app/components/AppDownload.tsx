"use client";

import Image from "next/image";
import ImageReveal from "./ImageReveal";
import { siApple, siGoogleplay } from "simple-icons";

const appFeatures = [
  "Live delivery quote before you pay",
  "Real-time courier tracking",
  "Reorder your favourites",
  "Catering requests from your phone",
  "Exclusive app offers"
];

export default function AppDownload() {
  return (
    <section
      id="app"
      className="scroll-mt-20 py-12 sm:py-16 lg:py-20"
      style={{
        backgroundColor: "var(--bg-main)",
        backgroundImage: "radial-gradient(var(--border-color) 0.7px, transparent 0.7px)",
        backgroundSize: "22px 22px",
      }}
    >
      <div className="container">
        <div className="grid items-center gap-8 lg:grid-cols-[minmax(0,1fr)_minmax(0,0.95fr)] lg:gap-12">
          
          {/* Left Column: Content */}
          <div className="relative z-10">
            <span style={{
              fontSize: "13px",
              fontWeight: 700,
              textTransform: "uppercase",
              letterSpacing: "0.08em",
              color: "var(--green-primary)",
              marginBottom: "12px",
              display: "block"
            }}>
              iOS & Android App
            </span>

            <h2 className="mb-4 text-3xl font-extrabold leading-[1.08] text-[var(--text-main)] sm:text-4xl lg:text-5xl">
              Get the app.<br />
              <span className="text-[var(--green-primary)]">Order faster.</span>
            </h2>

            <p className="mb-6 max-w-[460px] text-base leading-7 text-[var(--text-muted)] sm:text-lg">
              Shop, track and reorder in a few taps. Your favourite stores, one basket, live delivery.
            </p>

            <ul className="mb-7 grid grid-cols-1 gap-2 sm:grid-cols-2">
              {appFeatures.map((feat, idx) => (
                <li key={idx} className="flex min-h-12 items-center gap-3 rounded-lg border border-[var(--border-color)] bg-[var(--bg-card)] px-3 py-2 text-sm font-semibold text-[var(--text-main)]">
                  <div style={{
                    width: "22px",
                    height: "22px",
                    flexShrink: 0,
                    borderRadius: "50%",
                    backgroundColor: "var(--green-soft)",
                    color: "var(--green-primary)",
                    display: "flex",
                    alignItems: "center",
                    justifyContent: "center",
                    fontSize: "12px",
                    fontWeight: 800
                  }}>
                    ✓
                  </div>
                  {feat}
                </li>
              ))}
            </ul>

            {/* Badges & QR Code */}
            <div className="flex flex-wrap items-center gap-3">
              <div className="flex flex-wrap gap-2">
                {/* App Store Badge */}
                <a aria-label="Download on the App Store" href="/download/ios" className="inline-flex min-h-[52px] min-w-[154px] items-center gap-3 rounded-lg bg-[#080a09] px-4 py-2 text-white shadow-sm transition-transform hover:-translate-y-0.5">
                  <svg aria-hidden="true" className="h-7 w-7 shrink-0 fill-current" viewBox="0 0 24 24">
                    <path d={siApple.path} />
                  </svg>
                  <div style={{ textAlign: "left", lineHeight: 1.08 }}>
                    <div style={{ fontSize: "9px", opacity: 0.8 }}>Download on the</div>
                    <div style={{ fontSize: "15px", fontWeight: 700 }}>App Store</div>
                  </div>
                </a>

                {/* Google Play Badge */}
                <a aria-label="Get it on Google Play" href="/download/android" className="inline-flex min-h-[52px] min-w-[162px] items-center gap-3 rounded-lg bg-[#080a09] px-4 py-2 text-white shadow-sm transition-transform hover:-translate-y-0.5">
                  <svg aria-hidden="true" className="h-7 w-7 shrink-0" viewBox="0 0 24 24">
                    <defs>
                      <linearGradient id="google-play-mark" x1="0" x2="1" y1="0" y2="1">
                        <stop offset="0" stopColor="#35d07f" />
                        <stop offset="0.45" stopColor="#00b8f0" />
                        <stop offset="0.72" stopColor="#ffd43b" />
                        <stop offset="1" stopColor="#f04454" />
                      </linearGradient>
                    </defs>
                    <path d={siGoogleplay.path} fill="url(#google-play-mark)" />
                  </svg>
                  <div style={{ textAlign: "left", lineHeight: 1.08 }}>
                    <div style={{ fontSize: "9px", opacity: 0.8 }}>GET IT ON</div>
                    <div style={{ fontSize: "15px", fontWeight: 700 }}>Google Play</div>
                  </div>
                </a>
              </div>

            </div>
          </div>

          {/* Right Column: Phone Mockup Visual */}
          <ImageReveal className="relative mx-auto h-[370px] w-full max-w-[390px] sm:h-[430px] sm:max-w-[440px] lg:h-[520px] lg:max-w-[500px]">
            <div className="absolute left-[1%] top-[15%] z-0 h-[300px] w-[158px] -rotate-[7deg] overflow-hidden rounded-[28px] border-[5px] border-[#222] bg-[#0b0b0b] p-2 shadow-xl sm:h-[350px] sm:w-[184px] lg:h-[410px] lg:w-[216px]">
              <div className="mb-1 flex items-center justify-between px-1 text-[6px] font-bold text-[var(--text-main)]">
                <span>9:41</span>
                <span>5G · 100%</span>
              </div>
              <div className="mx-auto mb-2 h-[10px] w-12 rounded-full bg-black" />
              <div className="h-[calc(100%-20px)] overflow-hidden rounded-[20px] bg-[var(--bg-main)] p-3 text-[9px] text-[var(--text-main)] sm:p-4 sm:text-[10px]">
                <div className="mb-3 flex items-center justify-between font-extrabold">
                  <span><span className="logo-gro">GRO</span><span className="logo-cerra">CERRA</span></span>
                  <span className="rounded-full bg-[var(--green-soft)] px-2 py-1 text-[8px] text-[var(--green-primary)]">LOCAL</span>
                </div>
                <div className="mb-3 rounded-md border border-[var(--border-color)] bg-[var(--bg-card)] px-2 py-2 text-[var(--text-muted)]">Search groceries</div>
                <div className="mb-2 font-bold">Popular near you</div>
                <div className="space-y-2">
                  <div className="flex items-center gap-2 rounded-md border border-[var(--border-color)] bg-[var(--bg-card)] p-2">
                    <span className="relative h-10 w-10 shrink-0">
                      <Image src="/images/rice.jpg" alt="" fill sizes="40px" style={{ objectFit: "contain" }} />
                    </span>
                    <span className="font-semibold">Miniket Rice<br />5kg · $18.99</span>
                  </div>
                  <div className="flex items-center gap-2 rounded-md border border-[var(--border-color)] bg-[var(--bg-card)] p-2">
                    <span className="relative h-10 w-10 shrink-0">
                      <Image src="/images/spice.jpg" alt="" fill sizes="40px" style={{ objectFit: "contain" }} />
                    </span>
                    <span className="font-semibold">Biryani Masala<br />$2.40</span>
                  </div>
                </div>
              </div>
            </div>

            <div
              className="absolute right-[10%] top-[2%] z-[1] h-[90%] w-[clamp(184px,52%,246px)] rounded-[42px] border-4 border-[#171717] p-2 shadow-xl"
              style={{ backgroundColor: "#0B0B0B", boxShadow: "0 28px 50px -18px rgba(0, 0, 0, 0.42)" }}
            >
              {/* Screen Content */}
              <div style={{
                backgroundColor: "var(--bg-main)",
                width: "100%",
                height: "100%",
                borderRadius: "32px",
                overflow: "hidden",
                display: "flex",
                flexDirection: "column",
                padding: "10px 12px 22px",
                fontSize: "12px",
                position: "relative"
              }}>
                <div style={{ position: "relative", display: "flex", alignItems: "center", justifyContent: "space-between", height: "22px", padding: "0 4px", marginBottom: "5px", fontSize: "8px", fontWeight: 800, color: "var(--text-main)" }}>
                  <span>9:41</span>
                  <div aria-hidden="true" style={{ position: "absolute", left: "50%", top: "1px", transform: "translateX(-50%)", width: "72px", height: "17px", borderRadius: "9999px", backgroundColor: "#050505" }} />
                  <span>5G · 100%</span>
                </div>

                {/* App Screen Header */}
                <div style={{ display: "flex", justifyContent: "space-between", alignItems: "center", marginBottom: "12px" }}>
                  <div>
                    <div style={{ fontSize: "10px", color: "var(--text-muted)" }}>DELIVERING TO</div>
                    <div style={{ fontSize: "13px", fontWeight: 800, color: "var(--text-main)" }}>Dandenong, VIC</div>
                  </div>
                  <div style={{ width: "42px", height: "28px", borderRadius: "9999px", backgroundColor: "var(--green-primary)", color: "#FFF", display: "flex", alignItems: "center", justifyContent: "center", fontWeight: 700, fontSize: "8px" }}>
                    LIVE
                  </div>
                </div>

                {/* Live Order Tracker Banner */}
                <div style={{ backgroundColor: "var(--green-soft)", border: "1px solid var(--green-primary)", borderRadius: "14px", padding: "12px", marginBottom: "14px" }}>
                  <div style={{ display: "flex", justifyContent: "space-between", marginBottom: "4px" }}>
                    <span style={{ fontWeight: 800, color: "var(--green-primary)", fontSize: "12px" }}>Courier En Route</span>
                    <span style={{ fontWeight: 700, color: "var(--green-primary)", fontSize: "12px" }}>ETA: 18 min</span>
                  </div>
                  <div style={{ width: "100%", height: "6px", backgroundColor: "rgba(34, 197, 94, 0.3)", borderRadius: "3px", overflow: "hidden" }}>
                    <div style={{ width: "70%", height: "100%", backgroundColor: "var(--green-primary)" }} />
                  </div>
                  <div style={{ fontSize: "10px", color: "var(--text-main)", marginTop: "6px" }}>Deshi Bazaar → 14 Station St</div>
                </div>

                {/* App Cart Summary */}
                <div style={{ backgroundColor: "var(--bg-card)", borderRadius: "14px", padding: "12px", border: "1px solid var(--border-card)", flex: 1, display: "flex", flexDirection: "column", justifyContent: "space-between" }}>
                  <div>
                    <div style={{ fontWeight: "700", marginBottom: "8px", color: "var(--text-main)" }}>Your Basket (3 items)</div>
                    <div style={{ display: "flex", flexDirection: "column", gap: "6px", color: "var(--text-main)" }}>
                      <div style={{ display: "flex", justifyContent: "space-between", fontSize: "11px" }}>
                        <span>1x Miniket Rice 5kg</span>
                        <strong>$18.99</strong>
                      </div>
                      <div style={{ display: "flex", justifyContent: "space-between", fontSize: "11px" }}>
                        <span>1x Fresh Halal Mutton 1kg</span>
                        <strong>$24.50</strong>
                      </div>
                      <div style={{ display: "flex", justifyContent: "space-between", fontSize: "11px" }}>
                        <span>2x Radhuni Biryani Masala</span>
                        <strong>$4.80</strong>
                      </div>
                    </div>
                  </div>

                  <div style={{ borderTop: "1px solid var(--border-color)", paddingTop: "8px" }}>
                    <div style={{ display: "flex", justifyContent: "space-between", fontWeight: "800", fontSize: "13px", color: "var(--text-main)", marginBottom: "8px" }}>
                      <span>Live Total</span>
                      <span>$48.29</span>
                    </div>
                    <div style={{ backgroundColor: "var(--green-primary)", color: "#FFF", borderRadius: "9999px", padding: "8px", textAlign: "center", fontWeight: "700", fontSize: "11px" }}>
                      Track Order Live
                    </div>
                  </div>
                </div>

                <div aria-hidden="true" style={{ position: "absolute", bottom: "6px", left: "50%", transform: "translateX(-50%)", width: "72px", height: "4px", borderRadius: "9999px", backgroundColor: "#171717" }} />

              </div>
            </div>
          </ImageReveal>

        </div>

      </div>
    </section>
  );
}
