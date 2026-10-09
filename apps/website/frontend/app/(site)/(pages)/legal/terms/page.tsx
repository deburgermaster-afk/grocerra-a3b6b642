import LegalLayout, { legalMetadata } from "@/app/components/site/LegalLayout";
import { terms } from "@/app/content/legal/terms";

export const metadata = legalMetadata(terms);

export default function TermsLegalPage() {
	return <LegalLayout doc={terms} />;
}
