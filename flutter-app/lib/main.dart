// ============================================================================
// PROTOTYPE — throwaway code, do not ship.
//
// Question: come devono apparire Archivio Piante + creazione Pianta
// (foto obbligatoria, specie obbligatoria) per la issue #3?
//
// Tre varianti strutturalmente diverse, switchabili dalla barra flottante
// in basso (o frecce ← → della tastiera, o ?variant=A|B|C su web):
//   A — "Giardino":  griglia fotografica immersiva, FAB, dettaglio bottom-sheet
//   B — "Diario":    lista verticale a card orizzontali, creazione a stepper
//   C — "Tokonoma":  una pianta alla volta, carousel contemplativo full-screen
//
// Dati in memoria. Le "foto" (camera/import) sono stub: immagini di esempio.
// ============================================================================

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// ---------------------------------------------------------------------------
// Palette "minimal organic Japanese" (MISSION.md)
// ---------------------------------------------------------------------------
const kSage = Color(0xFF8A9B6E);
const kSageDark = Color(0xFF5C6B47);
const kWashi = Color(0xFFF6F1E7);
const kCharcoal = Color(0xFF33342E);
const kClay = Color(0xFFC4A484);

// ---------------------------------------------------------------------------
// Modello + stato in memoria (nessuna persistenza — è il prototipo)
// ---------------------------------------------------------------------------
class Pianta {
  Pianta({
    required this.species,
    required this.photoUrl,
    this.nickname,
  }) : createdAt = DateTime.now();

  final String species;
  final String photoUrl; // stub camera/import
  final String? nickname;
  final DateTime createdAt;

  String get displayName => nickname?.isNotEmpty == true ? nickname! : species;
}

const kSpecies = [
  'Acer palmatum',
  'Juniperus chinensis',
  'Ficus retusa',
  'Pinus thunbergii',
  'Ulmus parvifolia',
  'Carpinus betulus',
  'Zelkova serrata',
];

// Foto stub — al posto di camera / import galleria.
const kStubPhotos = [
  'https://picsum.photos/seed/bonsai1/900/1200',
  'https://picsum.photos/seed/bonsai2/900/1200',
  'https://picsum.photos/seed/bonsai3/900/1200',
  'https://picsum.photos/seed/bonsai4/900/1200',
  'https://picsum.photos/seed/bonsai5/900/1200',
  'https://picsum.photos/seed/bonsai6/900/1200',
];

final ValueNotifier<List<Pianta>> archivio = ValueNotifier<List<Pianta>>([
  Pianta(species: 'Acer palmatum', photoUrl: kStubPhotos[0], nickname: 'Momiji'),
  Pianta(species: 'Juniperus chinensis', photoUrl: kStubPhotos[1]),
  Pianta(species: 'Ficus retusa', photoUrl: kStubPhotos[2], nickname: 'Kojiro'),
]);

void addPianta(Pianta p) => archivio.value = [...archivio.value, p];

// ---------------------------------------------------------------------------
// App + switcher varianti
// ---------------------------------------------------------------------------
void main() => runApp(const PrototypeApp());

const _variants = ['A', 'B', 'C'];
const _variantNames = {
  'A': 'Giardino — griglia foto',
  'B': 'Diario — lista + stepper',
  'C': 'Tokonoma — carousel',
};

class PrototypeApp extends StatefulWidget {
  const PrototypeApp({super.key});

  @override
  State<PrototypeApp> createState() => _PrototypeAppState();
}

class _PrototypeAppState extends State<PrototypeApp> {
  late String variant;

  @override
  void initState() {
    super.initState();
    final fromUrl = Uri.base.queryParameters['variant']?.toUpperCase();
    variant = _variants.contains(fromUrl) ? fromUrl! : 'A';
  }

  void _cycle(int dir) {
    setState(() {
      final i = (_variants.indexOf(variant) + dir) % _variants.length;
      variant = _variants[(i + _variants.length) % _variants.length];
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Zeimoto — PROTOTYPE',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: kWashi,
        colorScheme: ColorScheme.fromSeed(
          seedColor: kSage,
          surface: kWashi,
          onSurface: kCharcoal,
        ),
        fontFamily: 'Georgia',
      ),
      home: Focus(
        autofocus: true,
        onKeyEvent: (node, event) {
          if (event is! KeyDownEvent) return KeyEventResult.ignored;
          if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
            _cycle(-1);
            return KeyEventResult.handled;
          }
          if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
            _cycle(1);
            return KeyEventResult.handled;
          }
          return KeyEventResult.ignored;
        },
        child: Stack(
          children: [
            switch (variant) {
              'B' => const VariantB(),
              'C' => const VariantC(),
              _ => const VariantA(),
            },
            if (kDebugMode)
              _SwitcherBar(
                current: variant,
                name: _variantNames[variant]!,
                onPrev: () => _cycle(-1),
                onNext: () => _cycle(1),
              ),
          ],
        ),
      ),
    );
  }
}

