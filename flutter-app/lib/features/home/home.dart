import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/design/zeimoto_theme.dart';
import '../../widgets/agent_bar.dart';
import '../../l10n/app_localizations.dart';
import '../../routing/routes.dart';
import 'home_pager.dart';

/// Feature Home — schermata principale di Zeimoto.
///
/// Ospita [HomePager] (5 sezioni a snap verticale con effetto parallasse),
/// un FAB per aprire il wizard di aggiunta pianta e l'[AgentBar] pinnata
/// in basso.
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
          // Paged content area — bottom is offset by both the agent bar
          // height and the system bottom inset (home indicator) so content is
          // never hidden behind the pinned bar.
          Positioned.fill(
            bottom:
                ZeimotoSpacing.agentBarHeight +
                MediaQuery.of(context).padding.bottom,
            child: SafeArea(bottom: false, child: HomePager()),
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
