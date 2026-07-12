import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../core/design/zeimoto_theme.dart';
import '../widgets/agent_bar.dart';
import '../features/ai_assistant/ai_assistant_section.dart';
import '../features/calendar/calendar_section.dart';
import '../features/collection/collection_section.dart';
import '../features/focus/focus_plant_section.dart';
import '../features/wiki/wiki_del_giorno_section.dart';
import '../l10n/app_localizations.dart';
import '../routing/plant_detail_route.dart';
import '../routing/routes.dart';

/// App Shell main entry point for Zeimoto MVP.
///
/// Mounts a [Scaffold] with washi background, a scrollable central area,
/// a pinned agent bar at the bottom, and a FAB that opens the add-plant wizard.
///
/// Navigation is **always** delegated to [AppRoutes] — no direct imports
/// of feature screens live here (see ADR-0001, ADR-0004).
class ZeimotoAppShell extends StatelessWidget {
  const ZeimotoAppShell({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: ZeimotoColors.washi,
      floatingActionButton: Padding(
        // Lift FAB above the pinned agent bar so it doesn't overlap.
        padding: const EdgeInsets.only(bottom: ZeimotoSpacing.agentBarHeight),
        child: FloatingActionButton(
          key: const Key('add_plant_fab'),
          tooltip: l10n.agent_bar_new_plant_tooltip,
          onPressed: () => context.push(AppRoutes.addPlant),
          child: const Icon(Icons.add),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: Stack(
        children: [
          // Scrollable content area — bottom is offset by both the agent bar
          // height and the system bottom inset (home indicator) so content is
          // never hidden behind the pinned bar.
          Positioned.fill(
            bottom:
                ZeimotoSpacing.agentBarHeight +
                MediaQuery.of(context).padding.bottom,
            child: SafeArea(
              bottom: false,
              child: CustomScrollView(
                slivers: [
                  const SliverToBoxAdapter(child: AiAssistantSection()),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                      child: Text(
                        l10n.collection_section_title,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ),
                  ),
                  // Collection Section — owns its own BlocProvider internally.
                  // Navigation to plant detail is delegated to the router.
                  SliverToBoxAdapter(
                    child: CollectionSection(
                      onTapPlant: (plant) =>
                          PlantDetailRoute(plant).push(context),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                      child: Text(
                        l10n.calendar_section_title,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ),
                  ),
                  const SliverToBoxAdapter(child: CalendarSection()),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                      child: Text(
                        l10n.focus_plant_section_title,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: FocusPlantSection(
                      onTapPlant: (plant) =>
                          PlantDetailRoute(plant).push(context),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                      child: Text(
                        l10n.wiki_section_title,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ),
                  ),
                  const SliverToBoxAdapter(child: WikiDelGiornoSection()),
                  const SliverToBoxAdapter(child: SizedBox(height: 16)),
                ],
              ),
            ),
          ),
          // Pinned agent bar
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              top: false,
              child: AgentBar(height: ZeimotoSpacing.agentBarHeight),
            ),
          ),
        ],
      ),
    );
  }
}


