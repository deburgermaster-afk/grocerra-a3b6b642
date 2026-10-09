export interface FloatingCardData {
  id: string;
  image: string;
  alt: string;
  label?: string;
  isDepthCard: boolean;
  colorWashClass: string;
  aspectRatio: "square" | "portrait";
  desktopPosition: string;
  tabletVisible: boolean;
  mobilePosition?: "top" | "bottom";
  floatDuration: number;
  floatDelay: number;
  floatDirection: "normal" | "reverse";
}

export interface StepData {
  number: string;
  title: string;
  description: string;
  image?: string;
  imageAlt?: string;
}

export const FLOATING_CARDS: FloatingCardData[] = [
  // 8 Sharp Cards (Primary Labels)
  {
    id: "store-front",
    image: "/images/store-front.webp",
    alt: "Grocerra partner store front window",
    label: "Store front",
    isDepthCard: false,
    colorWashClass: "bg-emerald-500/10 dark:bg-emerald-400/15 border-emerald-500/20 dark:border-emerald-400/25",
    aspectRatio: "portrait",
    desktopPosition: "top-[4%] left-[2%]",
    tabletVisible: true,
    mobilePosition: "top",
    floatDuration: 5.8,
    floatDelay: 0,
    floatDirection: "normal",
  },
  {
    id: "tomatoes",
    image: "/images/tomatoes1.webp",
    alt: "Fresh vine-ripened red tomatoes",
    label: "Tomatoes",
    isDepthCard: false,
    colorWashClass: "bg-orange-500/10 dark:bg-orange-400/15 border-orange-500/20 dark:border-orange-400/25",
    aspectRatio: "square",
    desktopPosition: "top-[0%] left-[42%]",
    tabletVisible: true,
    mobilePosition: "top",
    floatDuration: 6.4,
    floatDelay: 0.4,
    floatDirection: "reverse",
  },
  {
    id: "delivery-bag",
    image: "/images/delivery-bag.webp",
    alt: "Packed Grocerra eco-friendly delivery bag",
    label: "Delivery bag",
    isDepthCard: false,
    colorWashClass: "bg-blue-500/10 dark:bg-blue-400/15 border-blue-500/20 dark:border-blue-400/25",
    aspectRatio: "portrait",
    desktopPosition: "top-[4%] right-[14%]",
    tabletVisible: true,
    mobilePosition: undefined,
    floatDuration: 7.0,
    floatDelay: 0.2,
    floatDirection: "normal",
  },
  {
    id: "order-on-phone",
    image: "/images/order-on-phone.webp",
    alt: "Ordering groceries on mobile phone app",
    label: "Order on phone",
    isDepthCard: false,
    colorWashClass: "bg-amber-500/10 dark:bg-amber-400/15 border-amber-500/20 dark:border-amber-400/25",
    aspectRatio: "portrait",
    desktopPosition: "top-[210px] left-[1%]",
    tabletVisible: true,
    mobilePosition: undefined,
    floatDuration: 6.2,
    floatDelay: 0.7,
    floatDirection: "reverse",
  },
  {
    id: "butcher",
    image: "/images/butcher.webp",
    alt: "Fresh halal butcher cuts and meats",
    label: "Butcher",
    isDepthCard: false,
    colorWashClass: "bg-rose-500/10 dark:bg-rose-400/15 border-rose-500/20 dark:border-rose-400/25",
    aspectRatio: "portrait",
    desktopPosition: "top-[190px] right-[2%]",
    tabletVisible: true,
    mobilePosition: undefined,
    floatDuration: 6.8,
    floatDelay: 0.5,
    floatDirection: "normal",
  },
  {
    id: "groceries",
    image: "/images/groceries.webp",
    alt: "Fresh grocery basket with vegetables and staples",
    label: "Groceries",
    isDepthCard: false,
    colorWashClass: "bg-amber-500/10 dark:bg-amber-400/15 border-amber-500/20 dark:border-amber-400/25",
    aspectRatio: "square",
    desktopPosition: "bottom-[12px] left-[27%]",
    tabletVisible: true,
    mobilePosition: "bottom",
    floatDuration: 5.5,
    floatDelay: 0.9,
    floatDirection: "reverse",
  },
  {
    id: "courier",
    image: "/images/courier.webp",
    alt: "Grocerra express courier rider delivering order",
    label: "Courier",
    isDepthCard: false,
    colorWashClass: "bg-emerald-500/10 dark:bg-emerald-400/15 border-emerald-500/20 dark:border-emerald-400/25",
    aspectRatio: "square",
    desktopPosition: "bottom-[0px] left-[49%]",
    tabletVisible: true,
    mobilePosition: "bottom",
    floatDuration: 7.2,
    floatDelay: 0.3,
    floatDirection: "normal",
  },
  {
    id: "spices",
    image: "/images/spices.webp",
    alt: "Aromatic South Asian spices and seasonings",
    label: "Spices",
    isDepthCard: false,
    colorWashClass: "bg-orange-500/10 dark:bg-orange-400/15 border-orange-500/20 dark:border-orange-400/25",
    aspectRatio: "portrait",
    desktopPosition: "bottom-[20px] right-[10%]",
    tabletVisible: true,
    mobilePosition: undefined,
    floatDuration: 6.0,
    floatDelay: 0.1,
    floatDirection: "reverse",
  },

  // 4 Depth Blurred Cards (Decorative Background Depth Layer)
  {
    id: "depth-eggs",
    image: "/images/eggs.jpg",
    alt: "",
    isDepthCard: true,
    colorWashClass: "bg-amber-500/10 dark:bg-amber-400/10 border-amber-500/10",
    aspectRatio: "square",
    desktopPosition: "top-[11%] left-[20%]",
    tabletVisible: false,
    floatDuration: 8.0,
    floatDelay: 0.6,
    floatDirection: "normal",
  },
  {
    id: "depth-rice",
    image: "/images/rice.jpg",
    alt: "",
    isDepthCard: true,
    colorWashClass: "bg-blue-500/10 dark:bg-blue-400/10 border-blue-500/10",
    aspectRatio: "square",
    desktopPosition: "top-[255px] left-[18%]",
    tabletVisible: false,
    floatDuration: 7.5,
    floatDelay: 1.1,
    floatDirection: "reverse",
  },
  {
    id: "depth-fish",
    image: "/images/fish.jpg",
    alt: "",
    isDepthCard: true,
    colorWashClass: "bg-sky-500/10 dark:bg-sky-400/10 border-sky-500/10",
    aspectRatio: "square",
    desktopPosition: "top-[280px] right-[19%]",
    tabletVisible: false,
    floatDuration: 8.2,
    floatDelay: 0.8,
    floatDirection: "normal",
  },
  {
    id: "depth-carrots",
    image: "/images/carrots.jpg",
    alt: "",
    isDepthCard: true,
    colorWashClass: "bg-orange-500/10 dark:bg-orange-400/10 border-orange-500/10",
    aspectRatio: "portrait",
    desktopPosition: "top-[2%] right-[32%]",
    tabletVisible: false,
    floatDuration: 7.8,
    floatDelay: 0.4,
    floatDirection: "reverse",
  },
];

export const STEPS_DATA: StepData[] = [
  {
    number: "01",
    title: "Find a store",
    description: "Enter your address and browse South Asian stores near you.",
    image: "/images/step-find-store.jpg",
    imageAlt: "Find local stores on Grocerra map",
  },
  {
    number: "02",
    title: "Add items and pay",
    description: "Fill your basket, see your live delivery quote, and pay securely.",
    image: "/images/step add and pay.jpg",
    imageAlt: "Add items to basket and secure checkout",
  },
  {
    number: "03",
    title: "Track your delivery",
    description: "Follow your courier in real time until it arrives at your door.",
    image: "/images/step-strack-delivery.jpg",
    imageAlt: "Real-time delivery tracking on mobile",
  },
];
