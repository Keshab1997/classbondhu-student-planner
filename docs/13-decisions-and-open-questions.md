# 13 — Decisions and open questions

## Confirmed for the project plan

- Product: student-focused planner for routine, attendance, and deadlines.
- App name: **ClassBondhu: Student Planner**.
- Confirmed Android application ID: `com.keshabstudios.classbondhu` (lowercase; keep identical in Play Console and Flutter Android build configuration).
- GitHub repo: `Keshab1997/classbondhu-student-planner`, public.
- UI languages: Bengali, English, Hindi.
- Initial product scope: four bottom tabs and nine principal screens.
- Storage: offline-first, local-only for v1; no account/cloud sync.
- Monetization: AdMob planned; begin with Google's test IDs/placeholders; production IDs belong to the owner's AdMob account and are not available yet.

## Must decide before code/release

1. **Age/target audience:** college-only/general audience or also school-age students? This affects ads, consent, and Play Console declarations.
2. **Android support:** minimum Android version/device baseline.
3. **Attendance policy:** default target (75% is only an example), optional per-subject target, and whether weighted/practical sessions are out of scope (recommended out of scope for v1).
4. **Notifications:** default reminder times and whether class reminders ship in v1 or only task reminders.
5. **Store ownership:** publisher name, support contact, privacy-policy URL, final icon/listing assets.
6. **AdMob production setup:** owner's App ID and chosen ad-unit IDs; consent/UMP and age treatment.
7. **Name clearance:** verify final Play Store/trademark/domain availability before publishing.

Do not silently guess these decisions in production code. Record each resolution here and update the dependent documents.
