import LegalLayout, { legalMetadata } from "@/app/components/site/LegalLayout";
import { cookies } from "@/app/content/legal/cookies";

export const metadata = legalMetadata(cookies);

export default function CookiesLegalPage() {
	return <LegalLayout doc={cookies} />;
}
