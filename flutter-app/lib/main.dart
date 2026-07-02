import 'package:flutter/material.dart';

void main() {
  runApp(const ZeimotoPrototypeApp());
}

class ZeimotoPrototypeApp extends StatelessWidget {
  const ZeimotoPrototypeApp({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: const Color(0xFF7B9A7A),
      brightness: Brightness.light,
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Zeimoto Prototype',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: colorScheme,
        scaffoldBackgroundColor: const Color(0xFFF6F1E8),
      ),
      home: const PrototypeHomePage(),
    );
  }
}

enum ArchiveVariant {
  a('A', 'Gallery First'),
  b('B', 'Calm Dashboard'),
  c('C', 'Wizard Entry');

  const ArchiveVariant(this.keyName, this.label);

  final String keyName;
  final String label;
}

class PrototypePlant {
  final String nickname;
  final String species;
  final String note;

  const PrototypePlant({
    required this.nickname,
    required this.species,
    required this.note,
  });
}

class PrototypeHomePage extends StatefulWidget {
  const PrototypeHomePage({super.key});

  @override
  State<PrototypeHomePage> createState() => _PrototypeHomePageState();
}

class _PrototypeHomePageState extends State<PrototypeHomePage> {
  ArchiveVariant _variant = ArchiveVariant.a;
  final List<PrototypePlant> _plants = const [
    PrototypePlant(
      nickname: 'acero_1',
      species: 'Acero giapponese',
      note: 'Riferimento visivo forte, impostazione classica.',
    ),
    PrototypePlant(
      nickname: 'ginepro_1',
      species: 'Ginepro cinese',
      note: 'Pianta pronta per una sessione di filo leggera.',
    ),
    PrototypePlant(
      nickname: 'fico_1',
      species: 'Ficus microcarpa',
      note: 'Buona candidata per testare un flusso a basso attrito.',
    ),
  ];

  String? _selectedSpecies;
  bool _hasPhoto = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SafeArea(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 220),
              child: switch (_variant) {
                ArchiveVariant.a => _VariantGalleryFirst(
                  key: const ValueKey('variant-a'),
                  plants: _plants,
                  selectedSpecies: _selectedSpecies,
                  hasPhoto: _hasPhoto,
                  onSpeciesChanged: _onSpeciesChanged,
                  onTogglePhoto: _onTogglePhoto,
                ),
                ArchiveVariant.b => _VariantCalmDashboard(
                  key: const ValueKey('variant-b'),
                  plants: _plants,
                  selectedSpecies: _selectedSpecies,
                  hasPhoto: _hasPhoto,
                  onSpeciesChanged: _onSpeciesChanged,
                  onTogglePhoto: _onTogglePhoto,
                ),
                ArchiveVariant.c => _VariantWizardEntry(
                  key: const ValueKey('variant-c'),
                  plants: _plants,
                  selectedSpecies: _selectedSpecies,
                  hasPhoto: _hasPhoto,
                  onSpeciesChanged: _onSpeciesChanged,
                  onTogglePhoto: _onTogglePhoto,
                ),
              },
            ),
          ),
          Positioned(
            left: 16,
            right: 16,
            bottom: 20,
            child: _PrototypeSwitcher(
              variant: _variant,
              onPrevious: () => _cycle(-1),
              onNext: () => _cycle(1),
            ),
          ),
        ],
      ),
    );
  }

  void _cycle(int delta) {
    final variants = ArchiveVariant.values;
    final index = variants.indexOf(_variant);
    final nextIndex = (index + delta + variants.length) % variants.length;
    setState(() {
      _variant = variants[nextIndex];
    });
  }

  void _onSpeciesChanged(String? value) {
    setState(() {
      _selectedSpecies = value;
    });
  }

  void _onTogglePhoto() {
    setState(() {
      _hasPhoto = !_hasPhoto;
    });
  }
}

class _PrototypeSwitcher extends StatelessWidget {
  final ArchiveVariant variant;
  final VoidCallback onPrevious;
  final VoidCallback onNext;

