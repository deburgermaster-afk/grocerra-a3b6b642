import Link from "next/link";
import { Fragment, type ReactNode } from "react";
import { cx } from "./cx";
import s from "./site.module.css";

export type TitleWord = { text: string; accent: boolean };

/** Splits "Bring the local store *to your door.*" into words, flagging the *starred* ones as the italic accent. */
export function parseTitle(title: string): TitleWord[] {
	const words: TitleWord[] = [];
	title.split(/(\*[^*]+\*)/).forEach((part) => {
		const accent = part.startsWith("*") && part.endsWith("*");
		const clean = accent ? part.slice(1, -1) : part;
		clean
			.split(" ")
			.filter(Boolean)
			.forEach((text) => words.push({ text, accent }));
	});
	return words;
}

/** Heading text with its accent words in the italic serif, either green ("hl") or underlined in yellow ("mark"). */
export function Title({ text, accent = "hl" }: { text: string; accent?: "hl" | "mark" }) {
	return (
		<>
			{text.split(/(\*[^*]+\*)/).map((part, i) =>
				part.startsWith("*") && part.endsWith("*") ? (
					<span key={i} className={cx(s.serif, accent === "hl" ? s.hl : s.mark)}>
						{part.slice(1, -1)}
					</span>
				) : (
					<Fragment key={i}>{part}</Fragment>
				)
			)}
		</>
	);
}

/** Placeholder text still to be confirmed, highlighted so it can't ship by accident. */
export function Ph({ children }: { children: ReactNode }) {
	return <span className={s.ph}>{children}</span>;
}

/**
 * Renders plain strings from the content files with two inline marks:
 * {{label|/href}} becomes a link and [[text]] becomes a highlighted [text] placeholder.
 */
export function RichText({ text }: { text: string }) {
	return (
		<>
			{text.split(/(\{\{[^}]+\}\}|\[\[[^\]]+\]\])/).map((part, i) => {
				if (part.startsWith("{{")) {
					const [label, href] = part.slice(2, -2).split("|");
					return href.startsWith("/") ? (
						<Link key={i} href={href}>
							{label}
						</Link>
					) : (
						<a key={i} href={href}>
							{label}
						</a>
					);
				}
				if (part.startsWith("[[")) return <Ph key={i}>[{part.slice(2, -2)}]</Ph>;
				return <Fragment key={i}>{part}</Fragment>;
			})}
		</>
	);
}
