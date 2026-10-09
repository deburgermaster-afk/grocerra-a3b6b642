import { DRAFT_OUTLINE, EMAIL_LINE, type LegalDoc } from "./types";

const UPDATED = "Last updated: [date]";

export const delivery: LegalDoc = {
	slug: "delivery",
	heroTitle: "Delivery & *courier terms*",
	heroSub: "Our Courier Terms Acknowledgement — how delivery is arranged, handed over and what happens if it fails.",
	description: "Grocerra's Courier Terms Acknowledgement: how delivery is arranged, handed over and what happens if it fails.",
	meta: [UPDATED],
	draftNote: DRAFT_OUTLINE,
	sections: [
		{
			id: "d1",
			toc: "Delivery areas",
			title: "Delivery areas",
			blocks: [
				{ type: "p", text: `Delivery is available only in selected Melbourne suburbs.` },
				{ type: "todo", text: `[List of suburbs or link to an area checker.]` },
			],
		},
		{
			id: "d2",
			toc: "Courier partners",
			title: "Courier partners",
			blocks: [
				{
					type: "p",
					text: `Our couriers are provided by third-party networks (currently Uber Direct and DoorDash Drive). GROCERRA arranges delivery on your behalf but is not the delivery provider. Couriers are responsible for the delivery service they provide.`,
				},
			],
		},
		{
			id: "d3",
			toc: "Delivery times",
			title: "Delivery times",
			blocks: [
				{
					type: "p",
					text: `Delivery times are estimates and may change because of weather, traffic, store preparation time or courier availability. You can choose standard or priority delivery at checkout where available.`,
				},
			],
		},
		{
			id: "d4",
			toc: "Address and instructions",
			title: "Your address and instructions",
			blocks: [
				{
					type: "p",
					text: `You can set your delivery address manually or by using your current location, add a unit or door number, and add delivery instructions such as "leave at door" or "meet at door".`,
				},
			],
		},
		{
			id: "d5",
			toc: "Tracking and location",
			title: "Live tracking and location",
			blocks: [
				{
					type: "p",
					text: `You can track your order live in the app. Your delivery location may be shared with the courier to help them find you, and you can stop sharing your live location at any time in the tracking screen. You can contact the courier through in-app chat or call, and add a tip before or after delivery.`,
				},
			],
		},
		{
			id: "d6",
			toc: "Handover",
			title: `Handover and "leave at door"`,
			blocks: [{ type: "p", text: `If you choose "leave at door", the courier may leave the order at your door and take a photo as proof of delivery.` }],
		},
		{
			id: "d7",
			toc: "Failed delivery",
			title: "Failed delivery and return fees",
			blocks: [
				{
					type: "p",
					text: `If you do not choose "leave at door" and no one answers within 5 minutes, the courier may return the order to the store and a return fee may apply. If a delivery fails or is delayed, contact us first and we will work with the courier on your behalf.`,
				},
			],
		},
		{
			id: "d8",
			toc: "Restricted items",
			title: "Age-restricted and restricted items",
			blocks: [
				{
					type: "p",
					text: `Age-restricted and other restricted orders are never left at the door. If they cannot be handed over, they are returned to the store and a return fee may apply.`,
				},
			],
		},
		{
			id: "d9",
			toc: "Risk of loss",
			title: "Risk of loss",
			blocks: [{ type: "todo", text: `[When responsibility for the order passes to the customer, and how lost or stolen deliveries are handled.]` }],
		},
		{ id: "d10", toc: "Contact", title: "Contact", blocks: [{ type: "contact", title: "Delivery problem?", lines: [EMAIL_LINE] }] },
	],
};
