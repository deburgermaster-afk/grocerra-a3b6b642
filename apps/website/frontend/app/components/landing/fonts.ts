import { Instrument_Serif, Poppins, Schibsted_Grotesk } from "next/font/google";

const poppins = Poppins({ subsets: ["latin"], weight: ["700", "800"], variable: "--font-poppins", display: "swap" });
const schibsted = Schibsted_Grotesk({ subsets: ["latin"], variable: "--font-schibsted", display: "swap" });
const instrument = Instrument_Serif({ subsets: ["latin"], weight: "400", style: ["normal", "italic"], variable: "--font-instrument", display: "swap" });

export const landingFonts = `${poppins.variable} ${schibsted.variable} ${instrument.variable}`;
