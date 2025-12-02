import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:zeimoto/models/plant.dart';
import 'package:zeimoto/models/photo.dart';
import 'package:zeimoto/models/enums.dart';
import 'package:zeimoto/services/intervention_repository.dart';
import 'package:zeimoto/services/photo_service.dart';
import 'package:zeimoto/services/suggestion_service.dart';
import 'package:zeimoto/widgets/photo_grid.dart';
import 'package:zeimoto/widgets/intervention_timeline.dart';
import 'package:zeimoto/widgets/suggestion_banner.dart';
import 'package:zeimoto/screens/wiki_screen.dart';

class PlantDetailScreen extends StatefulWidget {
  final String plantId;
  final int? initialTabIndex;
  const PlantDetailScreen({super.key, required this.plantId, this.initialTabIndex});
  @override
  State<PlantDetailScreen> createState() => _PlantDetailScreenState();
}

class _PlantDetailScreenState extends State<PlantDetailScreen> with TickerProviderStateMixin {
  late final TabController _tab = TabController(length: 4, vsync: this, initialIndex: widget.initialTabIndex ?? 0);
  final _interRepo = InterventionRepository();
  final _photoSvc = PhotoService();
  final _suggest = SuggestionService();

  @override
  Widget build(BuildContext context) {
    final plant = Hive.box('plants').get(widget.plantId) as Plant?;
    if (plant == null) {
      return Scaffold(appBar: AppBar(), body: const Center(child: Text('Pianta non trovata')));
    }
    final photos = Hive.box('photos').values.cast<PhotoEntry>().where((p) => p.plantId == plant.id).toList();
    final interventions = _interRepo.forPlant(plant.id);

    return Scaffold(
      appBar: AppBar(
        title: Text('${plant.name} • ${plant.species}'),
        actions: [
          IconButton(
            tooltip: 'Galleria',
            icon: const Icon(Icons.photo_library),
            onPressed: () => setState(() { _tab.index = 1; }),
          ),
        ],
        bottom: TabBar(
          controller: _tab,
          tabs: const [
            Tab(text: 'Info'),
            Tab(text: 'Galleria'),
            Tab(text: 'Interventi'),
            Tab(text: 'Wiki'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tab,
        children: [
          _InfoTab(plant: plant, onOpenGallery: () => setState(() { _tab.index = 1; })),
          PhotoGrid(photos: photos, onAddFromGallery: () async {
            await _photoSvc.pickAndSave(plant.id, fromCamera: false);
            setState(() { _tab.index = 1; });
          }, onAddFromCamera: () async {
            await _photoSvc.pickAndSave(plant.id, fromCamera: true);
            setState(() { _tab.index = 1; });
          }),
          InterventionTimeline(plantId: plant.id, interventions: interventions),
          WikiScreen(plant: plant),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final choice = await showModalBottomSheet<String>(
            context: context,
            builder: (ctx) => SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(leading: const Icon(Icons.photo_library), title: const Text('Aggiungi da galleria'), onTap: () => Navigator.pop(ctx, 'gallery')),
                  ListTile(leading: const Icon(Icons.camera_alt), title: const Text('Scatta foto'), onTap: () => Navigator.pop(ctx, 'camera')),
                ],
              ),
            ),
          );
          if (choice == 'gallery') {
            await _photoSvc.pickAndSave(plant.id, fromCamera: false);
            setState(() { _tab.index = 1; });
          } else if (choice == 'camera') {
            await _photoSvc.pickAndSave(plant.id, fromCamera: true);
            setState(() { _tab.index = 1; });
          }
        },
        icon: const Icon(Icons.add_a_photo),
        label: const Text('Foto'),
      ),
      bottomNavigationBar: SuggestionBanner(messages: _suggest.suggestionsFor(plant, DateTime.now())),
    );
  }
}

class _InfoTab extends StatelessWidget {
  final Plant plant;
  final VoidCallback onOpenGallery;
  const _InfoTab({required this.plant, required this.onOpenGallery});
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _tile('Specie', plant.species),
        _tile('Grado', _label(plant.stage)),
        _tile('Registrata', plant.createdAt.toLocal().toString().substring(0, 16)),
        const SizedBox(height: 12),
        FilledButton.icon(onPressed: onOpenGallery, icon: const Icon(Icons.photo_library), label: const Text('Apri galleria')),
      ],
    );
  }
  Widget _tile(String title, String value) {
    return ListTile(title: Text(title), subtitle: Text(value));
  }
  String _label(WorkStage s) {
    switch (s) {
      case WorkStage.nursery: return 'Nursery';
      case WorkStage.firstSetup: return 'Prima impostazione';
      case WorkStage.refinement: return 'Rifinitura';
      case WorkStage.mature: return 'Bonsai maturo';
    }
  }
}
