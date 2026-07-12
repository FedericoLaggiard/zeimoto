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
/// Owns a [PageController] (or accepts an injected one via [controller]) and
/// renders a vertical [PageView] with native [PageScrollPhysics] snap.
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
/// The [controller] parameter exists exclusively for widget testing; production
/// code never passes it.  Sections do not know they live inside a [PageView].
class HomePager extends StatefulWidget {
  const HomePager({super.key, this.controller});

  /// Optional [PageController] for test injection.
  /// When `null`, [HomePager] creates and owns its own controller.
  final PageController? controller;

  @override
  State<HomePager> createState() => _HomePagerState();
}

class _HomePagerState extends State<HomePager> {
  late final PageController _controller;
  late final bool _ownsController;

  @override
  void initState() {
    super.initState();
    _ownsController = widget.controller == null;
    _controller = widget.controller ?? PageController();
  }

  @override
  void dispose() {
    if (_ownsController) _controller.dispose();
    super.dispose();
  }

  Widget _titleFor(BuildContext context, int index) {
    final l10n = AppLocalizations.of(context)!;
    // Page 0 (AI Assistant) already contains its own title.
    if (index == 0) return const SizedBox.shrink();

    final titles = [
      '',
      l10n.collection_section_title,
      l10n.calendar_section_title,
      l10n.focus_plant_section_title,
      l10n.wiki_section_title,
    ];
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
      child: Text(
        titles[index],
        style: Theme.of(context).textTheme.titleLarge,
      ),
    );
  }

  Widget _sectionFor(BuildContext context, int index) {
    switch (index) {
      case 0:
        return const AiAssistantSection();
      case 1:
        return CollectionSection(
          onTapPlant: (plant) => PlantDetailRoute(plant).push(context),
          onAddPlant: () => context.push(AppRoutes.addPlant),
        );
      case 2:
        return const CalendarSection();
      case 3:
        return FocusPlantSection(
          onTapPlant: (plant) => PlantDetailRoute(plant).push(context),
        );
      case 4:
        return const WikiDelGiornoSection();
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildPage(BuildContext context, int index) {
    return Column(
      children: [
        SectionParallax(
          pageController: _controller,
          pageIndex: index,
          depth: 1.35,
          child: _titleFor(context, index),
        ),
        Expanded(
          // ClipRect prevents sections taller than the page from overflowing
          // into the agent bar (spec: "il contenuto viene troncato").
          child: ClipRect(
            child: SectionParallax(
              pageController: _controller,
              pageIndex: index,
              depth: 0.85,
              child: OverflowBox(
                alignment: Alignment.topCenter,
                maxHeight: double.infinity,
                child: _sectionFor(context, index),
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
      controller: _controller,
      scrollDirection: Axis.vertical,
      physics: const PageScrollPhysics(),
      itemCount: 5,
      itemBuilder: _buildPage,
    );
  }
}
