import type { ReactNode } from "react";
import { Reveal } from "./motion";
import Produce, { type ProduceName } from "./Produce";
import s from "./site.module.css";

export type Step = { title: string; body: ReactNode; produce: ProduceName };

/** Big numbered steps that slide in from alternating sides. */
export default function StepList({ steps }: { steps: Step[] }) {
	return (
		<ol className={s.steps} style={{ listStyle: "none", margin: 0, padding: 0 }}>
			{steps.map((step, i) => (
				<Reveal as="li" key={step.title} variant={i % 2 === 0 ? "left" : "right"}>
					<div className={s.step}>
						<div className={s.stepN} aria-hidden="true">
							{i + 1}
						</div>
						<div>
							<h3 className={s.h3}>{step.title}</h3>
							<p>{step.body}</p>
						</div>
						<div className={s.stepImg}>
							<Produce name={step.produce} sizes="130px" />
						</div>
					</div>
				</Reveal>
			))}
		</ol>
	);
}
