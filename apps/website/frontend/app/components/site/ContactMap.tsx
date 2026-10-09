"use client";

import { motion } from "framer-motion";
import { cx } from "./cx";
import { Reveal } from "./motion";
import s from "./site.module.css";

/** Stylised street map with a pin that drops in when scrolled into view. */
export default function ContactMap() {
	return (
		<Reveal variant="right">
			<div className={cx(s.visual, s.mapBox)} aria-hidden="true">
				<svg className={s.mapSvg} viewBox="0 0 600 320" preserveAspectRatio="xMidYMid slice">
					<g stroke="#FFFFFF" strokeWidth="14" fill="none" strokeLinecap="round">
						<path d="M-20 90H620M-20 230H620M140 -20V340M420 -20V340" />
						<path d="M-20 300L300 120 620 40" strokeWidth="10" />
					</g>
					<g fill="#CDEBD6">
						<rect x="20" y="110" width="100" height="100" rx="12" />
						<rect x="160" y="10" width="240" height="60" rx="12" />
						<rect x="440" y="110" width="140" height="100" rx="12" />
						<rect x="160" y="250" width="110" height="60" rx="12" />
					</g>
				</svg>
				<div className={s.pulse} />
				<motion.div
					className={s.pin}
					initial={{ opacity: 0, y: -120 }}
					whileInView={{ opacity: 1, y: 0 }}
					viewport={{ once: true }}
					transition={{ type: "spring", stiffness: 220, damping: 12, delay: 0.3 }}
				>
					<div className={s.pinShape} />
				</motion.div>
			</div>
		</Reveal>
	);
}
