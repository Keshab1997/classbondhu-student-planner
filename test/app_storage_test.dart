import 'package:classbondhu/core/app_controller.dart';
import 'package:classbondhu/core/app_storage.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('planner state survives controller reload from local storage', () async {
    final storage = MemoryAppStorage();
    final first = await AppController.open(storage);

    first.addSubject('Chemistry');
    first.addTask(title: 'Read chapter 2', subject: 'Chemistry', dueLabel: 'Next week', type: 'Assignment');
    first.setLanguage(AppLanguage.bn);
    await first.flush();

    final reopened = await AppController.open(storage);
    expect(reopened.subjects.any((subject) => subject.name == 'Chemistry'), isTrue);
    expect(reopened.tasks.any((task) => task.title == 'Read chapter 2'), isTrue);
    expect(reopened.language, AppLanguage.bn);
    expect(reopened.attendanceTarget, 75);
  });

  test('attendance changes are included in the persisted snapshot', () async {
    final storage = MemoryAppStorage();
    final controller = await AppController.open(storage);
    final before = controller.subjects.firstWhere((subject) => subject.id == 'math').attended;

    controller.markAttendance('math', attendanceKey: 'routine-1', present: true);
    await controller.flush();

    final reopened = await AppController.open(storage);
    expect(reopened.subjects.firstWhere((subject) => subject.id == 'math').attended, before + 1);
    expect(reopened.todayAttendance['routine-1'], isTrue);
  });
}
