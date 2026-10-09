import Link from "next/link";
import { ACCOUNT_LINKS, COMPANY, FOOTER_COLUMNS, LEGAL_DOCS } from "@/app/content/site";
import { RiseIn } from "./motion";
import { Logo } from "./Navbar";
import s from "./site.module.css";

// "#" links are placeholders until the app store listings and merchant portal exist
function FooterLink({ href, children }: { href: string; children: React.ReactNode }) {
	return href.startsWith("/") ? <Link href={href}>{children}</Link> : <a href={href}>{children}</a>;
}

export default function Footer() {
	return (
		<footer className={s.foot}>
			<div className={s.wrap}>
				<div className={s.footTop}>
					<div className={s.footBrand}>
						<Logo inverse />
						<p>{COMPANY.blurb}</p>
						<div className={s.badges}>
							<a className={s.badge} href={ACCOUNT_LINKS.appStore}>
								App Store
							</a>
							<a className={s.badge} href={ACCOUNT_LINKS.googlePlay}>
								Google Play
							</a>
						</div>
					</div>
					{FOOTER_COLUMNS.map((col) => (
						<nav key={col.title} aria-label={col.title}>
							<h2 className={s.footTitle}>{col.title}</h2>
							<ul>
								{col.links.map((link) => (
									<li key={link.label}>
										<FooterLink href={link.href}>{link.label}</FooterLink>
									</li>
								))}
							</ul>
						</nav>
					))}
				</div>
				<nav className={s.footLegal} aria-label="Legal">
					<h2 className={s.footTitle}>Legal</h2>
					<ul>
						{LEGAL_DOCS.map((doc) => (
							<li key={doc.slug}>
								<Link href={doc.href}>{doc.long}</Link>
							</li>
						))}
					</ul>
				</nav>
				<RiseIn className={s.giant}>
					GRO<span>CERRA</span>
				</RiseIn>
				<FooterBottom />
			</div>
		</footer>
	);
}

export function FooterBottom() {
	return (
		<div className={s.footBottom}>
			<span>{COMPANY.copyright}</span>
			<span>
				{COMPANY.address} · <a href={`mailto:${COMPANY.email}`}>{COMPANY.email}</a>
			</span>
		</div>
	);
}

/** Slim footer used by the 404 page. */
export function SmallFooter() {
	return (
		<div className={`${s.foot} ${s.footSmall}`}>
			<div className={`${s.wrap} ${s.footBottom}`}>
				<span>{COMPANY.copyright}</span>
				<span>
					<Link href="/legal/terms">Terms</Link> · <Link href="/legal/privacy">Privacy</Link> · <Link href="/contact">Contact</Link>
				</span>
			</div>
		</div>
	);
}
