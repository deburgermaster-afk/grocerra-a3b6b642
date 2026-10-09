import type { Metadata } from "next";
import ButtonLink from "@/app/components/site/Button";
import Card from "@/app/components/site/Card";
import CtaBand from "@/app/components/site/CtaBand";
import { cx } from "@/app/components/site/cx";
import { Icon } from "@/app/components/site/icons";
import { Reveal } from "@/app/components/site/motion";
import PageHero from "@/app/components/site/PageHero";
import RingVisual from "@/app/components/site/RingVisual";
import SectionHeading from "@/app/components/site/SectionHeading";
import s from "@/app/components/site/site.module.css";
import StepList from "@/app/components/site/StepList";
import { Ph } from "@/app/components/site/text";

export const metadata: Metadata = {
	title: "Food safety & allergens",
	description: "How product information works on Grocerra, who is responsible for it, and what to do before ordering if you have an allergy.",
};

const LABELS = [
	{ label: "Halal", color: "var(--green)" },
	{ label: "Vegetarian", color: "var(--yellow)" },
	{ label: "Vegan", color: "var(--black)" },
	{ label: "Contains allergens", color: "var(--green-d)" },
];

export default function FoodSafetyPage() {
	return (
		<>
			<PageHero
				small
				crumbs={[{ label: "Home", href: "/" }, { label: "Help", href: "/help" }, { label: "Food safety" }]}
				title="Food safety, *allergens* & *dietary labels.*"
				sub="How product information works on Grocerra, and what to do if you have an allergy."
				produce={[
					{ name: "garlic", style: { left: "7%", top: 130, width: "clamp(80px,9vw,130px)" }, py: -180, pr: -30, delay: 0.6 },
					{ name: "ginger", style: { right: "7%", top: 140, width: "clamp(80px,9vw,130px)" }, py: -200, pr: 30, delay: 0.75, bob: 2 },
				]}
			/>

			<section className={s.sec}>
				<div className={s.wrap}>
					<Reveal variant="zoom">
						<div className={s.warn} role="note">
							<Icon name="alert" size={28} strokeWidth={2.2} />
							<div>
								<b>Severe allergy?</b> We strongly recommend contacting the store before you order. Grocerra cannot guarantee that any product is free from a particular allergen.
							</div>
						</div>
					</Reveal>
				</div>
			</section>

			<section className={s.sec} style={{ paddingTop: 0 }}>
				<div className={s.wrap}>
					<SectionHeading eyebrow="Who's responsible" title="Shared *responsibility*" />
					<div className={s.grid3}>
						<Card tone="green" icon="store" title="Stores">
							<p>Provide product descriptions, ingredients and allergen information, are responsible for its accuracy, and work to prevent cross-contamination in their kitchens.</p>
						</Card>
						<Card icon="clipboard" title="Grocerra" delay={0.08}>
							<p>Displays the information exactly as the store provides it. We don&apos;t independently verify it.</p>
						</Card>
						<Card tone="black" icon="user" title="You" delay={0.16}>
							<p>Check the information provided and contact the store directly before ordering if you have an allergy, intolerance or dietary requirement.</p>
						</Card>
					</div>
				</div>
			</section>

			<section className={cx(s.sec, s.secGrey)}>
				<div className={s.wrap}>
					<SectionHeading eyebrow="If you have an allergy" title="Three steps *before you order*" />
					<StepList
						steps={[
							{ title: "Read the product details", body: "Check the ingredients and allergen information on every product in your basket.", produce: "lemon" },
							{ title: "Contact the store", body: "Ask about ingredients, preparation and cross-contamination directly.", produce: "brown-cap-mushroom" },
							{ title: "Add clear instructions", body: "Use the special instructions field to note your requirements on the order.", produce: "lime" },
						]}
					/>
				</div>
			</section>

			<section className={s.sec}>
				<div className={cx(s.wrap, s.split)}>
					<div>
						<SectionHeading
							align="left"
							eyebrow="Dietary labels"
							title="Halal, vegetarian *& vegan*"
							lede={
								<>
									Stores label products to help you find what suits you. <Ph>[How labels are verified and who certifies halal products — to be confirmed]</Ph>
								</>
							}
						/>
						<Reveal>
							<ul className={s.labels} style={{ listStyle: "none", padding: 0 }}>
								{LABELS.map((l) => (
									<li key={l.label} className={s.lbl}>
										<i style={{ background: l.color }} aria-hidden="true" />
										{l.label}
									</li>
								))}
							</ul>
						</Reveal>
					</div>
					<RingVisual
						rings={[360]}
						main={{ name: "avocado", width: 200 }}
						items={[
							{ name: "aubergine", width: 110, style: { left: "14%", top: "16%" } },
							{ name: "yellow-onion", width: 110, style: { right: "12%", bottom: "14%" }, bob: 3 },
						]}
					/>
				</div>
			</section>

			<CtaBand title="Report a *concern*" text="Found an incorrect label or a food safety issue? Tell us and we'll follow it up with the store.">
				<ButtonLink href="/contact" tone="white">
					Report a concern
				</ButtonLink>
			</CtaBand>
		</>
	);
}
