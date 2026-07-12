import 'package:flutter/material.dart';

import '../../domain/plants.dart';

/// Minimal placeholder detail page for a single plant.
///
/// Shows: photo, nickname, species.
/// Navigation: back button.
class PlantDetailPlaceholder extends StatelessWidget {
  const PlantDetailPlaceholder({
    super.key,
    required this.plant,
  });

  final Plant plant;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(onPressed: () => Navigator.of(context).pop()),
        title: Text(plant.nickname),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Photo placeholder
            Container(
              height: 420,
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
                  style: const TextStyle(fontSize: 72),
                ),
              ),
            ),
            const SizedBox(height: 24),
            // Plant info
            Text(
              plant.nickname,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              plant.species,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontStyle: FontStyle.italic,
              ),
            ),
            const SizedBox(height: 24),
            // Placeholder for future rich details
            Text(
              'Dettagli completi disponibili a breve',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
        ),
      ),
    );
  }
}
