"use client";

import { motion, useReducedMotion } from "framer-motion";

const reviews = [
  {
    rating: 5,
    quote: "Finally an easy way to get fresh miniket rice and halal meat delivered in Dandenong without driving in weekend traffic!",
    name: "Farhana A.",
    suburb: "Dandenong",
    tag: "Verified Customer"
  },
  {
    rating: 5,
    quote: "Ordered Eid catering for 40 people through Grocerra. The biryani arrived hot on time and the quote process was super simple.",
    name: "Rahul M.",
    suburb: "Point Cook",
    tag: "Catering Customer"
  },
  {
    rating: 5,
    quote: "The live courier tracking is a game changer for fresh produce. Got my spices and sweets within 30 minutes!",
    name: "Tariq K.",
    suburb: "Tarneit",
    tag: "App User"
  }
];

export default function CustomerReviews() {
  const shouldReduceMotion = useReducedMotion();

  return (
    <section className="section-padding overflow-hidden" style={{ backgroundColor: "var(--bg-card)", borderTop: "1px solid var(--border-color)", transition: "background-color 0.3s ease" }}>
      <div>
        
        <div className="mx-auto mb-10 max-w-[600px] px-6 text-center sm:mb-12">
          <span className="text-xs font-bold uppercase tracking-[0.08em] text-[var(--green-primary)]">
            Community Feedback
          </span>
          <h2 className="mt-2 text-3xl font-extrabold text-[var(--text-main)] sm:text-4xl">
            Loved by our community
          </h2>
          <p className="mt-3 text-sm text-[var(--text-muted)] sm:text-base">Real orders, from kitchens and families across Victoria.</p>
        </div>

        <div aria-label="Customer testimonials" className="overflow-hidden">
          <motion.div
            animate={shouldReduceMotion ? undefined : { x: ["0%", "-50%"] }}
            className="flex w-max"
            transition={shouldReduceMotion ? undefined : { duration: 42, ease: "linear", repeat: Infinity }}
          >
            {[0, 1].map((copy) => (
              <div key={copy} aria-hidden={copy === 1 ? true : undefined} className="flex gap-4 pr-4">
                {reviews.map((review) => (
                  <article key={`${copy}-${review.name}`} className="flex min-h-[250px] w-[min(340px,84vw)] flex-col justify-between rounded-xl border border-[var(--border-card)] bg-[var(--bg-main)] p-5 shadow-[var(--shadow-sm)] sm:p-6">
                    <div>
                      <div className="mb-4 flex items-center justify-between gap-3">
                        <span aria-label={`${review.rating} out of 5 stars`} className="text-xs font-bold text-[#c77712]">{review.rating}.0 / 5</span>
                        <span className="rounded-full bg-[var(--green-soft)] px-2.5 py-1 text-[10px] font-bold text-[var(--green-primary)]">{review.tag}</span>
                      </div>
                      <p className="text-sm leading-6 text-[var(--text-main)] sm:text-[15px]">“{review.quote}”</p>
                    </div>
                    <div className="mt-5 border-t border-[var(--border-color)] pt-4">
                      <p className="text-sm font-bold text-[var(--text-main)]">{review.name}</p>
                      <p className="mt-1 text-xs text-[var(--text-muted)]">{review.suburb}, Victoria</p>
                    </div>
                  </article>
                ))}
              </div>
            ))}
          </motion.div>
        </div>
      </div>
    </section>
  );
}
