import type { Metadata } from "next";
import { SmallFooter } from "./components/site/Footer";
import NotFoundHero from "./components/site/NotFoundHero";
import s from "./components/site/site.module.css";

export const metadata: Metadata = {
	title: "Page not found",
	description: "The page you're looking for has moved or doesn't exist.",
};

export default function NotFound() {
	return (
		<div className={s.page}>
			<NotFoundHero />
			<SmallFooter />
		</div>
	);
}
