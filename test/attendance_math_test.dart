import 'package:flutter_test/flutter_test.dart';
import 'package:classbondhu/core/attendance_math.dart';

void main() {
  group('AttendanceMath', () {
    test('returns the current ratio', () {
      expect(AttendanceMath.percentage(attended: 9, conducted: 12), 0.75);
    });

    test('does not divide by zero when no sessions exist', () {
      expect(AttendanceMath.percentage(attended: 0, conducted: 0), 0);
      expect(AttendanceMath.classesRequired(attended: 0, conducted: 0, targetPercent: 75), 0);
    });

    test('calculates consecutive classes needed to reach target', () {
      expect(AttendanceMath.classesRequired(attended: 6, conducted: 10, targetPercent: 75), 6);
    });

    test('calculates safe absences at and above target', () {
      expect(AttendanceMath.safeAbsences(attended: 9, conducted: 12, targetPercent: 75), 0);
      expect(AttendanceMath.safeAbsences(attended: 10, conducted: 12, targetPercent: 75), 1);
    });

    test('handles a 100 percent target without division by zero', () {
      expect(AttendanceMath.classesRequired(attended: 9, conducted: 10, targetPercent: 100), isNull);
      expect(AttendanceMath.classesRequired(attended: 10, conducted: 10, targetPercent: 100), 0);
    });
  });
}
