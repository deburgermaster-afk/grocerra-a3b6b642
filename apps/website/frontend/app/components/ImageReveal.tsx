"use client";

import { motion, useReducedMotion } from "framer-motion";
import type { ReactNode } from "react";

interface ImageRevealProps {
	children: ReactNode;
	className?: string;
	delay?: number;
}

export default function ImageReveal({ children, className, delay = 0 }: ImageRevealProps) {
	const shouldReduceMotion = useReducedMotion();

	return (
		<motion.div
			className={className}
			initial={shouldReduceMotion ? { opacity: 0 } : { opacity: 0, y: 18, rotateY: -4 }}
			whileInView={{ opacity: 1, y: 0, rotateY: 0 }}
			whileHover={shouldReduceMotion ? undefined : { scale: 1.025, rotateY: 1.5 }}
			viewport={{ once: true, amount: 0.2 }}
			transition={{ duration: 0.55, delay, ease: "easeOut" }}
			style={{ transformPerspective: 1000 }}
		>
			{children}
		</motion.div>
	);
}