  const _PrototypeSwitcher({
    required this.variant,
    required this.onPrevious,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Center(
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: const Color(0xFF1F2A22),
            borderRadius: BorderRadius.circular(999),
            boxShadow: const [
              BoxShadow(
                blurRadius: 24,
                color: Color(0x33000000),
                offset: Offset(0, 8),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  visualDensity: VisualDensity.compact,
                  onPressed: onPrevious,
                  icon: const Icon(Icons.chevron_left, color: Colors.white),
                ),
                Text(
                  '${variant.keyName} - ${variant.label}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                IconButton(
                  visualDensity: VisualDensity.compact,
                  onPressed: onNext,
                  icon: const Icon(Icons.chevron_right, color: Colors.white),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _VariantGalleryFirst extends StatelessWidget {
  final List<PrototypePlant> plants;
  final String? selectedSpecies;
  final bool hasPhoto;
  final ValueChanged<String?> onSpeciesChanged;
  final VoidCallback onTogglePhoto;

  const _VariantGalleryFirst({
    super.key,
    required this.plants,
    required this.selectedSpecies,
    required this.hasPhoto,
    required this.onSpeciesChanged,
    required this.onTogglePhoto,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),
      children: [
        Text(
          'PROTOTYPE: 3 varianti per issue #3',
          style: Theme.of(context).textTheme.labelLarge,
        ),
        const SizedBox(height: 12),
        Text(
          'Variant A: Gallery-first',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: 8),
        Text(
          'La foto domina. Il form di creazione vive subito sotto la hero, come gesto diretto e visivo.',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const SizedBox(height: 18),
        _HeroPhotoTile(hasPhoto: hasPhoto, onTogglePhoto: onTogglePhoto),
        const SizedBox(height: 18),
        _InlineCreatePanel(
          selectedSpecies: selectedSpecies,
          hasPhoto: hasPhoto,
          onSpeciesChanged: onSpeciesChanged,
        ),
        const SizedBox(height: 22),
        Text('Archivio', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 12),
        LayoutBuilder(
          builder: (context, constraints) {
            final crossAxisCount = constraints.maxWidth >= 380 ? 2 : 1;

            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: crossAxisCount == 1 ? 1.25 : 0.8,
              ),
              itemCount: plants.length,
              itemBuilder: (context, index) {
                return _PlantTileCard(plant: plants[index]);
              },
            );
          },
        ),
      ],
    );
  }
}

class _VariantCalmDashboard extends StatelessWidget {
  final List<PrototypePlant> plants;
  final String? selectedSpecies;
  final bool hasPhoto;
  final ValueChanged<String?> onSpeciesChanged;
  final VoidCallback onTogglePhoto;

  const _VariantCalmDashboard({
    super.key,
    required this.plants,
    required this.selectedSpecies,
    required this.hasPhoto,
    required this.onSpeciesChanged,
    required this.onTogglePhoto,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),
      children: [
        Text(
          'Variant B: Calm dashboard',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: 12),
        LayoutBuilder(
          builder: (context, constraints) {
            final useTwoColumn = constraints.maxWidth >= 700;
            final left = _DashboardPanel(
              title: 'Requisiti minimi',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _ChecklistRow(label: 'Foto obbligatoria', checked: hasPhoto),
                  _ChecklistRow(
                    label: 'Specie selezionata',
                    checked: selectedSpecies != null,
                  ),
                  const SizedBox(height: 12),
                  FilledButton.tonalIcon(
                    onPressed: onTogglePhoto,
                    icon: const Icon(Icons.add_a_photo_outlined),
                    label: Text(hasPhoto ? 'Foto pronta' : 'Simula foto'),
                  ),
                  const SizedBox(height: 12),
                  _SpeciesDropdown(
                    selectedSpecies: selectedSpecies,
                    onSpeciesChanged: onSpeciesChanged,
                  ),
                ],
              ),
            );

            final right = _DashboardPanel(
              title: 'Dettaglio pianta',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 220, child: _GradientPhoto()),
                  const SizedBox(height: 12),
                  Text(
                    selectedSpecies ?? 'Seleziona specie',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    hasPhoto
                        ? 'La cover esiste, il nickname potrà essere generato.'
                        : 'Senza foto la pianta non nasce.',
                  ),
                ],
              ),
            );

            if (!useTwoColumn) {
              return Column(
                children: [left, const SizedBox(height: 12), right],
              );
            }

            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: left),
                const SizedBox(width: 12),
                Expanded(child: right),
              ],
            );
          },
        ),
        const SizedBox(height: 18),
        _DashboardPanel(
          title: 'Archivio fotografico',
          child: SizedBox(
            height: 280,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: plants.length,
              separatorBuilder: (_, _) => const SizedBox(width: 12),
              itemBuilder: (context, index) => SizedBox(
                width: 220,
                child: _PlantTileCard(plant: plants[index]),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _VariantWizardEntry extends StatelessWidget {
  final List<PrototypePlant> plants;
  final String? selectedSpecies;
  final bool hasPhoto;
  final ValueChanged<String?> onSpeciesChanged;
  final VoidCallback onTogglePhoto;

  const _VariantWizardEntry({
    super.key,
    required this.plants,
    required this.selectedSpecies,
    required this.hasPhoto,
    required this.onSpeciesChanged,
    required this.onTogglePhoto,
  });

  @override
  Widget build(BuildContext context) {
    final step = hasPhoto ? (selectedSpecies != null ? 3 : 2) : 1;

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),
      children: [
        Text(
          'Variant C: Wizard entry',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: 8),
        Text(
          'Flusso guidato. Prima nasce la Pianta, poi sotto si vede l’archivio esistente come contesto secondario.',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const SizedBox(height: 18),
        DecoratedBox(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Step $step / 3',
                  style: Theme.of(context).textTheme.labelLarge,
                ),
                const SizedBox(height: 8),
                LinearProgressIndicator(value: step / 3),
                const SizedBox(height: 18),
                const Text('1. Aggiungi foto'),
                const SizedBox(height: 8),
                _HeroPhotoTile(
                  hasPhoto: hasPhoto,
                  onTogglePhoto: onTogglePhoto,
                ),
                const SizedBox(height: 18),
                const Text('2. Scegli specie'),
                const SizedBox(height: 8),
                _SpeciesDropdown(
                  selectedSpecies: selectedSpecies,
                  onSpeciesChanged: onSpeciesChanged,
                ),
                const SizedBox(height: 18),
                FilledButton(
                  onPressed: hasPhoto && selectedSpecies != null ? () {} : null,
                  child: const Text('Crea Pianta'),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 18),
        Text(
          'Archivio esistente',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 10),
        Column(
          children: plants
              .map(
                (plant) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _PlantListRow(plant: plant),
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}

class _InlineCreatePanel extends StatelessWidget {
  final String? selectedSpecies;
  final bool hasPhoto;
  final ValueChanged<String?> onSpeciesChanged;

  const _InlineCreatePanel({
    required this.selectedSpecies,
    required this.hasPhoto,
    required this.onSpeciesChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Nuova Pianta', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            _SpeciesDropdown(
              selectedSpecies: selectedSpecies,
              onSpeciesChanged: onSpeciesChanged,
            ),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: hasPhoto && selectedSpecies != null ? () {} : null,
              child: const Text('Crea con nickname automatico'),
            ),
          ],
        ),
      ),
    );
  }
}

class _DashboardPanel extends StatelessWidget {
  final String title;
  final Widget child;

  const _DashboardPanel({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 12),
            child,
          ],
        ),
      ),
    );
  }
}

