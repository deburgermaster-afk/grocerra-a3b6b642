import Link from "next/link";
import type { ReactNode } from "react";
import { cx } from "./cx";
import { Icon } from "./icons";
import s from "./site.module.css";

const TONES = { green: s.btnGreen, black: s.btnBlack, white: s.btnWhite, line: s.btnLine, ghost: s.btnGhost };

type ButtonLinkProps = { href: string; tone?: keyof typeof TONES; small?: boolean; arrow?: boolean; children: ReactNode };

/** Pill-shaped link styled as a button. Internal routes use next/link; anchors, mailto and "#" use a plain <a>. */
export default function ButtonLink({ href, tone = "green", small, arrow, children }: ButtonLinkProps) {
	const className = cx(s.btn, TONES[tone], small && s.btnSm);
	const content = (
		<>
			{children}
			{arrow && <Icon name="arrow" size={18} strokeWidth={2.4} />}
		</>
	);
	return href.startsWith("/") ? (
		<Link className={className} href={href}>
			{content}
		</Link>
	) : (
		<a className={className} href={href}>
			{content}
		</a>
	);
}
