"use client";

import { AnimatePresence, motion } from "framer-motion";
import { useId, useState, type ReactNode } from "react";
import { cx } from "./cx";
import { Icon } from "./icons";
import { EASE, Reveal } from "./motion";
import s from "./site.module.css";

export type FaqItem = { q: string; a: ReactNode };

function FaqRow({ item, open, onToggle }: { item: FaqItem; open: boolean; onToggle: () => void }) {
	const id = useId();
	return (
		<div className={cx(s.faq, open && s.faqOpen)}>
			<h3 style={{ margin: 0 }}>
				<button type="button" className={s.faqQ} aria-expanded={open} aria-controls={`${id}-a`} id={`${id}-q`} onClick={onToggle}>
					{item.q}
					<motion.span className={s.faqIcon} animate={{ rotate: open ? 135 : 0 }} transition={{ type: "spring", stiffness: 260, damping: 14 }} aria-hidden="true">
						<Icon name="plus" size={16} strokeWidth={2.6} />
					</motion.span>
				</button>
			</h3>
			<AnimatePresence initial={false}>
				{open && (
					<motion.div
						id={`${id}-a`}
						role="region"
						aria-labelledby={`${id}-q`}
						className={s.faqA}
						initial={{ height: 0, opacity: 0 }}
						animate={{ height: "auto", opacity: 1 }}
						exit={{ height: 0, opacity: 0 }}
						transition={{ duration: 0.4, ease: EASE }}
					>
						<div className={s.faqAIn}>{item.a}</div>
					</motion.div>
				)}
			</AnimatePresence>
		</div>
	);
}

/** Accordion of questions; each opens and closes independently. */
export default function FaqAccordion({ items, openFirst = false }: { items: FaqItem[]; openFirst?: boolean }) {
	const [open, setOpen] = useState<Set<number>>(() => new Set(openFirst ? [0] : []));
	const toggle = (i: number) =>
		setOpen((prev) => {
			const next = new Set(prev);
			if (next.has(i)) next.delete(i);
			else next.add(i);
			return next;
		});

	return (
		<div>
			{items.map((item, i) => (
				<Reveal key={item.q} className={s.faqItem}>
					<FaqRow item={item} open={open.has(i)} onToggle={() => toggle(i)} />
				</Reveal>
			))}
		</div>
	);
}
