# 01 — Requirements and scope

## Functional requirements (v1)

### Setup and preferences
- Select Bengali, English, or Hindi; allow changing it later in Settings.
- Create, edit, archive, and delete subjects.
- Configure a default attendance target and optional per-subject target.
- Add/edit weekly timetable entries with weekday, start/end time, subject, and optional room.

### Today and routine
- Show today's scheduled classes in time order and upcoming tasks.
- Show a clear action for recording Present or Absent after a class.
- Allow correcting a mistakenly recorded attendance entry, with confirmation where data is overwritten.
- Show a weekly routine with empty states and timetable editing.

### Attendance
- Display attended classes, conducted classes, percentage, target, and the calculation explanation.
- Show classes required to attend in a row when below target, or the maximum safe absences when at/above target.
- Keep a dated, editable class history. Handle cancellation/holiday without silently counting it as an absence.
- Never imply that the app is an official college record.

### Tasks
- Add/edit/delete an assignment, quiz, exam, or other task.
- Store title, subject (optional), due date/time (optional), details (optional), and completion state.
- Sort by due date; separate upcoming, completed, and overdue items.
- Schedule, update, and cancel local reminders when task details change.

### Reliability and accessibility
- Core data available offline and retained after relaunch.
- Support large text and screen readers; do not use color as the only status signal.
- Ask before destructive actions and offer undo where practical.

## Non-functional requirements

- No login required for core use.
- Keep the UI responsive on entry-level Android devices.
- Store only data needed for the described functions.
- Localization must cover labels, dates, plural forms, empty/error states, and notifications.
- Attendance arithmetic must use tested integer counts and explicit rounding rules.

## Explicitly deferred

Cloud sync/backup, account system, collaboration, timetable import, data export, widgets, iOS launch, analytics, and production ads are out of the first implementation milestone. Revisit only after user testing and privacy review.

## MVP release gate

No public beta until the app has passed the acceptance checklist in `10-testing-and-acceptance.md`, data-loss checks, notification checks on target Android versions, and policy/privacy review in the release docs.
