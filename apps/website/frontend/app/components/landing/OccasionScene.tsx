"use client";

import { AnimatePresence, motion, useReducedMotion } from "framer-motion";
import Image from "next/image";
import { useEffect, useState } from "react";
import s from "./landing.module.css";
import { cx } from "./shared";

const OCCASIONS = [
	{ name: "Eid dinner", guests: 40, slot: "Saturday · 6:30 pm", items: ["Basmati rice · 10 kg", "Lamb, curry cut · 8 kg", "Fresh naan · 60"] },
	{ name: "Birthday party", guests: 25, slot: "Sunday · 2:00 pm", items: ["Party snack trays · 6", "Chicken tikka · 4 kg", "Sweets boxes · 3"] },
	{ name: "Office lunch", guests: 60, slot: "Friday · 12:00 pm", items: ["Chicken biryani trays · 8", "Salad platters · 6", "Soft drinks · 60"] },
	{ name: "Diwali gathering", guests: 35, slot: "Sunday · 7:00 pm", items: ["Mithai assortment · 4 kg", "Paneer · 3 kg", "Samosas · 80"] },
	{ name: "Family BBQ", guests: 20, slot: "Saturday · 1:00 pm", items: ["Lamb chops · 5 kg", "Chicken wings · 4 kg", "Corn & veg trays · 3"] },
	{ name: "Wedding mehndi", guests: 150, slot: "Thursday · 5:00 pm", items: ["Biryani rice · 40 kg", "Goat, bone-in · 25 kg", "Dessert platters · 12"] },
];

const CYCLE_MS = 4800;
const ease = [0.2, 0.7, 0.2, 1] as const;

function Check() {
	return (
		<svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth={3.4} strokeLinecap="round" strokeLinejoin="round" aria-hidden="true">
			<path d="m5 12 5 5 9-10" />
		</svg>
	);
}

export default function OccasionScene() {
	const [index, setIndex] = useState(0);
	const [paused, setPaused] = useState(false);
	const reduceMotion = useReducedMotion();
	const occasion = OCCASIONS[index];

	useEffect(() => {
		if (paused || reduceMotion) return;
		const id = window.setTimeout(() => setIndex((i) => (i + 1) % OCCASIONS.length), CYCLE_MS);
		return () => window.clearTimeout(id);
	}, [index, paused, reduceMotion]);

	return (
		<div className={cx(s.occasion, s.zoom)} data-reveal="zoom" onMouseEnter={() => setPaused(true)} onMouseLeave={() => setPaused(false)}>
			<Image src="/images/catering-spread.jpg" alt="A catering spread of trays and serving dishes" fill sizes="(max-width: 960px) 100vw, 600px" className={s.occasionImg} />
			<div className={s.occasionShade} />

			<div className={cx(s.badge, s.occasionSlot)}>
				<svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth={2} strokeLinecap="round" strokeLinejoin="round" aria-hidden="true">
					<rect x="3" y="4" width="18" height="18" rx="2" />
					<path d="M16 2v4M8 2v4M3 10h18" />
				</svg>
				<AnimatePresence mode="wait" initial={false}>
					<motion.span key={occasion.slot} initial={{ opacity: 0, y: 8 }} animate={{ opacity: 1, y: 0 }} exit={{ opacity: 0, y: -8 }} transition={{ duration: 0.3 }}>
						{occasion.slot}
					</motion.span>
				</AnimatePresence>
			</div>

			<div className={cx(s.badge, s.badgeLime, s.occasionGuests)}>
				<svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth={2} strokeLinecap="round" strokeLinejoin="round" aria-hidden="true">
					<path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2" />
					<circle cx="9" cy="7" r="4" />
					<path d="M23 21v-2a4 4 0 0 0-3-3.9M16 3.1a4 4 0 0 1 0 7.8" />
				</svg>
				<AnimatePresence mode="wait" initial={false}>
					<motion.span key={occasion.guests} initial={{ opacity: 0, scale: 0.8 }} animate={{ opacity: 1, scale: 1 }} exit={{ opacity: 0, scale: 0.8 }} transition={{ duration: 0.3 }}>
						Feeds {occasion.guests} guests
					</motion.span>
				</AnimatePresence>
			</div>

			<div className={s.orderCard}>
				<AnimatePresence mode="wait" initial={false}>
					<motion.div key={occasion.name} initial={{ opacity: 0, y: 24 }} animate={{ opacity: 1, y: 0 }} exit={{ opacity: 0, y: -16 }} transition={{ duration: 0.45, ease }}>
						<small className={s.orderKicker}>Catering order</small>
						<h3 className={s.orderTitle}>{occasion.name}</h3>
						<ul className={s.orderItems}>
							{occasion.items.map((item, i) => (
								<motion.li key={item} initial={{ opacity: 0, x: -12 }} animate={{ opacity: 1, x: 0 }} transition={{ delay: 0.35 + i * 0.35, duration: 0.35, ease }}>
									<motion.span className={s.orderTick} initial={{ scale: 0 }} animate={{ scale: 1 }} transition={{ delay: 0.55 + i * 0.35, type: "spring", stiffness: 500, damping: 20 }}>
										<Check />
									</motion.span>
									{item}
								</motion.li>
							))}
						</ul>
						<div className={s.orderProgress}>
							<motion.span key={`bar-${index}`} initial={{ scaleX: 0 }} animate={{ scaleX: 1 }} transition={{ duration: reduceMotion ? 0 : CYCLE_MS / 1000, ease: "linear" }} />
						</div>
					</motion.div>
				</AnimatePresence>
				<div className={s.occasionDots}>
					{OCCASIONS.map((o, i) => (
						<button key={o.name} type="button" aria-label={`Show ${o.name}`} aria-pressed={i === index} className={cx(s.occasionDot, i === index && s.occasionDotOn)} onClick={() => setIndex(i)} />
					))}
				</div>
			</div>
		</div>
	);
}
