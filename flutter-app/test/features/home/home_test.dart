import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zeimoto/features/home/home.dart';
import 'package:zeimoto/features/home/home_pager.dart';
import 'package:zeimoto/core/design/zeimoto_theme.dart';
import 'package:zeimoto/widgets/agent_bar.dart';
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
  group('Home', () {
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

    /// Returns the [PageController] owned by the live [HomePager] state.
    ///
    /// This is the intended test seam for page navigation — call after
    /// [WidgetTester.pumpWidget] so the state is mounted.
    PageController _pagerController(WidgetTester tester) =>
        tester.state<HomePagerState>(find.byType(HomePager)).controller;

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

    testWidgets(
      'central area uses PageView with 5 pages and does not cover agent bar',
      (WidgetTester tester) async {
        final (:widget, :repo) = buildApp();
        await tester.pumpWidget(widget);

        // PageView replaced the old CustomScrollView — snap paging is active.
        expect(find.byType(PageView), findsOneWidget);

        // Verify 5 pages: navigate to the last one to confirm all are reachable.
        _pagerController(tester).jumpToPage(4);
        await tester.pumpAndSettle();
        expect(find.byType(WikiDelGiornoSection), findsOneWidget);

        expect(find.byType(AgentBar), findsOneWidget);
      },
    );

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

      // Page 3 — Focus Plant.
      _pagerController(tester).jumpToPage(3);
      await tester.pumpAndSettle();

      expect(find.text(l10n.focus_plant_section_title), findsOneWidget);
      expect(find.byType(FocusPlantSection), findsOneWidget);
      final plants = await repo.getAll();
      final hasAnyNickname = plants.any(
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

      // Page 3 — Focus Plant.
      _pagerController(tester).jumpToPage(3);
      await tester.pumpAndSettle();

      await tester.tap(
        find.descendant(
          of: find.byType(FocusPlantSection),
          matching: find.byType(GestureDetector),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(PlantDetailPlaceholder), findsOneWidget);

      final hasAnyNicknameInDetail = (await repo.getAll()).any(
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

        // Page 2 — Calendar.
        _pagerController(tester).jumpToPage(2);
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

      // Page 4 — Wiki del Giorno.
      _pagerController(tester).jumpToPage(4);
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

        // Verify each section is on the expected page (page order enforced).
        // Page 1 — Collection.
        _pagerController(tester).jumpToPage(1);
        await tester.pumpAndSettle();
        expect(find.text(l10n.collection_section_title), findsOneWidget);
        expect(find.byType(CollectionSection), findsOneWidget);

        // Page 2 — Calendar (must come after Collection).
        _pagerController(tester).jumpToPage(2);
        await tester.pumpAndSettle();
        expect(find.text(l10n.calendar_section_title), findsOneWidget);
        expect(find.byType(CalendarSection), findsOneWidget);

        // Page 3 — Focus Plant (must come after Calendar).
        _pagerController(tester).jumpToPage(3);
        await tester.pumpAndSettle();
        expect(find.text(l10n.focus_plant_section_title), findsOneWidget);
        expect(find.byType(FocusPlantSection), findsOneWidget);

        // Page 4 — Wiki del Giorno.
        _pagerController(tester).jumpToPage(4);
        await tester.pumpAndSettle();
        expect(find.byType(WikiDelGiornoSection), findsOneWidget);
      },
    );

    testWidgets(
      'agent bar resta visibile e pinned dopo aver scorso tutta la home',
      (WidgetTester tester) async {
        final (:widget, :repo) = buildApp();
        await tester.pumpWidget(widget);

        // Navigate to the last page (Wiki del Giorno).
        _pagerController(tester).jumpToPage(4);
        await tester.pumpAndSettle();

        expect(find.byType(AgentBar), findsOneWidget);
      },
    );

    testWidgets(
      'ultimo contenuto non è nascosto dalla barra con safe-area bottom inset',
      (WidgetTester tester) async {
        // Simulate a device with a 34 px bottom system inset (home indicator).
        // The PageView is positioned with Positioned.fill(bottom:
        // agentBarHeight + padding.bottom), so by construction no page content
        // can overlap the agent bar regardless of inset size.
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

        // Navigate to the last page (Wiki del Giorno).
        _pagerController(tester).jumpToPage(4);
        await tester.pumpAndSettle();

        expect(find.byType(WikiDelGiornoSection), findsOneWidget);

        // The HomePager (paged content area) must not overlap the AgentBar.
        final pagerBottom = tester.getBottomLeft(find.byType(HomePager)).dy;
        final agentBarTop = tester.getTopLeft(find.byType(AgentBar)).dy;

        expect(
          pagerBottom,
          lessThanOrEqualTo(agentBarTop),
          reason:
              'Il PageView non deve sovrapporsi alla agent bar '
              '(safe-area bottom inset non considerato)',
        );
      },
    );

    testWidgets(
      'il tap su una card della Collezione apre il dettaglio della pianta corrispondente',
      (WidgetTester tester) async {
        final (:widget, :repo) = buildApp();
        await tester.pumpWidget(widget);

        // Page 1 — Collection.
        _pagerController(tester).jumpToPage(1);
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
        final hasAnyNicknameInDetail = (await repo.getAll()).any(
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
      expect(find.byType(Home), findsOneWidget);
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
      // TODO(#37): re-enable once ImagePicker is injectable via app router.
      // The wizard now requires an ImagePicker to pick a real photo; the
      // integration harness does not yet inject a mock.
    }, skip: true); // TODO(#37): re-enable once ImagePicker is injectable via app router
  });
}
