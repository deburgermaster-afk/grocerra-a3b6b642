import s from "./landing.module.css";
import { Grocery, type GroceryName } from "./GroceryArt";
import { vars } from "./shared";

// --fx / --fy: where each item flies in from as the green panel opens
const FLYERS: { name: GroceryName; style: Record<string, string | number> }[] = [
	{ name: "bread", style: { left: "7%", top: "13%", "--fx": "300px", "--fy": "200px" } },
	{ name: "milk", style: { right: "10%", top: "12%", width: "clamp(60px,7vw,110px)", "--fx": "-300px", "--fy": "200px" } },
	{ name: "rice", style: { left: "11%", bottom: "11%", width: "clamp(80px,9vw,140px)", "--fx": "300px", "--fy": "-200px" } },
	{ name: "meat", style: { right: "9%", bottom: "13%", "--fx": "-300px", "--fy": "-200px" } },
];

export default function ColourWipe() {
	return (
		<section className={s.wipe} aria-label="From their shelves to your table">
			<div className={s.wipePin}>
				<div className={s.wipePanel}>
					{FLYERS.map((f) => (
						<div key={f.name} className={s.wfly} style={vars(f.style)}>
							<Grocery name={f.name} />
						</div>
					))}
					<p className={s.wipeText} data-reveal="zoom">
						From their shelves
						<br />
						to <span className={s.serif}>your table.</span>
						<span className={s.wipeSub}>Local stores. Fresh food. One tap away.</span>
					</p>
				</div>
			</div>
		</section>
	);
}
