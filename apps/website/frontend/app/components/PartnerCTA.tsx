"use client";

import { useEffect, useRef, useState } from "react";
import { animate, useInView, useReducedMotion } from "framer-motion";
import { MERCHANT_BENEFITS, MERCHANT_CONFIG } from "../lib/merchantData";

function AnimatedStat({
  value,
  suffix,
  decimals = 0,
  active,
  reduceMotion,
  accessibleText,
  formattedFinal,
}: {
  value: number;
  suffix: string;
  decimals?: number;
  active: boolean;
  reduceMotion: boolean | null;
  accessibleText: string;
  formattedFinal: string;
}) {
  const [displayNumber, setDisplayNumber] = useState<string>(formattedFinal.replace(suffix, ""));
  const [hasStarted, setHasStarted] = useState(false);

  useEffect(() => {
    if (!active || hasStarted) return;
    setHasStarted(true);

    if (reduceMotion) {
      setDisplayNumber(formattedFinal.replace(suffix, ""));
      return;
    }

    const format = (num: number) => (decimals > 0 ? num.toFixed(decimals) : Math.round(num).toString());
    setDisplayNumber(format(0));

    const controls = animate(0, value, {
      duration: 1.4,
      ease: "easeOut",
      onUpdate: (latest) => {
        setDisplayNumber(format(latest));
      },
      onComplete: () => {
        setDisplayNumber(format(value));
      },
    });

    return () => controls.stop();
  }, [active, decimals, formattedFinal, hasStarted, reduceMotion, suffix, value]);

  return (
    <span className="inline-flex items-baseline tabular-nums" aria-label={accessibleText}>
      {/* Accessible text for screen readers */}
      <span className="sr-only">{accessibleText}</span>

      {/* Visual animating numbers - hidden from screen reader stream */}
      <span aria-hidden="true" className="inline-flex font-mono tabular-nums font-extrabold">
        <span>{displayNumber}</span>
        <span>{suffix}</span>
      </span>
    </span>
  );
}