class _SwitcherBar extends StatelessWidget {
  const _SwitcherBar({
    required this.current,
    required this.name,
    required this.onPrev,
    required this.onNext,
  });

  final String current;
  final String name;
  final VoidCallback onPrev;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 16,
      left: 0,
      right: 0,
      child: Center(
        child: Material(
          color: kCharcoal,
          elevation: 8,
          borderRadius: BorderRadius.circular(30),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.chevron_left, color: kWashi),
                  onPressed: onPrev,
                ),
                Text('$current — $name',
                    style: const TextStyle(color: kWashi, fontSize: 13)),
                IconButton(
                  icon: const Icon(Icons.chevron_right, color: kWashi),
                  onPressed: onNext,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Stub "scatta foto / importa" — condiviso: ritorna una foto o null
// ---------------------------------------------------------------------------
Future<String?> pickStubPhoto(BuildContext context) {
  return showModalBottomSheet<String>(
    context: context,
    backgroundColor: kWashi,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (ctx) => Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Foto (stub camera / import)',
              style: TextStyle(fontSize: 16, color: kCharcoal)),
          const SizedBox(height: 14),
          SizedBox(
            height: 110,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: kStubPhotos.length,
              separatorBuilder: (_, __) => const SizedBox(width: 10),
              itemBuilder: (_, i) => GestureDetector(
                onTap: () => Navigator.pop(ctx, kStubPhotos[i]),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(kStubPhotos[i],
                      width: 84, height: 110, fit: BoxFit.cover),
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
        ],
      ),
    ),
  );
}

// ---------------------------------------------------------------------------
// Dettaglio Pianta condiviso (dati base: cover, specie, nickname)
// ---------------------------------------------------------------------------
class DettaglioPianta extends StatelessWidget {
  const DettaglioPianta({super.key, required this.pianta});
  final Pianta pianta;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWashi,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 380,
            pinned: true,
            backgroundColor: kSageDark,
            flexibleSpace: FlexibleSpaceBar(
              background: Image.network(pianta.photoUrl, fit: BoxFit.cover),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(pianta.displayName,
                      style: const TextStyle(
                          fontSize: 30, color: kCharcoal, height: 1.1)),
                  const SizedBox(height: 6),
                  Text(pianta.species,
                      style: TextStyle(
                          fontSize: 16,
                          fontStyle: FontStyle.italic,
                          color: kCharcoal.withValues(alpha: .6))),
                  const SizedBox(height: 20),
                  _row('Specie', pianta.species),
                  _row('Nickname', pianta.nickname ?? '—'),
                  _row('Creata il',
                      '${pianta.createdAt.day}/${pianta.createdAt.month}/${pianta.createdAt.year}'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _row(String label, String value) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            SizedBox(
                width: 110,
                child: Text(label,
                    style: TextStyle(color: kCharcoal.withValues(alpha: .5)))),
            Expanded(child: Text(value, style: const TextStyle(color: kCharcoal))),
          ],
        ),
      );
}

