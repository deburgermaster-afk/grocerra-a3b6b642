import { cx } from "./cx";
import { Reveal } from "./motion";
import s from "./site.module.css";
import { Title } from "./text";

type SectionHeadingProps = {
	eyebrow: string;
	/** Title with *starred* accent words, e.g. "Three partners, *one order*". */
	title: string;
	lede?: React.ReactNode;
	align?: "center" | "left";
};

export default function SectionHeading({ eyebrow, title, lede, align = "center" }: SectionHeadingProps) {
	return (
		<Reveal className={cx(align === "center" && s.center, align === "center" && s.head)}>
			<span className={s.eyebrow}>{eyebrow}</span>
			<h2 className={s.h2}>
				<Title text={title} />
			</h2>
			{lede && <p className={s.lede}>{lede}</p>}
		</Reveal>
	);
}
