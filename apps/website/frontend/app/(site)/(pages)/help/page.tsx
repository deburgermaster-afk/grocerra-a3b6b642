import type { Metadata } from "next";
import ButtonLink from "@/app/components/site/Button";
import CtaBand from "@/app/components/site/CtaBand";
import { cx } from "@/app/components/site/cx";
import FaqList from "@/app/components/site/FaqList";
import { Icon } from "@/app/components/site/icons";
import { Reveal } from "@/app/components/site/motion";
import PageHero from "@/app/components/site/PageHero";
import s from "@/app/components/site/site.module.css";
import { HELP_FAQ } from "@/app/content/faq";
import { COMPANY } from "@/app/content/site";

export const metadata: Metadata = {
	title: "Help centre & FAQ",
	description: "Answers about orders, payments and fees, delivery, your account, catering and allergens.",
};

export default function HelpPage() {
	return (
		<>
			<PageHero
				crumbs={[{ label: "Home", href: "/" }, { label: "Help centre" }]}
				title="How can we *help?*"
				produce={[
					{ name: "lime", style: { left: "7%", top: 150, width: "clamp(80px,9vw,140px)" }, py: -200, pr: -30, delay: 0.6 },
					{ name: "pink-lady", style: { right: "7%", top: 160, width: "clamp(80px,9vw,140px)" }, py: -220, pr: 30, delay: 0.75, bob: 2 },
				]}
			>
				{/* Search is a preview only until help content is searchable */}
				<div className={s.search} role="search" aria-label="Search the help centre">
					<Icon name="search" size={20} strokeWidth={2.4} />
					<label htmlFor="help-q" className="sr-only">
						Search for answers
					</label>
					<input id="help-q" type="search" placeholder="Search for answers — e.g. refund, delivery fee" />
					<button type="button" className={cx(s.btn, s.btnGreen, s.btnSm)}>
						Search
					</button>
				</div>
			</PageHero>

			<section className={s.secTight}>
				<div className={cx(s.wrap, s.topics)}>
					{HELP_FAQ.map((group, i) => (
						<Reveal key={group.id} variant="zoom" delay={i * 0.08} className={s.cell}>
							<a className={s.topic} href={`#${group.id}`}>
								<span className={s.topicIco}>
									<Icon name={group.icon} size={22} />
								</span>
								{group.title}
								<small>{group.blurb}</small>
							</a>
						</Reveal>
					))}
				</div>
			</section>

			<section className={s.sec} style={{ paddingTop: 30 }}>
				<div className={s.narrow}>
					{HELP_FAQ.map((group) => (
						<div key={group.id} id={group.id} className={s.faqGroup}>
							<Reveal>
								<h2 className={s.faqGroupTitle}>
									<span>
										<Icon name={group.icon} size={20} strokeWidth={2.2} />
									</span>
									{group.title}
								</h2>
							</Reveal>
							<FaqList items={group.items} openFirst={group.id === "orders"} />
						</div>
					))}
				</div>
			</section>

			<CtaBand title="Still need *help?*" text="Our support team can help with any order, delivery, refund or account question.">
				<ButtonLink href="/contact" tone="white">
					Contact support
				</ButtonLink>
				<ButtonLink href={`mailto:${COMPANY.email}`} tone="line">
					{COMPANY.email}
				</ButtonLink>
			</CtaBand>
		</>
	);
}
