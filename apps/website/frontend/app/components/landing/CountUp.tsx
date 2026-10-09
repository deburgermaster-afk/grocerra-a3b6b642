"use client";

import { animate, useInView, useReducedMotion } from "framer-motion";
import { useEffect, useRef, useState } from "react";
import s from "./landing.module.css";

type Props = { to: number; decimals?: number; prefix?: string; suffix?: string; duration?: number };

/** Counts from 0 up to `to` the first time it scrolls into view. */
export default function CountUp({ to, decimals = 0, prefix = "", suffix = "", duration = 1.8 }: Props) {
	const ref = useRef<HTMLSpanElement>(null);
	const inView = useInView(ref, { once: true, amount: 0.6 });
	const reduceMotion = useReducedMotion();
	const [value, setValue] = useState(0);

	useEffect(() => {
		if (!inView) return;
		if (reduceMotion) {
			setValue(to);
			return;
		}
		const controls = animate(0, to, { duration, ease: [0.2, 0.7, 0.2, 1], onUpdate: setValue });
		return () => controls.stop();
	}, [inView, reduceMotion, to, duration]);

	const text = `${prefix}${value.toFixed(decimals)}${suffix}`;
	const final = `${prefix}${to.toFixed(decimals)}${suffix}`;

	return (
		<span ref={ref}>
			<span aria-hidden="true">{text}</span>
			<span className={s.srOnly}>{final}</span>
		</span>
	);
}
