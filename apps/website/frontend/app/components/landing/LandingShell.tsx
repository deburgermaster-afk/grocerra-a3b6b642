"use client";

import { inView } from "framer-motion";
import { useEffect, useRef } from "react";
import s from "./landing.module.css";
import { landingFonts } from "./fonts";

/**
 * Page wrapper for the landing sections. Chromium/Safari animate on scroll with CSS
 * scroll timelines; browsers without them (Firefox) get fade/slide-ins instead:
 * each [data-reveal] element receives .is-visible when it enters the viewport.
 */
export default function LandingShell({ children }: { children: React.ReactNode }) {
	const ref = useRef<HTMLDivElement>(null);

	useEffect(() => {
		const root = ref.current;
		if (!root) return;
		if (CSS.supports("animation-timeline: view()")) return;
		if (window.matchMedia("(prefers-reduced-motion: reduce)").matches) return;

		root.dataset.io = "";
		const stop = inView(
			root.querySelectorAll<HTMLElement>("[data-reveal]"),
			(el) => {
				el.classList.add("is-visible");
			},
			{ amount: 0.15 }
		);
		return () => {
			stop();
			delete root.dataset.io;
		};
	}, []);

	return (
		<div ref={ref} className={`${s.page} ${landingFonts}`}>
			{children}
		</div>
	);
}
