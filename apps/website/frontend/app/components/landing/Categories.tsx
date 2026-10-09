import Link from "next/link";
import s from "./landing.module.css";
import { CategoryIcon, type CategoryIconName } from "./CategoryIcons";
import { ArrowIcon, cx, Eyebrow, vars } from "./shared";

/** One icon on a card: width as a share of the card, resting tilt in degrees. */
type Art = { icon: CategoryIconName; size: string; tilt?: number };

type Category = {
	title: string;
	body: string;
	tone: string;
	art: Art[];
	badge?: string;
	layout?: "wide" | "tall";
};

// Grid: 4 columns × 2 rows on desktop — fruits span two columns, meat spans two rows
const CATEGORIES: Category[] = [
	{
		title: "Fruits",
		body: "Seasonal, ripe and hand-picked",
		tone: s.cMint,
		layout: "wide",
		art: [
			{ icon: "orange", size: "21%", tilt: -8 },
			{ icon: "watermelon", size: "27%", tilt: 6 },
			{ icon: "apple", size: "21%", tilt: -4 },
			{ icon: "banana", size: "24%", tilt: 10 },
		],
	},
	{
		title: "Meat, poultry & fish",
		body: "Halal cuts prepared by local butchers",
		tone: s.cForest,
		layout: "tall",
		badge: "Halal",
		art: [
			{ icon: "steak", size: "60%", tilt: -10 },
			{ icon: "drumstick", size: "50%", tilt: 12 },
			{ icon: "fish", size: "58%", tilt: -6 },
		],
	},
	{
		title: "Vegetables",
		body: "Crisp and colourful",
		tone: s.cGreen,
		art: [
			{ icon: "carrot", size: "46%", tilt: -6 },
			{ icon: "broccoli", size: "46%", tilt: 8 },
		],
	},
	{
		title: "Rice & grains",
		body: "Basmati, jasmine and more",
		tone: s.cLime,
		art: [{ icon: "rice", size: "62%", tilt: -4 }],
	},
	{
		title: "Spices & masala",
		body: "Whole, ground and blends",
		tone: s.cWhite,
		art: [
			{ icon: "mortar", size: "50%", tilt: -4 },
			{ icon: "chilli", size: "42%", tilt: 14 },
		],
	},
	{
		title: "Dairy & eggs",
		body: "Milk, paneer and free-range eggs",
		tone: s.cPale,
		art: [
			{ icon: "milk", size: "48%", tilt: -6 },
			{ icon: "egg", size: "38%", tilt: 10 },
		],
	},
];

export default function Categories() {
	return (
		<section className={s.sec} id="categories">
			<div className={s.wrap}>
				<div className={s.center}>
					<Eyebrow reveal>Categories</Eyebrow>
					<h2 className={cx(s.h2, s.reveal)} data-reveal="up">
						Everything fresh, <span className={cx(s.serif, s.hl)}>in one place</span>
					</h2>
					<p className={cx(s.lede, s.reveal)} data-reveal="up">
						From the weekly shop to the butcher&apos;s counter — browse every aisle of the stores near you.
					</p>
				</div>
				<div className={s.bento}>
					{CATEGORIES.map((c) => (
						<Link
							key={c.title}
							href="/#app"
							aria-label={`Shop ${c.title.toLowerCase()} in the Grocerra app`}
							className={cx(s.cat, c.tone, c.layout === "wide" && s.wide, c.layout === "tall" && s.tall)}
							data-reveal="up"
						>
							<div className={s.catHead}>
								<div>
									<h3>{c.title}</h3>
									<p>{c.body}</p>
								</div>
								<span className={s.catGo} aria-hidden="true">
									<ArrowIcon size={16} />
								</span>
							</div>
							<div className={s.catArt} aria-hidden="true">
								{c.art.map((a, i) => (
									<span key={a.icon} className={s.catIcon} style={vars({ "--s": a.size, "--r": `${a.tilt ?? 0}deg`, "--d": `${i * 0.06}s` })}>
										<CategoryIcon name={a.icon} />
									</span>
								))}
							</div>
							{c.badge && <span className={s.catBadge}>{c.badge}</span>}
						</Link>
					))}
				</div>
			</div>
		</section>
	);
}
