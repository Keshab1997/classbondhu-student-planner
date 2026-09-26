# 06 — Attendance rules and calculations

## Definitions

For a subject:
- `A` = number of recorded Present sessions.
- `T` = number of recorded sessions that actually occurred, Present or Absent.
- `r` = attendance target as a decimal, e.g. 75% is `0.75`.

Canceled, holiday, or not-yet-held classes do not count in `T`. The timetable alone never increments attendance. If `T = 0`, show “No classes recorded yet,” not 0% or 100%.

## Current percentage

`percentage = 100 * A / T`, when `T > 0`.

Display rounded percentage for readability, but keep the underlying integer counts authoritative. State the counts (for example “9 attended out of 12 recorded”) so rounding is transparent.

## Consecutive classes required to reach target

When current attendance is below target and `0 < r < 1`, the minimum consecutive future classes the student must attend is:

`max(0, ceil((r*T - A) / (1-r)))`

If already at/above target, show 0 required. If the target is 100% and attendance is below 100%, say all future classes must be attended; do not divide by zero.

## Maximum additional absences at/above target

When current attendance is at/above target and `r > 0`, the maximum further absences while still meeting the target is:

`max(0, floor(A/r - T))`

Clamp tiny floating-point errors carefully (or use integer/rational arithmetic) so an exact boundary does not display a misleading extra absence. At/below target, do not label any absence “safe.”

## Examples at a 75% target

- 9 attended / 12 recorded = 75%. Maximum additional absences: `floor(9/0.75 - 12) = 0`.
- 10 / 12 is 83.3%. Maximum additional absences: `floor(10/0.75 - 12) = 1`.
- 6 / 10 is 60%. Required consecutive attends: `ceil((0.75*10 - 6)/(1-0.75)) = 6`.

## UX and data handling

- Call the figure an estimate based on entries, not an official institutional record.
- Let users set a different target for each subject.
- Explain calculations and provide edit/undo for a wrong Present/Absent mark.
- Validate `0 < r <= 1`; clearly state what happens if the institution uses a different policy (e.g. practicals or weighted sessions). Weighted attendance is not supported in v1.

## Required tests

Test empty data, exact target, just below/above target, target 100%, 1/1, large counts, corrections, and canceled classes. Test both formula results and user-facing wording.
