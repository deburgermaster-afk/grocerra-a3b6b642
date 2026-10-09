import { DRAFT_OUTLINE, EMAIL_LINE, type LegalDoc } from "./types";

const UPDATED = "Last updated: [date]";

export const refunds: LegalDoc = {
	slug: "refunds",
	heroTitle: "Refunds & *cancellations*",
	heroSub: "When refunds apply, how to cancel, and what happens with missing or damaged items.",
	description: "When refunds apply on Grocerra, how to cancel an order, and what happens with missing or damaged items.",
	meta: [UPDATED],
	draftNote: DRAFT_OUTLINE,
	intro: [{ type: "p", text: `Nothing in this policy limits your rights under the Australian Consumer Law.` }],
	sections: [
		{
			id: "r1",
			toc: "When refunds apply",
			title: "When refunds apply",
			blocks: [
				{
					type: "ul",
					items: [
						`If an item is out of stock and you didn't allow substitutions, it is removed and you are not charged for it.`,
						`If we decline or cancel your order — for example because an item is unavailable or we suspect fraud — we refund any amount charged.`,
						`For weight-priced items, you're charged only for the exact weight packed. Any difference from the pre-authorised amount is released automatically.`,
					],
				},
			],
		},
		{
			id: "r2",
			toc: "Cancelling an order",
			title: "Cancelling an order",
			blocks: [
				{
					type: "todo",
					text: `[Cancellation windows — for example free cancellation before the store confirms, and what applies after the store starts preparing the order.]`,
				},
			],
		},
		{
			id: "r3",
			toc: "Missing or damaged items",
			title: "Missing, damaged or wrong items",
			blocks: [{ type: "todo", text: `[How and when to report (e.g. within x hours, with a photo), and how refunds or credits are issued.]` }],
		},
		{
			id: "r4",
			toc: "Partial refunds",
			title: "Partial refunds",
			blocks: [{ type: "todo", text: `[When partial refunds apply and how they're calculated, including fees.]` }],
		},
		{
			id: "r5",
			toc: "Return fees",
			title: "Return fees",
			blocks: [
				{
					type: "p",
					text: `A return fee may apply if a courier cannot complete delivery because no one is available and you have not chosen "leave at door". Age-restricted and other restricted orders that cannot be handed over are returned to the store and a return fee may apply. See our {{Delivery & Courier Policy|/legal/delivery}}.`,
				},
			],
		},
		{
			id: "r6",
			toc: "Catering",
			title: "Catering cancellations and deposits",
			blocks: [
				{
					type: "p",
					text: `Catering orders are quoted by the caterer and need a deposit. They follow the catering cancellation terms in our {{Catering Terms|/legal/catering}}.`,
				},
				{ type: "todo", text: `[Deposit refundability and cancellation deadlines for catering.]` },
			],
		},
		{
			id: "r7",
			toc: "Contact",
			title: "Contact",
			blocks: [{ type: "contact", title: "Need a refund?", lines: ["Contact us first and we'll work with the store and courier for you.", EMAIL_LINE] }],
		},
	],
};
