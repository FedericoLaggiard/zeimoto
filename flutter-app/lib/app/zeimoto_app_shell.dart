import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../core/design/zeimoto_theme.dart';
import '../domain/plants.dart';
import '../features/collection/collection_cubit.dart';
import '../features/collection/collection_section.dart';
import '../features/collection/plant_detail_placeholder.dart';

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
            child: CustomScrollView(
              slivers: [
                // Section title + spacing
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                    child: Text(
                      'La Tua Collezione',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                ),
                // Collection Section carousel
                SliverToBoxAdapter(
                  child: BlocProvider(
                    create: (ctx) => CollectionCubit(ctx.read<PlantRepository>()),
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
                ),
                // Other sections will be added in subsequent issues
                SliverToBoxAdapter(
                  child: Container(
                    // Placeholder for future sections
                  ),
                ),
              ],
            ),
          ),
          // Pinned agent bar
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: AgentBar(height: ZeimotoSpacing.agentBarHeight),
          ),
        ],
      ),
    );
  }
}

/// Agent bar component — pinned at the bottom.
///
/// In A1, it displays a placeholder "Cosa vuoi fare oggi?" and is inert (no actions).
/// It will become operativa in subsequent issues.
class AgentBar extends StatelessWidget {
  final double height;

  const AgentBar({super.key, this.height = ZeimotoSpacing.agentBarHeight});

  @override
  Widget build(BuildContext context) {
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
            // AbsorbPointer + IgnorePointer rendono la barra completamente inerte:
            // nessun focus, nessuna apertura tastiera, nessun evento di input.
            // Verrà reso interattivo in A6.
            child: AbsorbPointer(
              child: IgnorePointer(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Cosa vuoi fare oggi?',
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
          ),
        ],
      ),
    );
  }
}
