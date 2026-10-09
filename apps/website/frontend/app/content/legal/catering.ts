import { DRAFT_OUTLINE, EMAIL_LINE, type LegalDoc } from "./types";

const UPDATED = "Last updated: [date]";

export const catering: LegalDoc = {
	slug: "catering",
	heroTitle: "Catering *Terms*",
	heroSub: "Quotes, deposits, changes and cancellations for catering orders.",
	description: "Grocerra's Catering Terms: quotes, deposits, changes and cancellations for catering orders.",
	meta: [UPDATED],
	draftNote: DRAFT_OUTLINE,
	sections: [
		{
			id: "c1",
			toc: "How catering works",
			title: "How catering orders work",
			blocks: [
				{
					type: "p",
					text: `Catering orders are quoted by the caterer, need a deposit and follow these catering cancellation terms. Caterers prepare the food; GROCERRA arranges the order and payment.`,
				},
			],
		},
		{ id: "c2", toc: "Quotes", title: "Quotes", blocks: [{ type: "todo", text: `[How quotes are requested and provided, what they include, and how long a quote stays valid.]` }] },
		{
			id: "c3",
			toc: "Deposits",
			title: "Deposits",
			blocks: [
				{ type: "p", text: `A deposit is required to confirm a catering order. The deposit amount is shown before you pay.` },
				{ type: "todo", text: `[Deposit amount or percentage, and when the balance is due.]` },
			],
		},
		{
			id: "c4",
			toc: "Minimums and lead times",
			title: "Minimum numbers and lead times",
			blocks: [{ type: "todo", text: `[Minimum guest numbers and the notice required before an event.]` }],
		},
		{
			id: "c5",
			toc: "Changes",
			title: "Changes to your order",
			blocks: [{ type: "todo", text: `[How and by when guest numbers or menu items can be changed, and how price changes are handled.]` }],
		},
		{
			id: "c6",
			toc: "Cancellations",
			title: "Cancellations",
			blocks: [{ type: "todo", text: `[Cancellation deadlines and whether deposits are refundable at each stage.]` }],
		},
		{
			id: "c7",
			toc: "Dietary and allergens",
			title: "Dietary requirements and allergens",
			blocks: [
				{
					type: "p",
					text: `Caterers provide ingredient and allergen information, and are responsible for its accuracy and for preventing cross-contamination in their kitchens. If you or your guests have an allergy, intolerance or dietary requirement, check the information provided and contact the caterer directly before ordering. GROCERRA cannot guarantee that any product is free from a particular allergen.`,
				},
			],
		},
		{
			id: "c8",
			toc: "Delivery and setup",
			title: "Delivery and setup",
			blocks: [{ type: "todo", text: `[Delivery windows for events, hot-food handling, and whether setup is included.]` }],
		},
		{ id: "c9", toc: "Contact", title: "Contact", blocks: [{ type: "contact", title: "Catering enquiries", lines: [EMAIL_LINE] }] },
	],
};
