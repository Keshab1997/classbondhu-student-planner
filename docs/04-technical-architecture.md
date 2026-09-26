# 04 — Technical architecture

## Platform and architecture

- Client: Flutter / Dart; Android first.
- Confirmed Android `applicationId`: `com.keshabstudios.classbondhu`; keep it exactly aligned with Play Console. Treat it as immutable after publishing.
- Architecture: feature-first folders with presentation, application/state, domain, and data boundaries. Keep attendance calculations in pure Dart domain code with unit tests.
- State management: choose one approach before coding (recommended: Riverpod, unless the team already has a maintained alternative); do not mix patterns casually.
- Storage: local SQLite-backed repository for subjects, schedule entries, attendance sessions, and tasks. Use a maintained Flutter plugin and migrations. Preferences (selected locale, defaults) may use a small preferences store.
- Notifications: local notifications only in v1.
- Network: none required for core functionality. AdMob, when approved for integration, is the only planned network-dependent feature in the initial monetization scope.

## Suggested source layout (when code begins)

```text
lib/
  app/                 # app shell, routing, theme, dependency setup
  core/                # shared errors, formatting, database, notifications
  features/
    onboarding/
    today/
    routine/
    attendance/
    tasks/
    settings/
  l10n/                # generated localization; source ARB files
```

## Dependency rules

Widgets must not issue raw SQL. UI calls feature services/repositories; repositories own persistence. Domain logic must not depend on Flutter widgets or AdMob. Keep ad configuration isolated so core features remain buildable with ads disabled.

## Data lifecycle

All v1 academic data stays on the device. On app update, migrations must preserve data. If app data is cleared or the app is uninstalled, data may be lost; communicate this clearly until export/backup exists. Do not add cloud sync without a separate threat model, consent, and privacy update.

## Build hygiene

- Pin compatible package versions and commit the lockfile for the app.
- Keep signing keys, real ad identifiers, and secrets out of source control.
- Document Flutter/Dart versions once chosen.
- Require `flutter analyze` and automated tests before merging implementation changes.
