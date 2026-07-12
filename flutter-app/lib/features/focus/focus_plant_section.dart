import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/design/zeimoto_theme.dart';
import '../../domain/plants.dart';
import '../../l10n/app_localizations.dart';
import 'focus_cubit.dart';
import 'focus_state.dart';

/// FocusPlantSection — feature entry widget for the focus-plant display.
///
/// Creates its own [FocusCubit] via [BlocProvider], reading
/// [PlantRepository] from the ambient [RepositoryProvider].
/// When the plant card is tapped, calls [onTapPlant] callback.
class FocusPlantSection extends StatelessWidget {
  const FocusPlantSection({super.key, required this.onTapPlant});

  final ValueChanged<Plant> onTapPlant;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (ctx) => FocusCubit(ctx.read<PlantRepository>()),
      child: _FocusView(onTapPlant: onTapPlant),
    );
  }
}

// ---------------------------------------------------------------------------
// Internal view — consumes FocusCubit
// ---------------------------------------------------------------------------

class _FocusView extends StatelessWidget {
  const _FocusView({required this.onTapPlant});

  final ValueChanged<Plant> onTapPlant;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FocusCubit, FocusState>(
      builder: (context, state) {
        return switch (state) {
          FocusLoading() => _buildLoading(),
          FocusLoaded(plant: final plant) => _buildCard(plant),
          FocusEmpty() => _buildEmpty(context),
        };
      },
    );
  }

  Widget _buildLoading() {
    return const SizedBox(
      height: 340,
      child: Center(child: CircularProgressIndicator()),
    );
  }

  Widget _buildCard(Plant plant) {
    return SizedBox(
      height: 340,
      child: _FocusPlantCard(plant: plant, onTap: () => onTapPlant(plant)),
    );
  }

  Widget _buildEmpty(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return SizedBox(
      height: 340,
      child: Center(
        child: Text(
          l10n.focus_plant_empty,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Card widget — identical visual style to CollectionSection's _PlantCard
// ---------------------------------------------------------------------------

class _FocusPlantCard extends StatelessWidget {
  const _FocusPlantCard({required this.plant, required this.onTap});

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
            // Photo placeholder — gradient + glyph, identical to CollectionSection
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
