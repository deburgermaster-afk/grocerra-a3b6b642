import type { CSSProperties } from "react";
import { siApple, siGoogleplay } from "simple-icons";
import { ACCOUNT_LINKS } from "@/app/content/site";
import s from "./landing.module.css";

/** Inline styles that include CSS custom properties (--py, --fx, …). */
export const vars = (style: Record<string, string | number>) => style as CSSProperties;

export const cx = (...names: (string | false | undefined)[]) => names.filter(Boolean).join(" ");

type IconProps = { size?: number };

export function ArrowIcon({ size = 18 }: IconProps) {
	return (
		<svg width={size} height={size} viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth={2.4} strokeLinecap="round" strokeLinejoin="round" aria-hidden="true">
			<path d="M5 12h14M13 6l6 6-6 6" />
		</svg>
	);
}

export function TruckIcon({ size = 30, strokeWidth = 2 }: IconProps & { strokeWidth?: number }) {
	return (
		<svg width={size} height={size} viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth={strokeWidth} strokeLinecap="round" strokeLinejoin="round" aria-hidden="true">
			<path d="M1 4h14v12H1zM15 9h4l4 4v3h-8z" />
			<circle cx="5.5" cy="18.5" r="2" />
			<circle cx="18.5" cy="18.5" r="2" />
		</svg>
	);
}

export function Eyebrow({ children, reveal = false }: { children: React.ReactNode; reveal?: boolean }) {
	return (
		<span className={cx(s.eyebrow, reveal && s.reveal)} data-reveal={reveal ? "up" : undefined}>
			{children}
		</span>
	);
}

function BrandIcon({ path, size = 24 }: { path: string; size?: number }) {
	return (
		<svg width={size} height={size} viewBox="0 0 24 24" fill="currentColor" aria-hidden="true">
			<path d={path} />
		</svg>
	);
}

// Store listings are not live yet; links come from ACCOUNT_LINKS in app/content/site.ts
export function StoreBadges({ tone = "light" }: { tone?: "light" | "dark" }) {
	const badge = cx(s.storeBadge, tone === "dark" && s.storeBadgeDark);
	return (
		<div className={s.storeBadges}>
			<a className={badge} href={ACCOUNT_LINKS.appStore} aria-label="Download on the App Store">
				<BrandIcon path={siApple.path} size={26} />
				<span>
					<small>Download on the</small>
					App Store
				</span>
			</a>
			<a className={badge} href={ACCOUNT_LINKS.googlePlay} aria-label="Get it on Google Play">
				<BrandIcon path={siGoogleplay.path} size={22} />
				<span>
					<small>Get it on</small>
					Google Play
				</span>
			</a>
		</div>
	);
}
