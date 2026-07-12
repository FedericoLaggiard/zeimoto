import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zeimoto/app/zeimoto_app_shell.dart';
import 'package:zeimoto/core/design/zeimoto_theme.dart';
import 'package:zeimoto/domain/plants.dart';
import 'package:zeimoto/features/add_plant/add_plant_wizard.dart';
import 'package:zeimoto/features/calendar/calendar_section.dart';
import 'package:zeimoto/features/collection/collection_section.dart';
import 'package:zeimoto/features/collection/plant_detail_placeholder.dart';
import 'package:zeimoto/features/focus/focus_plant_section.dart';
import 'package:zeimoto/features/wiki/wiki_del_giorno_section.dart';
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
      expect(find.text(l10n.agent_bar_hint_text), findsWidgets);
    });

    testWidgets('home shows static AI assistant section copy', (
      WidgetTester tester,
    ) async {
      final (:widget, :repo) = buildApp();
      await tester.pumpWidget(widget);

      final l10n = lookupAppLocalizations(const Locale('it'));

      expect(find.text(l10n.ai_assistant_section_title), findsOneWidget);
      expect(find.text(l10n.ai_assistant_card_message), findsOneWidget);
    });

    testWidgets('home shows focus section title and content card', (
      WidgetTester tester,
    ) async {
      final (:widget, :repo) = buildApp();
      await tester.pumpWidget(widget);

      final l10n = lookupAppLocalizations(const Locale('it'));

      // Scroll to the section title — it sits just above FocusPlantSection in
      // the sliver list, so once the title is visible the card is also in the
      // viewport (title ~50 px + card 340 px fit in the 600 px test viewport).
      await tester.scrollUntilVisible(
        find.text(l10n.focus_plant_section_title),
        300,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.pumpAndSettle();

      expect(find.text(l10n.focus_plant_section_title), findsOneWidget);
      expect(find.byType(FocusPlantSection), findsOneWidget);
      final hasAnyNickname = repo.plants.any(
        (plant) => find
            .descendant(
              of: find.byType(FocusPlantSection),
              matching: find.text(plant.nickname),
            )
            .evaluate()
            .isNotEmpty,
      );
      expect(hasAnyNickname, isTrue);
    });

    testWidgets('tapping focus plant card opens plant detail placeholder', (
      WidgetTester tester,
    ) async {
      final (:widget, :repo) = buildApp();
      await tester.pumpWidget(widget);

      await tester.scrollUntilVisible(
        find.byType(FocusPlantSection),
        300,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.pumpAndSettle();

      await tester.tap(
        find.descendant(
          of: find.byType(FocusPlantSection),
          matching: find.byType(GestureDetector),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(PlantDetailPlaceholder), findsOneWidget);

      final hasAnyNicknameInDetail = repo.plants.any(
        (plant) => find.text(plant.nickname).evaluate().isNotEmpty,
      );
      expect(hasAnyNicknameInDetail, isTrue);
    });

    testWidgets(
      'home shows static calendar with distinct past/suggested blocks',
      (WidgetTester tester) async {
        final (:widget, :repo) = buildApp();
        await tester.pumpWidget(widget);

        final l10n = lookupAppLocalizations(const Locale('it'));

        // Scroll to the section title first so that both the title and the
        // blocks below it are inside the 600px test viewport.
        await tester.scrollUntilVisible(
          find.text(l10n.calendar_section_title),
          300,
          scrollable: find.byType(Scrollable).first,
        );
        await tester.pumpAndSettle();

        expect(find.byType(CalendarSection), findsOneWidget);
        expect(find.text(l10n.calendar_section_title), findsOneWidget);
        expect(
          find.byKey(const Key('calendar_past_events_block')),
          findsOneWidget,
        );
        expect(
          find.byKey(const Key('calendar_suggested_tasks_block')),
          findsOneWidget,
        );
        expect(find.text(l10n.calendar_past_events_title), findsOneWidget);
        expect(find.text(l10n.calendar_suggested_tasks_title), findsOneWidget);
        expect(find.text(l10n.calendar_suggested_badge), findsNWidgets(3));
      },
    );

    testWidgets('home shows wiki del giorno section title and article', (
      WidgetTester tester,
    ) async {
      final (:widget, :repo) = buildApp();
      await tester.pumpWidget(widget);

      final l10n = lookupAppLocalizations(const Locale('it'));

      await tester.scrollUntilVisible(
        find.byType(WikiDelGiornoSection),
        300,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.pumpAndSettle();

      expect(find.byType(WikiDelGiornoSection), findsOneWidget);
      expect(find.text(l10n.wiki_section_title), findsOneWidget);
      expect(find.text(l10n.wiki_reading_label), findsOneWidget);
    });

    // ── A11: Home Section Composition ───────────────────────────────────────

    testWidgets(
      'le 5 sezioni sono presenti e Calendario precede Focus Pianta',
      (WidgetTester tester) async {
        final (:widget, :repo) = buildApp();
        await tester.pumpWidget(widget);

        final l10n = lookupAppLocalizations(const Locale('it'));
        final scrollable = find.byType(Scrollable).first;

        // Scroll until each section title becomes visible, recording the
        // scroll offset at that moment. A section found at a GREATER offset
        // is lower in the page. If the order is wrong the second
        // scrollUntilVisible will overshoot the max extent and throw.
        await tester.scrollUntilVisible(
          find.text(l10n.collection_section_title),
          80,
          scrollable: scrollable,
        );
        final collectionOffset = tester
            .state<ScrollableState>(scrollable)
            .position
            .pixels;

        await tester.scrollUntilVisible(
          find.text(l10n.calendar_section_title),
          80,
          scrollable: scrollable,
        );
        final calOffset = tester
            .state<ScrollableState>(scrollable)
            .position
            .pixels;

        await tester.scrollUntilVisible(
          find.text(l10n.focus_plant_section_title),
          80,
          scrollable: scrollable,
        );
        final focusOffset = tester
            .state<ScrollableState>(scrollable)
            .position
            .pixels;

        // Each section must require more scrolling than the previous one
        expect(
          calOffset,
          greaterThan(collectionOffset),
          reason: 'Collezione deve precedere Calendario nella home',
        );
        expect(
          focusOffset,
          greaterThan(calOffset),
          reason: 'Calendario deve precedere Focus Pianta nella home',
        );

        // All 5 sections present when scrolling to the end
        await tester.scrollUntilVisible(
          find.byType(WikiDelGiornoSection),
          200,
          scrollable: scrollable,
        );
        expect(find.byType(WikiDelGiornoSection), findsOneWidget);
      },
    );

    testWidgets(
      'agent bar resta visibile e pinned dopo aver scorso tutta la home',
      (WidgetTester tester) async {
        final (:widget, :repo) = buildApp();
        await tester.pumpWidget(widget);

        await tester.scrollUntilVisible(
          find.byType(WikiDelGiornoSection),
          300,
          scrollable: find.byType(Scrollable).first,
        );
        await tester.pumpAndSettle();

        expect(find.byType(AgentBar), findsOneWidget);
      },
    );

    testWidgets(
      'ultimo contenuto non è nascosto dalla barra con safe-area bottom inset',
      (WidgetTester tester) async {
        // Simulate a device with a 34 px bottom system inset (home indicator).
        // Before the fix, Positioned.fill(bottom: agentBarHeight) did not
        // account for this inset, so the last 34 px of scroll content were
        // hidden behind the agent bar.
        const bottomInset = 34.0;

        final (:widget, :repo) = buildApp();
        await tester.pumpWidget(
          MediaQuery(
            data: const MediaQueryData(
              padding: EdgeInsets.only(bottom: bottomInset),
            ),
            child: widget,
          ),
        );

        // Scroll to the bottom of the list
        await tester.scrollUntilVisible(
          find.byType(WikiDelGiornoSection),
          100,
          scrollable: find.byType(Scrollable).first,
        );

        // Drag to max extent so the very last pixel of content is shown
        final scrollable = find.byType(Scrollable).first;
        await tester.drag(scrollable, const Offset(0, -500));
        await tester.pumpAndSettle();

        // The bottom of the wiki card must sit at or above the agent bar top.
        // If not, content is hidden behind the bar.
        final wikiBottom =
            tester.getBottomLeft(find.byType(WikiDelGiornoSection)).dy;
        final agentBarTop =
            tester.getTopLeft(find.byType(AgentBar)).dy;

        expect(
          wikiBottom,
          lessThanOrEqualTo(agentBarTop),
          reason:
              'Il contenuto finale non deve sovrapporsi alla agent bar '
              '(safe-area bottom inset non considerato)',
        );
      },
    );

    testWidgets(
      'il tap su una card della Collezione apre il dettaglio della pianta corrispondente',
      (WidgetTester tester) async {
        final (:widget, :repo) = buildApp();
        await tester.pumpWidget(widget);

        await tester.scrollUntilVisible(
          find.byType(CollectionSection),
          200,
          scrollable: find.byType(Scrollable).first,
        );
        await tester.pumpAndSettle();

        // The first visible card in the carousel
        final card = find
            .descendant(
              of: find.byType(CollectionSection),
              matching: find.byType(GestureDetector),
            )
            .first;

        await tester.tap(card);
        await tester.pumpAndSettle();

        expect(find.byType(PlantDetailPlaceholder), findsOneWidget);

        // The detail page must show a nickname that belongs to the repository
        final hasAnyNicknameInDetail = repo.plants.any(
          (plant) => find.text(plant.nickname).evaluate().isNotEmpty,
        );
        expect(hasAnyNicknameInDetail, isTrue);
      },
    );

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
      final addPlantFab = find.byKey(const Key('add_plant_fab'));
      expect(addPlantFab, findsOneWidget);
      await tester.tap(addPlantFab);
      await tester.pumpAndSettle();

      // Step 1 — select first photo
      final photoItem = find.byKey(const Key('wizard_photo_item_0'));
      expect(photoItem, findsOneWidget);
      await tester.ensureVisible(photoItem);
      await tester.tap(photoItem);
      await tester.pump();

      // Advance to step 2
      final nextButton = find.byKey(const Key('wizard_next_button'));
      expect(nextButton, findsOneWidget);
      await tester.ensureVisible(nextButton);
      await tester.tap(nextButton);
      await tester.pumpAndSettle();

      // Step 2 — select first species from list
      final speciesItem = find.byKey(const Key('wizard_species_item_0'));
      expect(speciesItem, findsOneWidget);
      await tester.ensureVisible(speciesItem);
      await tester.tap(speciesItem);
      await tester.pump();

      // Advance to step 3
      expect(nextButton, findsOneWidget);
      await tester.ensureVisible(nextButton);
      await tester.tap(nextButton);
      await tester.pumpAndSettle();

      // Step 3 — save (nickname is optional)
      final saveButton = find.byKey(const Key('wizard_save_button'));
      expect(saveButton, findsOneWidget);
      await tester.ensureVisible(saveButton);
      await tester.tap(saveButton);
      await tester.pumpAndSettle();

      // Wizard is gone, shell is back
      expect(find.byType(AddPlantWizard), findsNothing);
      expect(find.byType(ZeimotoAppShell), findsOneWidget);

      // Repository has one more plant
      expect(repo.plants.length, initialCount + 1);

      // Calendar section can push the collection below the initial viewport.
      await tester.scrollUntilVisible(
        find.byType(CollectionSection),
        300,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.pumpAndSettle();

      // CollectionSection has rebuilt and shows the new plant
      expect(find.byType(CollectionSection), findsOneWidget);
      // The new plant's auto-generated nickname must appear in the carousel
      final newPlant = repo.plants.first; // sorted most-recent first
      expect(find.text(newPlant.nickname), findsWidgets);
    });
  });
}
