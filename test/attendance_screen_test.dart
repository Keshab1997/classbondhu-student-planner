import 'package:classbondhu/app.dart';
import 'package:classbondhu/core/app_controller.dart';
import 'package:classbondhu/core/app_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('adding a subject from the attendance screen saves it and closes cleanly', (tester) async {
    final controller = await AppController.open(MemoryAppStorage());
    await tester.pumpWidget(ClassBondhuApp(controller: controller));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Attendance'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Add subject'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), 'Chemistry');
    await tester.tap(find.widgetWithText(FilledButton, 'Save'));
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(find.byType(AlertDialog), findsNothing);
    expect(controller.subjects.any((subject) => subject.name == 'Chemistry'), isTrue);
    expect(controller.subjects.length, 4);
  });
}
