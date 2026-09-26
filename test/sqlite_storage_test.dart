import 'dart:io';

import 'package:classbondhu/core/app_controller.dart';
import 'package:classbondhu/core/app_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  test('SQLite store restores subjects, tasks, settings, and attendance', () async {
    final directory = await Directory.systemTemp.createTemp('classbondhu-sqlite-');
    await databaseFactoryFfi.setDatabasesPath(directory.path);
    final store = SqliteAppStorage(databaseName: 'round-trip.db');

    try {
      final first = await AppController.open(store);
      first.addSubject('Chemistry');
      first.addTask(title: 'Read chapter 2', subject: 'Chemistry', dueLabel: 'Next week', type: 'Assignment');
      first.setLanguage(AppLanguage.bn);
      first.markAttendance('math', attendanceKey: 'routine-1', present: true);
      await first.flush();
      await store.close();

      final reopenedStore = SqliteAppStorage(databaseName: 'round-trip.db');
      final reopened = await AppController.open(reopenedStore);
      expect(reopened.subjects.any((subject) => subject.name == 'Chemistry'), isTrue);
      expect(reopened.tasks.any((task) => task.title == 'Read chapter 2'), isTrue);
      expect(reopened.language, AppLanguage.bn);
      expect(reopened.todayAttendance['routine-1'], isTrue);
      await reopenedStore.close();
    } finally {
      await directory.delete(recursive: true);
    }
  });
}
