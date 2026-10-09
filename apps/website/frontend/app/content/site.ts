// Site-wide navigation, footer links and company details.

export type NavLink = { label: string; href: string };

export const MAIN_NAV: NavLink[] = [
	{ label: "How it works", href: "/how-it-works" },
	{ label: "Catering", href: "/catering" },
	{ label: "Partners", href: "/partners" },
	{ label: "About", href: "/about" },
	{ label: "Help", href: "/help" },
];

export type LegalDocLink = { slug: string; short: string; long: string; href: string };

// Order matches the legal sidebar and the footer's Legal column
export const LEGAL_DOCS: LegalDocLink[] = [
	{ slug: "terms", short: "Terms of Use", long: "Terms of Use" },
	{ slug: "privacy", short: "Privacy Policy", long: "Privacy Policy" },
	{ slug: "cookies", short: "Cookie Policy", long: "Cookie Policy" },
	{ slug: "refunds", short: "Refunds & Cancellations", long: "Refund & Cancellation Policy" },
	{ slug: "delivery", short: "Delivery & Courier", long: "Delivery & Courier Policy" },
	{ slug: "payments", short: "Payment Policy", long: "Payment Policy" },
	{ slug: "catering", short: "Catering Terms", long: "Catering Terms" },
	{ slug: "acceptable-use", short: "Acceptable Use", long: "Acceptable Use & Content Policy" },
].map((d) => ({ ...d, href: `/legal/${d.slug}` }));

// Log in, sign up and merchant login have no destination until the apps go live
export const ACCOUNT_LINKS = { login: "#", signup: "#", merchantLogin: "#", appStore: "#", googlePlay: "#" };

export const FOOTER_COLUMNS: { title: string; links: NavLink[] }[] = [
	{
		title: "Company",
		links: [
			{ label: "About us", href: "/about" },
			{ label: "Careers", href: "/careers" },
			{ label: "Contact us", href: "/contact" },
		],
	},
	{
		title: "Customers",
		links: [
			{ label: "How it works", href: "/how-it-works" },
			{ label: "Delivery & fees", href: "/delivery" },
			{ label: "Catering", href: "/catering" },
			{ label: "Download the app", href: "/#app" },
		],
	},
	{
		title: "Partners",
		links: [
			{ label: "Partner with us", href: "/partners" },
			{ label: "Partner requirements", href: "/partners#requirements" },
			{ label: "Partner FAQ", href: "/partners#faq" },
			{ label: "Merchant login", href: ACCOUNT_LINKS.merchantLogin },
		],
	},
	{
		title: "Help",
		links: [
			{ label: "Help centre & FAQ", href: "/help" },
			{ label: "Food safety & allergens", href: "/food-safety" },
			{ label: "Contact support", href: "/contact" },
		],
	},
];

export const COMPANY = {
	email: "contact@grocerra.com",
	operator: "Reevake",
	abn: "27 281 074 266",
	address: "PO Box 74, Village Crescent, Westmeadows VIC 3049",
	blurb: "Groceries, fresh meat and catering from independent local stores, delivered across selected Melbourne suburbs.",
	copyright: "© 2026 Grocerra · Operated by Reevake (ABN 27 281 074 266)",
};
