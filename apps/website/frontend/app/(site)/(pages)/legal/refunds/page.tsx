import LegalLayout, { legalMetadata } from "@/app/components/site/LegalLayout";
import { refunds } from "@/app/content/legal/refunds";

export const metadata = legalMetadata(refunds);

export default function RefundsLegalPage() {
	return <LegalLayout doc={refunds} />;
}
