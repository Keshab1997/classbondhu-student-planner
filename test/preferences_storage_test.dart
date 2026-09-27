import 'package:classbondhu/core/app_controller.dart';
import 'package:classbondhu/core/app_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  test('preferences store restores subjects, tasks, settings, and attendance', () async {
    final store = PreferencesAppStorage();

    final first = await AppController.open(store);
    first.addSubject('Chemistry');
    first.addTask(title: 'Read chapter 2', subject: 'Chemistry', dueLabel: 'Next week', type: 'Assignment');
    first.setLanguage(AppLanguage.hi);
    first.markAttendance('math', attendanceKey: 'routine-1', present: true);
    await first.flush();

    final reopened = await AppController.open(PreferencesAppStorage());
    expect(reopened.subjects.any((subject) => subject.name == 'Chemistry'), isTrue);
    expect(reopened.tasks.any((task) => task.title == 'Read chapter 2'), isTrue);
    expect(reopened.language, AppLanguage.hi);
    expect(reopened.todayAttendance['routine-1'], isTrue);
  });

  test('preferences store reports no saved state on a fresh browser profile', () async {
    expect(await PreferencesAppStorage().load(), isNull);
  });
}
