import Footer from "@/app/components/site/Footer";
import s from "@/app/components/site/site.module.css";

export default function SiteLayout({ children }: { children: React.ReactNode }) {
	return (
		<>
			{children}
			<div className={s.page}>
				<Footer />
			</div>
		</>
	);
}
