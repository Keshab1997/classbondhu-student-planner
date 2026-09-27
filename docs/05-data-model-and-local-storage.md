# 05 — Data model and local storage

Use stable local IDs (UUIDs or database-generated IDs), UTC timestamps where appropriate, and local timezone-aware class/task times. Decide a schema version and migration policy before the first app build.

**Current implementation note:** v0.1 stores this model as one versioned JSON snapshot so changes are atomic and data survives app restarts. The entity definitions below are the logical model; normalized SQL tables and migrations can replace the snapshot if filtering/reporting needs grow. Do not change the snapshot shape without incrementing and handling `schemaVersion`.

Storage is selected per platform behind the `AppStorage` interface. Android and desktop write the snapshot to SQLite in a single `app_state` row (`SqliteAppStorage`). The web build has no sqflite implementation, so it stores the same JSON snapshot through `shared_preferences`, which is browser local storage (`PreferencesAppStorage`). Web data is a preview convenience only: it lives in one browser profile, is not encrypted, and is not shared with the mobile database.

## Entities

### Subject
- `id`, `name` (user-entered, required), optional `code`, optional `color_key` (theme token, not raw color), `attendance_target` (nullable override), `created_at`, `archived_at` (nullable).

### ScheduleEntry
- `id`, `subject_id`, `weekday` (1–7 with documented convention), `start_minute`, `end_minute`, optional `room`, `active_from`/`active_until` (optional term boundaries).
- A timetable entry is a recurring plan, not proof that a class actually happened.

### AttendanceSession
- `id`, `subject_id`, `scheduled_entry_id` (nullable), local class date, optional start time, `status` (`present` or `absent`), optional note, `created_at`, `updated_at`.
- Only held/recorded sessions count in conducted classes. A canceled class should not create an absent session.
- Enforce duplicate protection for the same subject/date/session; allow a deliberate correction.

### Task
- `id`, `title`, `type` (`assignment`, `quiz`, `exam`, `other`), optional `subject_id`, optional `details`, optional due timestamp, `is_completed`, `completed_at`, optional `reminder_at`, notification ID, `created_at`, `updated_at`.

### UserPreferences
- Selected locale, default attendance target, reminder defaults, first-run completion. Avoid collecting name, college, or email unless a later feature has a clear need.

## Integrity and deletion

Use foreign keys where supported. Deleting a subject should explain what happens to linked schedule, attendance, and tasks; offer archive as the safer default. Back up/restore is deferred, so warn clearly before permanent data deletion.

## Privacy constraints

No attendance, timetable, or task records should be written to logs, crash reports, or analytics. Database encryption is not a v1 requirement unless a threat/privacy review changes that decision; never claim data is encrypted if it is not.
