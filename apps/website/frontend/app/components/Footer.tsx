"use client";

const companyLinks = [
  { label: "About Us", href: "/about" },
  { label: "Careers", href: "/careers" },
  { label: "Blog and News", href: "/blog" },
  { label: "Press and Media", href: "/press" },
  { label: "Contact Us", href: "/contact" }
];

const customerLinks = [
  { label: "Stores and Groceries", href: "/stores" },
  { label: "Catering", href: "/catering" },
  { label: "Delivery", href: "/delivery" },
  { label: "Pricing and Fees", href: "/pricing" },
  { label: "Offers and Referrals", href: "/offers" },
  { label: "Download the App", href: "/download" }
];

const partnerLinks = [
  { label: "Partner With Us", href: "/partners" },
  { label: "Store Sign-Up", href: "/partners/signup" },
  { label: "Caterer Sign-Up", href: "/partners/caterer-signup" },
  { label: "Partner Requirements", href: "/partners/requirements" },
  { label: "Merchant Portal Login", href: "https://merchant.grocerra.com" },
  { label: "Partner FAQ", href: "/partners/faq" }
];

const helpLinks = [
  { label: "Help Centre", href: "/help" },
  { label: "Customer FAQ", href: "/help/faq" },
  { label: "Track My Order", href: "/help/track" },
  { label: "Report a Problem", href: "/help/report" },
  { label: "Food Safety and Allergens", href: "/help/food-safety" },
  { label: "Halal & Dietary Information", href: "/help/halal-info" },
  { label: "Safety and Trust", href: "/help/safety" },
  { label: "Accessibility", href: "/help/accessibility" },
  { label: "Complaints and Feedback", href: "/help/feedback" }
];

const legalLinks = [
  { label: "Terms of Use", href: "/legal/terms" },
  { label: "Privacy Policy", href: "/legal/privacy" },
  { label: "Cookie Policy", href: "https://claude.ai/legal/cookies" },
  { label: "Refund and Cancellation", href: "/legal/refunds" },
  { label: "Delivery Policy", href: "/legal/delivery" },
  { label: "Payment Policy", href: "/legal/payment" },
  { label: "Catering Terms", href: "/legal/catering-terms" },
  { label: "Merchant Terms", href: "/legal/merchant-terms" },
  { label: "Substitution Policy", href: "/legal/substitution" },
  { label: "Promotion Terms", href: "https://claude.ai/legal/promotions" },
  { label: "Acceptable Use", href: "/legal/acceptable-use" },
  { label: "Sitemap", href: "/sitemap" }
];

