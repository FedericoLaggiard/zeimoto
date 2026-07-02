// Variant C — "Cover carousel + agent bar"
// App shell: horizontal swipe of large cover cards (PageView), plus a
// persistent input bar "Cosa vuoi fare oggi?" pinned to the bottom.
// Archive = the carousel itself + a small chip strip on top.
// Detail: full-screen swipeable pages between plants.
// Create: dedicated wizard (Foto → Specie → Nickname) as a full-page 3-step flow.
import 'package:flutter/material.dart';

import '../shared/create_widgets.dart';
import '../shared/design.dart';
import '../shared/plant.dart';
import '../shared/plant_store.dart';

class VariantCCarousel extends StatefulWidget {
  const VariantCCarousel({super.key});

  @override
  State<VariantCCarousel> createState() => _VariantCCarouselState();
}

class _VariantCCarouselState extends State<VariantCCarousel> {
  late final PageController _pc = PageController(
    viewportFraction: 0.82,
    initialPage: 0,
  );
  int _current = 0;

  @override
  void initState() {
    super.initState();
    PlantStore.instance.addListener(_onChange);
    _pc.addListener(() {
      final page = _pc.page?.round() ?? 0;
      if (page != _current) setState(() => _current = page);
    });
  }

  @override
  void dispose() {
    PlantStore.instance.removeListener(_onChange);
    _pc.dispose();
    super.dispose();
  }

  void _onChange() => setState(() {});

  @override
  Widget build(BuildContext context) {
    final plants = PlantStore.instance.plants;
    final selected = plants.isNotEmpty
        ? plants[_current.clamp(0, plants.length - 1)]
        : null;

    return Scaffold(
      backgroundColor: ZeimotoColors.washi,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
              child: Row(
                children: [
                  Text(
                    'la tua collezione',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    plants.isEmpty ? '0' : '${_current + 1} / ${plants.length}',
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
                ],
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 12),
              child: Row(
                children: [
                  for (final label in const [
                    'tutte',
                    'shohin',
                    'aceri',
                    'conifere',
                    'in raffinazione',
                  ])
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: Chip(
                        label: Text(label),
                        backgroundColor: ZeimotoColors.washiDeep,
                        side: BorderSide.none,
                      ),
                    ),
                ],
              ),
            ),
            Expanded(
              child: plants.isEmpty
                  ? const Center(child: Text('nessuna pianta'))
                  : PageView.builder(
                      controller: _pc,
                      itemCount: plants.length,
                      itemBuilder: (ctx, i) {
                        final p = plants[i];
                        final active = i == _current;
                        return AnimatedPadding(
                          duration: const Duration(milliseconds: 220),
                          padding: EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: active ? 8 : 32,
                          ),
                          child: GestureDetector(
                            onTap: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) =>
                                    _DetailPagerC(initial: i, plants: plants),
                              ),
                            ),
                            child: _CoverCard(plant: p, active: active),
                          ),
                        );
                      },
                    ),
            ),
            if (selected != null)
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 12, 24, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      selected.nickname,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    Text(
                      selected.species,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ),
            _AgentBar(onCreate: () => _openCreateC(context)),
            const SizedBox(height: 72),
          ],
        ),
      ),
    );
  }
}

class _CoverCard extends StatelessWidget {
  const _CoverCard({required this.plant, required this.active});
  final Plant plant;
  final bool active;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        boxShadow: active
            ? [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.18),
                  blurRadius: 22,
                  offset: const Offset(0, 10),
                ),
              ]
            : const [],
      ),
      child: PhotoTile(photo: plant.cover, borderRadius: 24),
    );
  }
}

