import s from "./landing.module.css";
import { STATS, type Stat } from "./content";
import CountUp from "./CountUp";
import { Grocery, type GroceryName } from "./GroceryArt";
import { cx, Eyebrow, vars } from "./shared";

const TONES = { left: [s.tLime, s.tForest], right: [s.tMint, s.tGreen] };
const RANGES = { left: [undefined, "entry 15% cover 45%"], right: ["entry 8% cover 38%", "entry 20% cover 50%"] };

// Groceries that drop into the basket as it scrolls into view (--r0 = starting spin)
const DROPS: { name: GroceryName; style: Record<string, string | number> }[] = [
	{ name: "rice", style: { left: "calc(50% - 165px)", bottom: 200, width: 120, "--r0": "-50deg" } },
	{ name: "milk", style: { left: "calc(50% + 70px)", bottom: 196, width: 84, "--r0": "40deg", animationRange: "entry 34% cover 58%" } },
	{ name: "oil", style: { left: "calc(50% - 40px)", bottom: 210, width: 58, "--r0": "-70deg", animationRange: "entry 38% cover 62%" } },
	{ name: "spices", style: { left: "calc(50% + 10px)", bottom: 200, width: 72, "--r0": "50deg", animationRange: "entry 42% cover 66%" } },
	{ name: "bread", style: { left: "calc(50% - 120px)", bottom: 236, width: 150, "--r0": "-30deg", animationRange: "entry 46% cover 70%" } },
	{ name: "eggs", style: { left: "calc(50% + 40px)", bottom: 250, width: 120, "--r0": "60deg", animationRange: "entry 50% cover 74%" } },
];

function TicketColumn({ side }: { side: "left" | "right" }) {
	return (
		<div className={cx(s.tcol, side === "left" ? s.tcolLeft : s.tcolRight)}>
			{STATS[side].map((stat: Stat, i) => (
				<div key={stat.label} className={cx(s.ticket, TONES[side][i])} style={RANGES[side][i] ? { animationRange: RANGES[side][i] } : undefined} data-reveal={side}>
					<div className={s.big}>
						<CountUp to={stat.to} decimals={stat.decimals} prefix={stat.prefix} suffix={stat.suffix} />
					</div>
					<div className={s.lbl}>{stat.label}</div>
				</div>
			))}
		</div>
	);
}

function Basket() {
	return (
		<div className={s.basketStage} aria-hidden="true">
			<div className={cx(s.bk, s.bkBack)} style={{ bottom: 150 }} data-reveal="up">
				<svg viewBox="0 0 430 200">
					<path d="M70 190C70 60 140 10 215 10S360 60 360 190" fill="none" className="stroke-grocerra-black" strokeWidth={16} strokeLinecap="round" />
					<ellipse cx="215" cy="190" rx="200" ry="10" className="fill-grocerra-black" />
				</svg>
			</div>
			{DROPS.map((d) => (
				<div key={d.name} className={s.drop} style={vars(d.style)} data-reveal="drop">
					<Grocery name={d.name} />
				</div>
			))}
			<div className={cx(s.bk, s.bkFront)} data-reveal="up">
				<svg viewBox="0 0 430 230">
					<rect x="6" y="0" width="418" height="36" rx="18" className="fill-grocerra-green-700" />
					<path d="M26 30H404L366 222a8 8 0 0 1-8 8H72a8 8 0 0 1-8-8Z" className="fill-grocerra-green" />
					<g className="stroke-grocerra-green-700" strokeWidth={6} opacity=".55">
						<path d="M40 80H390M50 130H380M58 180H372" />
					</g>
					<g className="stroke-grocerra-white" strokeWidth={4} opacity=".35">
						<path d="M110 36L120 228M170 36L172 228M230 36L228 228M290 36L280 228M350 36L332 228" />
					</g>
					<rect x="155" y="98" width="120" height="44" rx="22" className="fill-grocerra-yellow" />
					<text x="215" y="127" textAnchor="middle" className={cx(s.svgText, "fill-grocerra-black")} fontSize="17" fontWeight={900}>
						FRESH
					</text>
				</svg>
			</div>
		</div>
	);
}

export default function StoresBasket() {
	return (
		<section className={s.sec} id="stores">
			<div className={cx(s.wrap, s.center)}>
				<Eyebrow reveal>Shop local</Eyebrow>
				<h2 className={cx(s.h2, s.reveal)} data-reveal="up">
					Shop your <span className={cx(s.serif, s.hl)}>favourite stores</span>
				</h2>
				<p className={cx(s.lede, s.reveal)} data-reveal="up">
					Trusted grocers, butchers and bakers near you — all in one basket, one checkout.
				</p>
			</div>
			<div className={cx(s.wrap, s.basketGrid)}>
				<TicketColumn side="left" />
				<Basket />
				<TicketColumn side="right" />
			</div>
		</section>
	);
}
