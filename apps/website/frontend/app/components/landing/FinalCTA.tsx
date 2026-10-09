import s from "./landing.module.css";
import { Grocery, type GroceryName } from "./GroceryArt";
import { cx, StoreBadges } from "./shared";

const FLOATERS: { name: GroceryName; style: React.CSSProperties; bob: string; hideMobile?: boolean }[] = [
	{ name: "bread", style: { left: "5%", top: 120, width: "clamp(100px,11vw,170px)" }, bob: s.bob, hideMobile: true },
	{ name: "oil", style: { right: "8%", top: 80, width: "clamp(48px,5vw,76px)" }, bob: s.bob2, hideMobile: true },
	{ name: "eggs", style: { left: "12%", bottom: 130, width: 130 }, bob: s.bob3, hideMobile: true },
	{ name: "spices", style: { right: "15%", bottom: 140, width: 80 }, bob: s.bob, hideMobile: true },
];

export default function FinalCTA() {
	return (
		<section className={s.finalShell}>
			<div className={s.final}>
				<div className={s.glow} />
				<svg className={cx(s.hill, s.finalHill)} viewBox="0 0 1440 300" preserveAspectRatio="xMidYMax slice" aria-hidden="true">
					<path d="M0 150C200 90 380 110 560 140C760 172 900 100 1100 100C1260 100 1360 130 1440 120V300H0Z" className="fill-grocerra-green-700" />
					<path d="M0 210C240 160 480 180 720 210C960 240 1200 170 1440 190V300H0Z" className="fill-grocerra-green-hill" />
					<path d="M0 262C300 236 600 244 900 264C1100 276 1300 252 1440 256V300H0Z" className="fill-grocerra-green-800" />
				</svg>
				{FLOATERS.map((f) => (
					<div key={f.name} className={cx(s.fl, f.hideMobile && s.hideM)} style={f.style}>
						<Grocery name={f.name} className={f.bob} />
					</div>
				))}
				<div className={s.glass} data-reveal="zoom">
					<h2 className={s.h2}>
						Fresh food, <span className={s.serif}>without the trip.</span>
					</h2>
					<p>Your favourite local stores, a few taps away — tonight and every night.</p>
					<StoreBadges tone="dark" />
				</div>
			</div>
		</section>
	);
}
