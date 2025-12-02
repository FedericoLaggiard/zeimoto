import 'package:flutter/material.dart';
import 'package:zeimoto/models/plant.dart';
import 'package:zeimoto/models/enums.dart';

class PlantCard extends StatelessWidget {
  final Plant plant;
  final VoidCallback? onTap;
  final VoidCallback? onOpenGallery;
  const PlantCard({super.key, required this.plant, this.onTap, this.onOpenGallery});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              CircleAvatar(child: Text(plant.name.substring(0, 1).toUpperCase())),
              const SizedBox(width: 12),
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(plant.name, style: Theme.of(context).textTheme.titleMedium),
                  Text(plant.species, style: Theme.of(context).textTheme.bodyMedium),
                ]),
              ),
              Row(children: [
                Text(_label(plant.stage)),
                const SizedBox(width: 8),
                IconButton(
                  tooltip: 'Galleria',
                  icon: const Icon(Icons.photo_library),
                  onPressed: onOpenGallery ?? onTap,
                ),
              ]),
            ],
          ),
        ),
      ),
    );
  }

  String _label(WorkStage s) {
    switch (s) {
      case WorkStage.nursery: return 'Nursery';
      case WorkStage.firstSetup: return 'Impostazione';
      case WorkStage.refinement: return 'Rifinitura';
      case WorkStage.mature: return 'Maturo';
    }
  }
}
