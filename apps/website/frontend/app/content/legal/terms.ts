import { EMAIL_LINE, type LegalDoc } from "./types";

// Keep this text exactly as approved — edit only with sign-off.
export const terms: LegalDoc = {
	slug: "terms",
	heroTitle: "Terms *of Use*",
	heroSub: "The rules for using Grocerra's app and website as a customer.",
	description: "The Terms of Use for customers using the Grocerra app and website.",
	meta: ["Last updated: [date]", "Applies to: customers"],
	draftNote: "Draft for review. All legal pages should be reviewed by an Australian lawyer before publishing.",
	sections: [
		{
			id: "t1",
			toc: "Who we are",
			title: "Who we are",
			blocks: [
				{
					type: "p",
					text: `GROCERRA is an online marketplace that connects customers with independent South Asian grocery stores, halal butchers and caterers in selected Melbourne suburbs. Stores sell the products. Independent courier networks (currently Uber Direct and DoorDash Drive) deliver them. GROCERRA arranges the order and payment, but does not prepare, pack or sell the food itself.`,
				},
				{
					type: "p",
					text: `By creating an account, placing an order or using the Platform, you agree to these Terms. If you do not agree, do not use the Platform.`,
				},
				{
					type: "p",
					text: `These Terms should be read together with our {{Privacy Policy|/legal/privacy}}, {{Cookie Policy|/legal/cookies}}, {{Acceptable Use and Content Policy|/legal/acceptable-use}}, {{Refund and Cancellation Policy|/legal/refunds}} and {{Courier Terms Acknowledgement|/legal/delivery}}.`,
				},
			],
		},
		{
			id: "t2",
			toc: "Your account",
			title: "Your account",
			blocks: [
				{
					type: "ul",
					items: [
						`You must be 18 or over, or have a parent's or guardian's permission to use the Platform.`,
						`Give us accurate information and keep it up to date.`,
						`Keep your login details and one-time codes private. You are responsible for activity on your account.`,
						`You can sign in with email and password, Apple or Google.`,
						`Tell us promptly if you think someone else has used your account.`,
						`You can delete your account at any time in Profile > Settings or through our web link.`,
					],
				},
			],
		},
		{
			id: "t3",
			toc: "Ordering",
			title: "Ordering",
			blocks: [
				{
					type: "ul",
					items: [
						`Prices are in Australian dollars (AUD). GROCERRA is not currently registered for GST, so no GST is charged on platform fees. Individual Stores may have their own GST obligations and will issue their own tax invoices where required.`,
						`You can browse stores by category, search for products, and filter by category (for example meat, rice and grains, spices).`,
						`For products with options, you can choose cut type (for example curry cut, mince, boneless) and weight (for example 500 g, 1 kg, 2 kg or a custom weight). You can add special instructions (for example "small pieces").`,
						`Weight-priced items (for example fresh meat and fish) are charged on the exact weight packed. We may hold a pre-authorisation of up to 10% above the estimated price and charge only the final amount. Any difference is released automatically.`,
						`Stores may run out of stock. If you allowed substitutions, we will ask before swapping an item. Otherwise the item is removed and you are not charged for it.`,
						`An order is accepted when the Store confirms it. We may decline or cancel an order, for example if an item is unavailable or we suspect fraud, and will refund any amount charged.`,
						`You can choose between Delivery and Pickup at checkout, where the Store supports it.`,
					],
				},
			],
		},
		{
			id: "t4",
			toc: "Delivery",
			title: "Delivery",
			blocks: [
				{
					type: "ul",
					items: [
						`Delivery is available only in selected Melbourne suburbs.`,
						`Delivery times are estimates and may change because of weather, traffic, Store preparation time or courier availability.`,
						`Our couriers are provided by third-party networks (Uber Direct and DoorDash Drive). GROCERRA arranges delivery on your behalf but is not the delivery provider. If a delivery fails or is delayed, contact us first and we will work with the courier on your behalf.`,
						`You can set your delivery address manually or by using your current location. You can add a unit or door number and delivery instructions (for example "leave at door" or "meet at door").`,
						`You can track your order live in the app. Your delivery location may be shared with the courier to help them find you. You can stop sharing your live location at any time in the tracking screen.`,
						`You can contact the courier through in-app chat or call, and you can add a tip before or after delivery.`,
						`If you choose "leave at door", the courier may leave the order at your door and take a photo as proof of delivery. If you do not choose this option and no one answers within 5 minutes, the courier may return the order to the Store and a return fee may apply.`,
						`Age-restricted and other restricted orders are never left at the door. If they cannot be handed over, they are returned to the Store and a return fee may apply.`,
						`Our {{Courier Terms Acknowledgement|/legal/delivery}} sets out the full delivery arrangements.`,
					],
				},
			],
		},
		{
			id: "t5",
			toc: "Fees",
			title: "Fees",
			blocks: [
				{
					type: "ul",
					items: [
						`A customer platform fee of 3.5% of the order value (excluding delivery fee, tips and GST) applies to orders, along with the delivery fee. These fees are shown to you at checkout before you pay.`,
						`You can choose standard or priority delivery at checkout where available. The price difference is shown before you pay.`,
						`Any other charge, such as a catering deposit or a return fee, is also shown before you pay.`,
						`Promotions and discounts are shown in your cart and at checkout before you pay. Conditions for each promotion are shown when it is applied.`,
						`The total you see at checkout is the total you pay, unless you change your order or an item's final weight changes.`,
					],
				},
			],
		},
		{
			id: "t6",
			toc: "Refunds",
			title: "Refunds and cancellations",
			blocks: [
				{
					type: "p",
					text: `See our {{Refund and Cancellation Policy|/legal/refunds}}. A return fee may apply if a courier cannot complete delivery because no one is available and you have not chosen "leave at door" (see our {{Courier Terms Acknowledgement|/legal/delivery}}).`,
				},
			],
		},
		{
			id: "t7",
			toc: "Catering",
			title: "Catering",
			blocks: [
				{
					type: "p",
					text: `Catering orders are quoted by the caterer, need a deposit and follow the catering cancellation terms. See our {{Catering Terms|/legal/catering}}.`,
				},
			],
		},
		{
			id: "t8",
			toc: "Reviews and photos",
			title: "Reviews and photos",
			blocks: [
				{
					type: "p",
					text: `Content you post, including reviews, ratings and photos, must follow our {{Acceptable Use and Content Policy|/legal/acceptable-use}}. You keep ownership of your content. You give us a non-exclusive, worldwide, royalty-free licence to host, display and distribute it to operate and promote the Platform. You can report content in the app, and we may remove content that breaches our policies.`,
				},
			],
		},
		{
			id: "t9",
			toc: "Acceptable use",
			title: "Acceptable use",
			blocks: [
				{
					type: "p",
					text: `You must use the Platform lawfully and in line with our Acceptable Use and Content Policy. We may suspend or end your access if you breach these Terms or that Policy, or if we reasonably believe your use is unlawful or puts others at risk.`,
				},
			],
		},
		{
			id: "t10",
			toc: "Allergens",
			title: "Product information and allergens",
			blocks: [
				{
					type: "p",
					text: `Stores provide product descriptions, ingredients and allergen information. We display this information as provided by the Store. We do not independently verify it.`,
				},
				{
					type: "p",
					text: `If you have an allergy, intolerance or dietary requirement, you must check the information provided and contact the Store directly before ordering. Stores are responsible for the accuracy of the allergen and ingredient information they provide, and for preventing cross-contamination in their kitchens.`,
				},
				{
					type: "p",
					text: `If you have a severe allergy, we strongly recommend contacting the Store before placing an order. GROCERRA cannot guarantee that any product is free from a particular allergen.`,
				},
			],
		},
		{
			id: "t11",
			toc: "Intellectual property",
			title: "Our Platform and intellectual property",
			blocks: [
				{
					type: "p",
					text: `The Platform, including its design, software, trademarks and content (other than your content and Store content), belongs to us or our licensors. You may use it only as these Terms allow.`,
				},
			],
		},
		{
			id: "t12",
			toc: "Liability",
			title: "Liability",
			blocks: [
				{
					type: "p",
					text: `Nothing in these Terms excludes, restricts or modifies any right or remedy you have under the Australian Consumer Law that cannot lawfully be excluded. To the extent the law allows, we are not liable for loss caused by events outside our reasonable control, or by the acts or omissions of independent Stores and couriers. Stores are responsible for the food they sell, including its quality, safety, description, ingredients and allergens. Couriers are responsible for the delivery service they provide.`,
				},
			],
		},
		{
			id: "t13",
			toc: "Privacy",
			title: "Privacy",
			blocks: [
				{
					type: "p",
					text: `We handle personal information in line with our {{Privacy Policy|/legal/privacy}} and {{Cookie Policy|/legal/cookies}}.`,
				},
			],
		},
		{
			id: "t14",
			toc: "Changes",
			title: "Changes to these Terms",
			blocks: [
				{
					type: "p",
					text: `We may update these Terms from time to time. We will publish the updated version on the Platform and, for material changes, notify you through the Platform or by email. Continued use of the Platform after an update is published means you accept the updated Terms.`,
				},
			],
		},
		{
			id: "t15",
			toc: "Governing law",
			title: "Governing law",
			blocks: [
				{
					type: "p",
					text: `These Terms are governed by the laws of Victoria, Australia, and you submit to the non-exclusive jurisdiction of the courts of Victoria and the Commonwealth.`,
				},
			],
		},
		{
			id: "t16",
			toc: "Contact",
			title: "Contact",
			blocks: [
				{
					type: "p",
					text: `We are here to help. For any question, complaint or issue about your account, an order, a delivery, a refund or this Platform, contact us using the details below.`,
				},
				{
					type: "contact",
					title: "GROCERRA support",
					lines: [EMAIL_LINE, "Business: Reevake (ABN 27 281 074 266)", "PO Box 74, Village Crescent, Westmeadows, VIC 3049\nMelbourne, Victoria, Australia"],
				},
			],
		},
	],
};
