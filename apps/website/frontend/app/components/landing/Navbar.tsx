"use client";

import { AnimatePresence, motion } from "framer-motion";
import Link from "next/link";
import { useEffect, useState } from "react";
import s from "./landing.module.css";
import { cx } from "./shared";

const LINKS = [
	{ href: "/about", label: "About Us" },
	{ href: "/how-it-works", label: "How We Help" },
	{ href: "/download", label: "Download the App" },
	{ href: "/contact", label: "Contact" },
];

export function Logo() {
	return (
		<Link className={s.logo} href="/" aria-label="Grocerra home">
			GRO<b>CERRA</b>
		</Link>
	);
}

export default function Navbar() {
	const [scrolled, setScrolled] = useState(false);
	const [open, setOpen] = useState(false);

	useEffect(() => {
		const onScroll = () => setScrolled(window.scrollY > 24);
		onScroll();
		window.addEventListener("scroll", onScroll, { passive: true });
		return () => window.removeEventListener("scroll", onScroll);
	}, []);

	return (
		<nav className={cx(s.nav, scrolled && s.navScrolled, open && s.navOpen)} aria-label="Main">
			<div className={s.navBar}>
				<Logo />
				<div className={s.navLinks}>
					{LINKS.map((link) => (
						<Link key={link.href} href={link.href}>
							{link.label}
						</Link>
					))}
				</div>
				<button type="button" className={s.menuBtn} aria-expanded={open} aria-controls="mobile-menu" aria-label={open ? "Close menu" : "Open menu"} onClick={() => setOpen((v) => !v)}>
					<span />
					<span />
					<span />
				</button>
			</div>
			<AnimatePresence>
				{open && (
					<motion.div
						id="mobile-menu"
						className={s.mobileMenu}
						initial={{ height: 0, opacity: 0 }}
						animate={{ height: "auto", opacity: 1 }}
						exit={{ height: 0, opacity: 0 }}
						transition={{ duration: 0.3, ease: [0.2, 0.7, 0.2, 1] }}
					>
						{LINKS.map((link) => (
							<Link key={link.href} href={link.href} onClick={() => setOpen(false)}>
								{link.label}
							</Link>
						))}
					</motion.div>
				)}
			</AnimatePresence>
		</nav>
	);
}
