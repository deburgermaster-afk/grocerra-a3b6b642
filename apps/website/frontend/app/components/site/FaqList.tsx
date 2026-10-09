import type { Faq } from "@/app/content/faq";
import FaqAccordion from "./FaqAccordion";
import s from "./site.module.css";
import { RichText } from "./text";

/** Renders FAQ entries from the content files as an accordion. */
export default function FaqList({ items, openFirst }: { items: Faq[]; openFirst?: boolean }) {
	return (
		<FaqAccordion
			openFirst={openFirst}
			items={items.map((f) => ({
				q: f.q,
				a: (
					<p>
						<RichText text={f.a} linkClassName={s.link} />
					</p>
				),
			}))}
		/>
	);
}
