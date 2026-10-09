import type { Metadata } from "next";
import ButtonLink from "@/app/components/site/Button";
import Card from "@/app/components/site/Card";
import { CheckGroup, FormButton, FormCard, SelectField, TextAreaField, TextField } from "@/app/components/site/Form";
import { Reveal } from "@/app/components/site/motion";
import PageHero from "@/app/components/site/PageHero";
import SectionHeading from "@/app/components/site/SectionHeading";
import s from "@/app/components/site/site.module.css";
import StepList from "@/app/components/site/StepList";
import TextLink from "@/app/components/site/TextLink";
import type { ProduceName } from "@/app/components/site/Produce";
import type { CardTone } from "@/app/components/site/Card";

export const metadata: Metadata = {
	title: "Catering",
	description: "Weddings, festivals, office lunches and community events — request a quote from trusted local caterers in Melbourne.",
};

const OCCASIONS: { title: string; body: string; tone: CardTone; produce: ProduceName }[] = [
	{ title: "Weddings", body: "Feed every guest, from mehndi night to the reception.", tone: "green", produce: "pomegranate" },
	{ title: "Eid & Diwali", body: "Festival feasts and sweets for family and friends.", tone: "tint", produce: "mango" },
	{ title: "Corporate", body: "Office lunches, launches and team celebrations.", tone: "black", produce: "red-bell-pepper" },
	{ title: "Community events", body: "Fundraisers, gatherings and cultural events.", tone: "tint", produce: "vine-tomato" },
	{ title: "Family gatherings", body: "Birthdays, anniversaries and Sunday get-togethers.", tone: "white", produce: "orange" },
	{ title: "Something else?", body: "Tell us about your event and we'll find the right caterer.", tone: "green", produce: "lime" },
];

const GOOD_TO_KNOW: { pill: string; value: string; body: string; tone: CardTone }[] = [
	{ pill: "Lead time", value: "[x] days", body: "Minimum notice before your event date.", tone: "white" },
	{ pill: "Minimum guests", value: "[x] guests", body: "The smallest event most caterers take on.", tone: "green" },
	{ pill: "Packages from", value: "$[x] / guest", body: "Final price depends on the caterer and menu.", tone: "white" },
];

export default function CateringPage() {
	return (
		<>
			<PageHero
				crumbs={[{ label: "Home", href: "/" }, { label: "Catering" }]}
				title="Catering for *every occasion.*"
				sub="Weddings, festivals, office lunches and community events — catered by trusted local caterers."
				produce={[
					{ name: "watermelon", style: { left: "5%", top: 150, width: "clamp(90px,11vw,170px)" }, py: -230, pr: -30, delay: 0.6 },
					{ name: "pomegranate", style: { right: "6%", top: 160, width: "clamp(80px,10vw,150px)" }, py: -210, pr: 35, delay: 0.75, bob: 2 },
					{ name: "brown-cap-mushroom", style: { left: "15%", bottom: 100, width: 110 }, py: -120, pr: 20, delay: 0.9, bob: 3, hideMobile: true },
					{ name: "mango", style: { right: "16%", bottom: 100, width: 110 }, py: -120, pr: -20, delay: 1, hideMobile: true },
				]}
			>
				<div className={s.heroCta}>
					<ButtonLink href="#quote" tone="white" arrow>
						Request a quote
					</ButtonLink>
					<ButtonLink href="#how" tone="line">
						How catering works
					</ButtonLink>
				</div>
			</PageHero>

			<section className={s.sec}>
				<div className={s.wrap}>
					<SectionHeading eyebrow="Occasions" title="Whatever you're *celebrating*" />
					<div className={s.grid3}>
						{OCCASIONS.map((o, i) => (
							<Card key={o.title} tone={o.tone} title={o.title} produce={o.produce} minHeight={240} delay={(i % 3) * 0.08}>
								<p>{o.body}</p>
							</Card>
						))}
					</div>
				</div>
			</section>

			<section className={`${s.sec} ${s.secGrey}`} id="how">
				<div className={s.wrap}>
					<SectionHeading eyebrow="How it works" title="Four steps to a *full table*" />
					<StepList
						steps={[
							{ title: "Request a quote", body: "Share your event date, guest count, budget and dietary needs.", produce: "lemon" },
							{ title: "Get your quote", body: "The caterer prepares a quote for your event. Review it and ask questions before you commit.", produce: "pink-lady" },
							{ title: "Pay a deposit", body: "Confirm your booking with a deposit. The amount is shown before you pay.", produce: "ginger" },
							{ title: "Enjoy the day", body: "Your food is prepared and delivered for your event.", produce: "watermelon" },
						]}
					/>
				</div>
			</section>

			<section className={s.sec}>
				<div className={s.wrap}>
					<SectionHeading eyebrow="Packages" title="Good to *know*" />
					<div className={s.grid3}>
						{GOOD_TO_KNOW.map((g, i) => (
							<Card key={g.pill} tone={g.tone} reveal="up" delay={i * 0.08}>
								<div className={s.pill}>{g.pill}</div>
								<h3 className={`${s.h3} ${s.statBig}`}>{g.value}</h3>
								<p>{g.body}</p>
							</Card>
						))}
					</div>
				</div>
			</section>

			<section className={`${s.sec} ${s.secGrey}`} id="quote">
				<div className={`${s.wrap} ${s.split} ${s.splitTop}`}>
					<div>
						<SectionHeading
							align="left"
							eyebrow="Request a quote"
							title="Tell us about *your event*"
							lede="We'll pass your request to suitable caterers, who will reply with a quote."
						/>
						<Reveal>
							<ul className={s.check}>
								<li>Halal, vegetarian and vegan options</li>
								<li>Quotes from local caterers</li>
								<li>Deposit to confirm, balance before the event</li>
							</ul>
							<p className={s.muted} style={{ marginTop: 28, fontSize: 15 }}>
								Catering orders follow our <TextLink href="/legal/catering">Catering Terms</TextLink>.
							</p>
						</Reveal>
					</div>
					<FormCard label="Catering quote request">
						<TextField id="c-date" label="Event date" type="date" />
						<TextField id="c-guests" label="Guest count" type="number" min={1} placeholder="e.g. 80" />
						<TextField id="c-budget" label="Budget (AUD)" placeholder="e.g. $2,000" />
						<SelectField id="c-type" label="Occasion" options={["Wedding", "Eid / Diwali", "Corporate", "Community event", "Family gathering", "Other"]} />
						<CheckGroup legend="Dietary needs" name="c-diet" options={["Halal", "Vegetarian", "Vegan", "Allergies"]} checked={["Halal"]} />
						<TextField id="c-addr" label="Delivery address" placeholder="Street, suburb, postcode" full />
						<TextAreaField id="c-notes" label="Notes" placeholder="Menu ideas, timing, setup…" />
						<FormButton>Request a quote</FormButton>
					</FormCard>
				</div>
			</section>
		</>
	);
}
