import LegalLayout, { legalMetadata } from "@/app/components/site/LegalLayout";
import { acceptableUse } from "@/app/content/legal/acceptable-use";

export const metadata = legalMetadata(acceptableUse);

export default function AcceptableUseLegalPage() {
	return <LegalLayout doc={acceptableUse} />;
}
