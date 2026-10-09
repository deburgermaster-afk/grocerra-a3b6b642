// FAQ content. Answers are plain strings rendered with <RichText>:
// {{label|/href}} is a link and [[text]] is a highlighted placeholder still to be confirmed.

import type { IconName } from "@/app/components/site/icons";

export type Faq = { q: string; a: string };
export type FaqGroup = { id: string; title: string; icon: IconName; blurb: string; items: Faq[] };

export const HOW_IT_WORKS_FAQ: Faq[] = [
	{
		q: "What fees will I pay?",
		a: "A customer platform fee of 3.5% of the order value (excluding delivery fee, tips and GST) plus the delivery fee. Both are shown at checkout before you pay.",
	},
	{
		q: "What if an item is out of stock?",
		a: "If you allowed substitutions, we'll ask before swapping an item. Otherwise the item is removed and you're not charged for it.",
	},
	{
		q: "Where do you deliver?",
		a: "Delivery is currently available in selected Melbourne suburbs. Enter your address in the app to check.",
	},
	{
		q: "What if I'm not home?",
		a: 'Choose "leave at door" and the courier may leave your order and take a photo as proof. Without it, if no one answers within 5 minutes the order may go back to the store and a return fee may apply.',
	},
];

export const PARTNER_FAQ: Faq[] = [
	{ q: "How much commission does Grocerra charge?", a: "[[Commission rate and what it covers]]" },
	{ q: "When do I get paid?", a: "[[Payout schedule and method]]" },
	{
		q: "How do I set up my menu?",
		a: "Add products in your merchant dashboard, including options such as cut type and weight, prices, and ingredient and allergen information.",
	},
	{
		q: "What happens when an item is out of stock?",
		a: "If the customer allowed substitutions, they're asked before an item is swapped. Otherwise the item is removed and the customer isn't charged for it.",
	},
	{
		q: "How does delivery handoff work?",
		a: "Once you've packed the order, a courier from our delivery partners (currently Uber Direct and DoorDash Drive) collects it from your store. Customers can also choose pickup where you support it.",
	},
	{
		q: "Who handles refunds?",
		a: "[[How refunds are handled between Grocerra and the store]] See our {{Refund & Cancellation Policy|/legal/refunds}}.",
	},
];

export const HELP_FAQ: FaqGroup[] = [
	{
		id: "orders",
		title: "Orders",
		icon: "basket",
		blurb: "Placing, changing, out of stock",
		items: [
			{
				q: "How do I place an order?",
				a: "Browse stores by category, search for products or filter by type (for example meat, rice and grains, spices). Add items to your basket, choose delivery or pickup, and check out.",
			},
			{
				q: "Can I choose the cut and weight of meat?",
				a: 'Yes. For products with options you can pick the cut type (such as curry cut, mince or boneless) and weight (such as 500 g, 1 kg, 2 kg or a custom weight), and add special instructions like "small pieces".',
			},
			{
				q: "What happens if an item is out of stock?",
				a: "If you allowed substitutions, we'll ask you before swapping an item. Otherwise the item is removed and you are not charged for it.",
			},
			{
				q: "When is my order confirmed?",
				a: "Your order is accepted when the store confirms it. If we have to decline or cancel an order — for example because an item is unavailable — any amount charged is refunded.",
			},
			{ q: "Can I pick up my order instead?", a: "Yes, choose Pickup at checkout where the store supports it." },
		],
	},
	{
		id: "payments",
		title: "Payments & fees",
		icon: "card",
		blurb: "Fees, holds, GST",
		items: [
			{
				q: "What fees will I pay?",
				a: "A customer platform fee of 3.5% of the order value (excluding the delivery fee, tips and GST), plus the delivery fee. All fees are shown at checkout before you pay. {{See a worked example →|/delivery}}",
			},
			{
				q: "Why is there a hold on my card for meat or fish?",
				a: "Weight-priced items are charged on the exact weight packed. We may hold up to 10% above the estimated price and charge only the final amount. Any difference is released automatically.",
			},
			{
				q: "Do you charge GST?",
				a: "Grocerra is not currently registered for GST, so no GST is charged on platform fees. Individual stores may have their own GST obligations and will issue their own tax invoices where required.",
			},
			{
				q: "How do promotions work?",
				a: "Promotions and discounts are shown in your cart and at checkout before you pay, along with the conditions for each one.",
			},
		],
	},
	{
		id: "delivery",
		title: "Delivery",
		icon: "truck",
		blurb: "Areas, tracking, leave at door",
		items: [
			{ q: "Where do you deliver?", a: "Delivery is currently available in selected Melbourne suburbs." },
			{
				q: "Who delivers my order?",
				a: "Third-party courier networks — currently Uber Direct and DoorDash Drive. Grocerra arranges delivery on your behalf. If a delivery fails or is delayed, contact us first and we'll work with the courier for you.",
			},
			{
				q: "Can I track my order?",
				a: "Yes, live in the app. You can chat with or call the courier, and stop sharing your live location at any time from the tracking screen.",
			},
			{
				q: "What if I'm not home?",
				a: 'If you choose "leave at door", the courier may leave your order and take a photo as proof of delivery. If you don\'t choose this and no one answers within 5 minutes, the order may be returned to the store and a return fee may apply. Age-restricted orders are never left at the door.',
			},
			{ q: "Can I tip my courier?", a: "Yes — you can add a tip before or after delivery." },
		],
	},
	{
		id: "account",
		title: "Account & more",
		icon: "user",
		blurb: "Sign-in, catering, allergens",
		items: [
			{
				q: "Who can create an account?",
				a: "You must be 18 or over, or have a parent's or guardian's permission. You can sign in with email and password, Apple or Google.",
			},
			{ q: "How do I delete my account?", a: "Go to Profile › Settings in the app, or use our web link. You can delete your account at any time." },
			{
				q: "How do catering orders work?",
				a: "Catering orders are quoted by the caterer, need a deposit and follow the catering cancellation terms. {{Learn about catering →|/catering}}",
			},
			{
				q: "I have a food allergy. What should I do?",
				a: "Check the product information and contact the store directly before ordering. Stores provide allergen information and we display it as provided — we can't guarantee any product is free from a particular allergen. {{Food safety & allergens →|/food-safety}}",
			},
			{
				q: "How do I get a refund?",
				a: "See our {{Refund & Cancellation Policy|/legal/refunds}}, or contact us at contact@grocerra.com.",
			},
		],
	},
];
