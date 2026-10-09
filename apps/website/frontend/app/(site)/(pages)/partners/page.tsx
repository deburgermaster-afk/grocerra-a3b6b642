import type { Metadata } from "next";
import ButtonLink from "@/app/components/site/Button";
import Card from "@/app/components/site/Card";
import FaqList from "@/app/components/site/FaqList";
import { FormButton, FormCard, SelectField, TextField } from "@/app/components/site/Form";
import Marquee from "@/app/components/site/Marquee";
import { Reveal } from "@/app/components/site/motion";
import PageHero from "@/app/components/site/PageHero";
import RingVisual from "@/app/components/site/RingVisual";
import SectionHeading from "@/app/components/site/SectionHeading";
import s from "@/app/components/site/site.module.css";
import StepList from "@/app/components/site/StepList";
import { Ph } from "@/app/components/site/text";
import { PARTNER_FAQ } from "@/app/content/faq";

export const metadata: Metadata = {
	title: "Partner with us",
	description: "For independent grocers, halal butchers and caterers: reach new customers nearby while Grocerra handles ordering, payments and delivery.",
};

export default function PartnersPage() {
	return (
		<>
			<PageHero
				crumbs={[{ label: "Home", href: "/" }, { label: "Partner with us" }]}
				title="Grow your store *with Grocerra.*"
				sub="For independent grocers, halal butchers and caterers. Reach new customers nearby — we'll handle ordering, payments and delivery."
				produce={[
					{ name: "banana", style: { left: "6%", top: 150, width: "clamp(80px,10vw,150px)" }, py: -220, pr: -30, delay: 0.6 },
					{ name: "cabbage", style: { right: "6%", top: 150, width: "clamp(80px,10vw,150px)" }, py: -220, pr: 30, delay: 0.75, bob: 2 },
					{ name: "yellow-onion", style: { left: "16%", bottom: 100, width: 100 }, py: -100, pr: 20, delay: 0.9, bob: 3, hideMobile: true },
				]}
			>
				<div className={s.heroCta}>
					<ButtonLink href="#apply" tone="white" arrow>
						Apply now
					</ButtonLink>
					<ButtonLink href="#requirements" tone="line">
						See requirements
					</ButtonLink>
				</div>
			</PageHero>

			<section className={s.sec}>
				<div className={s.wrap}>
					<SectionHeading eyebrow="Why Grocerra" title="Everything you need *to sell online*" />
					<div className={s.grid4}>
						<Card tone="green" icon="users" title="New customers">
							<p>Get discovered by shoppers in your area looking for exactly what you sell.</p>
						</Card>
						<Card icon="truck" title="Delivery handled" delay={0.08}>
							<p>Courier partners collect from your store and deliver to the customer.</p>
						</Card>
						<Card tone="black" icon="dashboard" title="Order dashboard" delay={0.16}>
							<p>Manage products, stock and incoming orders in one simple place.</p>
						</Card>
						<Card tone="tint" icon="payout" title="Regular payouts" delay={0.24}>
							<p>
								Get paid <Ph>[payout schedule]</Ph> straight to your bank account.
							</p>
						</Card>
					</div>
				</div>
			</section>

			<Marquee items={["Grocery stores", "Halal butchers", "Caterers", "Home chefs", "Bakeries"]} />

			<section className={s.sec}>
				<div className={s.wrap}>
					<SectionHeading eyebrow="Getting started" title="Live in *four steps*" />
					<StepList
						steps={[
							{ title: "Apply", body: "Tell us about your business — it takes a few minutes.", produce: "yellow-bell-pepper" },
							{ title: "Get verified", body: "We check your ABN, food business registration and insurance.", produce: "kiwi" },
							{ title: "Set up your store", body: "Add products, prices, options like cuts and weights, and allergen information.", produce: "carrots" },
							{ title: "Start selling", body: "Accept orders, pack them fresh and hand them to the courier.", produce: "orange" },
						]}
					/>
				</div>
			</section>

			<section className={`${s.sec} ${s.secGrey}`} id="requirements">
				<div className={`${s.wrap} ${s.split}`}>
					<div>
						<SectionHeading align="left" eyebrow="Requirements" title="What you'll *need*" lede="Have these ready to speed up your application." />
						<Reveal>
							<ul className={s.check}>
								<li>An active ABN</li>
								<li>Your GST registration status</li>
								<li>Food business registration with your local council</li>
								<li>Current public liability insurance</li>
								<li>Packaging that meets our standards</li>
								<li>Product labelling, ingredient and allergen information</li>
							</ul>
						</Reveal>
					</div>
					<RingVisual
						tone="green"
						rings={[380, 250]}
						minHeight={460}
						main={{ name: "cabbage", width: 220 }}
						items={[
							{ name: "red-bell-pepper", width: 110, style: { left: "12%", top: "14%" } },
							{ name: "garlic", width: 120, style: { right: "12%", bottom: "12%" }, bob: 3 },
						]}
					/>
				</div>
			</section>

			<section className={s.sec} id="faq">
				<div className={s.narrow}>
					<SectionHeading eyebrow="Partner FAQ" title="Questions from *store owners*" />
					<FaqList items={PARTNER_FAQ} openFirst />
				</div>
			</section>

			<section className={`${s.sec} ${s.secGrey}`} id="apply">
				<div className={`${s.wrap} ${s.split} ${s.splitTop}`}>
					<div>
						<SectionHeading
							align="left"
							eyebrow="Apply"
							title="Join *Grocerra*"
							lede={
								<>
									Start your application and our partner team will be in touch within <Ph>[x business days]</Ph>.
								</>
							}
						/>
						<Reveal as="p" className={s.muted}>
							<span style={{ display: "block", marginTop: 22, fontSize: 15 }}>
								Approved partners sign our Merchant Terms <Ph>[link once drafted]</Ph>.
							</span>
						</Reveal>
					</div>
					<FormCard label="Partner application">
						<TextField id="p-name" label="Business name" />
						<TextField id="p-abn" label="ABN" inputMode="numeric" />
						<TextField id="p-addr" label="Store address" placeholder="Street, suburb, postcode" full />
						<TextField id="p-contact" label="Contact name" />
						<TextField id="p-phone" label="Phone" type="tel" />
						<TextField id="p-email" label="Email" type="email" />
						<SelectField id="p-type" label="Store type" options={["Grocery store", "Halal butcher", "Caterer", "Home chef", "Bakery / sweets", "Other"]} />
						<FormButton>Start application</FormButton>
					</FormCard>
				</div>
			</section>
		</>
	);
}
