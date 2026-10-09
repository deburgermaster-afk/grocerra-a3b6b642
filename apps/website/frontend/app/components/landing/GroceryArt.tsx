import s from "./landing.module.css";
import { cx } from "./shared";

// Flat grocery illustrations that float around the page (same style as the van, basket and seal).
// Natural product colours live here; brand colours come from the Tailwind theme classes.

const text = cx(s.svgText);

function Milk() {
	return (
		<svg viewBox="0 0 100 150">
			<path d="M40 2h20v14H40z" fill="#E2E8F0" />
			<path d="M20 40 50 12l30 28z" fill="#F1F5F9" />
			<path d="M50 12l30 28H50z" fill="#E2E8F0" />
			<circle cx="64" cy="27" r="7" className="fill-grocerra-green" />
			<rect x="20" y="40" width="60" height="104" rx="4" fill="#FFFFFF" />
			<rect x="20" y="40" width="12" height="104" fill="#0B0B0B" opacity=".06" />
			<rect x="20" y="70" width="60" height="36" className="fill-grocerra-green" />
			<text x="51" y="94" textAnchor="middle" className={cx(text, "fill-grocerra-white")} fontSize="15" fontWeight={900}>MILK</text>
			<text x="51" y="126" textAnchor="middle" className={text} fill="#64748B" fontSize="7.5" fontWeight={700}>FULL CREAM</text>
		</svg>
	);
}

function Rice() {
	return (
		<svg viewBox="0 0 120 150">
			<path d="M20 30Q14 90 22 140q38 9 76 0 8-50 2-110z" fill="#F3E6C8" />
			<path d="M20 30Q14 90 22 140q8 2 14 3Q28 90 34 30z" fill="#0B0B0B" opacity=".06" />
			<path d="M24 22Q60 8 96 22l4 8Q60 18 20 30z" fill="#E7D3A6" />
			<path d="M34 10q26-10 52 0l-4 14q-22-6-44 0z" fill="#EBDDBA" />
			<rect x="30" y="20" width="60" height="8" rx="4" fill="#92400E" />
			<rect x="32" y="56" width="56" height="58" rx="8" className="fill-grocerra-green" />
			<text x="60" y="84" textAnchor="middle" className={cx(text, "fill-grocerra-white")} fontSize="16" fontWeight={900}>RICE</text>
			<text x="60" y="100" textAnchor="middle" className={cx(text, "fill-grocerra-yellow")} fontSize="8" fontWeight={800}>BASMATI</text>
			<g fill="#FFFFFF" opacity=".9">
				<ellipse cx="44" cy="128" rx="4" ry="1.8" transform="rotate(20 44 128)" />
				<ellipse cx="58" cy="131" rx="4" ry="1.8" transform="rotate(-15 58 131)" />
				<ellipse cx="74" cy="127" rx="4" ry="1.8" transform="rotate(30 74 127)" />
			</g>
		</svg>
	);
}

function Bread() {
	return (
		<svg viewBox="0 0 160 100">
			<path d="M10 70Q8 30 50 22q30-12 60 0 42 8 40 48 0 18-20 20H30Q10 88 10 70z" fill="#C2690B" />
			<ellipse cx="80" cy="42" rx="60" ry="18" fill="#F59E0B" opacity=".55" />
			<g stroke="#FDE68A" strokeWidth="5" strokeLinecap="round" fill="none">
				<path d="M48 32l12 20M76 26l12 24M104 30l10 22" />
			</g>
			<path d="M14 74q66 14 132 0" stroke="#7C2D12" strokeWidth="3" fill="none" opacity=".25" />
		</svg>
	);
}

function Eggs() {
	return (
		<svg viewBox="0 0 160 100">
			<ellipse cx="40" cy="40" rx="18" ry="24" fill="#F3DCC0" />
			<ellipse cx="80" cy="36" rx="18" ry="24" fill="#FAF3EA" />
			<ellipse cx="120" cy="40" rx="18" ry="24" fill="#EBC9A2" />
			<g fill="#FFFFFF" opacity=".6">
				<ellipse cx="34" cy="30" rx="5" ry="8" />
				<ellipse cx="74" cy="26" rx="5" ry="8" />
				<ellipse cx="114" cy="30" rx="5" ry="8" />
			</g>
			<path d="M8 50h144l-8 42H16z" fill="#D6C7A8" />
			<path d="M8 50q16 16 32 0t40 0 40 0 32 0v8H8z" fill="#C4B28C" />
			<rect x="58" y="66" width="44" height="16" rx="4" className="fill-grocerra-green" />
			<text x="80" y="78" textAnchor="middle" className={cx(text, "fill-grocerra-white")} fontSize="9" fontWeight={900}>FREE RANGE</text>
		</svg>
	);
}

