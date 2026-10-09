// Every public page on the marketing site, grouped the way the footer shows them.
// Pages that don't exist yet will 404 until they're built.

export type SiteLink = { label: string; href: string };

export const MAIN_PAGES: SiteLink[] = [
	{ label: "Home", href: "/" },
	{ label: "How It Works", href: "/how-it-works" },
	{ label: "Download the App", href: "/download" },
	{ label: "Catering", href: "/catering" },
	{ label: "Delivery", href: "/delivery" },
	{ label: "Pricing and Fees", href: "/pricing-and-fees" },
	{ label: "About Us", href: "/about" },
	{ label: "Contact Us", href: "/contact" },
];

export const PARTNER_PAGES: SiteLink[] = [
	{ label: "Partner With Us", href: "/partner-with-us" },
	{ label: "Partner Requirements", href: "/partner-requirements" },
	{ label: "Partner FAQ", href: "/partner-faq" },
];

export const HELP_PAGES: SiteLink[] = [
	{ label: "Customer FAQ", href: "/faq" },
	{ label: "Food Safety and Allergens", href: "/food-safety-and-allergens" },
	{ label: "Halal and Dietary Information", href: "/halal-and-dietary-information" },
	{ label: "Safety and Trust", href: "/safety-and-trust" },
	{ label: "Accessibility", href: "/accessibility" },
	{ label: "Complaints and Feedback", href: "/complaints-and-feedback" },
];

export const LEGAL_PAGES: SiteLink[] = [
	{ label: "Terms of Use", href: "/terms" },
	{ label: "Privacy Policy", href: "/privacy" },
	{ label: "Cookie Policy", href: "/cookie-policy" },
	{ label: "Refund and Cancellation", href: "/refund-and-cancellation" },
	{ label: "Delivery Policy", href: "/delivery-policy" },
];

export const SITEMAP_LINK: SiteLink = { label: "Sitemap", href: "/sitemap" };

export const FOOTER_COLUMNS = [
	{ title: "Grocerra", links: MAIN_PAGES },
	{ title: "Partners", links: PARTNER_PAGES },
	{ title: "Help and trust", links: HELP_PAGES },
	{ title: "Legal", links: LEGAL_PAGES },
];
