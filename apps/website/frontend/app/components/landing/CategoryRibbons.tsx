import s from "./landing.module.css";
import { cx } from "./shared";

const CATEGORIES = ["Fruits & vegetables", "Fresh meat", "Poultry", "Dairy & eggs", "Bakery", "Pantry staples"];
const PROMISES = ["Packed fresh", "Local stores", "One basket", "To your door"];

function Sparkle() {
	return (
		<svg width="22" height="22" viewBox="0 0 24 24" fill="currentColor">
			<path d="M12 0l2.6 9.4L24 12l-9.4 2.6L12 24l-2.6-9.4L0 12l9.4-2.6Z" />
		</svg>
	);
}

function Dot() {
	return (
		<svg width="20" height="20" viewBox="0 0 24 24" className="fill-grocerra-yellow">
			<circle cx="12" cy="12" r="6" />
		</svg>
	);
}

// Each list is rendered twice so the -50% marquee loops seamlessly
export default function CategoryRibbons() {
	return (
		<div className={s.ribbons} aria-hidden="true">
			<div className={cx(s.ribbon, s.r1)}>
				<div className={s.track}>
					{[...CATEGORIES, ...CATEGORIES].map((label, i) => (
						<span key={i}>
							{label} <Sparkle />
						</span>
					))}
				</div>
			</div>
			<div className={cx(s.ribbon, s.r2)}>
				<div className={cx(s.track, s.rev)}>
					{[...PROMISES, ...PROMISES].map((label, i) => (
						<span key={i}>
							{label} <Dot />
						</span>
					))}
				</div>
			</div>
		</div>
	);
}
