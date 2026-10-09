"use client";

import { useState, useEffect } from "react";
import { useTheme } from "./ThemeProvider";
import { Button } from "./ui/button";

export default function Header() {
  const [mobileMenuOpen, setMobileMenuOpen] = useState(false);
  const [scrolled, setScrolled] = useState(false);
  const { theme, toggleTheme } = useTheme();

  useEffect(() => {
    const handleScroll = () => {
      if (window.scrollY > 40) {
        setScrolled(true);
      } else {
        setScrolled(false);
      }
    };
    handleScroll();
    window.addEventListener("scroll", handleScroll);
    return () => window.removeEventListener("scroll", handleScroll);
  }, []);

  return (
    <header 
      className={`fixed inset-x-0 top-0 z-50 transition-all duration-300 ease-[cubic-bezier(0.16,1,0.3,1)] ${
        scrolled
          ? "border-b border-[var(--border-color)] bg-[var(--header-bg)] shadow-sm"
          : "bg-transparent"
      }`}
    >
      <div className="container flex h-[76px] items-center justify-between">

        <div className="flex items-center">
          <a href="/" className="inline-flex items-center text-lg font-extrabold tracking-tight">
            <span className="logo-gro">GRO</span>
            <span className="logo-cerra">CERRA</span>
          </a>
        </div>

        <nav className="desktop-nav flex items-center gap-8 text-sm font-semibold max-[900px]:hidden">
          <a href="/stores" className="transition-colors hover:text-[var(--green-primary)]">Stores</a>
          <a href="/catering" className="transition-colors hover:text-[var(--green-primary)]">Catering</a>
          <a href="/partners" className="transition-colors hover:text-[var(--green-primary)]">Partner With Us</a>
          <a href="/help" className="transition-colors hover:text-[var(--green-primary)]">Help</a>
        </nav>

        <div className="header-actions flex items-center gap-6 text-sm font-semibold">
          <a href="/login" className="transition-colors hover:text-[var(--green-primary)] max-[900px]:hidden">Log in</a>
          <a href="/signup" className="transition-colors hover:text-[var(--green-primary)] max-[900px]:hidden">Sign up</a>

          <Button
            variant="unstyled"
            className="p-2 text-[var(--text-main)] transition-colors hover:text-[var(--green-primary)]"
            onClick={toggleTheme}
            aria-label={theme === "light" ? "Switch to dark mode" : "Switch to light mode"}
            aria-pressed={theme === "dark"}
            title={theme === "light" ? "Switch to dark mode" : "Switch to light mode"}
          >
            {theme === "light" ? (
              <svg aria-hidden="true" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
                <path d="M21 12.79A9 9 0 1 1 11.21 3 7 7 0 0 0 21 12.79z" />
              </svg>
            ) : (
              <svg aria-hidden="true" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
                <circle cx="12" cy="12" r="5" />
                <line x1="12" y1="1" x2="12" y2="3" />
                <line x1="12" y1="21" x2="12" y2="23" />
                <line x1="4.22" y1="4.22" x2="5.64" y2="5.64" />
                <line x1="18.36" y1="5.64" x2="19.78" y2="4.22" />
                <line x1="1" y1="12" x2="3" y2="12" />
                <line x1="21" y1="12" x2="23" y2="12" />
                <line x1="4.22" y1="19.07" x2="5.64" y2="17.66" />
                <line x1="18.36" y1="5.64" x2="19.78" y2="4.22" />
              </svg>
            )}
          </Button>

          <Button
            variant="unstyled"
            className="mobile-menu-toggle hidden p-2 text-xl text-[var(--text-main)] max-[900px]:block"
            onClick={() => setMobileMenuOpen(!mobileMenuOpen)}
            aria-label="Toggle Menu"
          >
            {mobileMenuOpen ? (
              <svg aria-hidden="true" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round">
                <path d="M18 6 6 18M6 6l12 12" />
              </svg>
            ) : (
              <svg aria-hidden="true" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round">
                <path d="M4 6h16M4 12h16M4 18h16" />
              </svg>
            )}
          </Button>
        </div>
      </div>

      {mobileMenuOpen && (
        <div className="flex flex-col gap-4 border-b border-[var(--border-color)] bg-[var(--bg-card)] px-6 py-5 text-[var(--text-main)]">
          <a href="/stores" onClick={() => setMobileMenuOpen(false)} className="text-base font-semibold">Stores</a>
          <a href="/catering" onClick={() => setMobileMenuOpen(false)} className="text-base font-semibold">Catering</a>
          <a href="/partners" onClick={() => setMobileMenuOpen(false)} className="text-base font-semibold">Partner With Us</a>
          <a href="/help" onClick={() => setMobileMenuOpen(false)} className="text-base font-semibold">Help</a>
          <div className="flex gap-5 border-t border-[var(--border-color)] pt-3 text-sm font-semibold">
            <a href="/login">Log in</a>
            <a href="/signup">Sign up</a>
          </div>
        </div>
      )}
    </header>
  );
}
