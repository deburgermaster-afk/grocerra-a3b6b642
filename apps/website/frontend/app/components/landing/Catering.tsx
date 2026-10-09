import Link from "next/link";
import s from "./landing.module.css";
import OccasionScene from "./OccasionScene";
import { ArrowIcon, cx, Eyebrow } from "./shared";

const CHECKS = ["Bulk orders from one or several stores", "Pick a delivery date and time slot", "Fresh cuts prepared the way you like"];

function CheckIcon() {
	return (
		<svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth={3} strokeLinecap="round" strokeLinejoin="round" aria-hidden="true">
			<path d="m5 12 5 5 9-10" />
		</svg>
	);
}

export default function Catering() {
	return (
		<section className={s.sec} id="catering">
			<div className={cx(s.wrap, s.split)}>
				<div className={cx(s.card, s.zoom)} data-reveal="zoom">
					<Eyebrow>Catering</Eyebrow>
					<h2 className={s.h2}>
						Catering for <span className={cx(s.serif, s.hl)}>every occasion</span>
					</h2>
					<p className={s.lede}>From Eid dinners and birthdays to office lunches — order in bulk from your favourite stores and schedule it ahead.</p>
					<ul className={s.checks}>
						{CHECKS.map((item) => (
							<li key={item}>
								<span className={s.ck}>
									<CheckIcon />
								</span>
								{item}
							</li>
						))}
					</ul>
					<Link className={s.textLink} href="/catering">
						How catering works
						<ArrowIcon />
					</Link>
				</div>
				<OccasionScene />
			</div>
		</section>
	);
}
