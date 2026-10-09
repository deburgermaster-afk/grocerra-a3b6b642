import type { Metadata } from "next";
import Card from "@/app/components/site/Card";
import { cx } from "@/app/components/site/cx";
import Marquee from "@/app/components/site/Marquee";
import { Reveal } from "@/app/components/site/motion";
import PageHero from "@/app/components/site/PageHero";
import PriceBars from "@/app/components/site/PriceBars";
import SectionHeading from "@/app/components/site/SectionHeading";
import s from "@/app/components/site/site.module.css";
import { Ph } from "@/app/components/site/text";
import TextLink from "@/app/components/site/TextLink";
import type { CardTone } from "@/app/components/site/Card";

export const metadata: Metadata = {
	title: "Delivery & fees",
	description: "Every fee is shown at checkout before you pay. See how item prices, the 3.5% platform fee, delivery fees and weight-priced items work.",
};

const FEES: { pill: string; big: string; body: string; tone: CardTone }[] = [
	{ pill: "Item prices", big: "Store", body: "Set by each store, in Australian dollars.", tone: "white" },
	{ pill: "Platform fee", big: "3.5%", body: "Of the order value, excluding delivery fee, tips and GST.", tone: "green" },
	{ pill: "Delivery fee", big: "Live", body: "Quoted at checkout. Choose standard or priority where available.", tone: "black" },
	{ pill: "Tips", big: "Optional", body: "Add a tip for your courier before or after delivery.", tone: "tint" },
];

export default function DeliveryPage() {
	return (
		<>
			<PageHero
				crumbs={[{ label: "Home", href: "/" }, { label: "Delivery & fees" }]}
				title="Clear fees. *No surprises.*"
				sub="Every fee is shown at checkout before you pay. Here's exactly how pricing and delivery work."
				produce={[
					{ name: "orange", style: { left: "6%", top: 150, width: "clamp(80px,10vw,150px)" }, py: -220, pr: -30, delay: 0.6 },
					{ name: "red-bell-pepper", style: { right: "6%", top: 160, width: "clamp(80px,10vw,150px)" }, py: -220, pr: 30, delay: 0.75, bob: 2 },
				]}
			/>

			<section className={s.sec}>
				<div className={s.wrap}>
					<SectionHeading eyebrow="What you pay" title="Your total, *explained*" />
					<div className={s.grid4}>
						{FEES.map((f, i) => (
							<Card key={f.pill} tone={f.tone} delay={i * 0.08}>
								<div className={s.pill}>{f.pill}</div>
								<div className={s.feeBig}>{f.big}</div>
								<p>{f.body}</p>
							</Card>
						))}
					</div>
				</div>
			</section>

			<section className={cx(s.sec, s.secGrey)}>
				<div className={cx(s.wrap, s.split)}>
					<div>
						<SectionHeading
							align="left"
							eyebrow="Worked example"
							title="An *$80 basket*"
							lede="Here's how the platform fee is calculated. Your delivery fee is a live quote shown at checkout."
						/>
						<Reveal as="p" className={s.muted}>
							<span style={{ display: "block", fontSize: 15, marginTop: 18 }}>
								Grocerra is not currently registered for GST, so no GST is charged on platform fees. Stores may issue their own tax invoices.
							</span>
						</Reveal>
					</div>
					<Reveal variant="zoom">
						<div className={s.tableWrap}>
							<table className={s.table}>
								<thead>
									<tr>
										<th scope="col">Item</th>
										<th scope="col">Amount</th>
									</tr>
								</thead>
								<tbody>
									<tr>
										<td>Groceries from the store</td>
										<td>$80.00</td>
									</tr>
									<tr>
										<td>Platform fee (3.5% × $80.00)</td>
										<td>$2.80</td>
									</tr>
									<tr>
										<td>Delivery fee</td>
										<td>Live quote</td>
									</tr>
									<tr>
										<td>Courier tip</td>
										<td>Optional</td>
									</tr>
									<tr className={s.total}>
										<td>You pay</td>
										<td>$82.80 + delivery</td>
									</tr>
								</tbody>
							</table>
						</div>
					</Reveal>
				</div>
			</section>

			<section className={s.sec}>
				<div className={cx(s.wrap, s.split)}>
					<PriceBars
						title="1 kg lamb, curry cut"
						bars={[
							{ label: "Estimated", amount: "$20.00", percent: 83, color: "#FFFFFF" },
							{ label: "Card hold (+10%)", amount: "$22.00", percent: 92, color: "var(--yellow)" },
							{ label: "Packed 1.04 kg", amount: "$20.80", percent: 87, color: "var(--green)" },
						]}
						note="You're charged $20.80. The remaining $1.20 hold is released automatically."
					/>
					<div>
						<SectionHeading
							align="left"
							eyebrow="Weight-priced items"
							title="Pay for *exactly what's packed*"
							lede="Fresh meat and fish are charged on the exact weight packed. We may hold up to 10% above the estimated price, then charge only the final amount."
						/>
						<Reveal as="p" className={s.muted}>
							<span style={{ display: "block", fontSize: 14, marginTop: 14 }}>Example prices are for illustration only.</span>
						</Reveal>
					</div>
				</div>
			</section>

			<Marquee items={["Selected Melbourne suburbs", "Live tracking", "Standard or priority", "Leave at door", "Chat with your courier"]} />

			<section className={s.sec}>
				<div className={s.wrap}>
					<SectionHeading eyebrow="Delivery" title="How *delivery* works" />
					<div className={s.grid3}>
						<Card icon="pin" title="Delivery areas">
							<p>
								Selected Melbourne suburbs: <Ph>[list of suburbs]</Ph>. Enter your address in the app to check.
							</p>
						</Card>
						<Card tone="green" icon="truck" title="Courier partners" delay={0.08}>
							<p>Orders are delivered by Uber Direct and DoorDash Drive. Grocerra arranges delivery for you.</p>
						</Card>
						<Card tone="black" icon="clock" title="Delivery times" delay={0.16}>
							<p>Times are estimates and can change with weather, traffic, store preparation or courier availability.</p>
						</Card>
						<Card tone="tint" icon="pulse" title="Live tracking">
							<p>Track your order live, chat or call your courier, and stop sharing your location any time.</p>
						</Card>
						<Card icon="door" title="Leave at door" delay={0.08}>
							<p>
								Choose &ldquo;leave at door&rdquo; and your courier may leave the order with a photo as proof. Otherwise, after 5 minutes with no answer, a return fee may apply.
							</p>
						</Card>
						<Card tone="green" icon="lock" title="Restricted items" delay={0.16}>
							<p>Age-restricted and other restricted orders are never left at the door, and must be handed over in person.</p>
						</Card>
					</div>
					<p className={s.center} style={{ marginTop: 36 }}>
						<TextLink href="/legal/delivery">Read the full Delivery &amp; Courier Policy →</TextLink>
					</p>
				</div>
			</section>
		</>
	);
}
