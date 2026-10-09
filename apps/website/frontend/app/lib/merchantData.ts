export interface MerchantStat {
  id: string;
  value?: number;
  suffix?: string;
  decimals?: number;
  label?: string;
  title: string;
  desc: string;
  accessibleText: string;
}

export const MERCHANT_CONFIG = {
  commissionRate: 4.5,
  commissionSuffix: "%",
  payoutHours: 24,
  payoutSuffix: "h",
  commissionFormatted: "4.5%",
  payoutFormatted: "24h",
};

export const MERCHANT_BENEFITS: MerchantStat[] = [
  {
    id: "commission",
    value: MERCHANT_CONFIG.commissionRate,
    suffix: MERCHANT_CONFIG.commissionSuffix,
    decimals: 1,
    title: "Low commission",
    desc: "Fair merchant fees to help protect your margins.",
    accessibleText: `${MERCHANT_CONFIG.commissionFormatted} low commission rate`,
  },
  {
    id: "onboarding",
    value: MERCHANT_CONFIG.payoutHours,
    suffix: MERCHANT_CONFIG.payoutSuffix,
    decimals: 0,
    title: "Simple onboarding",
    desc: "List your inventory in under a day.",
    accessibleText: `${MERCHANT_CONFIG.payoutFormatted} simple onboarding and fast payouts`,
  },
  {
    id: "dashboard",
    label: "LIVE",
    title: "Order dashboard",
    desc: "Accept, pack and track each order.",
    accessibleText: "LIVE order dashboard to accept, pack and track orders",
  },
  {
    id: "payouts",
    label: "WEEKLY",
    title: "Regular payouts",
    desc: "Automated payouts direct to your bank.",
    accessibleText: "WEEKLY automated payouts direct to your bank",
  },
  {
    id: "delivery",
    label: "LOCAL",
    title: "Courier delivery",
    desc: "On-demand drivers handle delivery.",
    accessibleText: "LOCAL on-demand courier drivers handle delivery",
  },
];
