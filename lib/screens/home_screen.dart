import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:zeimoto/services/plant_repository.dart';
import 'package:zeimoto/widgets/plant_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final repo = PlantRepository();
    return Scaffold(
      appBar: AppBar(title: const Text('Bonsai')),
      body: ValueListenableBuilder(
        valueListenable: Hive.box('plants').listenable(),
        builder: (ctx, box, _) {
          final items = repo.all();
          if (items.isEmpty) {
            return const Center(child: Text('Nessuna pianta. Aggiungi con +'));
          }
          return ListView.separated(
            padding: const EdgeInsets.all(12),
            itemCount: items.length,
            separatorBuilder: (context, index) => const SizedBox(height: 8),
            itemBuilder: (ctx, i) {
              final p = items.elementAt(i);
              return PlantCard(
                plant: p,
                onTap: () => context.push('/plant/${p.id}'),
                onOpenGallery: () => context.push('/plant/${p.id}?tab=gallery'),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/add-plant'),
        heroTag: 'add_plant_fab',
        child: const Icon(Icons.add),
      ),
    );
  }
}
