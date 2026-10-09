import Image from "next/image";
import s from "./landing.module.css";
import { cx } from "./shared";

const TILES = [
	{ name: "Halal butcher", image: "/images/halal-meat.jpg" },
	{ name: "Spice market", image: "/images/spices.jpg" },
	{ name: "Fresh grocer", image: "/images/produce-market.jpg" },
	{ name: "Dairy & eggs", image: "/images/eggs.jpg" },
];

/** The Grocerra app home screen, used in the hero and the app section. */
export default function PhoneMockup({ className, reveal = true, preload }: { className?: string; reveal?: boolean; preload?: boolean }) {
	return (
		<div className={cx(s.phone, className)} data-reveal={reveal ? "up" : undefined}>
			<div className={s.notch} />
			<div className={s.screen}>
				<div className={s.scHead}>
					<div>
						<div className={s.scGreet}>Good morning</div>
						<div className={s.scTitle}>What&apos;s for dinner?</div>
					</div>
					<div className={s.scAvatar} />
				</div>
				<div className={s.scSearch}>
					<svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth={2.4} strokeLinecap="round" aria-hidden="true">
						<circle cx="11" cy="11" r="7" />
						<path d="m20 20-3.5-3.5" />
					</svg>
					Search stores
				</div>
				<div className={s.scChips}>
					<span>All</span>
					<span>Grocery</span>
					<span>Meat</span>
					<span>Bakery</span>
				</div>
				<div className={s.scOrder}>
					<small>Current order</small>
					<b>Out for delivery</b>
					<div className={s.prog}>
						<span />
					</div>
				</div>
				<div className={s.scGrid}>
					{TILES.map((t) => (
						<div key={t.name} className={s.scTile}>
							<Image src={t.image} alt="" fill sizes="120px" className={s.scTileImg} preload={preload} />
							<span>{t.name}</span>
						</div>
					))}
				</div>
			</div>
		</div>
	);
}
