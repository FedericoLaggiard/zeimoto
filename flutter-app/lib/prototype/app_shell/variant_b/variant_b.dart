// Variant B — "Feed verticale + bottom nav"
// App shell: bottom nav (Piante/Home/Calendario/Chat), single-column tall
// photo cards like a considered feed. "+" in nav center.
// Detail: cards-based sections.
// Create: modal bottom-sheet stepper (photo → species → conferma).
import 'package:flutter/material.dart';

import '../shared/create_widgets.dart';
import '../shared/design.dart';
import '../shared/plant.dart';
import '../shared/plant_store.dart';

class VariantBFeed extends StatefulWidget {
  const VariantBFeed({super.key});

  @override
  State<VariantBFeed> createState() => _VariantBFeedState();
}

class _VariantBFeedState extends State<VariantBFeed> {
  int _tab = 1;

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
    return Scaffold(
      backgroundColor: ZeimotoColors.washi,
      appBar: AppBar(
        title: Text(
          _tab == 0 ? 'Archivio Piante' : 'Zeimoto',
          style: Theme.of(
            context,
          ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w400),
        ),
        actions: [IconButton(icon: const Icon(Icons.search), onPressed: () {})],
      ),
      body: IndexedStack(
        index: _tab,
        children: [
          _FeedList(onOpen: (p) => _openDetailB(context, p)),
          const _HomePlaceholder(),
          const _StubTab(label: 'Calendario'),
          const _StubTab(label: 'Chat'),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 44),
        child: NavigationBar(
          backgroundColor: ZeimotoColors.washi,
          indicatorColor: ZeimotoColors.sage.withValues(alpha: 0.3),
          selectedIndex: _tab,
          onDestinationSelected: (i) {
            if (i == 4) {
              _openCreateB(context);
              return;
            }
            setState(() => _tab = i);
          },
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.grid_view_outlined),
              selectedIcon: Icon(Icons.grid_view),
              label: 'Piante',
            ),
            NavigationDestination(
              icon: Icon(Icons.spa_outlined),
              selectedIcon: Icon(Icons.spa),
              label: 'Home',
            ),
            NavigationDestination(
              icon: Icon(Icons.calendar_today_outlined),
              label: 'Calendario',
            ),
            NavigationDestination(
              icon: Icon(Icons.forum_outlined),
              label: 'Chat',
            ),
            NavigationDestination(
              icon: Icon(Icons.add_circle_outline),
              label: 'Nuova',
            ),
          ],
        ),
      ),
    );
  }
}

class _FeedList extends StatelessWidget {
  const _FeedList({required this.onOpen});
  final ValueChanged<Plant> onOpen;

  @override
  Widget build(BuildContext context) {
    final plants = PlantStore.instance.plants;
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 140),
      itemCount: plants.length,
      separatorBuilder: (_, __) => const SizedBox(height: 16),
      itemBuilder: (ctx, i) {
        final p = plants[i];
        return GestureDetector(
          onTap: () => onOpen(p),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Container(
              color: ZeimotoColors.washiDeep,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 340,
                    child: PhotoTile(photo: p.cover, borderRadius: 0),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                p.nickname,
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              const SizedBox(height: 2),
                              Text(
                                p.species,
                                style: Theme.of(context).textTheme.bodyMedium
                                    ?.copyWith(fontStyle: FontStyle.italic),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: ZeimotoColors.sage.withValues(alpha: 0.25),
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: const Text(
                            'stabile',
                            style: TextStyle(
                              fontSize: 11,
                              color: ZeimotoColors.moss,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _HomePlaceholder extends StatelessWidget {
  const _HomePlaceholder();
  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(24),
      child: Text(
        'Home — “Cosa vuoi fare oggi?” vive qui.\n(stub prototype)',
        style: TextStyle(color: ZeimotoColors.charcoalSoft),
      ),
    );
  }
}

class _StubTab extends StatelessWidget {
  const _StubTab({required this.label});
  final String label;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        '$label — stub',
        style: const TextStyle(color: ZeimotoColors.charcoalSoft),
      ),
    );
  }
}

Future<void> _openDetailB(BuildContext context, Plant plant) async {
  await Navigator.of(context).push(
    MaterialPageRoute(
      builder: (_) => Scaffold(
        backgroundColor: ZeimotoColors.washi,
        appBar: AppBar(title: Text(plant.nickname)),
        body: ListView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 140),
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child: SizedBox(
                height: 260,
                child: PhotoTile(photo: plant.cover, borderRadius: 0),
              ),
            ),
            const SizedBox(height: 20),
            _Card(title: 'Specie', content: plant.species),
            _Card(title: 'Nickname', content: plant.nickname),
            _Card(
              title: 'Stato',
              content: 'stabile · nessuna proposta AI pending',
            ),
          ],
        ),
      ),
    ),
  );
}

