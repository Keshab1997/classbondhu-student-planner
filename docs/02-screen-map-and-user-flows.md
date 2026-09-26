# 02 — Screen map and user flows

## Nine principal screens

1. **Language selection** — Bengali / English / Hindi. Can be skipped only if a sensible device-language default is available; language remains changeable in Settings.
2. **Quick setup** — create the first subjects, choose attendance target, and add or skip timetable setup. Keep this as a short wizard, not a long form.
3. **Today** — today's classes, one-tap attendance actions, attendance warnings, and next deadlines.
4. **Routine** — weekly timetable; add/edit a class; show an empty state when no routine exists.
5. **Attendance** — subject list with percentage, target, and status text.
6. **Subject attendance detail** — counts, target, calculation explanation, and dated attendance history with correction controls.
7. **Tasks** — upcoming, overdue, and completed assignments/exams.
8. **Add/edit task** — title, type, optional subject, due date/time, details, reminder, and save.
9. **Settings** — language, default attendance target, reminder defaults, data/privacy information, and app version.

Subject create/edit can begin as a dialog or bottom sheet from Setup, Routine, and Attendance; promote it to a page only if user testing shows the form is too crowded. The nine-screen count is a planning baseline, not a restriction on accessible navigation.

## Navigation

Persistent bottom navigation (four destinations): **Today · Routine · Attendance · Tasks**. Settings is reached from the app bar/profile control. Use platform back navigation consistently.

## Main flows

### First launch
Language → quick setup → add one or more subjects → optionally add timetable → Today.
Allow “I'll do this later”; never trap a user in setup.

### Record attendance
Today or Subject detail → tap Present/Absent → confirm subject/date/session → update totals immediately → provide a small undo action. Prevent accidental double recording for the same scheduled session; allow editing from history.

### Add a task
Tasks → Add → enter title and due date → choose reminder → Save → task appears in date order and a local notification is scheduled.

### Change language
Settings → Language → choose one of three supported locales → apply immediately and preserve user-entered subject/task text unchanged.

## Essential states for every screen

- Loading (brief, only if needed), empty, normal, validation error, storage error, and permission denied where applicable.
- Destructive delete has confirmation/undo.
- Large text and narrow screens must not clip primary actions.