export default function PartnerCTA() {
  const statsRef = useRef<HTMLDivElement>(null);
  const statsInView = useInView(statsRef, { once: true, amount: 0.2 });
  const shouldReduceMotion = useReducedMotion();

  return (
    <section className="section-padding bg-[var(--bg-main)]">
      <div className="container">
        <div className="overflow-hidden rounded-2xl border border-[var(--border-card)] bg-[var(--bg-card)] shadow-[var(--shadow-lg)]">
          <div className="grid lg:grid-cols-[minmax(0,1fr)_minmax(0,0.95fr)]">
            <div className="flex flex-col items-start justify-center p-6 sm:p-9 lg:p-12">
              <span className="mb-4 inline-flex rounded-md border border-[var(--border-color)] bg-[var(--green-soft)] px-3 py-1.5 text-[11px] font-bold uppercase tracking-[0.1em] text-[var(--green-primary)]">
                Partner merchant program
              </span>
              <h2 className="max-w-[560px] text-3xl font-extrabold leading-[1.08] text-[var(--text-main)] sm:text-4xl">
                Own a grocery, butcher or catering business?
              </h2>
              <p className="mt-4 max-w-[540px] text-sm leading-6 text-[var(--text-muted)] sm:text-base">
                Reach more customers with low commission ({MERCHANT_CONFIG.commissionFormatted}), a simple order dashboard and fast payouts within {MERCHANT_CONFIG.payoutFormatted}. Our courier network handles delivery so you can focus on your business.
              </p>
              <div className="mt-6 flex flex-wrap gap-3">
                <a href="/partners" className="btn-pill btn-green-accent min-h-11 px-5 text-sm">
                  Partner with us
                </a>
                <a href="/partners/signup" className="btn-pill btn-secondary min-h-11 px-5 text-sm">
                  Sign up your store →
                </a>
              </div>
            </div>

            <div className="flex items-center bg-[var(--bg-card-subtle)] p-4 sm:p-7 lg:p-8">
              <div className="w-full rounded-xl border border-[var(--border-color)] bg-[var(--bg-card)] p-4 shadow-[var(--shadow-md)] sm:p-5">
                <div className="mb-4 flex items-center justify-between gap-3">
                  <div>
                    <p className="text-sm font-bold text-[var(--text-main)]">Today&apos;s orders</p>
                    <p className="mt-1 text-xs text-[var(--text-muted)]">Sample merchant dashboard</p>
                  </div>
                  <span className="inline-flex items-center gap-1.5 rounded-full bg-[var(--green-soft)] px-2.5 py-1 text-[10px] font-bold text-[var(--green-primary)]">
                    <span className="size-1.5 rounded-full bg-[var(--green-primary)]" /> LIVE
                  </span>
                </div>

                <div className="space-y-2.5">
                  <div className="flex items-center justify-between gap-3 rounded-lg border border-[var(--green-primary)]/40 bg-[var(--green-soft)] p-3">
                    <div className="min-w-0">
                      <p className="truncate text-xs font-bold text-[var(--text-main)]">#1042 · Farhana A.</p>
                      <p className="mt-1 text-[10px] text-[var(--text-muted)]">3 items · Delivery</p>
                      <p className="mt-1 text-[10px] font-semibold text-[var(--green-primary)]">New order</p>
                    </div>
                    <span className="shrink-0 rounded-md bg-[var(--green-primary)] px-2.5 py-1.5 text-[10px] font-bold text-white">Accept</span>
                  </div>
                  <div className="flex items-center justify-between gap-3 rounded-lg border border-[var(--border-color)] bg-[var(--bg-main)] p-3">
                    <div className="min-w-0">
                      <p className="truncate text-xs font-bold text-[var(--text-main)]">#1041 · Rahul M.</p>
                      <p className="mt-1 text-[10px] text-[var(--text-muted)]">Catering · 40 guests</p>
                      <p className="mt-1 text-[10px] font-semibold text-[var(--green-primary)]">Packing</p>
                    </div>
                    <span className="shrink-0 rounded-md bg-[var(--green-primary)] px-2.5 py-1.5 text-[10px] font-bold text-white">Mark ready</span>
                  </div>
                  <div className="flex items-center justify-between gap-3 rounded-lg border border-[var(--border-color)] bg-[var(--bg-main)] p-3">
                    <div className="min-w-0">
                      <p className="truncate text-xs font-bold text-[var(--text-main)]">#1040 · Tariq K.</p>
                      <p className="mt-1 text-[10px] text-[var(--text-muted)]">5 items · Delivery</p>
                      <p className="mt-1 text-[10px] font-semibold text-[var(--green-primary)]">Courier arriving in 4 min</p>
                    </div>
                    <span className="shrink-0 rounded-md border border-[var(--border-color)] px-2.5 py-1.5 text-[10px] font-bold text-[var(--text-muted)]">Ready</span>
                  </div>
                </div>

                <div className="ml-auto mt-3 w-fit rounded-md bg-[#0b0f0d] px-3 py-2 text-right text-white shadow-[var(--shadow-sm)]">
                  <p className="text-[9px] text-white/65">Next weekly payout</p>
                  <p className="text-sm font-extrabold">$1,284.60</p>
                </div>
              </div>
            </div>
          </div>

          <div ref={statsRef} className="grid grid-cols-2 border-t border-[var(--border-color)] sm:grid-cols-2 lg:grid-cols-5">
            {MERCHANT_BENEFITS.map((stat, index) => {
              const formattedFinal = stat.value !== undefined ? `${stat.decimals && stat.decimals > 0 ? stat.value.toFixed(stat.decimals) : stat.value}${stat.suffix ?? ""}` : "";

              return (
                <div
                  key={stat.title}
                  className={`flex flex-col justify-center min-h-[118px] p-5 sm:p-6 border-b border-[var(--border-color)] sm:border-b-0 ${
                    index % 2 !== 0 ? "border-l border-[var(--border-color)] lg:border-l" : index > 0 ? "lg:border-l border-[var(--border-color)]" : ""
                  } ${index === MERCHANT_BENEFITS.length - 1 ? "col-span-2 lg:col-span-1 border-b-0" : ""}`}
                >
                  <p className="text-xl font-extrabold leading-none text-[var(--green-primary)] sm:text-2xl">
                    {stat.value !== undefined ? (
                      <AnimatedStat
                        value={stat.value}
                        suffix={stat.suffix ?? ""}
                        decimals={stat.decimals}
                        active={statsInView}
                        reduceMotion={shouldReduceMotion}
                        accessibleText={stat.accessibleText}
                        formattedFinal={formattedFinal}
                      />
                    ) : (
                      stat.label
                    )}
                  </p>
                  <h3 className="mt-2 text-xs font-bold text-[var(--text-main)] sm:text-sm">{stat.title}</h3>
                  <p className="mt-1 text-[11px] leading-4 text-[var(--text-muted)] sm:text-xs">{stat.desc}</p>
                </div>
              );
            })}
          </div>
        </div>
      </div>
    </section>
  );
}
