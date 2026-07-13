import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../l10n/app_localizations.dart';
import '../../routing/plant_detail_route.dart';
import '../../routing/routes.dart';
import '../../widgets/section_parallax.dart';
import '../ai_assistant/ai_assistant_section.dart';
import '../calendar/calendar_section.dart';
import '../collection/collection_section.dart';
import '../focus/focus_plant_section.dart';
import '../wiki/wiki_del_giorno_section.dart';

/// Vertically-paging container for the 5 home sections.
///
/// Owns a [PageController] and renders a vertical [PageView] with native
/// [PageScrollPhysics] snap.
///
/// Each page slot wraps its title and content in a [SectionParallax] with the
/// depth values taken from the Zeimoto prototype (Variant C):
/// - title depth: `1.35`
/// - content depth: `0.85`
///
/// Page order:
///   0 — AI Assistant (section owns its own title)
///   1 — Collection
///   2 — Calendar
///   3 — Focus Plant
///   4 — Wiki del Giorno
///
/// Sections do not know they live inside a [PageView].
///
/// The controller is accessible via [HomePagerState.controller] — this is the
/// intended test seam (e.g. `tester.state<HomePagerState>(find.byType(HomePager)).controller`).
class HomePager extends StatefulWidget {
  const HomePager({super.key});

  @override
  HomePagerState createState() => HomePagerState();
}

/// Public state to expose [controller] as a test seam.
class HomePagerState extends State<HomePager> {
  late final PageController controller;

  @override
  void initState() {
    super.initState();
    controller = PageController();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Widget _makeTitle(BuildContext context, String text) => Padding(
    padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
    child: Text(text, style: Theme.of(context).textTheme.titleLarge),
  );

  Widget _buildPage(BuildContext context, int index) {
    final l10n = AppLocalizations.of(context)!;

    // Single source of truth for all pages — title + section in one record.
    final pages = <({Widget title, Widget section})>[
      (title: const SizedBox.shrink(), section: const AiAssistantSection()),
      (
        title: _makeTitle(context, l10n.collection_section_title),
        section: CollectionSection(
          onTapPlant: (plant) => PlantDetailRoute(plant).push(context),
          onAddPlant: () => context.push(AppRoutes.addPlant),
        ),
      ),
      (
        title: _makeTitle(context, l10n.calendar_section_title),
        section: const CalendarSection(),
      ),
      (
        title: _makeTitle(context, l10n.focus_plant_section_title),
        section: FocusPlantSection(
          onTapPlant: (plant) => PlantDetailRoute(plant).push(context),
        ),
      ),
      (
        title: _makeTitle(context, l10n.wiki_section_title),
        section: const WikiDelGiornoSection(),
      ),
    ];

    final (:title, :section) = pages[index];

    return Column(
      children: [
        SectionParallax(
          pageController: controller,
          pageIndex: index,
          depth: 1.35,
          child: title,
        ),
        Expanded(
          // ClipRect prevents sections taller than the page from overflowing
          // into the agent bar (spec: "il contenuto viene troncato").
          child: ClipRect(
            child: SectionParallax(
              pageController: controller,
              pageIndex: index,
              depth: 0.85,
              child: OverflowBox(
                alignment: Alignment.topCenter,
                maxHeight: double.infinity,
                child: section,
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: controller,
      scrollDirection: Axis.vertical,
      physics: const PageScrollPhysics(),
      itemCount: 5,
      itemBuilder: _buildPage,
    );
  }
}
