import { DRAFT_OUTLINE, EMAIL_LINE, type LegalDoc } from "./types";

const UPDATED = "Last updated: [date]";

export const privacy: LegalDoc = {
	slug: "privacy",
	heroTitle: "Privacy *Policy*",
	heroSub: "How we collect, use, share and protect your personal information.",
	description: "How Grocerra collects, uses, shares and protects your personal information under the Australian Privacy Principles.",
	meta: [UPDATED, "Australian Privacy Principles"],
	draftNote: DRAFT_OUTLINE,
	sections: [
		{
			id: "p1",
			toc: "Who we are",
			title: "Who we are",
			blocks: [
				{
					type: "p",
					text: `GROCERRA is operated by Reevake (ABN 27 281 074 266). This policy explains how we handle personal information when you use our app and website, in line with the Australian Privacy Principles.`,
				},
			],
		},
		{
			id: "p2",
			toc: "What we collect",
			title: "What we collect",
			blocks: [
				{
					type: "todo",
					text: `[List the personal information collected — for example account details, sign-in via Apple or Google, delivery addresses, order history, payment details handled by the payment processor, device information and location data.]`,
				},
			],
		},
		{
			id: "p3",
			toc: "Why we collect it",
			title: "Why we collect it",
			blocks: [
				{
					type: "todo",
					text: `[Purposes — for example to create your account, process and deliver orders, provide support, prevent fraud, and send service or marketing messages (with opt-out).]`,
				},
			],
		},
		{
			id: "p4",
			toc: "How we use and share it",
			title: "How we use and share it",
			blocks: [
				{
					type: "p",
					text: `To deliver your order, your delivery address and live location may be shared with the courier (currently Uber Direct and DoorDash Drive) to help them find you. You can stop sharing your live location at any time in the tracking screen.`,
				},
				{ type: "todo", text: `[Other sharing — stores fulfilling your order, the payment processor, service providers, and any overseas disclosure.]` },
			],
		},
		{
			id: "p5",
			toc: "Storage and security",
			title: "Storage and security",
			blocks: [{ type: "todo", text: `[Where data is stored, how long it is kept, and the security measures in place.]` }],
		},
		{
			id: "p6",
			toc: "Access and correction",
			title: "Access and correction",
			blocks: [
				{ type: "todo", text: `[How to request access to or correction of your personal information, and response times.]` },
				{ type: "p", text: `You can delete your account at any time in Profile > Settings or through our web link.` },
			],
		},
		{
			id: "p7",
			toc: "Complaints",
			title: "Complaints",
			blocks: [
				{
					type: "todo",
					text: `[How to make a privacy complaint, how it is handled, and the option to contact the Office of the Australian Information Commissioner (OAIC).]`,
				},
			],
		},
		{
			id: "p8",
			toc: "Contact",
			title: "Contact",
			blocks: [{ type: "contact", title: "Privacy questions", lines: [EMAIL_LINE, "Reevake (ABN 27 281 074 266) · PO Box 74, Village Crescent, Westmeadows VIC 3049"] }],
		},
	],
};
