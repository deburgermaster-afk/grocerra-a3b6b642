"use client";

import { AnimatePresence, motion } from "framer-motion";
import Link from "next/link";
import { usePathname } from "next/navigation";
import { useEffect, useState } from "react";
import { ACCOUNT_LINKS, MAIN_NAV } from "@/app/content/site";
import { cx } from "./cx";
import { EASE } from "./motion";
import s from "./site.module.css";

export function Logo({ inverse = false }: { inverse?: boolean }) {
	return (
		<Link className={cx(s.logo, inverse && s.logoInv)} href="/" aria-label="Grocerra home">
			GRO<b>CERRA</b>
		</Link>
	);
}

export default function Navbar() {
	const pathname = usePathname();
	const [open, setOpen] = useState(false);
	const isPartners = pathname === "/partners";

	// Close the mobile menu after navigating
	useEffect(() => setOpen(false), [pathname]);

	const isActive = (href: string) => pathname === href || pathname.startsWith(`${href}/`);

	return (
		<motion.nav
			className={cx(s.nav, open && s.menuOpen)}
			aria-label="Main"
			initial={{ opacity: 0, y: -40 }}
			animate={{ opacity: 1, y: 0 }}
			transition={{ duration: 0.9, delay: 0.1, ease: EASE }}
		>
			<div className={s.navBar}>
				<Logo />
				<div className={s.navLinks}>
					{MAIN_NAV.map((link) => (
						<Link key={link.href} href={link.href} className={cx(isActive(link.href) && s.isActive)} aria-current={isActive(link.href) ? "page" : undefined}>
							{link.label}
						</Link>
					))}
				</div>
				<div className={s.navRight}>
					{isPartners ? (
						<>
							<a className={s.login} href={ACCOUNT_LINKS.merchantLogin}>
								Merchant login
							</a>
							<a className={cx(s.btn, s.btnBlack, s.btnSm)} href="#apply">
								Apply now
							</a>
						</>
					) : (
						<>
							<a className={s.login} href={ACCOUNT_LINKS.login}>
								Log in
							</a>
							<a className={cx(s.btn, s.btnBlack, s.btnSm)} href={ACCOUNT_LINKS.signup}>
								Sign up
							</a>
						</>
					)}
					<button
						type="button"
						className={s.menuBtn}
						aria-expanded={open}
						aria-controls="site-menu"
						aria-label={open ? "Close menu" : "Open menu"}
						onClick={() => setOpen((v) => !v)}
					>
						<span />
						<span />
						<span />
					</button>
				</div>
			</div>
			<AnimatePresence initial={false}>
				{open && (
					<motion.div
						id="site-menu"
						className={s.mobileMenu}
						initial={{ height: 0, opacity: 0 }}
						animate={{ height: "auto", opacity: 1 }}
						exit={{ height: 0, opacity: 0 }}
						transition={{ duration: 0.3, ease: EASE }}
					>
						<div className={s.mobileMenuIn}>
							{MAIN_NAV.map((link) => (
								<Link key={link.href} href={link.href} className={cx(isActive(link.href) && s.isActive)} aria-current={isActive(link.href) ? "page" : undefined}>
									{link.label}
								</Link>
							))}
							<a href={isPartners ? ACCOUNT_LINKS.merchantLogin : ACCOUNT_LINKS.login}>{isPartners ? "Merchant login" : "Log in"}</a>
						</div>
					</motion.div>
				)}
			</AnimatePresence>
		</motion.nav>
	);
}
