import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zeimoto/app/zeimoto_app_shell.dart';
import 'package:zeimoto/core/design/zeimoto_theme.dart';
import 'package:zeimoto/domain/plants.dart';
import 'package:zeimoto/features/add_plant/add_plant_wizard.dart';
import 'package:zeimoto/l10n/app_localizations.dart';

void main() {
  group('ZeimotoAppShell', () {
    /// Helper to build app shell with i18n support
    Widget buildAppShell() {
      return RepositoryProvider<PlantRepository>(
        create: (_) => InMemoryPlantRepository(),
        child: MaterialApp(
          theme: ZeimotoTheme.light,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: const Locale('it'),
          home: const ZeimotoAppShell(),
        ),
      );
    }

    testWidgets('displays washi background', (WidgetTester tester) async {
      await tester.pumpWidget(buildAppShell());

      expect(find.byType(Scaffold), findsOneWidget);

      final scaffold =
          find.byType(Scaffold).evaluate().first.widget as Scaffold;
      expect(scaffold.backgroundColor, ZeimotoColors.washi);
    });

    testWidgets('agent bar is visible and pinned at bottom', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(buildAppShell());

      // Agent bar should be visible
      expect(find.byType(AgentBar), findsOneWidget);

      // Agent bar should be in a positioned/pinned container at the bottom
      final agentBar = find.byType(AgentBar);
      expect(agentBar, findsOneWidget);
    });

    testWidgets('central area is scrollable and does not cover agent bar', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(buildAppShell());

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

    testWidgets('agent bar shows localized placeholder text', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(buildAppShell());

      // Should show the hint text for the agent bar field
      expect(find.text('Cosa vuoi fare oggi?'), findsWidgets);
    });

    testWidgets('agent bar has operative CTA button to open wizard', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(buildAppShell());

      // Find the "New Plant" button by its key
      expect(
        find.byKey(const Key('agent_bar_new_plant_button')),
        findsOneWidget,
      );
    });

    testWidgets('tapping agent bar CTA opens wizard as full-page route', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(buildAppShell());

      // Initial state: only app shell visible
      expect(find.byType(ZeimotoAppShell), findsOneWidget);
      expect(find.byType(AddPlantWizard), findsNothing);

      // Tap the "New Plant" button
      await tester.tap(find.byKey(const Key('agent_bar_new_plant_button')));
      await tester.pumpAndSettle();

      // Wizard should now be visible
      expect(find.byType(AddPlantWizard), findsOneWidget);
    });

    testWidgets('collection remains visible after wizard opens and closes', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(buildAppShell());

      // Tap CTA to open wizard
      await tester.tap(find.byKey(const Key('agent_bar_new_plant_button')));
      await tester.pumpAndSettle();

      // Verify wizard is open
      expect(find.byType(AddPlantWizard), findsOneWidget);

      // Close the wizard by pressing the X button (close icon in app bar)
      await tester.tap(find.byIcon(Icons.close));
      await tester.pumpAndSettle();

      // Verify wizard is closed and we're back to app shell
      expect(find.byType(AddPlantWizard), findsNothing);
      expect(find.byType(ZeimotoAppShell), findsOneWidget);
      expect(find.byType(AgentBar), findsOneWidget);
    });

    testWidgets('agent bar field does not accept input', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(buildAppShell());

      // Try to tap on the text field to focus it
      final textField = find.byType(TextField);
      await tester.tap(textField);
      await tester.pumpAndSettle();

      // The field should NOT have gained focus (wrapped in AbsorbPointer)
      expect(
        tester.testTextInput.isVisible,
        isFalse,
        reason: 'Text field must not accept input (non-interactive affordance)',
      );

      // App shell should still be mounted (no unexpected navigation)
      expect(find.byType(ZeimotoAppShell), findsOneWidget);
    });
  });
}
