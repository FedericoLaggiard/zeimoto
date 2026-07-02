import 'package:flutter_test/flutter_test.dart';

import 'package:zeimoto_prototype/main.dart';

void main() {
  testWidgets('prototype renders variant switcher', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const ZeimotoPrototypeApp());
    await tester.pump();
    expect(find.textContaining('Gallery First'), findsOneWidget);
    expect(find.textContaining('PROTOTYPE'), findsOneWidget);
  });
}
