# 14 — GitHub Actions workflows

These caller workflows use the reusable workflows in `Keshab1997/flutter-builder`, pinned to the release tag **v1.7.0**. They grant the least permission needed and do not expose repository secrets on ordinary CI runs.

## Workflow inventory

| File | Trigger | What it does |
|---|---|---|
| `.github/workflows/ci.yml` | Push/PR to `main`, or manual dispatch | Runs format setting as configured, analysis, tests, and coverage. No APK/AAB and no release. |
| `.github/workflows/manual-build.yml` | Manual dispatch | Lets a maintainer choose APK or AAB; generates Android runner files in the temporary runner if missing. |
| `.github/workflows/publish-release.yml` | Manual dispatch only | Builds APK/AAB and publishes a GitHub Release. Draft is the default. Requires QA and Android signing secrets first. |
| `.github/workflows/release.yml` | Push a `v*` tag | Builds a signed AAB artifact only; does not publish a GitHub Release. Requires Android signing secrets. |

## Current setup notes

- `ci.yml` temporarily sets `run-format-check: false` because Dart formatting has not yet been run in an environment with Flutter installed. Run `dart format .`, review the diff, then enable the format check.
- CI has no secrets mapped. The build/release workflows pass only the four Android signing secrets by name; no `secrets: inherit` is used.
- The repository currently has no Android platform folder. Manual build/release workflows request generation with `com.keshabstudios`, producing the confirmed app ID `com.keshabstudios.classbondhu` in the temporary build workspace.
- A signed AAB/release requires `ANDROID_KEYSTORE_BASE64`, `KEYSTORE_PASSWORD`, `KEY_ALIAS`, and `KEY_PASSWORD` configured in GitHub Actions secrets. Do not create or commit a keystore in the repo.
- The `publish-release.yml` workflow is manual and draft-first. Do not dispatch it until source, version, privacy/policy review, and signing are ready.
- The `release.yml` tag workflow can run only after pushing a `v*` tag. Do not create a version tag until signing is configured.
- Core app state is currently a UI prototype; successful CI is not evidence that storage, notifications, AdMob, or Play policy requirements are complete.

## Version upgrades

Review changes to the upstream reusable workflows before changing `@v1.7.0`. Prefer a tested release tag or full commit SHA instead of `@main`. Update all four caller files together and review the new permissions, external Actions, and secrets handling.
