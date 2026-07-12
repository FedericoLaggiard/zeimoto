import 'package:flutter/material.dart';

import '../core/design/zeimoto_theme.dart';
import '../features/add_plant/add_plant_wizard.dart';
import '../features/collection/collection_section.dart';
import '../features/collection/plant_detail_placeholder.dart';
import '../l10n/app_localizations.dart';

/// App Shell main entry point for Zeimoto MVP.
///
/// Mounts a [Scaffold] with washi background, a scrollable central area,
/// and a pinned agent bar at the bottom.
class ZeimotoAppShell extends StatelessWidget {
  const ZeimotoAppShell({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ZeimotoColors.washi,
      body: Stack(
        children: [
          // Scrollable content area
          Positioned.fill(
            bottom: ZeimotoSpacing
                .agentBarHeight, // Leave space for pinned agent bar
            child: SafeArea(
              bottom: false, // Don't inset from bottom; AgentBar handles it
              child: CustomScrollView(
                slivers: [
                  // Section title
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                      child: Text(
                        AppLocalizations.of(context)!.collectionSectionTitle,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ),
                  ),
                  // Collection Section — owns its own BlocProvider internally
                  SliverToBoxAdapter(
                    child: CollectionSection(
                      onTapPlant: (plant) {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) =>
                                PlantDetailPlaceholder(plant: plant),
                          ),
                        );
                      },
                    ),
                  ),
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

/// Agent bar component — pinned at the bottom.
///
/// In A6, displays an operative agent bar with:
/// - A "Cosa vuoi fare oggi?" placeholder text field (non-interactive, for affordance)
/// - A CTA button ("Nuova Pianta") that opens the plant creation wizard as a full-page route
///
/// Free text input in the field produces no action (no intent detection in this slice).
class AgentBar extends StatelessWidget {
  final double height;

  const AgentBar({super.key, this.height = ZeimotoSpacing.agentBarHeight});

  void _openWizard(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (_) => const AddPlantWizard(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      height: height,
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        border: Border(
          top: BorderSide(
            color: Theme.of(
              context,
            ).colorScheme.onSurface.withValues(alpha: 0.1),
            width: 1,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: ZeimotoSpacing.agentBarShadowColor,
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Expanded(
            // Text field is non-interactive (for visual affordance) — no focus, no keyboard.
            // Free text input is ignored in this slice.
            child: AbsorbPointer(
              child: TextField(
                decoration: InputDecoration(
                  hintText: l10n.agentBarHintText,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withValues(alpha: 0.2),
                    ),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  isDense: true,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          // CTA button: opens the plant creation wizard
          IconButton(
            key: const Key('agent_bar_new_plant_button'),
            icon: const Icon(Icons.add_circle),
            tooltip: l10n.agentBarNewPlantTooltip,
            onPressed: () => _openWizard(context),
          ),
        ],
      ),
    );
  }
}
