import { DRAFT_OUTLINE, EMAIL_LINE, type LegalDoc } from "./types";

const UPDATED = "Last updated: [date]";

export const payments: LegalDoc = {
	slug: "payments",
	heroTitle: "Payment *Policy*",
	heroSub: "How payments, fees, holds and GST work on Grocerra.",
	description: "How payments, fees, authorisation holds and GST work on Grocerra.",
	meta: [UPDATED],
	draftNote: DRAFT_OUTLINE,
	sections: [
		{ id: "y1", toc: "Payment methods", title: "Accepted payment methods", blocks: [{ type: "todo", text: `[Cards, digital wallets and any other methods accepted.]` }] },
		{ id: "y2", toc: "Payment processor", title: "Payment processor", blocks: [{ type: "todo", text: `[Name of the payment processor and how card details are handled.]` }] },
		{
			id: "y3",
			toc: "Prices and currency",
			title: "Prices and currency",
			blocks: [
				{
					type: "p",
					text: `All prices are in Australian dollars (AUD). Item prices are set by each store. The total you see at checkout is the total you pay, unless you change your order or an item's final weight changes.`,
				},
			],
		},
		{
			id: "y4",
			toc: "Fees",
			title: "Fees",
			blocks: [
				{
					type: "ul",
					items: [
						`A customer platform fee of 3.5% of the order value (excluding delivery fee, tips and GST) applies to orders, along with the delivery fee.`,
						`You can choose standard or priority delivery where available. The price difference is shown before you pay.`,
						`Any other charge, such as a catering deposit or a return fee, is shown before you pay.`,
						`Promotions and discounts are shown in your cart and at checkout before you pay.`,
					],
				},
			],
		},
		{
			id: "y5",
			toc: "Authorisation holds",
			title: "Authorisation holds",
			blocks: [
				{
					type: "p",
					text: `Weight-priced items (for example fresh meat and fish) are charged on the exact weight packed. We may hold a pre-authorisation of up to 10% above the estimated price and charge only the final amount. Any difference is released automatically.`,
				},
				{ type: "todo", text: `[Typical time for released holds to show on a bank statement.]` },
			],
		},
		{
			id: "y6",
			toc: "GST",
			title: "GST",
			blocks: [
				{
					type: "p",
					text: `GROCERRA is not currently registered for GST, so no GST is charged on platform fees. Individual stores may have their own GST obligations and will issue their own tax invoices where required.`,
				},
			],
		},
		{
			id: "y7",
			toc: "Disputes and chargebacks",
			title: "Disputes and chargebacks",
			blocks: [{ type: "todo", text: `[Ask customers to contact support before raising a chargeback, and explain how disputes are handled.]` }],
		},
		{
			id: "y8",
			toc: "Security",
			title: "Payment security",
			blocks: [{ type: "todo", text: `[Security standards followed by the payment processor (e.g. PCI DSS) and what GROCERRA does and does not store.]` }],
		},
		{ id: "y9", toc: "Contact", title: "Contact", blocks: [{ type: "contact", title: "Payment questions", lines: [EMAIL_LINE] }] },
	],
};
