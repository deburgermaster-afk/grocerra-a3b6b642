// Landing page figures and testimonials.
// ⚠ SAMPLE CONTENT — replace with real, verifiable numbers and genuine customer reviews
// (shared with the customer's permission) before launch. Publishing invented stats or
// reviews is misleading under Australian Consumer Law.

export type Stat = { to: number; decimals?: number; prefix?: string; suffix?: string; label: string };

export const STATS: { left: Stat[]; right: Stat[] } = {
	left: [
		{ to: 50, suffix: "+", label: "Partner stores near you" },
		{ to: 45, suffix: " min", label: "Average delivery time" },
	],
	right: [
		{ to: 4.8, decimals: 1, suffix: "★", label: "Average app rating" },
		{ to: 7, suffix: " days", label: "A week, morning to night" },
	],
};

export type Review = {
	name: string;
	location: string;
	country: string;
	countryCode: string;
	quote: string;
	ordered: string;
	/** Optional path in /public, e.g. "/images/reviews/ayesha.jpg". Initials are shown until one is added. */
	photo?: string;
};

export const REVIEWS: Review[] = [
	{
		name: "Ayesha Rahman",
		location: "Dandenong, VIC",
		country: "Bangladesh",
		countryCode: "BD",
		quote: "I finally get proper hilsa and deshi spices without driving across town. Everything arrived cold, packed well and on time.",
		ordered: "Fish & spices",
	},
	{
		name: "Rohan Mehta",
		location: "Tarneit, VIC",
		country: "India",
		countryCode: "IN",
		quote: "Ordered atta, paneer and fresh coriander for a Sunday cook-up. Same store we always use — just without the queue.",
		ordered: "Pantry staples",
	},
	{
		name: "Fatima Siddiqui",
		location: "Craigieburn, VIC",
		country: "Pakistan",
		countryCode: "PK",
		quote: "The butcher cut the lamb exactly how I asked for karahi. Halal, fresh and at my door before Maghrib.",
		ordered: "Halal lamb",
	},
	{
		name: "Nimal Perera",
		location: "Clayton, VIC",
		country: "Sri Lanka",
		countryCode: "LK",
		quote: "Curry leaves, Maldive fish and red rice in one basket. It feels like shopping at the corner shop back home.",
		ordered: "Groceries",
	},
	{
		name: "Sita Gurung",
		location: "Footscray, VIC",
		country: "Nepal",
		countryCode: "NP",
		quote: "We ordered sweets and snacks for Dashain from two different shops and paid once. Super easy for big family events.",
		ordered: "Catering",
	},
	{
		name: "Omar Haddad",
		location: "Coburg, VIC",
		country: "Lebanon",
		countryCode: "LB",
		quote: "Fresh flatbread, labneh and chicken from my local shops. Tracking the driver live is a nice touch.",
		ordered: "Bakery & poultry",
	},
	{
		name: "Grace Nguyen",
		location: "Springvale, VIC",
		country: "Vietnam",
		countryCode: "VN",
		quote: "Herbs are always crisp and the rice bags are delivered right to the kitchen. Saves me a whole afternoon.",
		ordered: "Fresh produce",
	},
	{
		name: "Hassan Abdi",
		location: "Flemington, VIC",
		country: "Somalia",
		countryCode: "SO",
		quote: "Goat meat cut to order and camel milk from the shop I trust. Grocerra just made it a few taps.",
		ordered: "Halal goat",
	},
];
