"use client";

import Image from "next/image";
import { useEffect, useRef, useState } from "react";

export default function WelcomePopup() {
	const [isOpen, setIsOpen] = useState(true);
	const [isEntered, setIsEntered] = useState(false);
	const [isClosing, setIsClosing] = useState(false);
	const closeButtonRef = useRef<HTMLButtonElement>(null);

	useEffect(() => {
		if (!isOpen) return;

		const previousOverflow = document.body.style.overflow;
		document.body.style.overflow = "hidden";
		closeButtonRef.current?.focus();

		const frame = window.requestAnimationFrame(() => setIsEntered(true));
		return () => {
			window.cancelAnimationFrame(frame);
			document.body.style.overflow = previousOverflow;
		};
	}, [isOpen]);

	const dismiss = () => {
		if (isClosing) return;
		setIsClosing(true);
		window.setTimeout(() => setIsOpen(false), 280);
	};

	if (!isOpen) return null;

	return (
		<div
			className={`fixed inset-0 z-[1000] flex items-center justify-center overflow-y-auto bg-black/65 p-4 backdrop-blur-sm transition-opacity duration-300 motion-reduce:transition-none ${isEntered && !isClosing ? "opacity-100" : "opacity-0"}`}
			onClick={(event) => {
				if (event.target === event.currentTarget) dismiss();
			}}
			onKeyDown={(event) => {
				if (event.key === "Escape") dismiss();
			}}
		>
			<section
				aria-describedby="welcome-offer-description"
				aria-labelledby="welcome-offer-title"
				aria-modal="true"
				className={`relative my-auto w-full max-w-[720px] overflow-hidden rounded-xl border border-[var(--border-color)] bg-[#050907] text-white shadow-2xl transition-[opacity,transform] duration-300 ease-out motion-reduce:transition-none ${isEntered && !isClosing ? "translate-y-0 scale-100 opacity-100" : "translate-y-4 scale-[0.98] opacity-0"}`}
				role="dialog"
			>
				<div className="relative">
					<a aria-label="Download the Grocerra app" className="block" href="#app" onClick={dismiss}>
						<picture className="relative block aspect-[1682/966] w-full bg-[#f8f6ec] max-[767px]:aspect-[4/5]">
							<source media="(max-width: 767px)" srcSet="/images/mob-promo.png" />
							<img
								alt="Fresh groceries delivered to your door. Download the Grocerra app."
								className="absolute inset-0 block h-full w-full object-contain"
								height="966"
								loading="eager"
								src="/images/promo.png"
								width="1682"
							/>
						</picture>
					</a>
					<button
						ref={closeButtonRef}
						aria-label="Close welcome offer"
						className="absolute right-[4%] top-[4%] z-10 flex size-10 items-center justify-center rounded-full bg-white/85 text-[var(--green-dark)] shadow-sm transition-colors hover:bg-white focus-visible:outline focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-[var(--green-primary)]"
						onClick={dismiss}
						type="button"
					>
						<svg aria-hidden="true" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round">
							<path d="M18 6 6 18M6 6l12 12" />
						</svg>
					</button>
				</div>

				<div className="p-5 sm:p-7">
					<p className="mb-2 text-xs font-bold uppercase tracking-[0.14em] text-[#42d4a0]">
						Welcome offer · First 20 app downloads
					</p>
					<h2 id="welcome-offer-title" className="text-2xl font-extrabold leading-tight sm:text-3xl">
						Get 10% off your first order
					</h2>
					<p id="welcome-offer-description" className="mt-2 text-sm leading-6 text-white/75 sm:text-base">
						Be one of the first 20 to download the app and get fresh groceries and meat delivered to your door.
					</p>

					<div className="mt-5 flex items-center gap-4">
						<button
							className="min-h-11 px-1 text-sm font-medium text-white/55 transition-colors hover:text-white"
							onClick={dismiss}
							type="button"
						>
							Maybe later
						</button>
					</div>
				</div>
			</section>
		</div>
	);
}