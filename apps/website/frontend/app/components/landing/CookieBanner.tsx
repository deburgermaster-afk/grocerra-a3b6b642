"use client";

import { AnimatePresence, motion } from "framer-motion";
import Link from "next/link";
import { useEffect, useState } from "react";
import s from "./landing.module.css";

const STORAGE_KEY = "grocerra_cookie_consent";

export default function CookieBanner() {
	const [visible, setVisible] = useState(false);

	useEffect(() => {
		let saved: string | null = null;
		try {
			saved = localStorage.getItem(STORAGE_KEY);
		} catch {
			// Storage blocked (private mode) — just show the banner
		}
		if (!saved) setVisible(true);
	}, []);

	const choose = (choice: "accepted" | "rejected") => {
		try {
			localStorage.setItem(STORAGE_KEY, choice);
		} catch {
			// Nothing to persist to; the banner still closes for this visit
		}
		setVisible(false);
	};

	return (
		<AnimatePresence>
			{visible && (
				<motion.div
					className={s.cookie}
					role="region"
					aria-label="Cookie consent"
					initial={{ opacity: 0, y: 40 }}
					animate={{ opacity: 1, y: 0, transition: { duration: 0.9, delay: 2.2, ease: [0.2, 0.7, 0.2, 1] } }}
					exit={{ opacity: 0, y: 40, transition: { duration: 0.3 } }}
				>
					<p className={s.cookieTitle}>We use cookies</p>
					<p className={s.cookieText}>
						To keep you signed in, remember your basket and improve Grocerra. <Link href="/legal/cookies">Cookie Policy</Link>
					</p>
					<div className={s.cookieBtns}>
						<button type="button" className={s.cookieAccept} onClick={() => choose("accepted")}>
							Accept all
						</button>
						<button type="button" className={s.cookieLine} onClick={() => choose("rejected")}>
							Reject
						</button>
						<Link className={s.cookieLine} href="/legal/cookies">
							Manage
						</Link>
					</div>
				</motion.div>
			)}
		</AnimatePresence>
	);
}
