import Image from "next/image";
import { Fragment } from "react";
import s from "./landing.module.css";
import { GrocerraBag } from "./GroceryArt";
import PhoneMockup from "./PhoneMockup";
import { cx, vars } from "./shared";

const WORDS = [
	{ text: "Groceries", delay: ".25s" },
	{ text: "and", delay: ".35s" },
	{ text: "fresh", delay: ".45s" },
	{ text: "meat,", delay: ".55s" },
	{ text: "delivered", delay: ".65s", accent: true },
	{ text: "to", delay: ".8s", serif: true },
	{ text: "your", delay: ".9s", serif: true },
	{ text: "door.", delay: "1s", serif: true },
];

// Groceries spilling out of a tipped-over Grocerra bag. left/top/width are % of the pile box;
// each item slides out from the bag mouth (MOUTH, also in %) to its resting spot.
const MOUTH = { x: 62, y: 20 };
const PILE_BOX = { w: 480, h: 330 };
// 3D produce (Fluent Emoji, MIT — see public/images/3d/LICENSE.txt)
const SPILL: { src: string; left: number; top: number; width: number; rotate: number }[] = [
	{ src: "leafy-green", left: 44, top: -4, width: 18, rotate: -30 },
	{ src: "carrot", left: 50, top: 22, width: 16, rotate: 40 },
	{ src: "bread", left: 22, top: 22, width: 22, rotate: -10 },
	{ src: "eggplant", left: 4, top: 44, width: 17, rotate: -20 },
	{ src: "tomato", left: 38, top: 42, width: 14, rotate: 8 },
	{ src: "egg", left: 17, top: 62, width: 11, rotate: 20 },
	{ src: "broccoli", left: 25, top: 52, width: 18, rotate: -6 },
	{ src: "apple", left: 2, top: 66, width: 14, rotate: -8 },
	{ src: "lemon", left: 44, top: 64, width: 12, rotate: 24 },
	{ src: "meat", left: 55, top: 52, width: 17, rotate: -14 },
];
const spillFrom = (left: number, top: number) => ({
	"--sx": `${Math.round(((MOUTH.x - left) / 100) * PILE_BOX.w)}px`,
	"--sy": `${Math.round(((MOUTH.y - top) / 100) * PILE_BOX.h)}px`,
});

function Van() {
	return (
		<div className={s.van} aria-hidden="true">
			<svg viewBox="0 0 160 80">
				<g className={s.vanBody}>
					<path d="M8 22a8 8 0 0 1 8-8h80v46H8Z" className="fill-grocerra-white" />
					<path d="M96 26h26c4 0 7 2 9 5l14 18c1 2 2 4 2 6v5H96Z" className="fill-grocerra-white" />
					<path d="M104 32h18l11 14h-29Z" className="fill-grocerra-green-pale" />
					<rect x="8" y="40" width="88" height="7" className="fill-grocerra-yellow" />
					<path d="M30 34c0-7 5-12 15-12 0 8-5 12-11 12Z" className="fill-grocerra-green" />
					<rect x="4" y="56" width="148" height="6" rx="3" className="fill-grocerra-black" />
				</g>
				{[36, 122].map((x) => (
					<g key={x} className={s.wheel}>
						<circle cx={x} cy="64" r="11" fill="#000000" />
						<circle cx={x} cy="64" r="4" className="fill-grocerra-yellow" />
						<rect x={x - 1} y="55" width="2" height="18" className="fill-grocerra-muted" />
					</g>
				))}
			</svg>
		</div>
	);
}

export default function Hero() {
	return (
		<div className={s.heroShell} id="top">
			<header className={s.hero}>
				<div className={s.heroGlow} />

				<div className={s.heroPhone} aria-hidden="true">
					<div className={s.flIn} style={{ animationDelay: ".6s" }}>
						<PhoneMockup reveal={false} preload />
					</div>
				</div>

				<div className={s.heroPile} aria-hidden="true">
					<div className={s.pileBag}>
						<div className={s.flIn} style={{ animationDelay: "1.1s" }}>
							<GrocerraBag />
						</div>
					</div>
					{SPILL.map((item, i) => (
						<div key={i} className={s.pileItem} style={vars({ left: `${item.left}%`, top: `${item.top}%`, width: `${item.width}%`, rotate: `${item.rotate}deg` })}>
							<div className={s.spill} style={vars({ ...spillFrom(item.left, item.top), animationDelay: `${1.5 + i * 0.12}s` })}>
								<Image src={`/images/3d/${item.src}.png`} alt="" width={256} height={256} sizes="100px" priority className={s.pileImg} />
							</div>
						</div>
					))}
				</div>

				<div className={cx(s.heroCopy, s.wrap)}>
					<span className={s.tag}>
						<b>Fresh</b> From the stores you already trust
					</span>
					<h1 className={s.h1}>
						{WORDS.map((w, i) => (
							<Fragment key={w.text}>
								{i > 0 && " "}
								<span className={cx(s.w, w.serif && s.serif, w.accent && s.h1Accent)} style={{ animationDelay: w.delay }}>
									{w.text}
								</span>
							</Fragment>
						))}
					</h1>
					<p className={s.heroSub}>
						Order from your favourite local grocers, butchers and bakers — packed fresh and brought straight to you.
					</p>
				</div>

				<div className={s.road} />
				<Van />
			</header>
		</div>
	);
}
