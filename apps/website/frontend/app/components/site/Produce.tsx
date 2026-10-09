import Image from "next/image";
import { cx } from "./cx";
import s from "./site.module.css";

// Cut-out produce photos in /public/images/produce, with their pixel sizes
const PRODUCE = {
	aubergine: [365, 190],
	avocado: [366, 273],
	banana: [365, 320],
	"brown-cap-mushroom": [364, 240],
	cabbage: [364, 358],
	carrots: [366, 177],
	garlic: [361, 356],
	ginger: [363, 229],
	kiwi: [365, 212],
	lemon: [365, 238],
	lime: [366, 237],
	mango: [364, 343],
	orange: [341, 365],
	"pink-lady": [309, 365],
	pomegranate: [276, 365],
	"red-bell-pepper": [300, 366],
	"vine-tomato": [365, 249],
	watermelon: [364, 344],
	"yellow-bell-pepper": [332, 366],
	"yellow-onion": [333, 363],
} as const;

export type ProduceName = keyof typeof PRODUCE;

type ProduceProps = {
	name: ProduceName;
	className?: string;
	/** Rendered width hint for next/image, e.g. "150px". */
	sizes?: string;
	priority?: boolean;
	/** Decorative by default; pass alt text when the image carries meaning. */
	alt?: string;
};

export default function Produce({ name, className, sizes = "180px", priority, alt = "" }: ProduceProps) {
	const [width, height] = PRODUCE[name];
	return (
		<Image
			src={`/images/produce/${name}.png`}
			alt={alt}
			width={width}
			height={height}
			sizes={sizes}
			priority={priority}
			className={cx(s.pimg, className)}
		/>
	);
}