class _Card extends StatelessWidget {
  const _Card({required this.title, required this.content});
  final String title;
  final String content;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ZeimotoColors.washiDeep,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title.toUpperCase(),
            style: Theme.of(context).textTheme.labelSmall,
          ),
          const SizedBox(height: 6),
          Text(
            content,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: ZeimotoColors.charcoal,
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }
}

Future<void> _openCreateB(BuildContext context) async {
  await showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => const _CreateSheetB(),
  );
}

class _CreateSheetB extends StatefulWidget {
  const _CreateSheetB();

  @override
  State<_CreateSheetB> createState() => _CreateSheetBState();
}

class _CreateSheetBState extends State<_CreateSheetB> {
  int _step = 0;
  PlaceholderPhoto? _photo;
  String? _species;
  final _nickname = TextEditingController();

  bool get _canNext {
    if (_step == 0) return _photo != null;
    if (_step == 1) return _species != null;
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final steps = ['Foto', 'Specie', 'Conferma'];
    return Container(
      decoration: const BoxDecoration(
        color: ZeimotoColors.washi,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 4,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: ZeimotoColors.charcoalSoft.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              for (int i = 0; i < steps.length; i++) ...[
                _StepDot(index: i, current: _step, label: steps[i]),
                if (i < steps.length - 1)
                  const Expanded(
                    child: Divider(color: ZeimotoColors.charcoalSoft),
                  ),
              ],
            ],
          ),
          const SizedBox(height: 20),
          if (_step == 0)
            PhotoTargetCell(
              photo: _photo,
              onTap: () => setState(() => _photo = PlaceholderPhoto.random()),
              hint: 'Scatta o importa (obbligatoria)',
            ),
          if (_step == 1) ...[
            SpeciesPickerField(
              value: _species,
              onChanged: (v) => setState(() => _species = v),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _nickname,
              decoration: InputDecoration(
                labelText: 'Nickname (opzionale)',
                filled: true,
                fillColor: ZeimotoColors.washiDeep,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ],
          if (_step == 2 && _photo != null && _species != null)
            _ConfirmPanel(
              photo: _photo!,
              species: _species!,
              nickname: _nickname.text,
            ),
          const SizedBox(height: 20),
          Row(
            children: [
              if (_step > 0)
                TextButton(
                  onPressed: () => setState(() => _step--),
                  child: const Text('Indietro'),
                ),
              const Spacer(),
              FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: ZeimotoColors.moss,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 28,
                    vertical: 14,
                  ),
                ),
                onPressed: !_canNext
                    ? null
                    : () {
                        if (_step < 2) {
                          setState(() => _step++);
                          return;
                        }
                        PlantStore.instance.add(
                          species: _species!,
                          nickname: _nickname.text,
                          cover: _photo!,
                        );
                        Navigator.pop(context);
                      },
                child: Text(_step < 2 ? 'Avanti' : 'Salva pianta'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StepDot extends StatelessWidget {
  const _StepDot({
    required this.index,
    required this.current,
    required this.label,
  });
  final int index;
  final int current;
  final String label;

  @override
  Widget build(BuildContext context) {
    final active = index <= current;
    return Column(
      children: [
        CircleAvatar(
          radius: 12,
          backgroundColor: active
              ? ZeimotoColors.moss
              : ZeimotoColors.washiDeep,
          child: Text(
            '${index + 1}',
            style: TextStyle(
              color: active ? Colors.white : ZeimotoColors.charcoalSoft,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: active ? ZeimotoColors.charcoal : ZeimotoColors.charcoalSoft,
          ),
        ),
      ],
    );
  }
}

class _ConfirmPanel extends StatelessWidget {
  const _ConfirmPanel({
    required this.photo,
    required this.species,
    required this.nickname,
  });
  final PlaceholderPhoto photo;
  final String species;
  final String nickname;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 96,
          height: 96,
          child: PhotoTile(photo: photo, borderRadius: 12),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(species, style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 4),
              Text(
                nickname.trim().isEmpty ? '(nickname auto)' : nickname.trim(),
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 6),
              Text(
                'Pronta al salvataggio',
                style: Theme.of(
                  context,
                ).textTheme.labelSmall?.copyWith(color: ZeimotoColors.moss),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
