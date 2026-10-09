// Line icons used across the site (24 × 24, stroke = currentColor).

const PATHS = {
	arrow: <path d="M5 12h14M13 6l6 6-6 6" />,
	store: <path d="M3 9l1.5-5h15L21 9M3 9h18M3 9v11h18V9M9 20v-6h6v6" />,
	storeSimple: <path d="M3 9l1.5-5h15L21 9M3 9h18M3 9v11h18V9" />,
	plusCircle: (
		<>
			<circle cx="12" cy="12" r="9" />
			<path d="M8 12h8M12 8v8" />
		</>
	),
	truck: (
		<>
			<path d="M1 4h14v12H1zM15 9h4l4 4v3h-8z" />
			<circle cx="5.5" cy="18.5" r="2" />
			<circle cx="18.5" cy="18.5" r="2" />
		</>
	),
	mail: (
		<>
			<rect x="2" y="4" width="20" height="16" rx="2" />
			<path d="m22 6-10 7L2 6" />
		</>
	),
	press: <path d="M4 22h14a2 2 0 0 0 2-2V7l-5-5H6a2 2 0 0 0-2 2v4M14 2v5h5M3 15h6M3 18h4" />,
	clock: (
		<>
			<circle cx="12" cy="12" r="9" />
			<path d="M12 7v5l3 2" />
		</>
	),
	pin: (
		<>
			<path d="M12 21s-7-6.2-7-12a7 7 0 0 1 14 0c0 5.8-7 12-7 12Z" />
			<circle cx="12" cy="9" r="2.5" />
		</>
	),
	pulse: <path d="M3 12h4l3 8 4-16 3 8h4" />,
	door: <path d="M3 21V5a2 2 0 0 1 2-2h9l5 5v13M3 21h18M14 12h.01" />,
	lock: (
		<>
			<rect x="5" y="11" width="14" height="10" rx="2" />
			<path d="M8 11V7a4 4 0 0 1 8 0v4" />
		</>
	),
	users: (
		<>
			<circle cx="9" cy="7" r="4" />
			<path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2M23 21v-2a4 4 0 0 0-3-3.9M16 3.1a4 4 0 0 1 0 7.8" />
		</>
	),
	dashboard: (
		<>
			<rect x="3" y="3" width="18" height="18" rx="2" />
			<path d="M3 9h18M9 21V9" />
		</>
	),
	payout: (
		<>
			<rect x="2" y="6" width="20" height="13" rx="2" />
			<path d="M2 10h20M6 15h4" />
		</>
	),
	card: (
		<>
			<rect x="2" y="6" width="20" height="13" rx="2" />
			<path d="M2 10h20" />
		</>
	),
	clipboard: (
		<>
			<rect x="5" y="2" width="14" height="20" rx="2" />
			<path d="M9 6h6M9 10h6M9 14h3" />
		</>
	),
	user: (
		<>
			<circle cx="12" cy="8" r="4" />
			<path d="M4 21v-1a7 7 0 0 1 16 0v1" />
		</>
	),
	basket: (
		<>
			<path d="M5 10h14l-1.5 10h-11Z" />
			<path d="M9 10l3-6 3 6" />
		</>
	),
	alert: <path d="M10.3 3.9 1.8 18a2 2 0 0 0 1.7 3h17a2 2 0 0 0 1.7-3L13.7 3.9a2 2 0 0 0-3.4 0ZM12 9v4M12 17h.01" />,
	info: (
		<>
			<circle cx="12" cy="12" r="9" />
			<path d="M12 8v5M12 16h.01" />
		</>
	),
	search: (
		<>
			<circle cx="11" cy="11" r="7" />
			<path d="m20 20-3.5-3.5" />
		</>
	),
	plus: <path d="M12 5v14M5 12h14" />,
};

export type IconName = keyof typeof PATHS;

export function Icon({ name, size = 26, strokeWidth = 2 }: { name: IconName; size?: number; strokeWidth?: number }) {
	return (
		<svg width={size} height={size} viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth={strokeWidth} strokeLinecap="round" strokeLinejoin="round" aria-hidden="true">
			{PATHS[name]}
		</svg>
	);
}
