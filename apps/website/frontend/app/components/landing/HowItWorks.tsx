import s from "./landing.module.css";
import { Grocery } from "./GroceryArt";
import { cx, Eyebrow, TruckIcon, vars } from "./shared";

function StoreIcon() {
	return (
		<svg width="30" height="30" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth={2} strokeLinecap="round" strokeLinejoin="round" aria-hidden="true">
			<path d="M3 9l1.5-5h15L21 9M3 9h18M3 9v11h18V9M9 20v-6h6v6" />
		</svg>
	);
}

function BasketIcon() {
	return (
		<svg width="30" height="30" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth={2} strokeLinecap="round" strokeLinejoin="round" aria-hidden="true">
			<path d="M5 10h14l-1.5 10h-11Z" />
			<path d="M9 10l3-6 3 6" />
		</svg>
	);
}

const STEPS = [
	{ icon: <StoreIcon />, title: "Choose a store", body: "Browse trusted grocers, butchers and bakers delivering to your area." },
	{ icon: <BasketIcon />, title: "Fill your basket", body: "Pick fresh produce, cuts and pantry staples in a few taps.", art: true },
	{ icon: <TruckIcon />, title: "Delivered to your door", body: "Sit back while your order is packed fresh and brought to you." },
];

// On wide screens the section is pinned and the cards slide in as you scroll through it
export default function HowItWorks() {
	return (
		<section className={s.steps} id="how">
			<div className={s.stepsPin}>
				<div className={s.wrap}>
					<div className={s.center}>
						<Eyebrow>How it works</Eyebrow>
						<h2 className={s.h2}>
							Groceries in <span className={cx(s.serif, s.hl)}>three simple steps</span>
						</h2>
					</div>
					<div className={s.stepsRow}>
						{STEPS.map((step, i) => (
							<div key={step.title} className={s.step} data-reveal="right" style={vars({ "--rd": `${i * 0.15}s` })}>
								<span className={s.sico} style={{ animationDelay: `${i * 0.4}s` }}>
									{step.icon}
								</span>
								<div className={s.num}>{i + 1}</div>
								<div>
									<h3>{step.title}</h3>
									<p>{step.body}</p>
								</div>
								{step.art && <Grocery name="rice" className={s.simg} />}
							</div>
						))}
					</div>
					<div className={s.bar}>
						<span />
					</div>
				</div>
			</div>
		</section>
	);
}
