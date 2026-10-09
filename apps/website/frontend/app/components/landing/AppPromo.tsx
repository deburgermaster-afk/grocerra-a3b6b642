import s from "./landing.module.css";
import { Grocery } from "./GroceryArt";
import PhoneMockup from "./PhoneMockup";
import { cx, Eyebrow, StoreBadges, TruckIcon } from "./shared";

export default function AppPromo() {
	return (
		<section className={s.sec} id="app">
			<div className={s.wrap}>
				<div className={cx(s.app, s.zoom)} data-reveal="zoom">
					<div className={cx(s.orb, s.orbLg)} />
					<div className={cx(s.orb, s.orbSm)} />
					<div className={s.appCopy}>
						<Eyebrow>Mobile app</Eyebrow>
						<h2 className={s.h2}>
							Get the app. <span className={s.serif}>Order faster.</span>
						</h2>
						<p className={s.lede}>Reorder favourites, follow your delivery and get store offers — all from your pocket.</p>
						<StoreBadges />
					</div>
					<div className={s.phoneStage} aria-hidden="true">
						<div className={cx(s.fl, s.hideM)} style={{ left: "2%", top: 60, width: 110, zIndex: 3 }}>
							<Grocery name="rice" className={s.bob} />
						</div>
						<div className={cx(s.fl, s.hideM)} style={{ right: "6%", bottom: 50, width: 80, zIndex: 3 }}>
							<Grocery name="milk" className={s.bob2} />
						</div>
						<div className={s.notif}>
							<div className={s.notifIc}>
								<TruckIcon size={20} strokeWidth={2.2} />
							</div>
							<div>
								<b>Your order is on its way</b>
								<br />
								<span className={s.notifSub}>Arriving soon</span>
							</div>
						</div>
						<PhoneMockup />
					</div>
				</div>
			</div>
		</section>
	);
}
