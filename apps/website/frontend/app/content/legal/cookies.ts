import { DRAFT_OUTLINE, EMAIL_LINE, type LegalDoc } from "./types";

const UPDATED = "Last updated: [date]";

export const cookies: LegalDoc = {
	slug: "cookies",
	heroTitle: "Cookie *Policy*",
	heroSub: "The cookies and tracking technologies we use, and how you can control them.",
	description: "The cookies and tracking technologies Grocerra uses, and how you can control them.",
	meta: [UPDATED],
	draftNote: DRAFT_OUTLINE,
	sections: [
		{
			id: "k1",
			toc: "What cookies are",
			title: "What cookies are",
			blocks: [{ type: "todo", text: `[Plain-language explanation of cookies and similar technologies (pixels, local storage, SDKs in the app).]` }],
		},
		{
			id: "k2",
			toc: "Types we use",
			title: "Types of cookies we use",
			blocks: [
				{
					type: "table",
					head: ["Type", "Purpose"],
					rows: [
						["Essential", "[Sign-in, basket, security]"],
						["Preferences", "[Remembering your address and settings]"],
						["Analytics", "[Tools used and what they measure]"],
						["Marketing", "[Advertising partners, if any]"],
					],
				},
			],
		},
		{
			id: "k3",
			toc: "Managing consent",
			title: "Managing your consent",
			blocks: [
				{
					type: "p",
					text: `You can accept, reject or manage your cookie preferences using the cookie banner when you first visit our website, and change your choice at any time.`,
				},
				{ type: "todo", text: `[Where to reopen cookie settings, how to block cookies in the browser, and what stops working if essential cookies are blocked.]` },
			],
		},
		{
			id: "k4",
			toc: "Contact",
			title: "Contact",
			blocks: [
				{ type: "p", text: `For more about how we handle personal information, see our {{Privacy Policy|/legal/privacy}}.` },
				{ type: "contact", title: "Questions about cookies", lines: [EMAIL_LINE] },
			],
		},
	],
};