export default function Footer() {
  return (
    <footer style={{ backgroundColor: "var(--bg-main)", borderTop: "1px solid var(--border-color)", paddingTop: "64px", paddingBottom: "40px", transition: "background-color 0.3s ease" }}>
      <div className="container">
        
        {/* Top 4 Columns */}
        <div style={{
          display: "grid",
          gridTemplateColumns: "repeat(auto-fit, minmax(200px, 1fr))",
          gap: "40px",
          marginBottom: "56px"
        }}>
          
          {/* Column 1: Company */}
          <div>
            <div style={{ marginBottom: "16px" }}>
              <a href="/" className="logo-brand">
                <span className="logo-gro">GRO</span>
                <span className="logo-cerra">CERRA</span>
              </a>
            </div>
            <p style={{ fontSize: "13px", color: "var(--text-muted)", marginBottom: "20px", lineHeight: "1.5" }}>
              Groceries, certified halal meat and fresh catering delivered across Melbourne on demand.
            </p>
            <h4 style={{ fontSize: "14px", fontWeight: 700, color: "var(--text-main)", marginBottom: "12px" }}>Company</h4>
            <ul style={{ listStyle: "none", padding: 0, display: "flex", flexDirection: "column", gap: "10px" }}>
              {companyLinks.map(link => (
                <li key={link.label}>
                  <a href={link.href} style={{ fontSize: "14px", color: "var(--text-muted)", transition: "color 0.2s" }} className="footer-link">
                    {link.label}
                  </a>
                </li>
              ))}
            </ul>
          </div>

          {/* Column 2: Customers */}
          <div>
            <h4 style={{ fontSize: "14px", fontWeight: 700, color: "var(--text-main)", marginBottom: "16px" }}>Customers</h4>
            <ul style={{ listStyle: "none", padding: 0, display: "flex", flexDirection: "column", gap: "10px" }}>
              {customerLinks.map(link => (
                <li key={link.label}>
                  <a href={link.href} style={{ fontSize: "14px", color: "var(--text-muted)" }} className="footer-link">
                    {link.label}
                  </a>
                </li>
              ))}
            </ul>
          </div>

          {/* Column 3: Partners */}
          <div>
            <h4 style={{ fontSize: "14px", fontWeight: 700, color: "var(--text-main)", marginBottom: "16px" }}>Partners</h4>
            <ul style={{ listStyle: "none", padding: 0, display: "flex", flexDirection: "column", gap: "10px" }}>
              {partnerLinks.map(link => (
                <li key={link.label}>
                  <a href={link.href} style={{ fontSize: "14px", color: "var(--text-muted)" }} className="footer-link">
                    {link.label}
                  </a>
                </li>
              ))}
            </ul>
          </div>

          {/* Column 4: Help */}
          <div>
            <h4 style={{ fontSize: "14px", fontWeight: 700, color: "var(--text-main)", marginBottom: "16px" }}>Help & Support</h4>
            <ul style={{ listStyle: "none", padding: 0, display: "flex", flexDirection: "column", gap: "10px" }}>
              {helpLinks.map(link => (
                <li key={link.label}>
                  <a href={link.href} style={{ fontSize: "14px", color: "var(--text-muted)" }} className="footer-link">
                    {link.label}
                  </a>
                </li>
              ))}
            </ul>
          </div>

        </div>

        {/* Legal Links Bar */}
        <div style={{
          paddingTop: "32px",
          borderTop: "1px solid var(--border-color)",
          marginBottom: "32px"
        }}>
          <h5 style={{ fontSize: "12px", fontWeight: 700, textTransform: "uppercase", letterSpacing: "0.05em", color: "var(--text-muted)", marginBottom: "12px" }}>
            Legal & Terms
          </h5>
          <div style={{ display: "flex", flexWrap: "wrap", gap: "12px 20px" }}>
            {legalLinks.map((link) => (
              <a key={link.label} href={link.href} style={{ fontSize: "13px", color: "var(--text-muted)" }} className="footer-link">
                {link.label}
              </a>
            ))}
          </div>
        </div>

        {/* Bottom Bar: Social, ABN & Copyright */}
        <div style={{
          paddingTop: "24px",
          borderTop: "1px solid var(--border-color)",
          display: "flex",
          justifyContent: "space-between",
          alignItems: "center",
          gap: "24px",
          flexWrap: "wrap"
        }}>
          <div>
            <p style={{ fontSize: "13px", fontWeight: 600, color: "var(--text-main)" }}>
              Grocerra Technologies Pty Ltd · ABN 74 678 412 993
            </p>
            <p style={{ fontSize: "12px", color: "var(--text-muted)", marginTop: "4px" }}>
              © {new Date().getFullYear()} Grocerra Technologies Pty Ltd. All rights reserved.
            </p>
          </div>

          {/* Social Icons */}
          <div style={{ display: "flex", alignItems: "center", gap: "8px", flexWrap: "wrap", maxWidth: "100%" }}>
            {["Instagram", "Facebook", "TikTok", "YouTube"].map((soc) => (
              <a 
                key={soc} 
                href={`https://${soc.toLowerCase()}.com`} 
                target="_blank" 
                rel="noreferrer"
                style={{
                  fontSize: "13px",
                  fontWeight: 600,
                  color: "var(--text-main)",
                  backgroundColor: "var(--bg-card)",
                  border: "1px solid var(--border-color)",
                  padding: "6px 10px",
                  borderRadius: "9999px"
                }}
              >
                {soc}
              </a>
            ))}
          </div>
        </div>

        {/* Acknowledgement of Country */}
        <div style={{ marginTop: "24px", textAlign: "center", paddingTop: "20px", borderTop: "1px dashed var(--border-color)" }}>
          <p style={{ fontSize: "12px", color: "var(--text-muted)", fontStyle: "italic", maxWidth: "800px", margin: "0 auto" }}>
            "We acknowledge the Traditional Custodians of the lands on which we live and work, and pay respect to Elders past, present, and emerging."
          </p>
        </div>

      </div>

      <style jsx>{`
        .footer-link:hover {
          color: var(--green-primary) !important;
          text-decoration: underline;
        }
      `}</style>
    </footer>
  );
}
