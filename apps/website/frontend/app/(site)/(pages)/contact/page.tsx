import type { Metadata } from "next";
import ButtonLink from "@/app/components/site/Button";
import Card from "@/app/components/site/Card";
import ContactMap from "@/app/components/site/ContactMap";
import CtaBand from "@/app/components/site/CtaBand";
import { FormButton, FormCard, SelectField, TextAreaField, TextField } from "@/app/components/site/Form";
import PageHero from "@/app/components/site/PageHero";
import s from "@/app/components/site/site.module.css";
import { Ph } from "@/app/components/site/text";
import { COMPANY } from "@/app/content/site";

export const metadata: Metadata = {
	title: "Contact us",
	description: "Questions about an order, a delivery, a refund or partnering with Grocerra — get in touch with our team.",
};

export default function ContactPage() {
	return (
		<>
			<PageHero
				small
				crumbs={[{ label: "Home", href: "/" }, { label: "Contact us" }]}
				title="We're here *to help.*"
				sub="Questions about an order, a delivery, a refund or partnering with us — reach out any time."
				produce={[
					{ name: "lemon", style: { left: "7%", top: 130, width: "clamp(80px,9vw,130px)" }, py: -180, pr: -30, delay: 0.6 },
					{ name: "kiwi", style: { right: "7%", top: 140, width: "clamp(80px,9vw,130px)" }, py: -200, pr: 30, delay: 0.75, bob: 2 },
				]}
			/>

			<section className={s.sec}>
				<div className={`${s.wrap} ${s.grid4}`}>
					<Card tone="green" icon="mail" title="Customer support">
						<p>
							<a href={`mailto:${COMPANY.email}`}>{COMPANY.email}</a>
						</p>
					</Card>
					<Card icon="storeSimple" title="Store partners" delay={0.08}>
						<p>
							<Ph>[partners email]</Ph>
						</p>
					</Card>
					<Card tone="black" icon="press" title="Media & press" delay={0.16}>
						<p>
							<Ph>[media email]</Ph>
						</p>
					</Card>
					<Card tone="tint" icon="clock" title="Support hours" delay={0.24}>
						<p>
							<Ph>[Mon–Sun, 9am–9pm AEST]</Ph>
						</p>
					</Card>
				</div>
			</section>

			<section className={`${s.sec} ${s.secGrey}`}>
				<div className={`${s.wrap} ${s.split} ${s.splitTop}`}>
					<FormCard label="Contact form" title="Send us a message" reveal="left">
						<TextField id="ct-name" label="Your name" />
						<TextField id="ct-email" label="Email" type="email" />
						<SelectField
							id="ct-topic"
							label="Topic"
							options={["An order", "Delivery", "Refund", "My account", "Catering", "Partnering with Grocerra", "Media", "Something else"]}
						/>
						<TextField id="ct-order" label="Order number (optional)" />
						<TextAreaField id="ct-msg" label="Message" />
						<FormButton>Send message</FormButton>
					</FormCard>
					<div className={s.stack}>
						<ContactMap />
						<Card tone="black" title="Postal address" reveal="right">
							<p>
								{COMPANY.operator} (trading as Grocerra)
								<br />
								ABN {COMPANY.abn}
								<br />
								PO Box 74, Village Crescent
								<br />
								Westmeadows VIC 3049, Australia
							</p>
						</Card>
					</div>
				</div>
			</section>

			<CtaBand title="Looking for a *quick answer?*" text="Most questions about orders, fees and delivery are answered in our Help centre." tightTop={false}>
				<ButtonLink href="/help" tone="white">
					Visit the Help centre
				</ButtonLink>
			</CtaBand>
		</>
	);
}
