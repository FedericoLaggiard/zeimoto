import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zeimoto/app/zeimoto_app_shell.dart';
import 'package:zeimoto/core/design/zeimoto_theme.dart';
import 'package:zeimoto/domain/plants.dart';
import 'package:zeimoto/features/add_plant/add_plant_wizard.dart';
import 'package:zeimoto/features/collection/collection_section.dart';
import 'package:zeimoto/l10n/app_localizations.dart';
import 'package:zeimoto/routing/app_router.dart';

void main() {
  group('ZeimotoAppShell', () {
    /// Builds a fully-wired app using the real GoRouter and a fresh
    /// [InMemoryPlantRepository].  The repository is exposed so tests can
    /// inspect its state independently.
    ({Widget widget, InMemoryPlantRepository repo}) buildApp() {
      final repo = InMemoryPlantRepository();
      final router = buildAppRouter();

      final widget = RepositoryProvider<PlantRepository>.value(
        value: repo,
        child: MaterialApp.router(
          theme: ZeimotoTheme.light,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: const Locale('it'),
          routerConfig: router,
        ),
      );

      return (widget: widget, repo: repo);
    }

    testWidgets('displays washi background', (WidgetTester tester) async {
      final (:widget, :repo) = buildApp();
      await tester.pumpWidget(widget);

      final scaffolds = find.byType(Scaffold);
      expect(scaffolds, findsWidgets);

      final appShellScaffold = tester.firstWidget<Scaffold>(
        find.ancestor(
          of: find.byType(AgentBar),
          matching: find.byType(Scaffold),
        ),
      );
      expect(appShellScaffold.backgroundColor, ZeimotoColors.washi);
    });

    testWidgets('agent bar is visible and pinned at bottom', (
      WidgetTester tester,
    ) async {
      final (:widget, :repo) = buildApp();
      await tester.pumpWidget(widget);

      expect(find.byType(AgentBar), findsOneWidget);
    });

    testWidgets('central area is scrollable and does not cover agent bar', (
      WidgetTester tester,
    ) async {
      final (:widget, :repo) = buildApp();
      await tester.pumpWidget(widget);

      expect(
        find.byWidgetPredicate(
          (w) =>
              w is CustomScrollView ||
              w is ListView ||
              w is SingleChildScrollView,
        ),
        findsOneWidget,
      );

      expect(find.byType(AgentBar), findsOneWidget);
    });

    testWidgets('agent bar shows localized placeholder text', (
      WidgetTester tester,
    ) async {
      final (:widget, :repo) = buildApp();
      await tester.pumpWidget(widget);

      // Verify the localised hint text via AppLocalizations rather than a
      // hard-coded Italian string, so the test stays correct if the ARB value
      // ever changes.
      final l10n = lookupAppLocalizations(const Locale('it'));
      expect(find.text(l10n.agentBarHintText), findsWidgets);
    });

    testWidgets('FAB is visible to trigger wizard', (
      WidgetTester tester,
    ) async {
      final (:widget, :repo) = buildApp();
      await tester.pumpWidget(widget);

      expect(find.byKey(const Key('add_plant_fab')), findsOneWidget);
    });

    testWidgets('tapping FAB opens add-plant wizard as full-page route', (
      WidgetTester tester,
    ) async {
      final (:widget, :repo) = buildApp();
      await tester.pumpWidget(widget);

      expect(find.byType(AddPlantWizard), findsNothing);

      await tester.tap(find.byKey(const Key('add_plant_fab')));
      await tester.pumpAndSettle();

      expect(find.byType(AddPlantWizard), findsOneWidget);
    });

    testWidgets('closing wizard without saving returns to shell', (
      WidgetTester tester,
    ) async {
      final (:widget, :repo) = buildApp();
      await tester.pumpWidget(widget);

      // Open wizard
      await tester.tap(find.byKey(const Key('add_plant_fab')));
      await tester.pumpAndSettle();
      expect(find.byType(AddPlantWizard), findsOneWidget);

      // Close via ✕
      await tester.tap(find.byKey(const Key('wizard_close_button')));
      await tester.pumpAndSettle();

      // Shell and agent bar are back
      expect(find.byType(AddPlantWizard), findsNothing);
      expect(find.byType(ZeimotoAppShell), findsOneWidget);
      expect(find.byType(AgentBar), findsOneWidget);
    });

    testWidgets('agent bar field does not open keyboard', (
      WidgetTester tester,
    ) async {
      final (:widget, :repo) = buildApp();
      await tester.pumpWidget(widget);

      final agentBar = find.byType(AgentBar);
      await tester.tapAt(tester.getCenter(agentBar) - const Offset(40, 0));
      await tester.pumpAndSettle();

      expect(
        tester.testTextInput.isVisible,
        isFalse,
        reason: 'Text field must not accept input (non-interactive affordance)',
      );
    });

    testWidgets('after saving a plant the collection shows the new plant', (
      WidgetTester tester,
    ) async {
      final (:widget, :repo) = buildApp();
      await tester.pumpWidget(widget);

      // Count plants before
      final initialCount = repo.plants.length;

      // Open wizard
      await tester.tap(find.byKey(const Key('add_plant_fab')));
      await tester.pumpAndSettle();

      // Step 1 — select first photo
      await tester.tap(find.byKey(const Key('wizard_photo_item_0')));
      await tester.pump();

      // Advance to step 2
      await tester.tap(find.byKey(const Key('wizard_next_button')));
      await tester.pumpAndSettle();

      // Step 2 — select first species from list
      await tester.tap(find.byKey(const Key('wizard_species_item_0')));
      await tester.pump();

      // Advance to step 3
      await tester.tap(find.byKey(const Key('wizard_next_button')));
      await tester.pumpAndSettle();

      // Step 3 — save (nickname is optional)
      await tester.tap(find.byKey(const Key('wizard_save_button')));
      await tester.pumpAndSettle();

      // Wizard is gone, shell is back
      expect(find.byType(AddPlantWizard), findsNothing);
      expect(find.byType(ZeimotoAppShell), findsOneWidget);

      // Repository has one more plant
      expect(repo.plants.length, initialCount + 1);

      // CollectionSection has rebuilt and shows the new plant
      expect(find.byType(CollectionSection), findsOneWidget);
      // The new plant's auto-generated nickname must appear in the carousel
      final newPlant = repo.plants.first; // sorted most-recent first
      expect(find.text(newPlant.nickname), findsWidgets);
    });
  });
}
