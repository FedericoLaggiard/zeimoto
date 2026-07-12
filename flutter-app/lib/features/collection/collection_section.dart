import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/design/zeimoto_theme.dart';
import '../../domain/plants.dart';
import '../../l10n/app_localizations.dart';
import 'collection_cubit.dart';
import 'collection_state.dart';

/// CollectionSection — feature entry widget for the collection carousel.
///
/// Creates its own [CollectionCubit] via [BlocProvider], reading
/// [PlantRepository] from the ambient [RepositoryProvider].
/// When a plant card is tapped, calls [onTapPlant] callback.
class CollectionSection extends StatelessWidget {
  const CollectionSection({super.key, required this.onTapPlant});

  final ValueChanged<Plant> onTapPlant;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (ctx) => CollectionCubit(ctx.read<PlantRepository>()),
      child: _CollectionView(onTapPlant: onTapPlant),
    );
  }
}

// ---------------------------------------------------------------------------
// Internal view — consumes CollectionCubit
// ---------------------------------------------------------------------------

class _CollectionView extends StatelessWidget {
  const _CollectionView({required this.onTapPlant});

  final ValueChanged<Plant> onTapPlant;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CollectionCubit, CollectionState>(
      builder: (context, state) {
        return switch (state) {
          CollectionLoading() => _buildLoading(),
          CollectionLoaded(plants: final plants) => _buildCarousel(
            context,
            plants,
          ),
          CollectionEmpty() => _buildEmpty(context),
        };
      },
    );
  }

  // ---------------------------------------------------------------------------
  // Build variants
  // ---------------------------------------------------------------------------

  Widget _buildLoading() {
    return const SizedBox(
      height: 340,
      child: Center(child: CircularProgressIndicator()),
    );
  }

  Widget _buildCarousel(BuildContext context, List<Plant> plants) {
    return SizedBox(
      height: 340,
      child: PageView.builder(
        itemCount: plants.length,
        itemBuilder: (ctx, i) {
          final plant = plants[i];
          return _PlantCard(plant: plant, onTap: () => onTapPlant(plant));
        },
      ),
    );
  }

  Widget _buildEmpty(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return SizedBox(
      height: 340,
      child: Center(
        child: Text(
          l10n.collection_empty,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Card widget
// ---------------------------------------------------------------------------

class _PlantCard extends StatelessWidget {
  const _PlantCard({required this.plant, required this.onTap});

  final Plant plant;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Photo placeholder
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [plant.cover.top, plant.cover.bottom],
                  ),
                ),
                child: Center(
                  child: Text(
                    plant.cover.glyph,
                    style: const TextStyle(fontSize: 48),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Plant info
            Text(
              plant.nickname,
              style: Theme.of(context).textTheme.titleMedium,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              plant.species,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontStyle: FontStyle.italic,
                color: ZeimotoColors.charcoalSoft,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
