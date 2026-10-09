"use client";

import { motion, useScroll, useTransform, type MotionValue } from "framer-motion";
import Link from "next/link";
import { Fragment, type CSSProperties, type ReactNode } from "react";
import { cx } from "./cx";
import { EASE } from "./motion";
import Produce, { type ProduceName } from "./Produce";
import s from "./site.module.css";
import { parseTitle } from "./text";

export type Crumb = { label: string; href?: string };

/** A floating produce item: CSS position, how far it drifts on scroll (py, px) and spins (pr, degrees). */
export type Floater = {
	name: ProduceName;
	style: CSSProperties;
	py?: number;
	pr?: number;
	delay?: number;
	bob?: 1 | 2 | 3;
	hideMobile?: boolean;
};

const BOB = { 1: s.bob, 2: s.bob2, 3: s.bob3 };

function FloatingProduce({ item, scrollY }: { item: Floater; scrollY: MotionValue<number> }) {
	const y = useTransform(scrollY, [0, 700], [0, item.py ?? -160]);
	const rotate = useTransform(scrollY, [0, 700], [0, item.pr ?? 25]);
	return (
		<motion.div className={cx(s.fl, item.hideMobile && s.hideM)} style={{ ...item.style, y, rotate }} aria-hidden="true">
			<motion.div
				initial={{ opacity: 0, scale: 0, rotate: -40 }}
				animate={{ opacity: 1, scale: 1, rotate: 0 }}
				transition={{ type: "spring", stiffness: 160, damping: 11, delay: item.delay ?? 0.6 }}
			>
				<Produce name={item.name} className={BOB[item.bob ?? 1]} sizes="170px" priority />
			</motion.div>
		</motion.div>
	);
}

const rise = (delay: number) => ({
	initial: { opacity: 0, y: 40, rotate: 3, filter: "blur(8px)" },
	animate: { opacity: 1, y: 0, rotate: 0, filter: "blur(0px)" },
	transition: { duration: 1, ease: EASE, delay },
});

type PageHeroProps = {
	crumbs: Crumb[];
	/** Title with *starred* words in the italic serif accent, e.g. "Good food starts *close to home.*" */
	title: string;
	sub?: string;
	small?: boolean;
	produce?: Floater[];
	/** Buttons or a search box under the title. */
	children?: ReactNode;
};

export default function PageHero({ crumbs, title, sub, small = false, produce = [], children }: PageHeroProps) {
	const { scrollY } = useScroll();
	const copyY = useTransform(scrollY, [0, 600], [0, -90]);
	const copyOpacity = useTransform(scrollY, [0, 600], [1, 0.15]);
	const words = parseTitle(title);

	return (
		<div className={s.heroShell}>
			<header className={cx(s.hero, small && s.heroSm)}>
				<svg className={s.hills} viewBox="0 0 1440 160" preserveAspectRatio="none" aria-hidden="true">
					<path d="M0 70C240 20 480 40 720 70C960 100 1200 30 1440 50V160H0Z" className="fill-grocerra-green-600" />
					<path d="M0 110C300 80 600 90 900 112C1100 126 1300 100 1440 104V160H0Z" className="fill-grocerra-green-700" />
				</svg>
				{produce.map((item) => (
					<FloatingProduce key={item.name} item={item} scrollY={scrollY} />
				))}
				<motion.div className={cx(s.wrap, s.heroIn)} style={{ y: copyY, opacity: copyOpacity }}>
					<motion.nav className={s.crumbs} aria-label="Breadcrumb" {...rise(0.05)}>
						{crumbs.map((c, i) => (
							<Fragment key={c.label}>
								{i > 0 && <span aria-hidden="true">/</span>}
								{c.href ? <Link href={c.href}>{c.label}</Link> : <span aria-current={i === crumbs.length - 1 ? "page" : undefined}>{c.label}</span>}
							</Fragment>
						))}
					</motion.nav>
					<h1 className={s.h1}>
						{words.map((w, i) => (
							<Fragment key={i}>
								{i > 0 && " "}
								<motion.span className={cx(s.w, w.accent && s.serif, w.accent && s.mark)} {...rise(0.15 + i * 0.07)}>
									{w.text}
								</motion.span>
							</Fragment>
						))}
					</h1>
					{sub && (
						<motion.p className={s.heroSub} {...rise(0.7)}>
							{sub}
						</motion.p>
					)}
					{children && <motion.div {...rise(0.85)}>{children}</motion.div>}
				</motion.div>
			</header>
		</div>
	);
}
