import s from "./site.module.css";

/** Black scrolling band of phrases (decorative; the list repeats so the loop is seamless). */
export default function Marquee({ items }: { items: string[] }) {
	return (
		<div className={s.marquee} aria-hidden="true">
			<div className={s.track}>
				{[...items, ...items].map((item, i) => (
					<span key={i}>{item}</span>
				))}
			</div>
		</div>
	);
}