class _AgentBar extends StatelessWidget {
  const _AgentBar({required this.onCreate});
  final VoidCallback onCreate;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: ZeimotoColors.washiDeep,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: ZeimotoColors.sage.withValues(alpha: 0.4)),
        ),
        child: Row(
          children: [
            const Icon(
              Icons.auto_awesome_outlined,
              color: ZeimotoColors.moss,
              size: 20,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Cosa vuoi fare oggi?',
                  hintStyle: TextStyle(
                    color: ZeimotoColors.charcoalSoft.withValues(alpha: 0.8),
                  ),
                  border: InputBorder.none,
                  isCollapsed: true,
                ),
              ),
            ),
            IconButton(
              tooltip: 'Nuova pianta',
              icon: const Icon(Icons.add_circle, color: ZeimotoColors.moss),
              onPressed: onCreate,
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailPagerC extends StatelessWidget {
  const _DetailPagerC({required this.initial, required this.plants});
  final int initial;
  final List<Plant> plants;

  @override
  Widget build(BuildContext context) {
    final controller = PageController(initialPage: initial);
    return Scaffold(
      backgroundColor: ZeimotoColors.washi,
      appBar: AppBar(title: const Text('scorri fra le piante')),
      body: PageView.builder(
        controller: controller,
        itemCount: plants.length,
        itemBuilder: (ctx, i) {
          final p = plants[i];
          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 140),
            children: [
              SizedBox(
                height: 420,
                child: PhotoTile(photo: p.cover, borderRadius: 20),
              ),
              const SizedBox(height: 20),
              Text(
                p.nickname,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              Text(
                p.species,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(fontStyle: FontStyle.italic),
              ),
              const SizedBox(height: 16),
              const Text(
                'Timeline · stato · task pending vivranno qui.',
                style: TextStyle(color: ZeimotoColors.charcoalSoft),
              ),
            ],
          );
        },
      ),
    );
  }
}

Future<void> _openCreateC(BuildContext context) async {
  await Navigator.of(context).push(
    MaterialPageRoute(
      fullscreenDialog: true,
      builder: (_) => const _CreateWizardC(),
    ),
  );
}

class _CreateWizardC extends StatefulWidget {
  const _CreateWizardC();

  @override
  State<_CreateWizardC> createState() => _CreateWizardCState();
}

class _CreateWizardCState extends State<_CreateWizardC> {
  final _pc = PageController();
  PlaceholderPhoto? _photo;
  String? _species;
  final _nickname = TextEditingController();
  int _page = 0;

  bool get _canProceed {
    if (_page == 0) return _photo != null;
    if (_page == 1) return _species != null;
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ZeimotoColors.washi,
      appBar: AppBar(
        title: Text('Nuova pianta · passo ${_page + 1}/3'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: PageView(
        controller: _pc,
        physics: const NeverScrollableScrollPhysics(),
        onPageChanged: (i) => setState(() => _page = i),
        children: [
          _StepPage(
            title: 'Una foto per iniziare',
            subtitle: 'La pianta esiste solo se la vedi. Foto obbligatoria.',
            child: PhotoTargetCell(
              photo: _photo,
              height: 320,
              onTap: () => setState(() => _photo = PlaceholderPhoto.random()),
            ),
          ),
          _StepPage(
            title: 'Che specie è?',
            subtitle: 'Serve per contestualizzare consigli e calendario.',
            child: SpeciesPickerField(
              value: _species,
              onChanged: (v) => setState(() => _species = v),
            ),
          ),
          _StepPage(
            title: 'Un nome (opzionale)',
            subtitle: 'Vuoto = auto (es. palmatum_03).',
            child: TextField(
              controller: _nickname,
              decoration: InputDecoration(
                hintText: 'Nickname',
                filled: true,
                fillColor: ZeimotoColors.washiDeep,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 72),
          child: Row(
            children: [
              if (_page > 0)
                TextButton(
                  onPressed: () => _pc.previousPage(
                    duration: const Duration(milliseconds: 220),
                    curve: Curves.easeOut,
                  ),
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
                onPressed: !_canProceed
                    ? null
                    : () {
                        if (_page < 2) {
                          _pc.nextPage(
                            duration: const Duration(milliseconds: 220),
                            curve: Curves.easeOut,
                          );
                          return;
                        }
                        PlantStore.instance.add(
                          species: _species!,
                          nickname: _nickname.text,
                          cover: _photo!,
                        );
                        Navigator.pop(context);
                      },
                child: Text(_page < 2 ? 'Avanti' : 'Salva pianta'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StepPage extends StatelessWidget {
  const _StepPage({
    required this.title,
    required this.subtitle,
    required this.child,
  });
  final String title;
  final String subtitle;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 4),
          Text(subtitle, style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 24),
          child,
        ],
      ),
    );
  }
}
