import Link from "next/link";
import { FOOTER_COLUMNS, SITEMAP_LINK } from "@/app/lib/siteLinks";
import s from "./landing.module.css";
import { Logo } from "./Navbar";

export default function Footer() {
	return (
		<footer className={s.foot}>
			<div className={s.wrap}>
				<div className={s.footGrid}>
					<div>
						<Logo />
						<p className={s.footBlurb}>Groceries and fresh meat from the stores you love, delivered to your door.</p>
					</div>
					{FOOTER_COLUMNS.map((col) => (
						<nav key={col.title} aria-label={col.title}>
							<h4>{col.title}</h4>
							<ul>
								{col.links.map((link) => (
									<li key={link.href}>
										<Link href={link.href}>{link.label}</Link>
									</li>
								))}
							</ul>
						</nav>
					))}
				</div>
				<div className={s.giant} aria-hidden="true" data-reveal="up">
					GRO<span>CERRA</span>
				</div>
				<div className={s.footBottom}>
					<span>© [Year] Grocerra. All rights reserved.</span>
					<Link href={SITEMAP_LINK.href}>{SITEMAP_LINK.label}</Link>
					<span>Made fresh, delivered fresh.</span>
				</div>
			</div>
		</footer>
	);
}
