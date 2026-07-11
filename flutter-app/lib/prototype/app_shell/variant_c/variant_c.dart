// Variant C — "Scrollable Home + Parallax sections + pinned agent bar"
// Homepage with 5 vertical sections scrollable with parallax title effect.
// Fixed bottom agent bar always pinned. Sections: AI advice, Collection
// carousel, Calendar, Focus Plant (random), Wiki del Giorno (random).
// Create: dedicated wizard (Foto → Specie → Nickname) as a full-page 3-step flow.
import 'dart:math';

import 'package:flutter/material.dart';

import '../shared/create_widgets.dart';
import '../shared/design.dart';
import '../shared/plant.dart';
import '../shared/plant_store.dart';

// ──────────────────────────────────────────────────────────────────────────────
// Mock data
// ──────────────────────────────────────────────────────────────────────────────

const _wikiArticles = <(String, String)>[
  (
    'Tecnica del Nebari',
    'Come sviluppare radici di superficie visibili e armoniose attraverso tecniche di esposizione progressiva.',
  ),
  (
    'Potatura di raffinazione',
    'Principi guida per la potatura fine: timing, angolatura e strumenti per rami sottili.',
  ),
  (
    'Rinvaso primaverile',
    'Finestre temporali e indicatori visivi per il corretto rinvaso stagionale.',
  ),
  (
    'Substrati e permeabilità',
    'Composizioni ottimali per diverse specie: akadama, pomice, lava vulcanica.',
  ),
  (
    'Filo di alluminio vs rame',
    'Differenze pratiche nell\'uso dei due materiali: forza, impronta e durata stagionale.',
  ),
];

const _mockOperations = <(String, String)>[
  ('Potatura rami primari', '12 giu'),
  ('Concimazione bilanciata', '28 mag'),
  ('Applicazione filo', '03 mag'),
  ('Rinvaso con akadama', '15 apr'),
  ('Pinzatura apici', '02 apr'),
];

// ──────────────────────────────────────────────────────────────────────────────
// Root widget
// ──────────────────────────────────────────────────────────────────────────────

class VariantCCarousel extends StatefulWidget {
  const VariantCCarousel({super.key});

  @override
  State<VariantCCarousel> createState() => _VariantCCarouselState();
}

class _VariantCCarouselState extends State<VariantCCarousel> {
  final _sectionsController = PageController();

  // Carousel state for collection section
  late final PageController _carouselPc = PageController(
    viewportFraction: 0.82,
  );
  int _carouselCurrent = 0;

  // Random picks refreshed on entry
  Plant? _focusPlant;
  int _wikiIndex = 0;

  @override
  void initState() {
    super.initState();
    PlantStore.instance.addListener(_onChange);
    _carouselPc.addListener(() {
      final page = _carouselPc.page?.round() ?? 0;
      if (page != _carouselCurrent) setState(() => _carouselCurrent = page);
    });
    _refreshRandom();
  }

  @override
  void dispose() {
    PlantStore.instance.removeListener(_onChange);
    _carouselPc.dispose();
    _sectionsController.dispose();
    super.dispose();
  }

  void _onChange() {
    setState(() => _refreshRandom());
  }

  void _refreshRandom() {
    final plants = PlantStore.instance.plants;
    if (plants.isNotEmpty) {
      _focusPlant = plants[Random().nextInt(plants.length)];
    } else {
      _focusPlant = null;
    }
    _wikiIndex = Random().nextInt(_wikiArticles.length);
  }

