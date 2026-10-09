import LegalLayout, { legalMetadata } from "@/app/components/site/LegalLayout";
import { payments } from "@/app/content/legal/payments";

export const metadata = legalMetadata(payments);

export default function PaymentsLegalPage() {
	return <LegalLayout doc={payments} />;
}
