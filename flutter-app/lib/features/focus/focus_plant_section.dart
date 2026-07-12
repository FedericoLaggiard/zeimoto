import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/design/zeimoto_theme.dart';
import '../../domain/plants.dart';
import '../../l10n/app_localizations.dart';

/// FocusPlantSection — feature widget that displays one random plant.
///
/// The random selection is computed once when the widget is inserted in the
/// tree and stays stable for the life of that widget instance.
class FocusPlantSection extends StatefulWidget {
  const FocusPlantSection({
    super.key,
    required this.onTapPlant,
    this.randomIndex,
  });

  final ValueChanged<Plant> onTapPlant;
  final int Function(int max)? randomIndex;

  @override
  State<FocusPlantSection> createState() => _FocusPlantSectionState();
}

class _FocusPlantSectionState extends State<FocusPlantSection> {
  Plant? _selectedPlant;

  @override
  void initState() {
    super.initState();

    final plants = context.read<PlantRepository>().plants;
    if (plants.isEmpty) {
      return;
    }

    final pickIndex = widget.randomIndex ?? (max) => Random().nextInt(max);
    final index = pickIndex(plants.length);
    _selectedPlant = plants[index];
  }

  @override
  Widget build(BuildContext context) {
    final plant = _selectedPlant;
    if (plant == null) {
      return _buildEmpty(context);
    }

    return _FocusPlantCard(plant: plant, onTap: () => widget.onTapPlant(plant));
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

class _FocusPlantCard extends StatelessWidget {
  const _FocusPlantCard({required this.plant, required this.onTap});

  final Plant plant;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 340,
      child: GestureDetector(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
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
      ),
    );
  }
}
