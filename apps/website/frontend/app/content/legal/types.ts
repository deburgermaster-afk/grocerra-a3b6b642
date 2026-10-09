// Shape of a legal document. Text strings are rendered with <RichText>:
// {{label|/href}} is a link. Square-bracket placeholders like [date] are shown as written.

export type LegalBlock =
	| { type: "p"; text: string }
	| { type: "ul"; items: string[] }
	/** Dashed "still to be written" box. */
	| { type: "todo"; text: string }
	/** Two-column table; the first column is bold. */
	| { type: "table"; head: [string, string]; rows: [string, string][] }
	/** Black contact box; "\n" inside a line becomes a line break. */
	| { type: "contact"; title: string; lines: string[] };

export type LegalSection = {
	id: string;
	/** Short label for the "On this page" list. */
	toc: string;
	title: string;
	blocks: LegalBlock[];
};

export type LegalDoc = {
	slug: string;
	/** Hero title with *starred* words in the italic accent. */
	heroTitle: string;
	heroSub: string;
	description: string;
	/** Pills under the hero, e.g. "Last updated: [date]". */
	meta: string[];
	draftNote: string;
	/** Blocks shown before the first numbered section. */
	intro?: LegalBlock[];
	sections: LegalSection[];
};

export const DRAFT_OUTLINE = "Draft outline. Dashed boxes mark text still to be written. All legal pages should be reviewed by an Australian lawyer before publishing.";

export const EMAIL_LINE = "Email: {{contact@grocerra.com|mailto:contact@grocerra.com}}";
