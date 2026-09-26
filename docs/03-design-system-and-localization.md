# 03 — Design system and localization

## Language support

Ship the interface in:
- Bengali — locale `bn` (choose and test the appropriate regional formatting; initial target is Bengali users in India).
- English — locale `en` with India as the initial region where formats require it.
- Hindi — locale `hi`.

Use Flutter's `flutter_localizations`, `intl`, and generated localization resources (`.arb` files with `flutter gen-l10n`). Do not hard-code visible strings in widgets. Add translations for all validation messages, notifications, plurals, accessibility labels, and date/time formats. Have native/fluent speakers review translations before release.

Student-entered content (subject names, assignment titles, room labels) must stay exactly as typed when the UI language changes. Language changes must not translate or rewrite personal data.

## Visual direction

- Friendly, calm, academic—not childish or overly gamified.
- Clear contrast; distinguish attendance states with icon + text, not color alone.
- A compact Today screen with readable class cards and large Present/Absent actions.
- Consistent spacing, type scale, button sizes, and empty-state illustrations.
- Support Android system font scaling and screen readers.

## Initial component inventory

App bar, four-item bottom navigation, subject chip/card, timetable class card, attendance progress/status card, task row, date/time picker form, confirmation dialog, snackbar with undo, empty state, permission explanation, and accessible loading/error states.

## Design acceptance

Review each screen in all three locales. Test long Hindi/Bengali strings, Bengali script shaping, numerals, screen-reader labels, 200% font scale, and small-screen layouts. Do not assume English text width will fit other languages.