class _PlantTileCard extends StatelessWidget {
  final PrototypePlant plant;

  const _PlantTileCard({required this.plant});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Expanded(child: _GradientPhoto()),
            const SizedBox(height: 10),
            Text(
              plant.nickname,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Text(plant.species),
            const SizedBox(height: 6),
            Text(plant.note, maxLines: 2, overflow: TextOverflow.ellipsis),
          ],
        ),
      ),
    );
  }
}

class _PlantListRow extends StatelessWidget {
  final PrototypePlant plant;

  const _PlantListRow({required this.plant});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            const SizedBox(
              width: 72,
              height: 72,
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(14)),
                child: _GradientPhoto(),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    plant.nickname,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  Text(plant.species),
                  const SizedBox(height: 4),
                  Text(
                    plant.note,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HeroPhotoTile extends StatelessWidget {
  final bool hasPhoto;
  final VoidCallback onTogglePhoto;

  const _HeroPhotoTile({required this.hasPhoto, required this.onTogglePhoto});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 4 / 3,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: hasPhoto
                    ? const _GradientPhoto()
                    : DecoratedBox(
                        decoration: BoxDecoration(
                          color: const Color(0xFFE9E2D6),
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: const Center(child: Text('Nessuna foto')),
                      ),
              ),
            ),
            const SizedBox(height: 12),
            FilledButton.tonalIcon(
              onPressed: onTogglePhoto,
              icon: const Icon(Icons.photo_camera_outlined),
              label: Text(hasPhoto ? 'Rimuovi foto mock' : 'Simula foto'),
            ),
          ],
        ),
      ),
    );
  }
}

class _SpeciesDropdown extends StatelessWidget {
  final String? selectedSpecies;
  final ValueChanged<String?> onSpeciesChanged;

  const _SpeciesDropdown({
    required this.selectedSpecies,
    required this.onSpeciesChanged,
  });

  static const species = [
    'Acero giapponese',
    'Ginepro cinese',
    'Ficus microcarpa',
    'Olmo cinese',
    'Altro',
  ];

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      initialValue: selectedSpecies,
      decoration: const InputDecoration(
        labelText: 'Specie',
        border: OutlineInputBorder(),
      ),
      items: species
          .map(
            (item) => DropdownMenuItem<String>(value: item, child: Text(item)),
          )
          .toList(),
      onChanged: onSpeciesChanged,
    );
  }
}

class _ChecklistRow extends StatelessWidget {
  final String label;
  final bool checked;

  const _ChecklistRow({required this.label, required this.checked});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(
            checked ? Icons.check_circle : Icons.radio_button_unchecked,
            color: checked ? Colors.green : Colors.grey,
          ),
          const SizedBox(width: 8),
          Text(label),
        ],
      ),
    );
  }
}

class _GradientPhoto extends StatelessWidget {
  const _GradientPhoto();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF8CB28C), Color(0xFF6E8B75), Color(0xFFB8A07C)],
        ),
        borderRadius: BorderRadius.circular(18),
      ),
      child: const SizedBox.expand(),
    );
  }
}
