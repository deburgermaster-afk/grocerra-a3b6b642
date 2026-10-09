import Link from "next/link";
import s from "./landing.module.css";
import { CategoryIcon, type CategoryIconName } from "./CategoryIcons";
import { ArrowIcon, cx, Eyebrow, vars } from "./shared";

// Scalloped awning: 7 half-circles hanging under the roof
const SCALLOPS = 7;
const AWNING_W = 344;
const R = AWNING_W / SCALLOPS / 2;
const awningPath =
	`M28 56h${AWNING_W}v20` +
	Array.from({ length: SCALLOPS }, () => `a${R} ${R} 0 0 1 -${R * 2} 0`).join("") +
	"z";

/** Produce placed over the storefront, as % of the stage: left, bottom, width, tilt. */
type Placed = { icon: CategoryIconName; x: number; y: number; w: number; r?: number; bob?: string };

// In the shop window
const WINDOW: Placed[] = [
	{ icon: "orange", x: 17, y: 35, w: 15 },
	{ icon: "lime", x: 30, y: 35, w: 10, r: 10 },
	{ icon: "apple", x: 38, y: 35, w: 11, r: -6 },
];

// Piled in front of the shop, back to front
const PILE: Placed[] = [
	{ icon: "tomatoes", x: 57, y: 8, w: 20, r: 4, bob: s.bob3 },
	{ icon: "carrot", x: 12, y: 6, w: 22, r: 40 },
	{ icon: "carrot", x: 18, y: 0, w: 22, r: 52 },
	{ icon: "mango", x: 30, y: -2, w: 24, r: -8 },
	{ icon: "lime", x: 37, y: 16, w: 10, r: -10, bob: s.bob2 },
	{ icon: "lime", x: 48, y: 3, w: 11, r: 14 },
	{ icon: "cabbage", x: -2, y: -10, w: 28 },
	{ icon: "bananas", x: 71, y: -8, w: 28, r: 10 },
];

function Storefront() {
	return (
		<div className={s.store} aria-hidden="true">
			<svg className={s.storeSvg} viewBox="0 0 400 330">
				<ellipse cx="200" cy="316" rx="180" ry="12" fill="#0B0B0B" opacity=".18" />
				{/* building */}
				<rect x="40" y="70" width="320" height="236" fill="#FFFFFF" />
				<rect x="64" y="128" width="136" height="100" rx="10" className="fill-grocerra-mint" />
				<rect x="64" y="212" width="136" height="16" fill="#0B0B0B" opacity=".06" />
				<rect x="64" y="244" width="136" height="44" rx="8" className="fill-grocerra-green-700" />
				<rect x="224" y="128" width="112" height="178" rx="10" className="fill-grocerra-green-700" />
				<rect x="244" y="148" width="72" height="34" rx="6" className="fill-grocerra-green" />
				<text x="280" y="171" textAnchor="middle" className={cx(s.svgText, "fill-grocerra-yellow")} fontSize="15" fontWeight={900}>
					OPEN
				</text>
				<circle cx="320" cy="226" r="6" className="fill-grocerra-yellow" />
				<rect x="30" y="300" width="340" height="10" rx="5" className="fill-grocerra-black" />
				{/* roof, sign and awning */}
				<rect x="22" y="8" width="356" height="52" rx="12" className="fill-grocerra-black" />
				<rect x="130" y="22" width="140" height="24" rx="12" className="fill-grocerra-yellow" />
				<text x="200" y="39" textAnchor="middle" className={cx(s.svgText, "fill-grocerra-black")} fontSize="12" fontWeight={900} letterSpacing="1.5">
					YOUR STORE
				</text>
				<path d={awningPath} className="fill-grocerra-yellow" />
			</svg>
			{[...WINDOW, ...PILE].map((p, i) => (
				<span
					key={i}
					className={cx(s.storeItem, p.bob)}
					style={vars({ left: `${p.x}%`, bottom: `${p.y}%`, width: `${p.w}%`, "--r": `${p.r ?? 0}deg` })}
				>
					<CategoryIcon name={p.icon} />
				</span>
			))}
			<div className={cx(s.ping, s.bob)}>
				<span className={s.pingDot} />
				New order received
			</div>
		</div>
	);
}

export default function PartnerCTA() {
	return (
		<section className={s.sec} id="partner">
			<div className={s.wrap}>
				<div className={cx(s.partner, s.zoom)} data-reveal="zoom">
					<div>
						<Eyebrow>For businesses</Eyebrow>
						<h2 className={s.h2}>
							Own a grocery or meat shop? <span className={s.serif}>Grow with us.</span>
						</h2>
						<p className={s.lede}>List your store, reach new customers nearby and manage every order from one simple dashboard.</p>
						<div className={s.partnerBtns}>
							<Link className={cx(s.pBtn, s.pBtnDark)} href="/partner-with-us">
								Become a partner
								<ArrowIcon size={16} />
							</Link>
							<Link className={cx(s.pBtn, s.pBtnGhost)} href="/partner-login">
								Partner login
							</Link>
						</div>
					</div>
					<Storefront />
				</div>
			</div>
		</section>
	);
}
