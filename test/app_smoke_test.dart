import 'package:classbondhu/app.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('home screen shows ClassBondhu and the main navigation', (tester) async {
    await tester.pumpWidget(const ClassBondhuApp());
    await tester.pumpAndSettle();

    expect(find.text('ClassBondhu'), findsOneWidget);
    expect(find.text('Today'), findsOneWidget);
    expect(find.text('Routine'), findsOneWidget);
    expect(find.text('Attendance'), findsOneWidget);
    expect(find.text('Tasks'), findsOneWidget);
  });
}
