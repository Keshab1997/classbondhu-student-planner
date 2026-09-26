# 12 — Implementation roadmap (serial order)

Complete in sequence; do not begin production monetization before core behavior and policy decisions are settled.

## Phase 0 — Product decisions and setup
- [ ] Confirm audience/age policy, Android minimum, application ID owner, and final name.
- [ ] Create Flutter project, Git conventions, CI checks, and localization generation.
- [ ] Add a minimal design system and navigation shell.

## Phase 1 — Foundations
- [ ] Configure Bengali/English/Hindi ARB localizations.
- [ ] Implement local database, schema versioning, and repositories.
- [ ] Add accessible theme, routing, and Settings preferences.

## Phase 2 — Subjects and timetable
- [ ] Subject create/edit/archive.
- [ ] Weekly schedule create/edit/delete.
- [ ] Routine screen and Today schedule view.

## Phase 3 — Attendance
- [ ] Attendance session recording, undo/correction, and history.
- [ ] Pure Dart attendance calculator with boundary tests.
- [ ] Attendance summary/detail screens and transparent explanation.

## Phase 4 — Tasks and reminders
- [ ] Task CRUD, filtering/sorting, completion state.
- [ ] Local notifications, permission rationale, and rescheduling tests.

## Phase 5 — Hardening and beta
- [ ] Complete test matrix and acceptance checklist.
- [ ] Accessibility/localization review by fluent speakers.
- [ ] Backup/migration/data-loss checks and small closed beta.

## Phase 6 — Monetization (optional, after policy review)
- [ ] Decide target age and ad/consent treatment.
- [ ] Integrate AdMob behind a feature flag using test IDs.
- [ ] Verify placements, frequency caps, offline behavior, and consent.
- [ ] Add owner's production IDs only after the AdMob account is ready.

## Phase 7 — Store release
- [ ] Finalize package ID, signing, privacy policy, store assets, declarations.
- [ ] Build signed AAB; internal → closed → staged production rollout.
- [ ] Update docs for actual shipped behavior.

## Definition of done for each phase

Acceptance criteria are met, tests pass, localization is complete for new UI, privacy/security implications are documented, and relevant docs are updated in the same change. No phase is complete solely because it compiles.
