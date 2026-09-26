# 11 — Play Store release checklist

## Before creating the listing

- Finalize title, icon, screenshots, short/full descriptions, support email, and privacy-policy URL.
- Verify the app name and package/application ID are available and suitable. The working title is **ClassBondhu: Student Planner**; availability is not guaranteed.
- Choose and lock a unique Android application ID before the first public release. The application ID is not the GitHub repo name and is difficult to change after publishing.
- Decide target age/audience and complete content rating honestly.
- Create a signed Android App Bundle (AAB); store signing/upload keys securely outside Git.
- Complete Data safety, ads declaration, target audience, content rating, and privacy disclosures based on actual behavior and SDKs.

## Beta sequence

1. Internal testing with test AdMob IDs or ads disabled.
2. Closed test with a small group of students; collect consented feedback without exposing real student records.
3. Fix usability, localization, attendance-calculation, notification, and data-loss issues.
4. Review current Android target API and Play Console requirements on release day.
5. Roll out gradually; monitor crashes and feedback without collecting unnecessary personal data.

## Store listing honesty

Do not claim official college integration, guaranteed attendance eligibility, cloud backup, or privacy/security properties that are not implemented. Explain that attendance is an estimate based on user-entered records. Provide a contact and deletion/data-loss explanation.
