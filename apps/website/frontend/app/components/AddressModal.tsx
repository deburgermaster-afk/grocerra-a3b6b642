"use client";

import { useState } from "react";

interface AddressModalProps {
  isOpen: boolean;
  onClose: () => void;
  onSelectAddress: (address: string) => void;
}

const popularSuburbs = [
  "Dandenong, VIC 3175",
  "Point Cook, VIC 3030",
  "Craigieburn, VIC 3064",
  "Tarneit, VIC 3029",
  "Epping, VIC 3076",
  "Sunshine, VIC 3020",
  "Footscray, VIC 3011",
  "Clayton, VIC 3168"
];

export default function AddressModal({ isOpen, onClose, onSelectAddress }: AddressModalProps) {
  const [query, setQuery] = useState("");

  if (!isOpen) return null;

  const handleSelect = (suburb: string) => {
    onSelectAddress(suburb);
    onClose();
  };

  const filteredSuburbs = popularSuburbs.filter(s => 
    s.toLowerCase().includes(query.toLowerCase())
  );

  return (
    <div 
      style={{
        position: "fixed",
        inset: 0,
        zIndex: 1000,
        backgroundColor: "rgba(0, 0, 0, 0.7)",
        backdropFilter: "blur(6px)",
        display: "flex",
        alignItems: "center",
        justifyContent: "center",
        padding: "20px"
      }}
      onClick={onClose}
    >
      <div 
        style={{
          backgroundColor: "var(--bg-card)",
          border: "1px solid var(--border-card)",
          borderRadius: "28px",
          width: "100%",
          maxWidth: "520px",
          padding: "32px",
          boxShadow: "var(--shadow-lg)",
          position: "relative",
          color: "var(--text-main)"
        }}
        onClick={(e) => e.stopPropagation()}
      >
        <div style={{ display: "flex", justifyContent: "space-between", alignItems: "center", marginBottom: "20px" }}>
          <h3 style={{ fontSize: "22px", fontWeight: 800, color: "var(--text-main)" }}>
            Enter your delivery address
          </h3>
          <button onClick={onClose} style={{ fontSize: "20px", color: "var(--text-muted)", padding: "4px" }}>
            ✕
          </button>
        </div>

        <p style={{ fontSize: "14px", color: "var(--text-muted)", marginBottom: "20px" }}>
          We'll show you grocery stores, butchers and caterers that deliver to your neighbourhood.
        </p>

        <div style={{
          display: "flex",
          alignItems: "center",
          gap: "10px",
          padding: "12px 18px",
          backgroundColor: "var(--bg-card-subtle)",
          border: "1px solid var(--border-color)",
          borderRadius: "9999px",
          marginBottom: "24px"
        }}>
          <input 
            type="text"
            placeholder="Type street name or suburb (e.g. Dandenong)..."
            value={query}
            onChange={(e) => setQuery(e.target.value)}
            style={{
              flex: 1,
              border: "none",
              outline: "none",
              backgroundColor: "transparent",
              fontSize: "15px",
              fontFamily: "inherit",
              color: "var(--text-main)"
            }}
            autoFocus
          />
        </div>

        <div>
          <h4 style={{ fontSize: "12px", fontWeight: 700, textTransform: "uppercase", letterSpacing: "0.05em", color: "var(--text-muted)", marginBottom: "12px" }}>
            Popular Delivery Suburbs in Melbourne
          </h4>

          <div style={{ display: "flex", flexDirection: "column", gap: "8px", maxHeight: "240px", overflowY: "auto" }}>
            {filteredSuburbs.map((suburb) => (
              <button
                key={suburb}
                onClick={() => handleSelect(suburb)}
                style={{
                  display: "flex",
                  alignItems: "center",
                  gap: "12px",
                  padding: "12px 16px",
                  borderRadius: "14px",
                  backgroundColor: "var(--bg-card)",
                  border: "1px solid var(--border-color)",
                  textAlign: "left",
                  fontSize: "14px",
                  fontWeight: 600,
                  color: "var(--text-main)",
                  transition: "all 0.2s ease"
                }}
                className="suburb-btn"
              >
                <span>{suburb}</span>
              </button>
            ))}
          </div>
        </div>
      </div>

      <style jsx>{`
        .suburb-btn:hover {
          background-color: var(--bg-card-subtle) !important;
          border-color: var(--green-primary) !important;
        }
      `}</style>
    </div>
  );
}
