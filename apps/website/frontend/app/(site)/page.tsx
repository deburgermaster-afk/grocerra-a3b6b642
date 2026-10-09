import LandingShell from "@/app/components/landing/LandingShell";
import Hero from "@/app/components/landing/Hero";
import CategoryRibbons from "@/app/components/landing/CategoryRibbons";
import StoresBasket from "@/app/components/landing/StoresBasket";
import Categories from "@/app/components/landing/Categories";
import HowItWorks from "@/app/components/landing/HowItWorks";
import Catering from "@/app/components/landing/Catering";
import AppPromo from "@/app/components/landing/AppPromo";
import ColourWipe from "@/app/components/landing/ColourWipe";
import Reviews from "@/app/components/landing/Reviews";
import PartnerCTA from "@/app/components/landing/PartnerCTA";
import FinalCTA from "@/app/components/landing/FinalCTA";
import CookieBanner from "@/app/components/landing/CookieBanner";

export const metadata = {
	title: { absolute: "Grocerra | Groceries and Fresh Meat Delivered in Australia" },
	description: "Order groceries, fresh halal meat and catering from independent local stores in selected Melbourne suburbs.",
};

export default function Home() {
	return (
		<LandingShell>
			<Hero />
			<main>
				<CategoryRibbons />
				<StoresBasket />
				<Categories />
				<HowItWorks />
				<Catering />
				<AppPromo />
				<ColourWipe />
				<Reviews />
				<PartnerCTA />
				<FinalCTA />
			</main>
			<CookieBanner />
		</LandingShell>
	);
}
