"use client";

import Image from "next/image";
import ImageReveal from "./ImageReveal";

const occasions = [
  "Weddings",
  "Eid",
  "Diwali",
  "Corporate Lunches",
  "Community Events"
];

const keyPoints = [
  { title: "Packages for every group size", desc: "From intimate family dinners (10 pax) to grand celebrations (500+ guests)." },
  { title: "Halal and vegetarian options", desc: "100% verified halal caterers with dedicated vegetarian & vegan prep streams." },
  { title: "Delivery and setup available", desc: "Hot insulated food transport with optional setup and service staff." },
  { title: "Simple quote process", desc: "Clear upfront package pricing, flexible lead times, and easy online modification." }
];

export default function CateringHighlight() {
  return (
    <section className="section-padding" style={{ backgroundColor: "var(--bg-main)", borderTop: "1px solid var(--border-color)", transition: "background-color 0.3s ease" }}>
      <div className="container">

        <div className="grid overflow-hidden rounded-2xl border border-[var(--border-card)] bg-[var(--bg-card)] text-[var(--text-main)] shadow-[var(--shadow-lg)] lg:grid-cols-[minmax(0,1.6fr)_minmax(300px,0.8fr)]">
          <div className="order-last p-6 sm:p-9 lg:order-first lg:p-12">
          <div style={{ maxWidth: "760px", marginBottom: "40px" }}>
            <span style={{
              display: "inline-block",
              padding: "6px 14px",
              borderRadius: "9999px",
              backgroundColor: "var(--green-soft)",
              color: "var(--green-primary)",
              fontSize: "13px",
              fontWeight: 700,
              textTransform: "uppercase",
              letterSpacing: "0.06em",
              marginBottom: "16px"
            }}>
              Fresh Catering for Every Occasion
            </span>

            <h2 style={{ fontSize: "clamp(30px, 4.5vw, 48px)", fontWeight: 800, lineHeight: 1.15, letterSpacing: "-0.02em", color: "var(--text-main)", marginBottom: "18px" }}>
              Catering for every occasion
            </h2>

            <p style={{ fontSize: "clamp(16px, 1.8vw, 19px)", color: "var(--text-muted)", lineHeight: 1.6 }}>
              Weddings, Eid, Diwali, corporate lunches and community events. Order fresh catering with clear packages, lead times, and halal and vegetarian options.
            </p>
          </div>

          {/* Occasion Chips */}
          <div style={{ marginBottom: "40px" }}>
            <p style={{ fontSize: "13px", fontWeight: 700, textTransform: "uppercase", letterSpacing: "0.08em", color: "var(--text-muted)", marginBottom: "12px" }}>
              Popular Occasions Served
            </p>
            <div style={{ display: "flex", gap: "10px", flexWrap: "wrap" }}>
              {occasions.map((occ, idx) => (
                <span key={idx} style={{
                  backgroundColor: "var(--bg-card-subtle)",
                  border: "1px solid var(--border-color)",
                  padding: "8px 18px",
                  borderRadius: "9999px",
                  fontSize: "14px",
                  fontWeight: 600,
                  color: "var(--text-main)"
                }}>
                  {occ}
                </span>
              ))}
            </div>
          </div>

          {/* Key Points Grid */}
          <div style={{
            display: "grid",
            gridTemplateColumns: "repeat(auto-fit, minmax(240px, 1fr))",
            gap: "20px",
            marginBottom: "44px",
            paddingTop: "32px",
            borderTop: "1px solid var(--border-color)"
          }}>
            {keyPoints.map((pt, idx) => (
              <div key={idx}>
                <h4 style={{ fontSize: "17px", fontWeight: 700, color: "var(--text-main)", marginBottom: "6px", display: "flex", alignItems: "center", gap: "8px" }}>
                  <span style={{ color: "var(--green-primary)" }}>✓</span> {pt.title}
                </h4>
                <p style={{ fontSize: "14px", color: "var(--text-muted)", lineHeight: "1.5" }}>
                  {pt.desc}
                </p>
              </div>
            ))}
          </div>

          {/* Action Buttons */}
          <div style={{ display: "flex", gap: "16px", flexWrap: "wrap", alignItems: "center" }}>
            <a href="/catering/request" className="btn-pill btn-pill-lg btn-green-accent">
              Request a quote
            </a>
            <a href="/catering" className="btn-pill btn-pill-lg btn-secondary">
              Explore catering →
            </a>
          </div>

          </div>

          <ImageReveal className="order-first relative aspect-[5/6] w-full overflow-hidden bg-[var(--bg-card-subtle)] sm:min-h-[360px] lg:order-last lg:aspect-auto lg:min-h-[520px] lg:self-stretch">
            <Image
              src="/images/catering-spread.jpg"
              alt="A catering buffet with fresh prepared dishes ready to serve"
              fill
              sizes="(max-width: 1024px) 100vw, 40vw"
              style={{ objectFit: "cover", objectPosition: "center" }}
            />
          </ImageReveal>
        </div>

      </div>
    </section>
  );
}
