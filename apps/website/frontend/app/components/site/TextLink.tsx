import Link from "next/link";
import type { ReactNode } from "react";
import s from "./site.module.css";

/** Green inline link with an underline that grows on hover. */
export default function TextLink({ href, children }: { href: string; children: ReactNode }) {
	return href.startsWith("/") ? (
		<Link className={s.link} href={href}>
			{children}
		</Link>
	) : (
		<a className={s.link} href={href}>
			{children}
		</a>
	);
}
