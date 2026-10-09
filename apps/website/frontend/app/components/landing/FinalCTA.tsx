import Image from "next/image";
import Link from "next/link";
import s from "./landing.module.css";
import { ArrowIcon, cx } from "./shared";

// 3D produce (Fluent Emoji, MIT — see public/images/3d/LICENSE.txt) floating around the card
const FLOATERS: { src: string; style: React.CSSProperties; bob: string; delay: string; hideMobile?: boolean }[] = [
	{ src: "watermelon", style: { left: "3%", top: 110, width: "clamp(96px,11vw,170px)" }, bob: s.bob, delay: "0s" },
	{ src: "bell-pepper", style: { right: "6%", top: 90, width: "clamp(90px,10vw,150px)" }, bob: s.bob2, delay: ".15s" },
	{ src: "onion", style: { left: "11%", bottom: 120, width: "clamp(80px,8vw,130px)" }, bob: s.bob3, delay: ".3s", hideMobile: true },
	{ src: "apple", style: { right: "14%", bottom: 140, width: "clamp(80px,8vw,120px)" }, bob: s.bob, delay: ".45s", hideMobile: true },
	{ src: "carrot", style: { left: "22%", top: 60, width: "clamp(60px,6vw,90px)" }, bob: s.bob2, delay: ".6s", hideMobile: true },
	{ src: "tomato", style: { right: "25%", top: 50, width: "clamp(56px,5vw,80px)" }, bob: s.bob3, delay: ".75s", hideMobile: true },
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
					<div key={f.src} className={cx(s.fl, s.finalFloat, f.hideMobile && s.hideM)} style={{ ...f.style, animationDelay: f.delay }} aria-hidden="true">
						<div className={f.bob}>
							<Image src={`/images/3d/${f.src}.png`} alt="" width={256} height={256} sizes="170px" />
						</div>
					</div>
				))}
				<div className={s.glass} data-reveal="zoom">
					<h2 className={s.h2}>
						Fresh food, <span className={s.serif}>without the trip.</span>
					</h2>
					<p>Your favourite local stores, a few taps away — tonight and every night.</p>
					<Link className={cx(s.pBtn, s.pBtnDark)} href="/download">
						Start shopping
						<ArrowIcon size={16} />
					</Link>
				</div>
			</div>
		</section>
	);
}
