import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/design/zeimoto_theme.dart';
import '../../widgets/agent_bar.dart';
import '../ai_assistant/ai_assistant_section.dart';
import '../calendar/calendar_section.dart';
import '../collection/collection_section.dart';
import '../focus/focus_plant_section.dart';
import '../wiki/wiki_del_giorno_section.dart';
import '../../l10n/app_localizations.dart';
import '../../routing/plant_detail_route.dart';
import '../../routing/routes.dart';

/// Feature Home — schermata principale di Zeimoto.
///
/// Composta da 5 sezioni verticali scrollabili ([AiAssistantSection],
/// [CollectionSection], [CalendarSection], [FocusPlantSection],
/// [WikiDelGiornoSection]), un FAB per aprire il wizard di aggiunta pianta
/// e l'[AgentBar] pinnata in basso.
///
/// Non accetta input: legge il [PlantRepository] ambient via
/// [RepositoryProvider] già montato dal router.
///
/// Navigation: sempre delegata ad [AppRoutes] (ADR-0001, ADR-0004).
class Home extends StatelessWidget {
  const Home({super.key});

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
                      onAddPlant: () => context.push(AppRoutes.addPlant),
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