function Oil() {
	return (
		<svg viewBox="0 0 80 170">
			<rect x="29" y="4" width="22" height="16" rx="3" className="fill-grocerra-green" />
			<path d="M33 20h14v14H33z" fill="#EAB308" />
			<path d="M33 34Q16 46 16 70v86q0 10 10 10h28q10 0 10-10V70q0-24-17-36z" fill="#EAB308" />
			<rect x="22" y="76" width="6" height="74" rx="3" fill="#FFFFFF" opacity=".45" />
			<rect x="16" y="96" width="48" height="40" fill="#FFFFFF" />
			<text x="40" y="117" textAnchor="middle" className={cx(text, "fill-grocerra-green")} fontSize="13" fontWeight={900}>OIL</text>
			<text x="40" y="129" textAnchor="middle" className={text} fill="#64748B" fontSize="6.5" fontWeight={700}>SUNFLOWER</text>
		</svg>
	);
}

function Spices() {
	return (
		<svg viewBox="0 0 90 120">
			<rect x="10" y="24" width="70" height="90" rx="12" fill="#FFFFFF" opacity=".7" />
			<rect x="14" y="44" width="62" height="66" rx="9" fill="#DC2626" />
			<ellipse cx="45" cy="45" rx="31" ry="4" fill="#EF4444" />
			<rect x="14" y="6" width="62" height="22" rx="5" fill="#0B0B0B" />
			<path d="M24 10v14M34 10v14M44 10v14M54 10v14M64 10v14" stroke="#374151" strokeWidth="2" />
			<rect x="18" y="62" width="54" height="28" rx="4" fill="#FFF7ED" />
			<text x="45" y="80" textAnchor="middle" className={text} fill="#9A3412" fontSize="10" fontWeight={900}>MASALA</text>
			<rect x="16" y="30" width="5" height="76" rx="2.5" fill="#FFFFFF" opacity=".55" />
		</svg>
	);
}

function Tin() {
	return (
		<svg viewBox="0 0 90 120">
			<rect x="11" y="14" width="68" height="92" fill="#D1D5DB" />
			<ellipse cx="45" cy="106" rx="34" ry="9" fill="#9CA3AF" />
			<rect x="11" y="30" width="68" height="62" className="fill-grocerra-green-700" />
			<ellipse cx="45" cy="14" rx="34" ry="9" fill="#E5E7EB" />
			<ellipse cx="45" cy="14" rx="26" ry="6" fill="#CBD5E1" />
			<circle cx="45" cy="56" r="13" className="fill-grocerra-yellow" />
			<text x="45" y="84" textAnchor="middle" className={cx(text, "fill-grocerra-white")} fontSize="9" fontWeight={900}>CHICKPEAS</text>
			<rect x="15" y="30" width="6" height="62" fill="#FFFFFF" opacity=".18" />
		</svg>
	);
}

function MeatTray() {
	return (
		<svg viewBox="0 0 160 100">
			<path d="M8 38h144l-10 54H18z" fill="#1F2937" />
			<path d="M28 44q20-14 46-4 14 8 8 24-8 20-34 18-28-4-28-20 0-10 8-18z" fill="#DC4A45" />
			<path d="M34 54q14-10 32-2M36 66q12 6 30 2" stroke="#FCE7E7" strokeWidth="3" strokeLinecap="round" fill="none" opacity=".8" />
			<path d="M84 46q22-12 46-2 12 8 6 22-8 16-30 14-24-2-26-16 0-10 4-18z" fill="#E1615B" />
			<path d="M92 58q14-8 30-2" stroke="#FCE7E7" strokeWidth="3" strokeLinecap="round" fill="none" opacity=".8" />
			<path d="M14 40q60-8 130 0" stroke="#FFFFFF" strokeWidth="4" strokeLinecap="round" opacity=".35" />
			<rect x="104" y="70" width="40" height="16" rx="4" className="fill-grocerra-green" />
			<text x="124" y="81.5" textAnchor="middle" className={cx(text, "fill-grocerra-white")} fontSize="8.5" fontWeight={900}>HALAL</text>
		</svg>
	);
}

