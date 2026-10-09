import Image from "next/image";
import Link from "next/link";
import s from "./landing.module.css";
import { ArrowIcon, cx, Eyebrow } from "./shared";

function MeatCollage() {
	return (
		<div className={s.collage} aria-hidden="true">
			<div className={s.collageMain}>
				<Image src="/images/lahore meat and groceries.jpg" alt="" fill sizes="(max-width: 960px) 90vw, 520px" className={s.coverImg} />
			</div>
			<div className={cx(s.collageSide, s.bob3)}>
				<Image src="/images/bengal fresh butchery.jpg" alt="" fill sizes="200px" className={s.coverImg} />
			</div>
			<div className={cx(s.ping, s.bob)}>
				<span className={s.pingDot} />
				New order received
			</div>
			<div className={cx(s.orderPing, s.bob2)}>
				<small>Order #1042</small>
				<b>Lamb, curry cut · 2 kg</b>
				<span>Ready for pickup in 20 min</span>
			</div>
		</div>
	);
}

export default function PartnerCTA() {
	return (
		<section className={s.sec} id="partner">
			<div className={s.wrap}>
				<div className={cx(s.partner, s.zoom)} data-reveal="zoom">
					<div>
						<Eyebrow>For businesses</Eyebrow>
						<h2 className={s.h2}>
							Own a grocery or meat shop? <span className={s.serif}>Grow with us.</span>
						</h2>
						<p className={s.lede}>List your store, reach new customers nearby and manage every order from one simple dashboard.</p>
						<Link className={cx(s.textLink, s.textLinkLight)} href="/partner-with-us">
							Partner with Grocerra
							<ArrowIcon />
						</Link>
					</div>
					<MeatCollage />
				</div>
			</div>
		</section>
	);
}
