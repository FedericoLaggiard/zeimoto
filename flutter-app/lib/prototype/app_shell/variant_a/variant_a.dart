// Variant A — "Griglia zen"
// App shell: no bottom nav, minimal top bar, 2-col photo grid, single FAB.
// Detail: full-bleed cover with parallax, minimal metadata below.
// Create: full-screen scroll — big photo hero first, then species, then nickname.
import 'package:flutter/material.dart';

import '../shared/create_widgets.dart';
import '../shared/design.dart';
import '../shared/plant.dart';
import '../shared/plant_store.dart';

class VariantAGrid extends StatefulWidget {
  const VariantAGrid({super.key});

  @override
  State<VariantAGrid> createState() => _VariantAGridState();
}

class _VariantAGridState extends State<VariantAGrid> {
  @override
  void initState() {
    super.initState();
    PlantStore.instance.addListener(_onChange);
  }

  @override
  void dispose() {
    PlantStore.instance.removeListener(_onChange);
    super.dispose();
  }

  void _onChange() => setState(() {});

  @override
  Widget build(BuildContext context) {
    final plants = PlantStore.instance.plants;
    return Scaffold(
      backgroundColor: ZeimotoColors.washi,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
              sliver: SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'zeimoto',
                      style: Theme.of(context).textTheme.headlineLarge
                          ?.copyWith(fontWeight: FontWeight.w200),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'la tua collezione, silenziosamente.',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 120),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.78,
                ),
                delegate: SliverChildBuilderDelegate(
                  (ctx, i) => _GridCell(plant: plants[i]),
                  childCount: plants.length,
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 64),
        child: FloatingActionButton.extended(
          backgroundColor: ZeimotoColors.moss,
          foregroundColor: Colors.white,
          onPressed: () => _openCreateA(context),
          icon: const Icon(Icons.add),
          label: const Text('Nuova pianta'),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

class _GridCell extends StatelessWidget {
  const _GridCell({required this.plant});
  final Plant plant;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(
        context,
      ).push(MaterialPageRoute(builder: (_) => _DetailA(plant: plant))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Hero(
              tag: 'a_${plant.id}',
              child: PhotoTile(photo: plant.cover, borderRadius: 16),
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Text(
              plant.nickname,
              style: Theme.of(context).textTheme.titleMedium,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Text(
              plant.species,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontStyle: FontStyle.italic,
                fontSize: 12,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailA extends StatelessWidget {
  const _DetailA({required this.plant});
  final Plant plant;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ZeimotoColors.washi,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 420,
            pinned: true,
            backgroundColor: ZeimotoColors.washi,
            iconTheme: const IconThemeData(color: Colors.white),
            flexibleSpace: FlexibleSpaceBar(
              background: Hero(
                tag: 'a_${plant.id}',
                child: PhotoTile(photo: plant.cover, borderRadius: 0),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 120),
            sliver: SliverList.list(
              children: [
                Text(
                  plant.nickname,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 4),
                Text(
                  plant.species,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(fontStyle: FontStyle.italic),
                ),
                const SizedBox(height: 24),
                const _MetaChip(
                  label: 'Stato',
                  value: 'stabile · nessuna nota',
                ),
                const SizedBox(height: 12),
                const _MetaChip(
                  label: 'Ultima osservazione',
                  value: 'nessuna registrata',
                ),
                const SizedBox(height: 12),
                _MetaChip(
                  label: 'Creata',
                  value: plant.createdAt == null
                      ? '—'
                      : '${plant.createdAt!.day}/${plant.createdAt!.month}/${plant.createdAt!.year}',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MetaChip extends StatelessWidget {
  const _MetaChip({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: ZeimotoColors.washiDeep,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 140,
            child: Text(
              label.toUpperCase(),
              style: Theme.of(context).textTheme.labelSmall,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: ZeimotoColors.charcoal,
                fontSize: 15,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Future<void> _openCreateA(BuildContext context) async {
  await Navigator.of(context).push(
    MaterialPageRoute(
      fullscreenDialog: true,
      builder: (_) => const _CreatePlantScreenA(),
    ),
  );
}

class _CreatePlantScreenA extends StatefulWidget {
  const _CreatePlantScreenA();

  @override
  State<_CreatePlantScreenA> createState() => _CreatePlantScreenAState();
}

class _CreatePlantScreenAState extends State<_CreatePlantScreenA> {
  PlaceholderPhoto? _photo;
  String? _species;
  final _nickname = TextEditingController();

  bool get _canSave => _photo != null && _species != null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ZeimotoColors.washi,
      appBar: AppBar(
        title: const Text('Nuova pianta'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 140),
          children: [
            PhotoTargetCell(
              photo: _photo,
              onTap: () => setState(() => _photo = PlaceholderPhoto.random()),
            ),
            const SizedBox(height: 20),
            SpeciesPickerField(
              value: _species,
              onChanged: (v) => setState(() => _species = v),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _nickname,
              decoration: InputDecoration(
                labelText: 'Nickname (opzionale)',
                helperText: 'Vuoto = auto (es. palmatum_03)',
                filled: true,
                fillColor: ZeimotoColors.washiDeep,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 72),
          child: FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: ZeimotoColors.moss,
              minimumSize: const Size.fromHeight(56),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            onPressed: _canSave
                ? () {
                    PlantStore.instance.add(
                      species: _species!,
                      nickname: _nickname.text,
                      cover: _photo!,
                    );
                    Navigator.pop(context);
                  }
                : null,
            child: const Text('Salva pianta'),
          ),
        ),
      ),
    );
  }
}
