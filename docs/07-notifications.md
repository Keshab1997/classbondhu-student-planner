# 07 — Notifications

## v1 notification types

- Optional class reminder before a scheduled class.
- Optional task reminder at a user-selected time before an assignment/exam deadline.

Defaults should be conservative and configurable; do not send notifications the user has not enabled. Do not place sensitive details in lock-screen text by default; allow a privacy-friendly notification setting.

## Behavior

- Explain why notification permission is useful before requesting it.
- Ask permission at the moment the user enables a reminder, not on first launch without context.
- Reschedule when time/date changes; cancel when reminder is disabled, task completed, or task deleted.
- Handle Android notification permission requirements and exact-alarm restrictions for the target OS versions. Use inexact scheduling unless exact timing is essential and policy permits it.
- If permission is denied, keep the reminder saved and show a clear way to enable permission in system settings.
- Reconcile pending notifications after app updates/restart where the plugin/platform requires it.

## Localization and tests

Localize title/body in Bengali, English, Hindi. Test permission denied, notification tapped, edited/deleted tasks, daylight-saving/timezone changes, reboot behavior where supported, and duplicate prevention.
