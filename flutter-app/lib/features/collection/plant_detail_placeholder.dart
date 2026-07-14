import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../domain/plants.dart';
import '../../l10n/app_localizations.dart';
import '../../widgets/plant_cover_photo.dart';

/// Minimal placeholder detail page for a single plant.
///
/// Shows: photo, nickname, species.
/// Navigation: back button.
class PlantDetailPlaceholder extends StatelessWidget {
  const PlantDetailPlaceholder({super.key, required this.plant});

  final Plant plant;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(onPressed: () => context.pop()),
        title: Text(plant.nickname),
      ),
      body: SafeArea(
        top: false, // AppBar handles the top inset
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Cover photo
              SizedBox(
                height: 420,
                child: PlantCoverPhoto(
                  path: plant.coverPhotoPath,
                  iconSize: 72,
                ),
              ),
              const SizedBox(height: 24),
              // Species only — nickname already shown in AppBar title
              Text(
                plant.species,
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge?.copyWith(fontStyle: FontStyle.italic),
              ),
              const SizedBox(height: 24),
              // Placeholder for future rich details
              Text(
                AppLocalizations.of(context)!.plant_detail_coming_soon,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
