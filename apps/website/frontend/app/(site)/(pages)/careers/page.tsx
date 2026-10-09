import type { Metadata } from "next";
import Card from "@/app/components/site/Card";
import { Icon } from "@/app/components/site/icons";
import { Reveal } from "@/app/components/site/motion";
import PageHero from "@/app/components/site/PageHero";
import SectionHeading from "@/app/components/site/SectionHeading";
import s from "@/app/components/site/site.module.css";
import { Ph } from "@/app/components/site/text";

export const metadata: Metadata = {
	title: "Careers",
	description: "Join a small team helping local food businesses thrive online.",
};

// Placeholder roles until real openings are published; each links nowhere yet
const ROLES = [
	{ title: "[Role title]", meta: "[Team] · Melbourne · [Full-time]" },
	{ title: "[Role title]", meta: "[Team] · Melbourne · [Part-time]" },
	{ title: "[Role title]", meta: "[Team] · Remote · [Contract]" },
];

export default function CareersPage() {
	return (
		<>
			<PageHero
				small
				crumbs={[{ label: "Home", href: "/" }, { label: "Careers" }]}
				title="Help us build *something fresh.*"
				sub="We're a small team helping local food businesses thrive online."
				produce={[
					{ name: "carrots", style: { left: "7%", top: 130, width: "clamp(80px,9vw,130px)" }, py: -180, pr: -30, delay: 0.6 },
					{ name: "pink-lady", style: { right: "7%", top: 140, width: "clamp(80px,9vw,130px)" }, py: -200, pr: 30, delay: 0.75, bob: 2 },
				]}
			/>

			<section className={s.sec}>
				<div className={s.wrap}>
					<SectionHeading eyebrow="Why join us" title="Work that *feeds people*" />
					<div className={s.grid3}>
						<Card tone="green" title="Real impact">
							<p>Your work helps independent stores reach new customers every day.</p>
						</Card>
						<Card title="Small team, big ownership" delay={0.08}>
							<p>Shape the product and see your ideas ship quickly.</p>
						</Card>
						<Card tone="black" title="Rooted in community" delay={0.16}>
							<p>Build for the neighbourhoods and food cultures you care about.</p>
						</Card>
					</div>
				</div>
			</section>

			<section className={`${s.sec} ${s.secGrey}`}>
				<div className={s.narrow}>
					<SectionHeading eyebrow="Open roles" title="Current *openings*" />
					<ul style={{ listStyle: "none", margin: 0, padding: 0 }}>
						{ROLES.map((role, i) => (
							<Reveal as="li" key={i} className={s.roleItem}>
								<a className={s.role} href="#">
									<div>
										<h3>{role.title}</h3>
										<p>{role.meta}</p>
									</div>
									<span className={s.go}>
										<Icon name="arrow" size={20} strokeWidth={2.4} />
									</span>
								</a>
							</Reveal>
						))}
					</ul>
					<p className={`${s.center} ${s.muted} ${s.note}`}>
						Don&apos;t see your role? Send your CV to <Ph>[careers email]</Ph>.
					</p>
				</div>
			</section>

			<section className={s.sec}>
				<div className={`${s.wrap} ${s.grid2}`}>
					<Card tone="tint" title="How to apply" reveal="left">
						<p>
							Choose a role, send your CV and a short note about why you&apos;d like to join. We&apos;ll reply within <Ph>[x business days]</Ph>.
						</p>
					</Card>
					<Card title="Equal opportunity" reveal="right">
						<p>We welcome applicants of every background, culture, gender, age and ability, and we&apos;re happy to make adjustments during the hiring process.</p>
					</Card>
				</div>
			</section>
		</>
	);
}
