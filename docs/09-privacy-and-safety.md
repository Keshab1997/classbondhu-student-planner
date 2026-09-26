# 09 — Privacy and safety

## v1 data collected

The planned v1 stores subjects, timetable, attendance records, tasks, and preferences locally on the device. It does not require a student name, college, account, location, contacts, microphone, or photo access.

## Principles

- Data minimization: collect only what a feature needs.
- No sharing academic data with other users in v1.
- No sensitive records in debug output, crash reports, ad requests, or analytics.
- Make local-only storage and uninstall/data-loss behavior clear.
- Provide a user-accessible way to delete app data; warn before deletion.
- Publish a truthful privacy policy and complete Play Console Data safety declarations before distribution. Revisit both if SDKs/ads change.

## Advertising and minors

The age/target-audience decision is open. Since students may include minors, do not launch personalized ads until the audience and applicable consent/child-directed treatment have been reviewed against current Google Play and AdMob policies. Ad SDK data practices must be reflected in the privacy policy and store disclosures.

## Security

- Keep dependencies maintained; minimize SDKs.
- Use Android's normal app sandbox; do not claim encryption at rest unless implemented and verified.
- Do not add a backend or cloud sync without a separate security/privacy design, retention policy, and user consent.
- Never put signing keys or credentials in Git.
