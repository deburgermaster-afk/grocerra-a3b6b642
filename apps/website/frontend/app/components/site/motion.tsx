"use client";

import { motion, MotionConfig, type Variants } from "framer-motion";
import type { ReactNode } from "react";

export const EASE = [0.2, 0.7, 0.2, 1] as const;

/** Respects the visitor's reduced-motion setting for every Framer Motion animation on the site. */
export function MotionProvider({ children }: { children: ReactNode }) {
	return <MotionConfig reducedMotion="user">{children}</MotionConfig>;
}

export type RevealVariant = "up" | "zoom" | "left" | "right";

const VARIANTS: Record<RevealVariant, Variants> = {
	up: { hidden: { opacity: 0, y: 60 }, show: { opacity: 1, y: 0 } },
	zoom: { hidden: { opacity: 0, scale: 0.9, y: 50 }, show: { opacity: 1, scale: 1, y: 0 } },
	left: { hidden: { opacity: 0, x: -120, rotate: -3 }, show: { opacity: 1, x: 0, rotate: 0 } },
	right: { hidden: { opacity: 0, x: 120, rotate: 3 }, show: { opacity: 1, x: 0, rotate: 0 } },
};

const TAGS = { div: motion.div, li: motion.li, form: motion.form, p: motion.p, span: motion.span };

type RevealProps = {
	children: ReactNode;
	variant?: RevealVariant;
	delay?: number;
	as?: keyof typeof TAGS;
	className?: string;
	id?: string;
};

/**
 * Animates its children in once when scrolled into view. It owns its own transform,
 * so hover effects belong on an inner element (see Card and StepList).
 */
export function Reveal({ children, variant = "up", delay = 0, as = "div", className, id }: RevealProps) {
	const Tag = TAGS[as] as typeof motion.div;
	return (
		<Tag
			id={id}
			className={className}
			variants={VARIANTS[variant]}
			initial="hidden"
			whileInView="show"
			viewport={{ once: true, amount: 0.2 }}
			transition={{ duration: 0.8, ease: EASE, delay }}
		>
			{children}
		</Tag>
	);
}

/** Large footer wordmark that rises in when it scrolls into view. */
export function RiseIn({ children, className }: { children: ReactNode; className?: string }) {
	return (
		<motion.div
			className={className}
			aria-hidden="true"
			initial={{ opacity: 0, y: 110 }}
			whileInView={{ opacity: 1, y: 0 }}
			viewport={{ once: true, amount: 0.3 }}
			transition={{ duration: 1, ease: EASE }}
		>
			{children}
		</motion.div>
	);
}
