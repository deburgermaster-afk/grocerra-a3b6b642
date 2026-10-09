import Header from "./components/Header";
import Hero from "./components/Hero";
import FeaturedStoresCuisines from "./components/FeaturedStoresCuisines";
import HowItWorks from "./components/HowItWorks";
import CateringHighlight from "./components/CateringHighlight";
import AppDownload from "./components/AppDownload";
import CustomerReviews from "./components/CustomerReviews";
import PartnerCTA from "./components/PartnerCTA";
import Footer from "./components/Footer";
import CookieBanner from "./components/CookieBanner";
import WelcomePopup from "./components/WelcomePopup";

export default function Home() {
  return (
    <>
      {/* 1. Sticky Header */}
      <Header />

      <main>
        {/* 2. Hero Section */}
        <Hero />

        {/* 3. Featured Stores & Cuisines */}
        <FeaturedStoresCuisines />

        {/* 4. How It Works (3 Steps) */}
        <HowItWorks />

        {/* 5. Catering Highlight */}
        <CateringHighlight />

        {/* 6. App Download Section */}
        <AppDownload />

        {/* 7. Customer Reviews */}
        <CustomerReviews />

        {/* 8. Partner Store CTA */}
        <PartnerCTA />
      </main>

      {/* 10. Footer & Global Elements */}
      <Footer />
      <CookieBanner />
      <WelcomePopup />
    </>
  );
}
