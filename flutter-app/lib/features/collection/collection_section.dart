import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/design/zeimoto_theme.dart';
import '../../domain/plants.dart';
import '../../l10n/app_localizations.dart';
import '../../widgets/plant_cover_photo.dart';
import 'collection_cubit.dart';
import 'collection_state.dart';

/// CollectionSection — feature entry widget for the collection carousel.
///
/// Creates its own [CollectionCubit] via [BlocProvider], reading
/// [PlantRepository] from the ambient [RepositoryProvider].
/// When a plant card is tapped, calls [onTapPlant] callback.
/// When the empty-state CTA is tapped, calls [onAddPlant] callback (if set).
class CollectionSection extends StatelessWidget {
  const CollectionSection({
    super.key,
    required this.onTapPlant,
    this.onAddPlant,
  });

  final ValueChanged<Plant> onTapPlant;
  final VoidCallback? onAddPlant;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (ctx) => CollectionCubit(ctx.read<PlantRepository>()),
      child: _CollectionView(onTapPlant: onTapPlant, onAddPlant: onAddPlant),
    );
  }
}

// ---------------------------------------------------------------------------
// Internal view — consumes CollectionCubit
// ---------------------------------------------------------------------------

class _CollectionView extends StatelessWidget {
  const _CollectionView({required this.onTapPlant, this.onAddPlant});

  final ValueChanged<Plant> onTapPlant;
  final VoidCallback? onAddPlant;

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
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              l10n.collection_empty,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            if (onAddPlant != null) ...[
              const SizedBox(height: 16),
              ElevatedButton(
                key: const Key('collection_add_plant_cta_button'),
                onPressed: onAddPlant,
                child: Text(l10n.collection_add_plant_cta),
              ),
            ],
          ],
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
            // Cover photo
            Expanded(
              child: PlantCoverPhoto(path: plant.coverPhotoPath),
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
