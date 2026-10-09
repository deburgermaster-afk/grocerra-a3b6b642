"use client";

import { motion } from "framer-motion";
import { cx } from "./cx";
import { EASE, Reveal } from "./motion";
import s from "./site.module.css";

export type PriceBar = { label: string; amount: string; percent: number; color: string };

/** Black panel of horizontal price bars that grow when scrolled into view. */
export default function PriceBars({ title, bars, note }: { title: string; bars: PriceBar[]; note: string }) {
	return (
		<Reveal variant="left">
			<div className={cx(s.visual, s.vBlack, s.barsBox)}>
				<h3 className={s.h3}>{title}</h3>
				<div className={s.bars}>
					{bars.map((bar, i) => (
						<div key={bar.label} className={s.barRow}>
							<span>{bar.label}</span>
							<span className={s.barTrack} aria-hidden="true">
								<motion.span
									className={s.barFill}
									style={{ width: `${bar.percent}%`, background: bar.color }}
									initial={{ scaleX: 0 }}
									whileInView={{ scaleX: 1 }}
									viewport={{ once: true, amount: 0.6 }}
									transition={{ duration: 1.4, ease: EASE, delay: 0.2 + i * 0.15 }}
								/>
							</span>
							<b>{bar.amount}</b>
						</div>
					))}
				</div>
				<p className={s.barsNote}>{note}</p>
			</div>
		</Reveal>
	);
}
