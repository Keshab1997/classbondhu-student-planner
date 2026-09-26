import 'dart:math' as math;

abstract final class AttendanceMath {
  static double percentage({required int attended, required int conducted}) {
    if (conducted <= 0) return 0;
    return attended / conducted;
  }

  /// Returns null when a finite number of classes cannot reach a 100% target.
  static int? classesRequired({required int attended, required int conducted, required int targetPercent}) {
    if (conducted <= 0 || targetPercent <= 0 || targetPercent > 100) return 0;
    final target = targetPercent / 100;
    final current = attended / conducted;
    if (current >= target) return 0;
    if (targetPercent == 100) return null;
    return math.max(0, ((target * conducted - attended) / (1 - target)).ceil());
  }

  static int safeAbsences({required int attended, required int conducted, required int targetPercent}) {
    if (conducted <= 0 || targetPercent <= 0 || targetPercent > 100) return 0;
    final target = targetPercent / 100;
    if (attended / conducted < target) return 0;
    return math.max(0, (attended / target - conducted + 1e-9).floor());
  }
}