// ===========================================================================
// VARIANTE A — "Giardino": griglia fotografica immersiva
//   Le foto sono protagoniste assolute. Griglia sfalsata edge-to-edge,
//   nessuna app bar, FAB per creare. Creazione in bottom-sheet unico.
// ===========================================================================
class VariantA extends StatelessWidget {
  const VariantA({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWashi,
      floatingActionButton: FloatingActionButton(
        backgroundColor: kSageDark,
        heroTag: 'fab-a',
        onPressed: () => _openCreateSheet(context),
        child: const Icon(Icons.add, color: kWashi),
      ),
      body: ValueListenableBuilder<List<Pianta>>(
        valueListenable: archivio,
        builder: (context, piante, _) => CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 60, 16, 8),
              sliver: SliverToBoxAdapter(
                child: Text('Il tuo giardino',
                    style: TextStyle(
                        fontSize: 34,
                        color: kCharcoal,
                        letterSpacing: -0.5)),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 14,
                  crossAxisSpacing: 14,
                  childAspectRatio: 0.72,
                ),
                delegate: SliverChildBuilderDelegate(
                  childCount: piante.length,
                  (context, i) {
                    final p = piante[i];
                    return GestureDetector(
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => DettaglioPianta(pianta: p))),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(18),
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            Image.network(p.photoUrl, fit: BoxFit.cover),
                            Positioned(
                              left: 0,
                              right: 0,
                              bottom: 0,
                              child: Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Colors.transparent,
                                      kCharcoal.withValues(alpha: .75),
                                    ],
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(p.displayName,
                                        style: const TextStyle(
                                            color: kWashi, fontSize: 16)),
                                    Text(p.species,
                                        style: TextStyle(
                                            color: kWashi.withValues(alpha: .7),
                                            fontSize: 11,
                                            fontStyle: FontStyle.italic)),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openCreateSheet(BuildContext context) {
    String? photo;
    String? species;
    final nickCtrl = TextEditingController();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: kWashi,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSheet) {
          final canSave = photo != null && species != null;
          return Padding(
            padding: EdgeInsets.fromLTRB(
                24, 24, 24, MediaQuery.of(ctx).viewInsets.bottom + 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Nuova pianta',
                    style: TextStyle(fontSize: 24, color: kCharcoal)),
                const SizedBox(height: 18),
                GestureDetector(
                  onTap: () async {
                    final res = await pickStubPhoto(ctx);
                    if (res != null) setSheet(() => photo = res);
                  },
                  child: Container(
                    height: 160,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: kSage.withValues(alpha: .15),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                          color: photo == null ? kClay : kSageDark, width: 1.5),
                      image: photo != null
                          ? DecorationImage(
                              image: NetworkImage(photo!), fit: BoxFit.cover)
                          : null,
                    ),
                    child: photo == null
                        ? const Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.photo_camera_outlined,
                                    color: kSageDark, size: 32),
                                SizedBox(height: 6),
                                Text('Foto obbligatoria — tocca per scattare',
                                    style: TextStyle(
                                        color: kSageDark, fontSize: 13)),
                              ],
                            ),
                          )
                        : null,
                  ),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  initialValue: species,
                  decoration: const InputDecoration(
                    labelText: 'Specie *',
                    border: OutlineInputBorder(),
                  ),
                  items: kSpecies
                      .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                      .toList(),
                  onChanged: (v) => setSheet(() => species = v),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: nickCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Nickname (facoltativo)',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    style: FilledButton.styleFrom(
                        backgroundColor: kSageDark,
                        padding: const EdgeInsets.symmetric(vertical: 16)),
                    onPressed: canSave
                        ? () {
                            addPianta(Pianta(
                                species: species!,
                                photoUrl: photo!,
                                nickname: nickCtrl.text));
                            Navigator.pop(ctx);
                          }
                        : null,
                    child: const Text('Pianta nel giardino'),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

// ===========================================================================
// VARIANTE B — "Diario": lista verticale a card orizzontali + stepper
//   Gerarchia informativa: testo e foto pari dignità, card orizzontali
//   ampie, app bar classica. Creazione come flusso a step full-screen
//   (1. foto → 2. specie → 3. nickname), un passo alla volta.
// ===========================================================================
class VariantB extends StatelessWidget {
  const VariantB({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWashi,
      appBar: AppBar(
        backgroundColor: kWashi,
        elevation: 0,
        title: const Text('Archivio Piante',
            style: TextStyle(color: kCharcoal, fontSize: 20)),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: FilledButton.icon(
              style: FilledButton.styleFrom(backgroundColor: kSageDark),
              icon: const Icon(Icons.add, size: 18),
              label: const Text('Nuova'),
              onPressed: () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const _CreaStepper())),
            ),
          ),
        ],
      ),
      body: ValueListenableBuilder<List<Pianta>>(
        valueListenable: archivio,
        builder: (context, piante, _) => ListView.separated(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
          itemCount: piante.length,
          separatorBuilder: (_, __) => const SizedBox(height: 14),
          itemBuilder: (context, i) {
            final p = piante[i];
            return Material(
              color: Colors.white.withValues(alpha: .65),
              borderRadius: BorderRadius.circular(16),
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => DettaglioPianta(pianta: p))),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(p.photoUrl,
                            width: 96, height: 120, fit: BoxFit.cover),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(p.displayName,
                                style: const TextStyle(
                                    fontSize: 19, color: kCharcoal)),
                            const SizedBox(height: 4),
                            Text(p.species,
                                style: TextStyle(
                                    fontSize: 13,
                                    fontStyle: FontStyle.italic,
                                    color: kCharcoal.withValues(alpha: .6))),
                            const SizedBox(height: 12),
                            Text(
                                'dal ${p.createdAt.day}/${p.createdAt.month}/${p.createdAt.year}',
                                style: TextStyle(
                                    fontSize: 12,
                                    color: kCharcoal.withValues(alpha: .45))),
                          ],
                        ),
                      ),
                      Icon(Icons.chevron_right,
                          color: kCharcoal.withValues(alpha: .3)),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _CreaStepper extends StatefulWidget {
  const _CreaStepper();

  @override
  State<_CreaStepper> createState() => _CreaStepperState();
}

