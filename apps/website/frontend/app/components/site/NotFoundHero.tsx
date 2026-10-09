"use client";

import { motion } from "framer-motion";
import ButtonLink from "./Button";
import { cx } from "./cx";
import { Icon } from "./icons";
import { EASE } from "./motion";
import Produce from "./Produce";
import s from "./site.module.css";

const rise = (delay: number) => ({
	initial: { opacity: 0, y: 60 },
	animate: { opacity: 1, y: 0 },
	transition: { duration: 1, ease: EASE, delay },
});

/** "4 [orange] 4" with an apple rolling along the bottom of the page. */
export default function NotFoundHero() {
	return (
		<main className={s.nf}>
			<div className={s.nf404} role="img" aria-label="404">
				<motion.span aria-hidden="true" {...rise(0)}>
					4
				</motion.span>
				<motion.span
					className={s.nfO}
					aria-hidden="true"
					initial={{ opacity: 0, scale: 0 }}
					animate={{ opacity: 1, scale: 1 }}
					transition={{ type: "spring", stiffness: 160, damping: 12, delay: 0.15 }}
				>
					<Produce name="orange" sizes="270px" priority />
				</motion.span>
				<motion.span aria-hidden="true" {...rise(0.25)}>
					4
				</motion.span>
			</div>
			<motion.h1 className={s.h2} {...rise(0.35)}>
				This aisle is <span className={cx(s.serif, s.hl)}>empty.</span>
			</motion.h1>
			<motion.p className={s.lede} {...rise(0.45)}>
				The page you&apos;re looking for has moved or doesn&apos;t exist. Let&apos;s get you back to the good stuff.
			</motion.p>
			<motion.div className={s.search} role="search" aria-label="Search Grocerra" {...rise(0.55)}>
				<Icon name="search" size={20} strokeWidth={2.4} />
				<label htmlFor="nf-q" className="sr-only">
					Search Grocerra
				</label>
				<input id="nf-q" type="search" placeholder="Search Grocerra" />
			</motion.div>
			<motion.div className={s.heroCta} {...rise(0.65)}>
				<ButtonLink href="/">Back to home</ButtonLink>
				<ButtonLink href="/help" tone="ghost">
					Help centre
				</ButtonLink>
			</motion.div>
			<div className={s.roll} aria-hidden="true">
				<Produce name="pink-lady" sizes="120px" />
			</div>
		</main>
	);
}
