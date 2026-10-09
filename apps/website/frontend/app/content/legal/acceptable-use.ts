import { DRAFT_OUTLINE, EMAIL_LINE, type LegalDoc } from "./types";

const UPDATED = "Last updated: [date]";

export const acceptableUse: LegalDoc = {
	slug: "acceptable-use",
	heroTitle: "Acceptable *use*",
	heroSub: "Our Acceptable Use and Content Policy — keeping Grocerra safe and respectful for everyone.",
	description: "Grocerra's Acceptable Use and Content Policy for reviews, photos and use of the platform.",
	meta: [UPDATED],
	draftNote: DRAFT_OUTLINE,
	sections: [
		{
			id: "a1",
			toc: "Using Grocerra lawfully",
			title: "Using Grocerra lawfully",
			blocks: [{ type: "p", text: `You must use the Platform lawfully and in line with this policy and our {{Terms of Use|/legal/terms}}.` }],
		},
		{
			id: "a2",
			toc: "Prohibited behaviour",
			title: "Prohibited behaviour",
			blocks: [
				{
					type: "todo",
					text: `[What isn't allowed — for example fraud or misuse of promotions, abusive behaviour towards stores or couriers, fake reviews, and attempts to interfere with the Platform.]`,
				},
			],
		},
		{
			id: "a3",
			toc: "Reviews and photos",
			title: "Reviews, ratings and photos",
			blocks: [
				{
					type: "p",
					text: `Content you post, including reviews, ratings and photos, must follow this policy. You keep ownership of your content. You give us a non-exclusive, worldwide, royalty-free licence to host, display and distribute it to operate and promote the Platform.`,
				},
				{ type: "todo", text: `[Content rules — for example honest, relevant, no personal information about others, nothing offensive or illegal.]` },
			],
		},
		{
			id: "a4",
			toc: "Reporting content",
			title: "Reporting content",
			blocks: [{ type: "p", text: `You can report content in the app, and we may remove content that breaches our policies.` }],
		},
		{
			id: "a5",
			toc: "Suspension",
			title: "Suspension and termination",
			blocks: [
				{
					type: "p",
					text: `We may suspend or end your access if you breach our Terms or this policy, or if we reasonably believe your use is unlawful or puts others at risk.`,
				},
			],
		},
		{ id: "a6", toc: "Contact", title: "Contact", blocks: [{ type: "contact", title: "Report a concern", lines: [EMAIL_LINE] }] },
	],
};
