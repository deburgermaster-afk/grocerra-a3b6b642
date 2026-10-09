import type { CSSProperties, ReactNode } from "react";
import { cx } from "./cx";
import { type IconName, Icon } from "./icons";
import { Reveal, type RevealVariant } from "./motion";
import Produce, { type ProduceName } from "./Produce";
import s from "./site.module.css";

export type CardTone = "white" | "tint" | "green" | "black";

const TONES: Record<CardTone, string | undefined> = { white: undefined, tint: s.tint, green: s.greencard, black: s.dark };

type CardProps = {
	tone?: CardTone;
	icon?: IconName;
	/** Anything shown above the title, e.g. a team photo. */
	media?: ReactNode;
	title?: ReactNode;
	children?: ReactNode;
	/** Produce photo tucked into the bottom-right corner. */
	produce?: ProduceName;
	produceWidth?: number;
	minHeight?: number;
	center?: boolean;
	reveal?: RevealVariant;
	delay?: number;
	className?: string;
	style?: CSSProperties;
};

/** Rounded content card. The reveal wrapper and the card are separate so the hover lift isn't overridden. */
export default function Card({ tone = "white", icon, media, title, children, produce, produceWidth, minHeight, center, reveal = "zoom", delay = 0, className, style }: CardProps) {
	return (
		<Reveal variant={reveal} delay={delay} className={s.cell}>
			<div className={cx(s.card, TONES[tone], center && s.center, className)} style={{ minHeight, ...style }}>
				<div className={s.cardBody}>
					{icon && (
						<div className={s.ico}>
							<Icon name={icon} />
						</div>
					)}
					{media}
					{title && <h3 className={s.h3}>{title}</h3>}
					{children}
				</div>
				{produce && (
					<div className={s.cardImg} style={produceWidth ? { width: produceWidth } : undefined}>
						<Produce name={produce} sizes="130px" />
					</div>
				)}
			</div>
		</Reveal>
	);
}
