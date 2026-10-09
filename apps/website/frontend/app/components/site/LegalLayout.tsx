import type { Metadata } from "next";
import Link from "next/link";
import { Fragment } from "react";
import type { LegalBlock, LegalDoc } from "@/app/content/legal/types";
import { LEGAL_DOCS } from "@/app/content/site";
import { cx } from "./cx";
import { Icon } from "./icons";
import { Reveal } from "./motion";
import PageHero from "./PageHero";
import s from "./site.module.css";
import { RichText } from "./text";

const docLink = (slug: string) => LEGAL_DOCS.find((d) => d.slug === slug)!;

/** Title + description for a legal page's <head>. */
export function legalMetadata(doc: LegalDoc): Metadata {
	return { title: docLink(doc.slug).long, description: doc.description };
}

/** Dashed box marking text that still needs to be written. */
export function TodoBlock({ children }: { children: React.ReactNode }) {
	return <div className={s.todo}>{children}</div>;
}

function Block({ block }: { block: LegalBlock }) {
	switch (block.type) {
		case "p":
			return (
				<p>
					<RichText text={block.text} />
				</p>
			);
		case "ul":
			return (
				<ul>
					{block.items.map((item) => (
						<li key={item}>
							<RichText text={item} />
						</li>
					))}
				</ul>
			);
		case "todo":
			return <TodoBlock>{block.text}</TodoBlock>;
		case "table":
			return (
				<div className={cx(s.tableWrap, s.tableLeft)} style={{ marginTop: 14 }}>
					<table className={s.table}>
						<thead>
							<tr>
								<th scope="col">{block.head[0]}</th>
								<th scope="col">{block.head[1]}</th>
							</tr>
						</thead>
						<tbody>
							{block.rows.map(([a, b]) => (
								<tr key={a}>
									<td>
										<b>{a}</b>
									</td>
									<td>{b}</td>
								</tr>
							))}
						</tbody>
					</table>
				</div>
			);
		case "contact":
			return (
				<div className={s.contactBox}>
					<h3 className={s.h3}>{block.title}</h3>
					{block.lines.map((line) => (
						<p key={line}>
							{line.split("\n").map((part, i) => (
								<Fragment key={i}>
									{i > 0 && <br />}
									<RichText text={part} />
								</Fragment>
							))}
						</p>
					))}
				</div>
			);
	}
}

/** Shared layout for all eight legal documents: hero, sticky sidebar, contents list and the document itself. */
export default function LegalLayout({ doc }: { doc: LegalDoc }) {
	const current = docLink(doc.slug);
	return (
		<>
			<PageHero small crumbs={[{ label: "Home", href: "/" }, { label: "Legal" }, { label: current.short }]} title={doc.heroTitle} sub={doc.heroSub} />

			<section className={s.sec}>
				<div className={cx(s.wrap, s.legal)}>
					<aside className={s.legalSide}>
						<Reveal variant="left">
							<nav className={s.legalNav} aria-label="Legal documents">
								<h2 className={s.sideTitle}>Legal documents</h2>
								{LEGAL_DOCS.map((d) => (
									<Link key={d.slug} href={d.href} className={cx(d.slug === doc.slug && s.isActive)} aria-current={d.slug === doc.slug ? "page" : undefined}>
										{d.short}
									</Link>
								))}
							</nav>
						</Reveal>
						<Reveal variant="left" delay={0.1}>
							<nav className={s.toc} aria-label="On this page">
								<h2 className={s.sideTitle}>On this page</h2>
								{doc.sections.map((sec, i) => (
									<a key={sec.id} href={`#${sec.id}`}>
										{i + 1}. {sec.toc}
									</a>
								))}
							</nav>
						</Reveal>
					</aside>

					<article className={s.doc}>
						<div className={s.docMeta}>
							{doc.meta.map((m) => (
								<span key={m} className={s.pill}>
									{m}
								</span>
							))}
						</div>
						<div className={s.draft} role="note">
							<Icon name="info" size={20} strokeWidth={2.2} />
							<div>{doc.draftNote}</div>
						</div>
						{doc.intro?.map((block, i) => <Block key={i} block={block} />)}
						{doc.sections.map((sec, i) => (
							<Fragment key={sec.id}>
								<h2 id={sec.id}>
									<span className={s.n}>{i + 1}</span>
									{sec.title}
								</h2>
								{sec.blocks.map((block, j) => (
									<Block key={j} block={block} />
								))}
							</Fragment>
						))}
					</article>
				</div>
			</section>
		</>
	);
}
