import s from "@/app/components/site/site.module.css";

// Inner pages share the site stylesheet; the home page uses the landing stylesheet instead
export default function PagesLayout({ children }: { children: React.ReactNode }) {
	return (
		<div className={s.page}>
			<main>{children}</main>
		</div>
	);
}