class _CreaStepperState extends State<_CreaStepper> {
  int step = 0;
  String? photo;
  String? species;
  final nickCtrl = TextEditingController();

  bool get canNext => switch (step) {
        0 => photo != null,
        1 => species != null,
        _ => true,
      };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWashi,
      appBar: AppBar(
        backgroundColor: kWashi,
        title: Text('Nuova pianta — passo ${step + 1} di 3',
            style: const TextStyle(color: kCharcoal, fontSize: 16)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            LinearProgressIndicator(
              value: (step + 1) / 3,
              color: kSageDark,
              backgroundColor: kSage.withValues(alpha: .2),
            ),
            const SizedBox(height: 32),
            Expanded(child: _stepBody()),
            FilledButton(
              style: FilledButton.styleFrom(
                  backgroundColor: kSageDark,
                  padding: const EdgeInsets.symmetric(vertical: 16)),
              onPressed: canNext
                  ? () {
                      if (step < 2) {
                        setState(() => step++);
                      } else {
                        addPianta(Pianta(
                            species: species!,
                            photoUrl: photo!,
                            nickname: nickCtrl.text));
                        Navigator.pop(context);
                      }
                    }
                  : null,
              child: Text(step < 2 ? 'Avanti' : 'Salva pianta'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _stepBody() {
    switch (step) {
      case 0:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('La foto prima di tutto',
                style: TextStyle(fontSize: 26, color: kCharcoal)),
            const SizedBox(height: 8),
            Text('Senza una foto la pianta non può essere creata.',
                style: TextStyle(color: kCharcoal.withValues(alpha: .6))),
            const SizedBox(height: 24),
            Expanded(
              child: GestureDetector(
                onTap: () async {
                  final res = await pickStubPhoto(context);
                  if (res != null) setState(() => photo = res);
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: kSage.withValues(alpha: .12),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                        color: photo == null ? kClay : kSageDark, width: 1.5),
                    image: photo != null
                        ? DecorationImage(
                            image: NetworkImage(photo!), fit: BoxFit.cover)
                        : null,
                  ),
                  child: photo == null
                      ? const Center(
                          child: Icon(Icons.photo_camera_outlined,
                              size: 48, color: kSageDark))
                      : null,
                ),
              ),
            ),
          ],
        );
      case 1:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Che specie è?',
                style: TextStyle(fontSize: 26, color: kCharcoal)),
            const SizedBox(height: 24),
            Expanded(
              child: ListView(
                children: kSpecies
                    .map((s) => RadioListTile<String>(
                          title: Text(s,
                              style: const TextStyle(
                                  fontStyle: FontStyle.italic,
                                  color: kCharcoal)),
                          value: s,
                          groupValue: species,
                          activeColor: kSageDark,
                          onChanged: (v) => setState(() => species = v),
                        ))
                    .toList(),
              ),
            ),
          ],
        );
      default:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Un nome affettuoso?',
                style: TextStyle(fontSize: 26, color: kCharcoal)),
            const SizedBox(height: 8),
            Text('Facoltativo — puoi saltare.',
                style: TextStyle(color: kCharcoal.withValues(alpha: .6))),
            const SizedBox(height: 24),
            TextField(
              controller: nickCtrl,
              decoration: const InputDecoration(
                labelText: 'Nickname',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        );
    }
  }
}

