import type { CSSProperties } from "react";
import { cx } from "./cx";
import { Reveal } from "./motion";
import Produce, { type ProduceName } from "./Produce";
import s from "./site.module.css";

type Item = { name: ProduceName; width: number; style?: CSSProperties; bob?: 1 | 2 | 3 };
const BOB = { 1: s.bob, 2: s.bob2, 3: s.bob3 };

type RingVisualProps = {
	tone?: "tint" | "green";
	/** Ring diameters in px; every second ring spins the other way. */
	rings: number[];
	main: Item;
	items: Item[];
	minHeight?: number;
};

/** Decorative panel: spinning dashed rings with a produce arrangement that bobs. */
export default function RingVisual({ tone = "tint", rings, main, items, minHeight }: RingVisualProps) {
	return (
		<Reveal variant="zoom">
			<div className={cx(s.visual, tone === "green" && s.vGreen)} style={{ minHeight }} aria-hidden="true">
				{rings.map((size, i) => (
					<div key={size} className={cx(s.ring, i % 2 === 1 && s.ringRev)} style={{ width: size, height: size }} />
				))}
				<div className={s.vMain} style={{ width: main.width }}>
					<Produce name={main.name} className={BOB[main.bob ?? 1]} sizes="220px" />
				</div>
				{items.map((item) => (
					<div key={item.name} className={s.vItem} style={{ width: item.width, ...item.style }}>
						<Produce name={item.name} className={BOB[item.bob ?? 2]} sizes="130px" />
					</div>
				))}
			</div>
		</Reveal>
	);
}