  @override
  Widget build(BuildContext context) {
    final plants = PlantStore.instance.plants;
    final bottomPadding = MediaQuery.of(context).padding.bottom;
    const pinnedBarHeight = 78.0;

    return Scaffold(
      backgroundColor: ZeimotoColors.washi,
      body: Stack(
        children: [
          // ── Full-screen sections with snap paging ─────────────────────────
          SafeArea(
            bottom: false,
            child: Padding(
              padding: EdgeInsets.only(bottom: pinnedBarHeight + bottomPadding),
              child: PageView(
                controller: _sectionsController,
                scrollDirection: Axis.vertical,
                children: [
                  _AiSection(pageController: _sectionsController, pageIndex: 0),
                  _CollectionSection(
                    plants: plants,
                    carouselController: _carouselPc,
                    carouselCurrent: _carouselCurrent,
                    pageController: _sectionsController,
                    pageIndex: 1,
                    onTapPlant: (i) => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) =>
                            _DetailPagerC(initial: i, plants: plants),
                      ),
                    ),
                  ),
                  _CalendarSection(
                    pageController: _sectionsController,
                    pageIndex: 2,
                  ),
                  _FocusPlantSection(
                    plant: _focusPlant,
                    pageController: _sectionsController,
                    pageIndex: 3,
                    onTap: _focusPlant == null
                        ? null
                        : () {
                            final i = plants.indexOf(_focusPlant!);
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => _DetailPagerC(
                                  initial: i.clamp(0, plants.length - 1),
                                  plants: plants,
                                ),
                              ),
                            );
                          },
                  ),
                  _WikiSection(
                    article: _wikiArticles[_wikiIndex],
                    pageController: _sectionsController,
                    pageIndex: 4,
                  ),
                ],
              ),
            ),
          ),

          // ── Pinned bottom agent bar ─────────────────────────────────────────
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              decoration: BoxDecoration(
                color: ZeimotoColors.washi,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 16,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: SafeArea(
                top: false,
                child: _AgentBar(onCreate: () => _openCreateC(context)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────────
// Parallax helpers
// ──────────────────────────────────────────────────────────────────────────────

class _SectionParallax extends StatelessWidget {
  const _SectionParallax({
    required this.pageController,
    required this.pageIndex,
    required this.depth,
    required this.child,
  });

  final PageController pageController;
  final int pageIndex;
  final double depth;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: pageController,
      builder: (context, _) {
        final page = pageController.hasClients
            ? (pageController.page ?? pageController.initialPage.toDouble())
            : pageController.initialPage.toDouble();
        final delta = pageIndex - page;
        final shiftY = delta * 124 * depth;
        final scale = 1 - (delta.abs() * 0.07 * depth).clamp(0.0, 0.18);
        final opacity = (1 - delta.abs() * 0.42).clamp(0.5, 1.0);

        return Transform.translate(
          offset: Offset(0, shiftY),
          child: Transform.scale(
            scale: scale,
            alignment: Alignment.topCenter,
            child: Opacity(opacity: opacity, child: child),
          ),
        );
      },
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 14),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 30,
          height: 1.0,
          letterSpacing: 0.2,
          fontWeight: FontWeight.w300,
          color: ZeimotoColors.moss,
        ),
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────────
// Section 1 – AI advice
// ──────────────────────────────────────────────────────────────────────────────

class _AiSection extends StatelessWidget {
  const _AiSection({required this.pageController, required this.pageIndex});
  final PageController pageController;
  final int pageIndex;

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 18, 0, 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _SectionParallax(
              pageController: pageController,
              pageIndex: pageIndex,
              depth: 1.35,
              child: const _SectionTitle('Assistente AI'),
            ),
            Expanded(
              child: Center(
                child: _SectionParallax(
                  pageController: pageController,
                  pageIndex: pageIndex,
                  depth: 0.85,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: ZeimotoColors.moss.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: ZeimotoColors.sage.withValues(alpha: 0.4),
                        ),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: ZeimotoColors.moss.withValues(
                                    alpha: 0.15,
                                  ),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.wb_sunny_outlined,
                                  color: ZeimotoColors.moss,
                                  size: 18,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Text(
                                'Oggi · 3 luglio',
                                style: Theme.of(context).textTheme.labelSmall
                                    ?.copyWith(
                                      color: ZeimotoColors.moss,
                                      letterSpacing: 1.0,
                                    ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),
                          RichText(
                            text: TextSpan(
                              style: const TextStyle(
                                fontSize: 15,
                                height: 1.55,
                                color: ZeimotoColors.charcoal,
                              ),
                              children: [
                                const TextSpan(
                                  text:
                                      'Oggi sono previsti 30°. Assicurati di ombreggiare le seguenti piante ',
                                ),
                                WidgetSpan(
                                  alignment: PlaceholderAlignment.middle,
                                  child: GestureDetector(
                                    onTap: () {},
                                    child: const Text(
                                      '→',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: ZeimotoColors.moss,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: const [
                              _PlantChip(name: 'acero rosso'),
                              _PlantChip(name: 'shohin del terrazzo'),
                              _PlantChip(name: 'ficus veloce'),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PlantChip extends StatelessWidget {
  const _PlantChip({required this.name});
  final String name;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: ZeimotoColors.sage.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        name,
        style: const TextStyle(
          fontSize: 12,
          color: ZeimotoColors.moss,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────────
// Section 2 – La tua collezione
// ──────────────────────────────────────────────────────────────────────────────

class _CollectionSection extends StatelessWidget {
  const _CollectionSection({
    required this.plants,
    required this.carouselController,
    required this.carouselCurrent,
    required this.pageController,
    required this.pageIndex,
    required this.onTapPlant,
  });
  final List<Plant> plants;
  final PageController carouselController;
  final int carouselCurrent;
  final PageController pageController;
  final int pageIndex;
  final void Function(int index) onTapPlant;

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 18, 0, 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _SectionParallax(
              pageController: pageController,
              pageIndex: pageIndex,
              depth: 1.35,
              child: const _SectionTitle('La Tua Collezione'),
            ),
            Expanded(
              child: Center(
                child: _SectionParallax(
                  pageController: pageController,
                  pageIndex: pageIndex,
                  depth: 0.85,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 14),
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
                      SizedBox(
                        height: 340,
                        child: plants.isEmpty
                            ? const Center(child: Text('nessuna pianta'))
                            : PageView.builder(
                                controller: carouselController,
                                itemCount: plants.length,
                                itemBuilder: (ctx, i) {
                                  final p = plants[i];
                                  final active = i == carouselCurrent;
                                  return AnimatedPadding(
                                    duration: const Duration(milliseconds: 220),
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: active ? 8 : 32,
                                    ),
                                    child: GestureDetector(
                                      onTap: () => onTapPlant(i),
                                      child: _CoverCard(
                                        plant: p,
                                        active: active,
                                      ),
                                    ),
                                  );
                                },
                              ),
                      ),
                      if (plants.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.fromLTRB(24, 10, 24, 0),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      plants[carouselCurrent.clamp(
                                            0,
                                            plants.length - 1,
                                          )]
                                          .nickname,
                                      style: Theme.of(
                                        context,
                                      ).textTheme.titleMedium,
                                    ),
                                    Text(
                                      plants[carouselCurrent.clamp(
                                            0,
                                            plants.length - 1,
                                          )]
                                          .species,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                            fontStyle: FontStyle.italic,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                '${carouselCurrent + 1} / ${plants.length}',
                                style: Theme.of(context).textTheme.labelSmall,
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
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

// ──────────────────────────────────────────────────────────────────────────────
// Section 3 – Calendario
// ──────────────────────────────────────────────────────────────────────────────

class _CalendarSection extends StatelessWidget {
  const _CalendarSection({
    required this.pageController,
    required this.pageIndex,
  });
  final PageController pageController;
  final int pageIndex;

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final daysInMonth = DateUtils.getDaysInMonth(now.year, now.month);
    final firstWeekday = DateTime(now.year, now.month, 1).weekday; // 1=Mon
    final monthName = _monthName(now.month);

    // Mock event days
    const eventDays = {5, 12, 18, 24};
    const taskDays = {8, 21};

    return SizedBox.expand(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 18, 0, 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _SectionParallax(
              pageController: pageController,
              pageIndex: pageIndex,
              depth: 1.35,
              child: const _SectionTitle('Calendario'),
            ),
            Expanded(
              child: Center(
                child: _SectionParallax(
                  pageController: pageController,
                  pageIndex: pageIndex,
                  depth: 0.85,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: ZeimotoColors.washiDeep,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '$monthName ${now.year}',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(
                                      Icons.chevron_left,
                                      size: 20,
                                    ),
                                    color: ZeimotoColors.charcoalSoft,
                                    onPressed: () {},
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(),
                                  ),
                                  const SizedBox(width: 12),
                                  IconButton(
                                    icon: const Icon(
                                      Icons.chevron_right,
                                      size: 20,
                                    ),
                                    color: ZeimotoColors.charcoalSoft,
                                    onPressed: () {},
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: ['L', 'M', 'M', 'G', 'V', 'S', 'D'].map((
                              d,
                            ) {
                              return Expanded(
                                child: Center(
                                  child: Text(
                                    d,
                                    style: const TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: 0.6,
                                      color: ZeimotoColors.charcoalSoft,
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                          const SizedBox(height: 10),
                          GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 7,
                                  mainAxisSpacing: 4,
                                  crossAxisSpacing: 2,
                                  childAspectRatio: 1.0,
                                ),
                            itemCount: (firstWeekday - 1) + daysInMonth,
                            itemBuilder: (ctx, idx) {
                              if (idx < firstWeekday - 1)
                                return const SizedBox();
                              final day = idx - (firstWeekday - 1) + 1;
                              final isToday = day == now.day;
                              final hasEvent = eventDays.contains(day);
                              final hasTask = taskDays.contains(day);
                              return _CalendarDay(
                                day: day,
                                isToday: isToday,
                                hasEvent: hasEvent,
                                hasTask: hasTask,
                              );
                            },
                          ),
                          const SizedBox(height: 12),
                          const Row(
                            children: [
                              _Legend(
                                color: ZeimotoColors.moss,
                                label: 'evento',
                              ),
                              SizedBox(width: 16),
                              _Legend(
                                color: ZeimotoColors.cinnabar,
                                label: 'task AI',
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static String _monthName(int month) {
    const names = [
      '',
      'Gennaio',
      'Febbraio',
      'Marzo',
      'Aprile',
      'Maggio',
      'Giugno',
      'Luglio',
      'Agosto',
      'Settembre',
      'Ottobre',
      'Novembre',
      'Dicembre',
    ];
    return names[month];
  }
}

class _CalendarDay extends StatelessWidget {
  const _CalendarDay({
    required this.day,
    required this.isToday,
    required this.hasEvent,
    required this.hasTask,
  });
  final int day;
  final bool isToday;
  final bool hasEvent;
  final bool hasTask;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 30,
          height: 30,
          decoration: isToday
              ? const BoxDecoration(
                  color: ZeimotoColors.moss,
                  shape: BoxShape.circle,
                )
              : null,
          child: Center(
            child: Text(
              '$day',
              style: TextStyle(
                fontSize: 12,
                fontWeight: isToday ? FontWeight.w600 : FontWeight.w400,
                color: isToday ? Colors.white : ZeimotoColors.charcoal,
              ),
            ),
          ),
        ),
        const SizedBox(height: 2),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (hasEvent)
              Container(
                width: 4,
                height: 4,
                margin: const EdgeInsets.symmetric(horizontal: 1),
                decoration: const BoxDecoration(
                  color: ZeimotoColors.moss,
                  shape: BoxShape.circle,
                ),
              ),
            if (hasTask)
              Container(
                width: 4,
                height: 4,
                margin: const EdgeInsets.symmetric(horizontal: 1),
                decoration: const BoxDecoration(
                  color: ZeimotoColors.cinnabar,
                  shape: BoxShape.circle,
                ),
              ),
          ],
        ),
      ],
    );
  }
}

class _Legend extends StatelessWidget {
  const _Legend({required this.color, required this.label});
  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            color: ZeimotoColors.charcoalSoft,
          ),
        ),
      ],
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────────
// Section 4 – Focus su pianta
// ──────────────────────────────────────────────────────────────────────────────

class _FocusPlantSection extends StatelessWidget {
  const _FocusPlantSection({
    required this.plant,
    required this.pageController,
    required this.pageIndex,
    required this.onTap,
  });
  final Plant? plant;
  final PageController pageController;
  final int pageIndex;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 18, 0, 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _SectionParallax(
              pageController: pageController,
              pageIndex: pageIndex,
              depth: 1.35,
              child: const _SectionTitle('Focus Su Pianta'),
            ),
            Expanded(
              child: Center(
                child: _SectionParallax(
                  pageController: pageController,
                  pageIndex: pageIndex,
                  depth: 0.85,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: plant == null
                        ? const Center(
                            child: Text('aggiungi almeno una pianta'),
                          )
                        : GestureDetector(
                            onTap: onTap,
                            child: Container(
                              decoration: BoxDecoration(
                                color: ZeimotoColors.washiDeep,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                    borderRadius: const BorderRadius.vertical(
                                      top: Radius.circular(20),
                                    ),
                                    child: SizedBox(
                                      height: 200,
                                      child: PhotoTile(
                                        photo: plant!.cover,
                                        borderRadius: 0,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(20),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    plant!.nickname,
                                                    style: Theme.of(
                                                      context,
                                                    ).textTheme.titleMedium,
                                                  ),
                                                  Text(
                                                    plant!.species,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyMedium
                                                        ?.copyWith(
                                                          fontStyle:
                                                              FontStyle.italic,
                                                        ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            const Icon(
                                              Icons.arrow_forward_ios,
                                              size: 14,
                                              color: ZeimotoColors.charcoalSoft,
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 18),
                                        const Wrap(
                                          spacing: 8,
                                          runSpacing: 8,
                                          children: [
                                            _StatusBadge(
                                              label: 'vigoroso',
                                              icon:
                                                  Icons.local_florist_outlined,
                                            ),
                                            _StatusBadge(
                                              label: 'raffinazione',
                                              icon: Icons.spa_outlined,
                                            ),
                                            _StatusBadge(
                                              label: 'estate',
                                              icon: Icons.wb_sunny_outlined,
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 18),
                                        Text(
                                          'ULTIME LAVORAZIONI',
                                          style: Theme.of(context)
                                              .textTheme
                                              .labelSmall
                                              ?.copyWith(
                                                letterSpacing: 1.8,
                                                fontSize: 9,
                                              ),
                                        ),
                                        const SizedBox(height: 10),
                                        for (final op in _mockOperations.take(
                                          3,
                                        ))
                                          Padding(
                                            padding: const EdgeInsets.only(
                                              bottom: 8,
                                            ),
                                            child: Row(
                                              children: [
                                                Container(
                                                  width: 6,
                                                  height: 6,
                                                  margin: const EdgeInsets.only(
                                                    right: 10,
                                                    top: 1,
                                                  ),
                                                  decoration:
                                                      const BoxDecoration(
                                                        color:
                                                            ZeimotoColors.sage,
                                                        shape: BoxShape.circle,
                                                      ),
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    op.$1,
                                                    style: const TextStyle(
                                                      fontSize: 13,
                                                      color: ZeimotoColors
                                                          .charcoal,
                                                    ),
                                                  ),
                                                ),
                                                Text(
                                                  op.$2,
                                                  style: const TextStyle(
                                                    fontSize: 11,
                                                    color: ZeimotoColors
                                                        .charcoalSoft,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.label, required this.icon});
  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: ZeimotoColors.sage.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: ZeimotoColors.moss),
          const SizedBox(width: 5),
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              color: ZeimotoColors.moss,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────────
// Section 5 – Wiki del giorno
// ──────────────────────────────────────────────────────────────────────────────

class _WikiSection extends StatelessWidget {
  const _WikiSection({
    required this.article,
    required this.pageController,
    required this.pageIndex,
  });
  final (String, String) article;
  final PageController pageController;
  final int pageIndex;

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 18, 0, 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _SectionParallax(
              pageController: pageController,
              pageIndex: pageIndex,
              depth: 1.35,
              child: const _SectionTitle('Wiki Del Giorno'),
            ),
            Expanded(
              child: Center(
                child: _SectionParallax(
                  pageController: pageController,
                  pageIndex: pageIndex,
                  depth: 0.85,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Container(
                      padding: const EdgeInsets.all(22),
                      decoration: BoxDecoration(
                        color: ZeimotoColors.charcoal,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.1),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.menu_book_outlined,
                                  color: ZeimotoColors.sage,
                                  size: 16,
                                ),
                              ),
                              const SizedBox(width: 10),
                              const Text(
                                'LETTURA CONSIGLIATA',
                                style: TextStyle(
                                  fontSize: 9,
                                  letterSpacing: 2.2,
                                  fontWeight: FontWeight.w600,
                                  color: ZeimotoColors.sage,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            article.$1,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w300,
                              color: Colors.white,
                              height: 1.3,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            article.$2,
                            style: TextStyle(
                              fontSize: 13,
                              height: 1.5,
                              color: Colors.white.withValues(alpha: 0.65),
                            ),
                          ),
                          const SizedBox(height: 20),
                          GestureDetector(
                            onTap: () {},
                            child: const Row(
                              children: [
                                Text(
                                  'leggi articolo',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: ZeimotoColors.sage,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(width: 6),
                                Text(
                                  '→',
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: ZeimotoColors.sage,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────────
// Agent bar (pinned at bottom)
// ──────────────────────────────────────────────────────────────────────────────

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