// ===========================================================================
// VARIANTE C — "Tokonoma": una pianta alla volta, carousel contemplativo
//   Full-screen PageView orizzontale, foto a tutto schermo, testo minimo
//   sovrapposto. Nessuna griglia, nessuna lista: contemplazione.
//   L'ultima "pagina" è la creazione stessa (inline).
// ===========================================================================
class VariantC extends StatelessWidget {
  const VariantC({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kCharcoal,
      body: ValueListenableBuilder<List<Pianta>>(
        valueListenable: archivio,
        builder: (context, piante, _) => PageView(
          children: [
            for (final p in piante) _PlantPage(pianta: p),
            const _CreatePage(),
          ],
        ),
      ),
    );
  }
}

class _PlantPage extends StatelessWidget {
  const _PlantPage({required this.pianta});
  final Pianta pianta;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(context,
          MaterialPageRoute(builder: (_) => DettaglioPianta(pianta: pianta))),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.network(pianta.photoUrl, fit: BoxFit.cover),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.transparent,
                  kCharcoal.withValues(alpha: .85),
                ],
              ),
            ),
          ),
          Positioned(
            left: 28,
            right: 28,
            bottom: 90,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(pianta.displayName,
                    style: const TextStyle(
                        color: kWashi, fontSize: 40, height: 1.05)),
                const SizedBox(height: 8),
                Text(pianta.species,
                    style: TextStyle(
                        color: kWashi.withValues(alpha: .7),
                        fontSize: 16,
                        fontStyle: FontStyle.italic)),
                const SizedBox(height: 16),
                Text('tocca per il dettaglio  ·  scorri →',
                    style: TextStyle(
                        color: kWashi.withValues(alpha: .45), fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CreatePage extends StatefulWidget {
  const _CreatePage();

  @override
  State<_CreatePage> createState() => _CreatePageState();
}

class _CreatePageState extends State<_CreatePage> {
  String? photo;
  String? species;
  final nickCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final canSave = photo != null && species != null;
    return Container(
      color: kCharcoal,
      padding: const EdgeInsets.fromLTRB(28, 80, 28, 90),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Accogli una\nnuova pianta',
                style: TextStyle(
                    color: kWashi, fontSize: 36, height: 1.1)),
            const SizedBox(height: 28),
            GestureDetector(
              onTap: () async {
                final res = await pickStubPhoto(context);
                if (res != null) setState(() => photo = res);
              },
              child: Container(
                height: 220,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: kWashi.withValues(alpha: .06),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                      color: photo == null
                          ? kClay
                          : kSage,
                      width: 1.5),
                  image: photo != null
                      ? DecorationImage(
                          image: NetworkImage(photo!), fit: BoxFit.cover)
                      : null,
                ),
                child: photo == null
                    ? Center(
                        child: Text('☉  foto obbligatoria',
                            style: TextStyle(
                                color: kWashi.withValues(alpha: .6))))
                    : null,
              ),
            ),
            const SizedBox(height: 20),
            Theme(
              data: ThemeData.dark(),
              child: DropdownButtonFormField<String>(
                initialValue: species,
                dropdownColor: kCharcoal,
                decoration: InputDecoration(
                  labelText: 'Specie *',
                  labelStyle: TextStyle(color: kWashi.withValues(alpha: .6)),
                  enabledBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: kWashi.withValues(alpha: .3))),
                  border: const OutlineInputBorder(),
                ),
                style: const TextStyle(color: kWashi),
                items: kSpecies
                    .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                    .toList(),
                onChanged: (v) => setState(() => species = v),
              ),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: nickCtrl,
              style: const TextStyle(color: kWashi),
              decoration: InputDecoration(
                labelText: 'Nickname (facoltativo)',
                labelStyle: TextStyle(color: kWashi.withValues(alpha: .6)),
                enabledBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: kWashi.withValues(alpha: .3))),
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                style: FilledButton.styleFrom(
                    backgroundColor: kSage,
                    foregroundColor: kCharcoal,
                    padding: const EdgeInsets.symmetric(vertical: 16)),
                onPressed: canSave
                    ? () {
                        addPianta(Pianta(
                            species: species!,
                            photoUrl: photo!,
                            nickname: nickCtrl.text));
                        setState(() {
                          photo = null;
                          species = null;
                          nickCtrl.clear();
                        });
                      }
                    : null,
                child: const Text('Accogli'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
