import LandingShell from "./components/landing/LandingShell";
import Navbar from "./components/landing/Navbar";
import Hero from "./components/landing/Hero";
import CategoryRibbons from "./components/landing/CategoryRibbons";
import StoresBasket from "./components/landing/StoresBasket";
import Categories from "./components/landing/Categories";
import HowItWorks from "./components/landing/HowItWorks";
import Catering from "./components/landing/Catering";
import AppPromo from "./components/landing/AppPromo";
import ColourWipe from "./components/landing/ColourWipe";
import Reviews from "./components/landing/Reviews";
import PartnerCTA from "./components/landing/PartnerCTA";
import FinalCTA from "./components/landing/FinalCTA";
import Footer from "./components/landing/Footer";

export default function Home() {
	return (
		<LandingShell>
			<Navbar />
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
			<Footer />
		</LandingShell>
	);
}
