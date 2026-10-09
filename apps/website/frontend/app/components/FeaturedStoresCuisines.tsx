"use client";

import { useState } from "react";
import Image from "next/image";
import ImageReveal from "./ImageReveal";

const cuisineList = [
  "All Cuisines",
  "Bangladeshi",
  "Indian",
  "Pakistani",
  "Sri Lankan",
  "Nepali",
  "Halal Butchery"
];

const categoryTiles = [
  { title: "Rice and Grains", desc: "Basmati, miniket, atta and more", image: "/images/rice.jpg", imageAlt: "Bag of long-grain white rice" },
  { title: "Spices", desc: "Whole and ground spices, masalas", image: "/images/spice.jpg", imageAlt: "Box of biryani spice and seasoning mix" },
  { title: "Halal Meat", desc: "Fresh cuts from trusted butchers", image: "/images/halal-meat.jpg", imageAlt: "Fresh cuts of meat from a butcher" },
  { title: "Frozen", desc: "Parathas, samosas, seafood", image: "/images/frozen-food.jpg", imageAlt: "Golden samosas ready to serve" },
  { title: "Sweets", desc: "Mithai for every celebration", image: "/images/sweets.jpg", imageAlt: "Packaged caramel biscuits" },
  { title: "Snacks", desc: "Biscuits and tea-time favourites", image: "/images/snacks.jpg", imageAlt: "Bag of fruit and coconut granola" }
];

const featuredStores = [
  {
    id: 1,
    name: "Deshi Bazaar & Butchery",
    suburb: "Dandenong",
    cuisine: "Bangladeshi",
    deliveryTime: "25–35 min",
    isHalal: true,
    rating: 4.9,
    reviews: 128,
    badge: "Popular in Dandenong",
    gradient: "linear-gradient(135deg, #14532D 0%, #16A34A 100%)",
    image: "/images/produce-market.jpg",
    imageAlt: "Fresh vegetables on a grocery market display"
  },
  {
    id: 2,
    name: "Royal Spice Market",
    suburb: "Point Cook",
    cuisine: "Indian",
    deliveryTime: "20–30 min",
    isHalal: true,
    rating: 4.8,
    reviews: 94,
    badge: "Top Rated Spices",
    gradient: "linear-gradient(135deg, #9A3412 0%, #EA580C 100%)",
    image: "/images/spices.jpg",
    imageAlt: "Royal Spice Market fresh spices display"
  },
  {
    id: 3,
    name: "Lahore Meat & Groceries",
    suburb: "Craigieburn",
    cuisine: "Pakistani",
    deliveryTime: "30–40 min",
    isHalal: true,
    rating: 4.9,
    reviews: 210,
    badge: "Fresh Halal Cuts",
    gradient: "linear-gradient(135deg, #065F46 0%, #059669 100%)",
    image: "/images/lahore meat and groceries.jpg",
    imageAlt: "Lahore Meat & Groceries fresh meat and grocery selection"
  },
  {
    id: 4,
    name: "Lanka Supermarket",
    suburb: "Tarneit",
    cuisine: "Sri Lankan",
    deliveryTime: "25–35 min",
    isHalal: false,
    rating: 4.7,
    reviews: 86,
    badge: "Authentic Goods",
    gradient: "linear-gradient(135deg, #854D0E 0%, #CA8A04 100%)",
    image: "/images/produce-market.jpg",
    imageAlt: "Fresh vegetables in a grocery market"
  },
  {
    id: 5,
    name: "Himalaya Spice & Sweets",
    suburb: "Epping",
    cuisine: "Nepali",
    deliveryTime: "20–30 min",
    isHalal: true,
    rating: 4.9,
    reviews: 74,
    badge: "Fresh Mithai",
    gradient: "linear-gradient(135deg, #831843 0%, #DB2777 100%)",
    image: "/images/sweets.jpg",
    imageAlt: "Decorated cake from a sweets counter"
  },
  {
    id: 6,
    name: "Bengal Fresh Butchery",
    suburb: "Sunshine",
    cuisine: "Bangladeshi",
    deliveryTime: "15–25 min",
    isHalal: true,
    rating: 5.0,
    reviews: 156,
    badge: "Fast Delivery",
    gradient: "linear-gradient(135deg, #1E3A8A 0%, #2563EB 100%)",
    image: "/images/bengal fresh butchery.jpg",
    imageAlt: "Bengal Fresh Butchery fresh halal meats"
  }
];

