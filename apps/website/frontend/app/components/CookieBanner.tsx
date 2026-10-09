"use client";

import { useState, useEffect } from "react";

export default function CookieBanner() {
  const [visible, setVisible] = useState(false);

  useEffect(() => {
    const consent = localStorage.getItem("grocerra_cookie_consent");
    if (!consent) {
      setVisible(true);
    }
  }, []);

  const handleAction = (type: string) => {
    localStorage.setItem("grocerra_cookie_consent", type);
    setVisible(false);
  };

  if (!visible) return null;

  return (
    <div className="cookie-banner">
      <div style={{ flex: 1, minWidth: "260px" }}>
        <p style={{ fontSize: "14px", lineHeight: "1.5", margin: 0 }}>
          We use cookies to improve your experience. Read our{" "}
          <a 
            href="https://claude.ai/legal/cookies" 
            target="_blank" 
            rel="noreferrer" 
            style={{ color: "#86EFAC", textDecoration: "underline" }}
          >
            Cookie Policy
          </a>.
        </p>
      </div>

      <div style={{ display: "flex", alignItems: "center", gap: "10px", flexWrap: "wrap" }}>
        <button 
          onClick={() => handleAction("accept")} 
          className="btn-pill btn-pill-sm btn-green"
          style={{ backgroundColor: "#1F7A4D", color: "#FFF" }}
        >
          Accept
        </button>
        <button 
          onClick={() => handleAction("reject")} 
          className="btn-pill btn-pill-sm btn-outline-white"
        >
          Reject
        </button>
        <button 
          onClick={() => handleAction("preferences")} 
          style={{ fontSize: "13px", color: "var(--color-ash)", textDecoration: "underline", padding: "6px 8px" }}
        >
          Manage preferences
        </button>
      </div>
    </div>
  );
}
