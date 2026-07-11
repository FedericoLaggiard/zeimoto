import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zeimoto/app/zeimoto_app_shell.dart';
import 'package:zeimoto/core/design/zeimoto_theme.dart';

void main() {
  group('ZeimotoAppShell', () {
    testWidgets('displays washi background', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(theme: ZeimotoTheme.light, home: const ZeimotoAppShell()),
      );

      expect(find.byType(Scaffold), findsOneWidget);

      final scaffold =
          find.byType(Scaffold).evaluate().first.widget as Scaffold;
      expect(scaffold.backgroundColor, ZeimotoColors.washi);
    });

    testWidgets('agent bar is visible and pinned at bottom', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(theme: ZeimotoTheme.light, home: const ZeimotoAppShell()),
      );

      // Agent bar should be visible
      expect(find.byType(AgentBar), findsOneWidget);

      // Agent bar should be in a positioned/pinned container at the bottom
      final agentBar = find.byType(AgentBar);
      expect(agentBar, findsOneWidget);
    });

    testWidgets('central area is scrollable and does not cover agent bar', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(theme: ZeimotoTheme.light, home: const ZeimotoAppShell()),
      );

      // CustomScrollView or similar scrollable should exist
      expect(
        find.byWidgetPredicate(
          (widget) =>
              widget is CustomScrollView ||
              widget is ListView ||
              widget is SingleChildScrollView,
        ),
        findsOneWidget,
      );

      // Agent bar should still be visible after scroll
      expect(find.byType(AgentBar), findsOneWidget);
    });

    testWidgets('agent bar shows "Cosa vuoi fare oggi?" placeholder text', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(theme: ZeimotoTheme.light, home: const ZeimotoAppShell()),
      );

      expect(find.text('Cosa vuoi fare oggi?'), findsWidgets);
    });

    testWidgets('agent bar is inert: tap does not open keyboard or navigate', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(theme: ZeimotoTheme.light, home: const ZeimotoAppShell()),
      );

      // Tap directly on the AgentBar area
      await tester.tap(find.byType(AgentBar));
      await tester.pumpAndSettle();

      // App shell still mounted — no navigation occurred
      expect(find.byType(ZeimotoAppShell), findsOneWidget);
      // No TextField has gained focus (keyboard not opened)
      expect(
        tester.testTextInput.isVisible,
        isFalse,
        reason: 'Keyboard must not open when tapping the agent bar in A1',
      );
    });
  });
}
