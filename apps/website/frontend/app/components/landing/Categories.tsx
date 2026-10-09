import Image from "next/image";
import s from "./landing.module.css";
import { cx, Eyebrow } from "./shared";

type Category = { title: string; body: string; image: string; alt: string; layout?: "wide" | "tall" };

// Grid: 4 columns × 2 rows on desktop — fruit & veg spans two columns, meat spans two rows
const CATEGORIES: Category[] = [
	{ title: "Fruits & vegetables", body: "Seasonal, crisp and colourful", image: "/images/produce-market.jpg", alt: "Shelves of fresh vegetables at a grocer", layout: "wide" },
	{ title: "Fresh meat & poultry", body: "Halal cuts prepared by local butchers", image: "/images/halal-meat.jpg", alt: "Raw beef and lamb cuts on a wooden board", layout: "tall" },
	{ title: "Rice & grains", body: "Basmati, jasmine and more", image: "/images/rice-grains.jpg", alt: "Long-grain rice" },
	{ title: "Spices & masala", body: "Whole, ground and blends", image: "/images/spices.jpg", alt: "Colourful spices at a market stall" },
	{ title: "Dairy & eggs", body: "Milk, paneer and free-range eggs", image: "/images/eggs.jpg", alt: "A tray of free-range eggs" },
	{ title: "Fish & seafood", body: "Fresh and frozen catch", image: "/images/fish.jpg", alt: "Two whole fish on a plate" },
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
						<article key={c.title} className={cx(s.cat, c.layout === "wide" && s.wide, c.layout === "tall" && s.tall)} data-reveal="up">
							<Image src={c.image} alt={c.alt} fill sizes={c.layout === "wide" ? "(max-width: 760px) 100vw, 600px" : "(max-width: 760px) 100vw, (max-width: 960px) 50vw, 300px"} className={s.catImg} />
							<div className={s.catShade} />
							<div className={s.catText}>
								<h3>{c.title}</h3>
								<p>{c.body}</p>
							</div>
						</article>
					))}
				</div>
			</div>
		</section>
	);
}
