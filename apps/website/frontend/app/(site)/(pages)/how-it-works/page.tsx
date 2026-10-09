import type { Metadata } from "next";
import ButtonLink from "@/app/components/site/Button";
import Card from "@/app/components/site/Card";
import CtaBand from "@/app/components/site/CtaBand";
import FaqList from "@/app/components/site/FaqList";
import Marquee from "@/app/components/site/Marquee";
import { Reveal } from "@/app/components/site/motion";
import PageHero from "@/app/components/site/PageHero";
import RingVisual from "@/app/components/site/RingVisual";
import SectionHeading from "@/app/components/site/SectionHeading";
import s from "@/app/components/site/site.module.css";
import StepList from "@/app/components/site/StepList";
import TextLink from "@/app/components/site/TextLink";
import { HOW_IT_WORKS_FAQ } from "@/app/content/faq";

export const metadata: Metadata = {
	title: "How it works",
	description: "Order groceries, fresh meat and catering from independent stores near you in five simple steps — delivery or pickup, with every fee shown upfront.",
};

export default function HowItWorksPage() {
	return (
		<>
			<PageHero
				crumbs={[{ label: "Home", href: "/" }, { label: "How it works" }]}
				title="From local shelves *to your door.*"
				sub="Order groceries, fresh meat and catering from independent stores near you — in five simple steps."
				produce={[
					{ name: "vine-tomato", style: { left: "7%", top: 150, width: "clamp(80px,9vw,140px)" }, py: -200, pr: -30, delay: 0.6 },
					{ name: "lime", style: { left: "14%", bottom: 120, width: 110 }, py: -120, pr: 30, delay: 0.8, bob: 2, hideMobile: true },
					{ name: "yellow-bell-pepper", style: { right: "7%", top: 170, width: "clamp(80px,9vw,140px)" }, py: -220, pr: 35, delay: 0.7, bob: 3 },
					{ name: "kiwi", style: { right: "15%", bottom: 110, width: 100 }, py: -100, pr: -25, delay: 0.9, hideMobile: true },
				]}
			>
				<div className={s.heroCta}>
					<ButtonLink href="/" tone="white" arrow>
						Start shopping
					</ButtonLink>
					<ButtonLink href="/help" tone="line">
						Read the FAQ
					</ButtonLink>
				</div>
			</PageHero>

			<section className={s.sec}>
				<div className={s.wrap}>
					<SectionHeading eyebrow="For customers" title="Five steps to a *fuller fridge*" />
					<StepList
						steps={[
							{ title: "Find a store", body: "Browse local grocers, halal butchers and caterers delivering to your suburb. Search for products or filter by category — meat, rice and grains, spices and more.", produce: "cabbage" },
							{ title: "Fill your basket", body: 'Choose options like cut type (curry cut, mince, boneless) and weight (500 g, 1 kg, 2 kg or custom), and add notes such as "small pieces".', produce: "mango" },
							{ title: "See your total upfront", body: "Choose delivery or pickup, and standard or priority delivery where available. Every fee is shown at checkout before you pay — no surprises.", produce: "lemon" },
							{ title: "Pay securely", body: "For weight-priced items like fresh meat and fish, you're charged for the exact weight packed — any difference from the estimate is released automatically.", produce: "red-bell-pepper" },
							{ title: "Track it live", body: 'Follow your courier in the app, chat or call them, and add a tip before or after delivery. Choose "leave at door" if you won\'t be home.', produce: "avocado" },
						]}
					/>
				</div>
			</section>

			<Marquee items={["Browse local stores", "Choose your cut", "See fees upfront", "Track live", "Delivery or pickup"]} />

			<section className={s.sec}>
				<div className={s.wrap}>
					<SectionHeading eyebrow="Your choice" title="Delivery *or* pickup" />
					<div className={s.grid2}>
						<Card tone="green" icon="truck" title="Delivery" produce="watermelon" minHeight={320}>
							<p>Delivered by trusted courier partners — currently Uber Direct and DoorDash Drive — to selected Melbourne suburbs. Add a unit number and delivery instructions at checkout.</p>
						</Card>
						<Card tone="black" icon="store" title="Pickup" produce="banana" minHeight={320} delay={0.1}>
							<p>Prefer to collect? Choose pickup at checkout where the store supports it, and grab your order when it&apos;s ready.</p>
						</Card>
					</div>
				</div>
			</section>

			<section className={`${s.sec} ${s.secGrey}`}>
				<div className={`${s.wrap} ${s.split}`}>
					<div>
						<SectionHeading
							align="left"
							eyebrow="Catering"
							title="Planning an event? *We've got you.*"
							lede="Catering orders work a little differently — the caterer prepares a quote for you first."
						/>
						<Reveal>
							<ul className={s.check}>
								<li>Tell us the date, guest count and dietary needs</li>
								<li>The caterer sends you a quote</li>
								<li>Pay a deposit to confirm</li>
								<li>Your food arrives on the day</li>
							</ul>
							<div style={{ marginTop: 32 }}>
								<ButtonLink href="/catering" arrow>
									Explore catering
								</ButtonLink>
							</div>
						</Reveal>
					</div>
					<RingVisual
						rings={[360, 240]}
						main={{ name: "pomegranate", width: 200 }}
						items={[
							{ name: "orange", width: 110, style: { left: "14%", top: "18%" } },
							{ name: "pink-lady", width: 120, style: { right: "12%", bottom: "14%" }, bob: 3 },
						]}
					/>
				</div>
			</section>

			<section className={s.sec}>
				<div className={s.narrow}>
					<SectionHeading eyebrow="Quick answers" title="Common *questions*" />
					<FaqList items={HOW_IT_WORKS_FAQ} openFirst />
					<p className={`${s.center} ${s.faqMore}`}>
						<TextLink href="/help">See all FAQs →</TextLink>
					</p>
				</div>
			</section>

			<CtaBand title="Ready when *you are.*" text="Your favourite local stores, a few taps away.">
				<ButtonLink href="/" tone="white">
					Start shopping
				</ButtonLink>
				<ButtonLink href="/#app" tone="line">
					Download the app
				</ButtonLink>
			</CtaBand>
		</>
	);
}
