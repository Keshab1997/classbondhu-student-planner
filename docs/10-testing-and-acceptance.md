# 10 — Testing and acceptance

## Test layers

- Pure unit tests: attendance formulas, date sorting, validation, locale formatting boundaries.
- Repository/database tests: create/update/delete, foreign keys, migrations, persistence after restart.
- Widget tests: screen states, language changes, accessible labels, large text.
- Integration/manual tests: complete onboarding, mark/correct attendance, add/edit/complete task, notification behavior, offline use.

## Release acceptance checklist

### Product
- [ ] New user can skip optional setup and return to finish it.
- [ ] Four main tabs work and retain expected state.
- [ ] Attendance percent, required classes, and safe absences match tested rules.
- [ ] Canceled classes are not silently counted absent.
- [ ] User can correct a mistake and history stays consistent.
- [ ] Task reminder is created, updated, and canceled as expected.

### Localization/accessibility
- [ ] All user-visible strings and notifications exist in Bengali, English, Hindi.
- [ ] No overflow or clipped actions on supported screen sizes / 200% font scale.
- [ ] TalkBack can identify controls and statuses; contrast is adequate.
- [ ] Locale changes do not alter entered data.

### Quality/privacy
- [ ] App works offline for all core features.
- [ ] Data remains after force-close/reopen and a test upgrade/migration.
- [ ] No real credentials or production AdMob IDs are committed.
- [ ] Permission denial and ad-load failure are graceful.
- [ ] Privacy policy and Data safety statements match actual SDK behavior.

### Build
- [ ] `flutter analyze` passes.
- [ ] Unit/widget/integration tests pass on CI or documented devices.
- [ ] Release signing is configured outside the repository.
- [ ] Ads disabled or configured with the owner's production IDs and verified consent flow.
