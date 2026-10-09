import LegalLayout, { legalMetadata } from "@/app/components/site/LegalLayout";
import { privacy } from "@/app/content/legal/privacy";

export const metadata = legalMetadata(privacy);

export default function PrivacyLegalPage() {
	return <LegalLayout doc={privacy} />;
}