/** Kraft paper carry bag with the Grocerra wordmark, shaded to look like a real paper bag, drawn tipped over so groceries spill from its mouth. */
export function GrocerraBag({ className }: { className?: string }) {
	return (
		<span className={cx(s.grocery, s.bagReal, className)} aria-hidden="true">
			<svg viewBox="0 0 300 320">
				<defs>
					<linearGradient id="gbFront" x1="0" y1="0" x2="1" y2="0">
						<stop offset="0" stopColor="#B98552" />
						<stop offset=".35" stopColor="#DDB07A" />
						<stop offset=".7" stopColor="#D4A26C" />
						<stop offset="1" stopColor="#A9743F" />
					</linearGradient>
					<linearGradient id="gbSide" x1="0" y1="0" x2="1" y2="0">
						<stop offset="0" stopColor="#8E5F31" />
						<stop offset="1" stopColor="#B07D4C" />
					</linearGradient>
					<linearGradient id="gbInside" x1="0" y1="0" x2="0" y2="1">
						<stop offset="0" stopColor="#4A2E14" />
						<stop offset="1" stopColor="#7A4E26" />
					</linearGradient>
					<linearGradient id="gbShade" x1="0" y1="0" x2="0" y2="1">
						<stop offset="0" stopColor="#000" stopOpacity=".18" />
						<stop offset=".25" stopColor="#000" stopOpacity="0" />
						<stop offset=".85" stopColor="#000" stopOpacity="0" />
						<stop offset="1" stopColor="#000" stopOpacity=".2" />
					</linearGradient>
					<filter id="gbPaper" x="0" y="0" width="100%" height="100%">
						<feTurbulence type="fractalNoise" baseFrequency=".9" numOctaves="3" seed="4" result="n" />
						<feColorMatrix in="n" type="matrix" values="0 0 0 0 .35  0 0 0 0 .22  0 0 0 0 .1  0 0 0 .55 0" />
						<feComposite in2="SourceGraphic" operator="in" />
					</filter>
					<filter id="gbBlur" x="-20%" y="-50%" width="140%" height="200%">
						<feGaussianBlur stdDeviation="8" />
					</filter>
				</defs>
				<ellipse cx="150" cy="304" rx="150" ry="14" fill="#0B0B0B" opacity=".28" filter="url(#gbBlur)" />
				<g transform="rotate(-24 270 300)">
					{/* inside of the bag, seen through the mouth */}
					<path d="M46 70 92 40l184 26-34 22z" fill="url(#gbInside)" />
					{/* back handle */}
					<path d="M126 66q10-48 34-46 24 3 20 52" fill="none" stroke="#6B4423" strokeWidth="7" strokeLinecap="round" />
					<path d="M126 66q10-48 34-46 24 3 20 52" fill="none" stroke="#8B5E34" strokeWidth="2.5" strokeLinecap="round" strokeDasharray="5 4" />
					{/* side gusset with a centre fold */}
					<path d="M242 88l34-22 10 216-30 18z" fill="url(#gbSide)" />
					<path d="M259 77l7 220" stroke="#6B4423" strokeWidth="2" opacity=".55" />
					<path d="M242 88l17-11 7 220-10 21z" fill="#000" opacity=".1" />
					{/* front panel */}
					<path d="M46 70h196l14 230H34z" fill="url(#gbFront)" />
					<path d="M46 70h196l14 230H34z" filter="url(#gbPaper)" opacity=".5" />
					<path d="M46 70h196l14 230H34z" fill="url(#gbShade)" />
					{/* folded rim and creases */}
					<path d="M46 70h196l2 24H45z" fill="#C4945F" />
					<path d="M45 94h199" stroke="#8B5E34" strokeWidth="1.5" opacity=".6" />
					<path d="M46 70h196" stroke="#F0CFA0" strokeWidth="2" opacity=".8" />
					<path d="M40 238l216 4M37 270l218 3" stroke="#8B5E34" strokeWidth="1.2" opacity=".35" />
					<path d="M78 96l-8 204M212 96l10 204" stroke="#FFF3DD" strokeWidth="3" opacity=".12" />
					<path d="M34 300h222l-1-12H35z" fill="#9C6B3B" />
					{/* front handle: twisted paper cord */}
					<path d="M110 74q8-68 46-62 36 4 30 74" fill="none" stroke="#7A4E26" strokeWidth="8" strokeLinecap="round" />
					<path d="M110 74q8-68 46-62 36 4 30 74" fill="none" stroke="#B88A5A" strokeWidth="3" strokeLinecap="round" strokeDasharray="6 5" />
					<rect x="102" y="70" width="16" height="12" rx="3" fill="#8B5E34" />
					<rect x="178" y="80" width="16" height="12" rx="3" fill="#8B5E34" />
					{/* printed logo */}
					<g opacity=".95">
						<text x="146" y="198" textAnchor="middle" className={s.svgLogo} fontSize="38" fontWeight={800} letterSpacing="-0.5">
							<tspan className="fill-grocerra-black">GRO</tspan>
							<tspan className="fill-grocerra-green-700">CERRA</tspan>
						</text>
						<path d="M136 226c0-9 6-15 20-15 0 11-7 17-15 17-2 0-4-1-5-2Z" className="fill-grocerra-green-700" />
					</g>
				</g>
			</svg>
		</span>
	);
}

const ART = { milk: Milk, rice: Rice, bread: Bread, eggs: Eggs, oil: Oil, spices: Spices, tin: Tin, meat: MeatTray };

export type GroceryName = keyof typeof ART;

export function Grocery({ name, className }: { name: GroceryName; className?: string }) {
	const Art = ART[name];
	return (
		<span className={cx(s.grocery, className)} aria-hidden="true">
			<Art />
		</span>
	);
}
