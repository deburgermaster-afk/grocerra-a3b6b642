import type { ReactNode } from "react";
import { Reveal } from "./motion";
import s from "./site.module.css";
import { Title } from "./text";

/** Green rounded call-to-action band. Title accent words (*starred*) get the yellow underline. */
export default function CtaBand({ title, text, children, tightTop = true }: { title: string; text: string; children: ReactNode; tightTop?: boolean }) {
	return (
		<section className={s.secTight} style={tightTop ? { paddingTop: 0 } : undefined}>
			<div className={s.wrap}>
				<Reveal variant="zoom">
					<div className={s.cta}>
						<h2 className={s.h2}>
							<Title text={title} accent="mark" />
						</h2>
						<p>{text}</p>
						<div className={s.heroCta} style={{ marginTop: 0 }}>
							{children}
						</div>
					</div>
				</Reveal>
			</div>
		</section>
	);
}
