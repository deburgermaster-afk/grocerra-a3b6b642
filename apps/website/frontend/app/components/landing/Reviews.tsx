import Image from "next/image";
import s from "./landing.module.css";
import { REVIEWS, type Review } from "./content";
import { cx, Eyebrow } from "./shared";

const AVATAR_TONES = [s.avGreen, s.avYellow, s.avBlack, s.avMint];

const initials = (name: string) =>
	name
		.split(" ")
		.map((part) => part[0])
		.slice(0, 2)
		.join("");

function Stars() {
	return (
		<div className={s.stars} aria-label="Rated 5 out of 5">
			{Array.from({ length: 5 }, (_, i) => (
				<svg key={i} width="16" height="16" viewBox="0 0 24 24" fill="currentColor" aria-hidden="true">
					<path d="M12 2.5l2.9 6.1 6.6.8-4.9 4.6 1.3 6.6L12 17.3 6.1 20.6l1.3-6.6L2.5 9.4l6.6-.8z" />
				</svg>
			))}
		</div>
	);
}

function ReviewCard({ review, index, duplicate }: { review: Review; index: number; duplicate?: boolean }) {
	return (
		<figure className={s.review} aria-hidden={duplicate || undefined}>
			<div className={s.reviewTop}>
				<Stars />
				<svg className={s.quoteMark} width="34" height="34" viewBox="0 0 24 24" fill="currentColor" aria-hidden="true">
					<path d="M9.6 6C6.4 7.3 4 10.3 4 14v4h6v-6H7.2c.2-2 1.5-3.6 3.4-4.5zm9 0c-3.2 1.3-5.6 4.3-5.6 8v4h6v-6h-2.8c.2-2 1.5-3.6 3.4-4.5z" />
				</svg>
			</div>
			<blockquote className={s.reviewQuote}>{review.quote}</blockquote>
			<span className={s.reviewTag}>Ordered: {review.ordered}</span>
			<figcaption className={s.who}>
				{review.photo ? (
					<Image src={review.photo} alt="" width={48} height={48} className={s.avatar} />
				) : (
					<span className={cx(s.avatar, AVATAR_TONES[index % AVATAR_TONES.length])} aria-hidden="true">
						{initials(review.name)}
					</span>
				)}
				<span className={s.whoText}>
					<b>{review.name}</b>
					<span>{review.location}</span>
					<span className={s.country}>
						<i>{review.countryCode}</i>
						{review.country}
					</span>
				</span>
			</figcaption>
		</figure>
	);
}

function Row({ reviews, offset, reverse }: { reviews: Review[]; offset: number; reverse?: boolean }) {
	return (
		<div className={s.rvWrap}>
			{/* Second copy is hidden from screen readers; it only makes the marquee loop */}
			<div className={cx(s.rvTrack, reverse && s.rev)}>
				{reviews.map((r, i) => (
					<ReviewCard key={r.name} review={r} index={i + offset} />
				))}
				{reviews.map((r, i) => (
					<ReviewCard key={`dup-${r.name}`} review={r} index={i + offset} duplicate />
				))}
			</div>
		</div>
	);
}

export default function Reviews() {
	const half = Math.ceil(REVIEWS.length / 2);
	return (
		<section className={s.sec} id="reviews">
			<div className={cx(s.wrap, s.center)}>
				<Eyebrow reveal>Community</Eyebrow>
				<h2 className={cx(s.h2, s.reveal)} data-reveal="up">
					Loved by <span className={cx(s.serif, s.hl)}>our community</span>
				</h2>
				<p className={cx(s.lede, s.reveal)} data-reveal="up">
					Families from every corner of the world, shopping the local stores that taste like home.
				</p>
			</div>
			<div className={s.rvRows}>
				<Row reviews={REVIEWS.slice(0, half)} offset={0} />
				<Row reviews={REVIEWS.slice(half)} offset={1} reverse />
			</div>
		</section>
	);
}
