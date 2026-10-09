export default function Hero() {
	return (
		<section
			className="relative isolate flex min-h-[780px] items-center justify-center overflow-hidden bg-[var(--bg-main)] px-5 pb-16 pt-28 text-center md:min-h-[90svh] md:pt-24"
			style={{
				backgroundImage:
					"var(--hero-image-overlay), url('/images/hero_grocery_bg_clean.jpg')",
				backgroundPosition: "center 58%",
				backgroundSize: "cover",
			}}
		>
			<div className="pointer-events-none absolute inset-0 -z-10 bg-[var(--hero-image-overlay)]" />
			<div className="container relative z-10 flex flex-col items-center py-16 md:py-20">
				<div className="w-full max-w-[920px]">
					<p className="mb-6 inline-flex items-center gap-2 text-[10px] font-bold text-[var(--text-main)] sm:text-sm">
						<span aria-hidden="true" className="h-2 w-2 rounded-full bg-[var(--green-primary)]" />
						Melbourne pilot launch · Order live on-demand
					</p>
					<h1 className="mx-auto max-w-[900px] text-2xl font-extrabold leading-tight text-[var(--text-main)] sm:text-6xl sm:leading-[1.04] md:text-7xl">
						Groceries and fresh meat, delivered <span className="accent-italic">to your door.</span>
					</h1>
					<p className="mx-auto mt-6 max-w-[680px] text-sm leading-6 text-[var(--text-main)] sm:text-lg sm:leading-7">
						Fresh produce, halal meat, pantry staples and catering from trusted local shops. Order in the app and track your delivery live.
					</p>
				</div>
			</div>
		</section>
	);
}