export default function FeaturedStoresCuisines() {
  const [selectedCuisine, setSelectedCuisine] = useState("All Cuisines");

  const filteredStores = selectedCuisine === "All Cuisines"
    ? featuredStores
    : selectedCuisine === "Halal Butchery"
      ? featuredStores.filter(s => s.isHalal)
      : featuredStores.filter(s => s.cuisine === selectedCuisine);

  return (
    <section className="section-padding" style={{ backgroundColor: "var(--bg-card)", borderTop: "1px solid var(--border-color)", transition: "background-color 0.3s ease" }}>
      <div className="container">
        
        {/* Section Header */}
        <div style={{ textAlign: "center", maxWidth: "640px", margin: "0 auto 48px" }}>
          <h2 style={{ fontSize: "clamp(28px, 4vw, 40px)", fontWeight: 800, letterSpacing: "-0.02em", color: "var(--text-main)", marginBottom: "12px" }}>
            Shop your favourite stores
          </h2>
          <p style={{ fontSize: "17px", color: "var(--text-muted)" }}>
            Browse by cuisine or category, from your neighbourhood stores.
          </p>
        </div>

        {/* Cuisine Chips */}
        <div style={{ display: "flex", alignItems: "center", justifyContent: "center", gap: "10px", flexWrap: "wrap", marginBottom: "48px" }}>
          {cuisineList.map((cuisine) => (
            <button
              key={cuisine}
              onClick={() => setSelectedCuisine(cuisine)}
              className={`chip ${selectedCuisine === cuisine ? "active" : ""}`}
            >
              {cuisine}
            </button>
          ))}
        </div>

        {/* Category Tiles Grid */}
        <div style={{ marginBottom: "64px" }}>
          <h3 style={{ fontSize: "20px", fontWeight: 700, marginBottom: "20px", color: "var(--text-main)" }}>
            Popular Categories
          </h3>
            <div className="grid grid-cols-1 gap-4 sm:grid-cols-2 sm:gap-5 xl:grid-cols-3">
            {categoryTiles.map((cat, idx) => (
              <a 
                key={idx}
                href="/stores"
                style={{
                  backgroundColor: "var(--bg-main)",
                  border: "1px solid var(--border-color)",
                  borderRadius: "10px",
                  display: "flex",
                  flexDirection: "column",
                  alignItems: "flex-start",
                  height: "100%",
                  overflow: "hidden",
                  transition: "all 0.25s ease",
                  textDecoration: "none"
                }}
                className="category-tile"
              >
                  <ImageReveal className="relative aspect-[16/10] w-full overflow-hidden bg-white sm:aspect-[3/2]" delay={idx * 0.04}>
                  <Image
                    src={cat.image}
                    alt={cat.imageAlt}
                    fill
                      sizes="(max-width: 640px) 90vw, (max-width: 1280px) 45vw, 380px"
                    unoptimized={cat.image === "/images/sweets.jpg"}
                      style={{ objectFit: "contain", padding: "16px" }}
                  />
                  </ImageReveal>
                  <div style={{ padding: "18px 20px 20px", display: "flex", flex: 1, flexDirection: "column", gap: "7px" }}>
                    <h4 style={{ fontSize: "17px", fontWeight: 700, lineHeight: 1.25, color: "var(--text-main)" }}>{cat.title}</h4>
                    <p style={{ fontSize: "13px", color: "var(--text-muted)", lineHeight: "1.5" }}>{cat.desc}</p>
                </div>
              </a>
            ))}
          </div>
        </div>

        {/* Featured Store Cards */}
        <div>
          <div style={{ display: "flex", alignItems: "center", justifyContent: "space-between", marginBottom: "24px" }}>
            <h3 style={{ fontSize: "22px", fontWeight: 700, color: "var(--text-main)" }}>
              Featured Local Stores
            </h3>
            <span style={{ fontSize: "14px", fontWeight: 600, color: "var(--green-primary)" }}>
              Showing {filteredStores.length} stores
            </span>
          </div>

          <div className="mb-10 grid grid-cols-1 gap-4 md:grid-cols-2 xl:grid-cols-3">
            {filteredStores.map((store) => (
              <article key={store.id} className="card min-h-[372px] sm:min-h-[345px]" style={{ display: "flex", flexDirection: "column", height: "100%", borderRadius: "12px" }}>
                
                {/* Store Photo */}
                <ImageReveal className="relative aspect-[16/10] w-full overflow-hidden bg-white sm:aspect-[3/2]">
                  <Image
                    src={store.image}
                    alt={store.imageAlt}
                    fill
                    sizes="(max-width: 768px) 100vw, (max-width: 1200px) 50vw, 400px"
                    style={{ objectFit: "contain", padding: "12px" }}
                  />
                  <div style={{ position: "absolute", inset: "12px 12px auto", display: "flex", justifyContent: "space-between", alignItems: "flex-start", gap: "8px" }}>
                    <span style={{
                      fontSize: "11px",
                      fontWeight: 700,
                      textTransform: "uppercase",
                      letterSpacing: "0.05em",
                      backgroundColor: "var(--bg-card)",
                      color: "var(--text-main)",
                      padding: "4px 10px",
                      borderRadius: "6px",
                      boxShadow: "var(--shadow-sm)"
                    }}>
                      {store.badge}
                    </span>

                    {store.isHalal && (
                      <span className="badge-halal" style={{ flexShrink: 0, backgroundColor: "var(--bg-card)", color: "var(--green-primary)" }}>
                        ✓ Halal Certified
                      </span>
                    )}
                  </div>
                </ImageReveal>

                {/* Store Content */}
                <div style={{ padding: "18px", display: "flex", flexDirection: "column", gap: "14px", flex: 1 }}>
                  <div style={{ flex: 1 }}>
                    <div style={{ display: "flex", alignItems: "flex-start", justifyContent: "space-between", gap: "12px", marginBottom: "8px" }}>
                      <h4 style={{ fontSize: "17px", fontWeight: 700, lineHeight: 1.3, color: "var(--text-main)", minHeight: "44px" }}>
                        {store.name}
                      </h4>
                      <span style={{ flexShrink: 0, fontSize: "12px", fontWeight: 700, color: "var(--text-main)", whiteSpace: "nowrap", padding: "4px 7px", borderRadius: "5px", backgroundColor: "var(--bg-card-subtle)" }}>
                        {store.rating} <span style={{ color: "var(--text-muted)", fontWeight: 500 }}>({store.reviews})</span>
                      </span>
                    </div>

                    <p style={{ fontSize: "13px", color: "var(--text-muted)" }}>
                      {store.suburb} · <span style={{ fontWeight: 600, color: "var(--text-main)" }}>{store.cuisine}</span>
                    </p>
                  </div>

                  <div style={{
                    display: "flex",
                    alignItems: "center",
                    justifyContent: "space-between",
                    gap: "12px",
                    paddingTop: "14px",
                    borderTop: "1px solid var(--border-color)"
                  }}>
                    <span style={{ fontSize: "12px", fontWeight: 600, color: "var(--text-muted)" }}>
                      {store.deliveryTime} delivery
                    </span>

                    <a href={`/stores/${store.id}`} className="btn-pill btn-pill-sm btn-primary" style={{ fontSize: "13px", padding: "6px 14px" }}>
                      View Store
                    </a>
                  </div>
                </div>
              </article>
            ))}
          </div>

          <div style={{ textAlign: "center" }}>
            <a href="/stores" className="btn-pill btn-pill-lg btn-secondary">
              See all stores →
            </a>
          </div>
        </div>

      </div>
    </section>
  );
}
