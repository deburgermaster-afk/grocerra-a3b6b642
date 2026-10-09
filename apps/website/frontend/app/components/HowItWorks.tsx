"use client";

import Image from "next/image";
import { motion, useReducedMotion } from "framer-motion";
import { FLOATING_CARDS, STEPS_DATA } from "../lib/howItWorksData";

export default function HowItWorks() {
  const shouldReduceMotion = useReducedMotion();

  return (
    <section className="section-padding overflow-hidden bg-[var(--green-soft)] transition-colors duration-300">
      <div className="container">
        {/* Floating Cards & Heading Container */}
        <div className="relative mx-auto mb-12 flex min-h-[560px] max-w-[1140px] flex-col items-center justify-center lg:mb-16">
          
          {/* Mobile Top Edge Cards (4 cards visible on small screens: 2 at top, 2 at bottom) */}
          <div className="mb-6 flex w-full max-w-sm justify-around gap-2 sm:hidden">
            {FLOATING_CARDS.filter((c) => c.mobilePosition === "top").map((card) => (
              <div
                key={`mobile-top-${card.id}`}
                className={`relative flex items-center gap-2 rounded-xl border p-1.5 shadow-sm backdrop-blur-sm ${card.colorWashClass} bg-[var(--bg-card)]/90`}
              >
                <div className="relative size-10 overflow-hidden rounded-lg bg-white">
                  <Image
                    src={card.image}
                    alt={card.alt}
                    fill
                    sizes="40px"
                    className="object-cover"
                  />
                </div>
                {card.label && (
                  <span className="text-[11px] font-bold text-[var(--text-main)] pr-1">
                    {card.label}
                  </span>
                )}
              </div>
            ))}
          </div>

          {/* Central Headline & Text */}
          <motion.div
            className="pointer-events-auto z-10 mx-auto max-w-[620px] px-4 text-center"
            initial={shouldReduceMotion ? false : { opacity: 0, y: 16 }}
            whileInView={{ opacity: 1, y: 0 }}
            viewport={{ once: true }}
            transition={{ duration: 0.6, ease: "easeOut" }}
          >
            <span className="inline-flex rounded-full bg-[var(--bg-card)] px-4 py-2 text-xs font-bold uppercase tracking-[0.08em] text-[var(--green-primary)] shadow-sm backdrop-blur-md border border-[var(--border-color)]">
              How it works
            </span>
            <h2 className="mt-5 text-3xl font-extrabold leading-tight text-[var(--text-main)] sm:text-4xl lg:text-5xl">
              Groceries in three simple steps
            </h2>
            <p className="mx-auto mt-4 max-w-[560px] text-base leading-7 text-[var(--text-main)] sm:text-lg">
              Find a store near you, <strong>add items and pay</strong> securely, then <strong>follow your courier</strong> in real time until it arrives at your door.
            </p>
          </motion.div>

          {/* Floating Image Cards Surround (Desktop & Tablet) */}
          <div className="hidden sm:mt-10 sm:grid sm:w-full sm:max-w-[740px] sm:grid-cols-4 sm:gap-3 lg:absolute lg:inset-0 lg:mt-0 lg:block lg:max-w-none">
            {FLOATING_CARDS.map((card, index) => {
              // Tablet visibility filter (8 sharp cards on tablet, all 12 on desktop)
              const tabletClass = card.tabletVisible ? "sm:flex" : "sm:hidden lg:flex";

              return (
                <motion.a
                  key={card.id}
                  aria-label={card.isDepthCard ? undefined : `Browse stores for ${card.label}`}
                  aria-hidden={card.isDepthCard ? "true" : undefined}
                  href="/stores"
                  tabIndex={card.isDepthCard ? -1 : 0}
                  className={`group absolute transition-all duration-300 ${tabletClass} flex-col items-center p-2 rounded-2xl border shadow-md backdrop-blur-sm ${card.colorWashClass} bg-[var(--bg-card)]/80 ${
                    card.isDepthCard ? "blur-[2px] opacity-40 dark:opacity-30 pointer-events-none scale-90" : "opacity-100"
                  } lg:absolute ${card.desktopPosition}`}
                  style={{ transformOrigin: "center" }}
                  initial={shouldReduceMotion ? false : { opacity: 0, scale: 0.85, y: 20 }}
                  whileInView={
                    shouldReduceMotion
                      ? { opacity: card.isDepthCard ? 0.4 : 1, scale: 1, y: 0 }
                      : { opacity: card.isDepthCard ? 0.4 : 1, scale: 1, y: 0 }
                  }
                  animate={
                    shouldReduceMotion
                      ? undefined
                      : {
                          y: card.floatDirection === "normal" ? [0, -10, 0] : [0, 10, 0],
                        }
                  }
                  whileHover={
                    shouldReduceMotion || card.isDepthCard
                      ? undefined
                      : {
                          scale: 1.06,
                          y: -6,
                          zIndex: 30,
                          opacity: 1,
                        }
                  }
                  whileTap={shouldReduceMotion || card.isDepthCard ? undefined : { scale: 0.95 }}
                  viewport={{ once: true }}
                  transition={
                    shouldReduceMotion
                      ? undefined
                      : {
                          y: {
                            duration: card.floatDuration,
                            delay: card.floatDelay,
                            repeat: Infinity,
                            ease: "easeInOut",
                          },
                          opacity: { duration: 0.5, delay: index * 0.04, ease: "easeOut" },
                          scale: { duration: 0.4, delay: index * 0.04, ease: "easeOut" },
                        }
                  }
                >
                  <div
                    className={`relative w-full overflow-hidden rounded-xl bg-white shadow-inner ${
                      card.aspectRatio === "portrait" ? "aspect-[3/4] min-w-[90px] lg:min-w-[105px]" : "aspect-square min-w-[85px] lg:min-w-[98px]"
                    }`}
                  >
                    <Image
                      src={card.image}
                      alt={card.isDepthCard ? "" : card.alt}
                      fill
                      sizes="(max-width: 768px) 100px, 140px"
                      className="object-cover transition-transform duration-500 group-hover:scale-108"
                    />
                  </div>
                  {card.label && !card.isDepthCard && (
                    <span className="mt-1.5 w-full truncate text-center text-[11px] font-bold text-[var(--text-main)] tracking-tight">
                      {card.label}
                    </span>
                  )}
                </motion.a>
              );
            })}
          </div>

          {/* Mobile Bottom Edge Cards */}
          <div className="mt-6 flex w-full max-w-sm justify-around gap-2 sm:hidden">
            {FLOATING_CARDS.filter((c) => c.mobilePosition === "bottom").map((card) => (
              <div
                key={`mobile-bottom-${card.id}`}
                className={`relative flex items-center gap-2 rounded-xl border p-1.5 shadow-sm backdrop-blur-sm ${card.colorWashClass} bg-[var(--bg-card)]/90`}
              >
                <div className="relative size-10 overflow-hidden rounded-lg bg-white">
                  <Image
                    src={card.image}
                    alt={card.alt}
                    fill
                    sizes="40px"
                    className="object-cover"
                  />
                </div>
                {card.label && (
                  <span className="text-[11px] font-bold text-[var(--text-main)] pr-1">
                    {card.label}
                  </span>
                )}
              </div>
            ))}
          </div>

        </div>

        {/* 3 Step Cards with Sequenced Animated Dividing Lines */}
        <div className="grid gap-6 md:grid-cols-3 md:gap-8 pt-6">
          {STEPS_DATA.map((step, index) => (
            <div key={step.number} className="relative flex flex-col">
              {/* Sequenced Line above each step that draws across */}
              <motion.div
                className="mb-4 h-0.5 w-full origin-left bg-[var(--green-primary)]/40 dark:bg-[var(--green-primary)]/60"
                initial={shouldReduceMotion ? { scaleX: 1 } : { scaleX: 0 }}
                whileInView={{ scaleX: 1 }}
                viewport={{ once: true, amount: 0.3 }}
                transition={{ duration: 0.6, delay: index * 0.2, ease: "easeOut" }}
              />

              <motion.article
                className="group flex flex-1 flex-col rounded-2xl border border-[var(--border-card)] bg-[var(--bg-card)] p-6 shadow-sm transition-all duration-300 hover:border-[var(--green-primary)] hover:shadow-md"
                initial={shouldReduceMotion ? { opacity: 1 } : { opacity: 0, y: 14 }}
                whileInView={{ opacity: 1, y: 0 }}
                viewport={{ once: true, amount: 0.25 }}
                transition={{ duration: 0.5, delay: index * 0.15, ease: "easeOut" }}
              >
                {step.image && (
                  <div className="relative mb-4 aspect-[16/9] w-full overflow-hidden rounded-xl bg-slate-100 dark:bg-slate-800">
                    <Image
                      src={step.image}
                      alt={step.imageAlt ?? step.title}
                      fill
                      sizes="(max-width: 768px) 100vw, 360px"
                      className="object-cover transition-transform duration-500 group-hover:scale-105"
                    />
                  </div>
                )}

                <span className="text-xs font-black tracking-widest text-[var(--green-primary)]">
                  {step.number}
                </span>

                <h3 className="mt-2 text-xl font-extrabold text-[var(--text-main)] group-hover:text-[var(--green-primary)] transition-colors">
                  {step.title}
                </h3>

                <p className="mt-2 text-sm leading-6 text-[var(--text-muted)]">
                  {step.description}
                </p>
              </motion.article>
            </div>
          ))}
        </div>

      </div>
    </section>
  );
}
