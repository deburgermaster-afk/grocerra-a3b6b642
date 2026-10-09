import type { Metadata } from "next";
import ButtonLink from "@/app/components/site/Button";
import Card from "@/app/components/site/Card";
import Marquee from "@/app/components/site/Marquee";
import { Reveal } from "@/app/components/site/motion";
import PageHero from "@/app/components/site/PageHero";
import RingVisual from "@/app/components/site/RingVisual";
import SectionHeading from "@/app/components/site/SectionHeading";
import s from "@/app/components/site/site.module.css";
import { Ph } from "@/app/components/site/text";
import { COMPANY } from "@/app/content/site";

export const metadata: Metadata = {
	title: "About us",
	description: "Grocerra connects Melbourne households with the independent grocers, halal butchers and caterers they already love.",
};

const VALUES = [
	{ title: "Support local", body: "Every order helps an independent neighbourhood business grow.", produce: "carrots" },
	{ title: "Fresh first", body: "Fresh cuts, produce and staples, packed by the people who know them best.", produce: "pink-lady" },
	{ title: "Clear pricing", body: "Every fee is shown at checkout before you pay. No hidden extras.", produce: "lemon" },
	{ title: "Community", body: "Food for everyday meals, festivals and the moments that bring people together.", produce: "pomegranate" },
] as const;

export default function AboutPage() {
	return (
		<>
			<PageHero
				crumbs={[{ label: "Home", href: "/" }, { label: "About us" }]}
				title="Good food starts *close to home.*"
				sub="We connect Melbourne households with the independent grocers, butchers and caterers they already love."
				produce={[
					{ name: "cabbage", style: { left: "6%", top: 160, width: "clamp(80px,10vw,150px)" }, py: -220, pr: -35, delay: 0.6 },
					{ name: "orange", style: { right: "6%", top: 150, width: "clamp(80px,10vw,150px)" }, py: -240, pr: 30, delay: 0.75, bob: 2 },
					{ name: "garlic", style: { right: "16%", bottom: 100, width: 100 }, py: -110, pr: -20, delay: 0.9, bob: 3, hideMobile: true },
				]}
			/>

			<section className={s.sec}>
				<div className={`${s.wrap} ${s.split}`}>
					<div>
						<SectionHeading
							align="left"
							eyebrow="Our mission"
							title="Bring the local store *to your door.*"
							lede="Grocerra is an online marketplace that connects customers with independent grocery stores, halal butchers and caterers in selected Melbourne suburbs."
						/>
						<Reveal as="p" className={s.lede}>
							<Ph>[Founding story — 2–3 sentences from the founders on why Grocerra started.]</Ph>
						</Reveal>
					</div>
					<RingVisual
						rings={[400, 260]}
						minHeight={480}
						main={{ name: "watermelon", width: 210 }}
						items={[
							{ name: "mango", width: 120, style: { left: "10%", top: "12%" } },
							{ name: "lime", width: 100, style: { right: "10%", top: "16%" }, bob: 3 },
							{ name: "red-bell-pepper", width: 120, style: { left: "16%", bottom: "10%" }, bob: 3 },
							{ name: "vine-tomato", width: 120, style: { right: "12%", bottom: "12%" }, bob: 1 },
						]}
					/>
				</div>
			</section>

			<section className={`${s.sec} ${s.secGrey}`}>
				<div className={s.wrap}>
					<SectionHeading
						eyebrow="How we work"
						title="Three partners, *one order*"
						lede="Grocerra arranges your order and payment. We don't prepare, pack or sell the food ourselves — local businesses do."
					/>
					<div className={s.grid3}>
						<Card icon="store" title="Stores sell">
							<p>Independent grocers, halal butchers and caterers prepare and pack your order, and stand behind the food they sell.</p>
						</Card>
						<Card tone="green" icon="plusCircle" title="Grocerra connects" delay={0.08}>
							<p>We bring the stores together in one app, arrange your order and payment, and support you if anything goes wrong.</p>
						</Card>
						<Card tone="black" icon="truck" title="Couriers deliver" delay={0.16}>
							<p>Independent courier networks — currently Uber Direct and DoorDash Drive — bring your order to your door.</p>
						</Card>
					</div>
				</div>
			</section>

			<section className={s.sec}>
				<div className={s.wrap}>
					<SectionHeading eyebrow="What we value" title="What we *stand for*" />
					<div className={s.grid4}>
						{VALUES.map((v, i) => (
							<Card key={v.title} tone="tint" title={v.title} produce={v.produce} produceWidth={100} reveal="up" delay={i * 0.08}>
								<p>{v.body}</p>
							</Card>
						))}
					</div>
				</div>
			</section>

			<Marquee items={["Independent grocers", "Halal butchers", "Local caterers", "Melbourne suburbs", "One basket"]} />

			<section className={s.sec}>
				<div className={s.wrap}>
					<SectionHeading eyebrow="Our team" title="The people *behind Grocerra*" />
					<div className={s.grid4}>
						{[0, 1, 2, 3].map((i) => (
							<Card key={i} title="[Name]" center delay={i * 0.08} media={<div className={s.avatarPh} aria-hidden="true" />}>
								<p>[Role]</p>
							</Card>
						))}
					</div>
				</div>
			</section>

			<section className={s.secTight} style={{ paddingTop: 0 }}>
				<div className={`${s.wrap} ${s.grid2}`}>
					<Card tone="black" title="Company details" reveal="left">
						<p>
							Grocerra is operated by {COMPANY.operator}
							<br />
							ABN {COMPANY.abn}
							<br />
							{COMPANY.address}
							<br />
							Melbourne, Victoria, Australia
						</p>
					</Card>
					<Card tone="green" title="Get in touch" reveal="right">
						<p>Questions, partnerships or press — we&apos;d love to hear from you.</p>
						<div style={{ marginTop: 22 }}>
							<ButtonLink href="/contact" tone="white">
								Contact us
							</ButtonLink>
						</div>
					</Card>
				</div>
			</section>
		</>
	);
}
