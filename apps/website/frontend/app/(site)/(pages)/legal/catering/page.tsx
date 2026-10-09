import LegalLayout, { legalMetadata } from "@/app/components/site/LegalLayout";
import { catering } from "@/app/content/legal/catering";

export const metadata = legalMetadata(catering);

export default function CateringLegalPage() {
	return <LegalLayout doc={catering} />;
}
