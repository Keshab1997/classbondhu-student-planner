# 08 — Monetization and AdMob

## Decision

AdMob is planned, but the first implementation should keep ads **disabled until the developer has created their own AdMob app and ad units, reviewed consent/policy requirements, and provided the real IDs**. Do not invent production IDs or copy another app's IDs.

## Safe development IDs

Use Google's official Android test identifiers during development only:

- Sample Android App ID: `ca-app-pub-3940256099942544~3347511713`
- Banner test unit: `ca-app-pub-3940256099942544/6300978111`
- Interstitial test unit: `ca-app-pub-3940256099942544/1033173712`
- Rewarded test unit: `ca-app-pub-3940256099942544/5224354917`

These are public Google test IDs, not the project's production IDs. Confirm current instructions in Google's official AdMob documentation before release. Never click live ads during testing.

## Production setup still required

The owner must create/register the app in their own AdMob account and supply:
- Android AdMob App ID (used in Android manifest/configuration).
- Ad-unit IDs for each chosen format.
- Consent/UMP configuration and any required privacy-message setup.

Keep values in build configuration/environment-specific files; if a value is embedded in a mobile app it is not a secret, but keep test and production builds unmistakably separate. Do not check in account credentials or private keys.

## Placement principles

- No ad overlay on Present/Absent actions, attendance calculations, task save/complete, onboarding, or permission prompts.
- Prefer one clearly labeled banner on a non-interactive screen, only if it does not crowd the UI.
- Interstitials are not part of v1 by default. If later tested, show only at a natural break, apply frequency caps, and never block a core action.
- Rewarded ads are optional and must offer a clear, truthful benefit; no deceptive rewards.
- The app must work normally if ads fail to load or the user is offline.

## Consent, children, and policy

The target age is not finalized. Before monetization, decide whether the app targets children/minors or general college students, review Google Play Families/AdMob policies as applicable, implement consent and privacy choices for the regions served, and update the Data safety form/privacy policy. Do not use personalized advertising for users where it is disallowed or without required consent.

## Release gate

Production build must contain only the owner's real IDs (or ads disabled), have consent flow tested, use test devices/test IDs in QA, and pass current Play/AdMob policy review. Keep an ads-off build flavor for reliable debugging.
