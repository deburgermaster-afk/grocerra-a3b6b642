import LegalLayout, { legalMetadata } from "@/app/components/site/LegalLayout";
import { delivery } from "@/app/content/legal/delivery";

export const metadata = legalMetadata(delivery);

export default function DeliveryLegalPage() {
	return <LegalLayout doc={delivery} />;
}
