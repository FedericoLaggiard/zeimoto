import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'shared/design.dart';
import 'variant_a/variant_a.dart';
import 'variant_b/variant_b.dart';
import 'variant_c/variant_c.dart';

/// Top-level prototype host. Cycles between radically different UI variants
/// via the floating switcher bar (or ← / → keyboard on desktop).
class PrototypeRoot extends StatefulWidget {
  const PrototypeRoot({super.key});

  @override
  State<PrototypeRoot> createState() => _PrototypeRootState();
}

class _PrototypeRootState extends State<PrototypeRoot> {
  final _focus = FocusNode();
  int _index = 0;

  static const _variants = <_VariantDef>[
    _VariantDef('A', 'Griglia zen', _buildA),
    _VariantDef('B', 'Feed + bottom nav', _buildB),
    _VariantDef('C', 'Carousel + agent bar', _buildC),
  ];

  static Widget _buildA(BuildContext _) => const VariantAGrid();
  static Widget _buildB(BuildContext _) => const VariantBFeed();
  static Widget _buildC(BuildContext _) => const VariantCCarousel();

  void _cycle(int delta) {
    setState(() {
      _index = (_index + delta) % _variants.length;
      if (_index < 0) _index += _variants.length;
    });
  }

  KeyEventResult _onKey(FocusNode _, KeyEvent event) {
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
  }

  @override
  Widget build(BuildContext context) {
    final variant = _variants[_index];
    _focus.requestFocus();
    return Focus(
      focusNode: _focus,
      autofocus: true,
      onKeyEvent: _onKey,
      child: Stack(
        children: [
          Positioned.fill(child: variant.build(context)),
          Positioned(
            left: 0,
            right: 0,
            bottom: MediaQuery.of(context).padding.bottom + 12,
            child: _SwitcherBar(
              label: '${variant.key} — ${variant.name}',
              onPrev: () => _cycle(-1),
              onNext: () => _cycle(1),
            ),
          ),
        ],
      ),
    );
  }
}

class _VariantDef {
  const _VariantDef(this.key, this.name, this.build);
  final String key;
  final String name;
  final Widget Function(BuildContext) build;
}

class _SwitcherBar extends StatelessWidget {
  const _SwitcherBar({
    required this.label,
    required this.onPrev,
    required this.onNext,
  });

  final String label;
  final VoidCallback onPrev;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        decoration: BoxDecoration(
          color: ZeimotoColors.charcoal.withValues(alpha: 0.92),
          borderRadius: BorderRadius.circular(999),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.25),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              onPressed: onPrev,
              iconSize: 20,
              color: Colors.white,
              icon: const Icon(Icons.chevron_left),
              tooltip: 'Variante precedente',
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.4,
                ),
              ),
            ),
            IconButton(
              onPressed: onNext,
              iconSize: 20,
              color: Colors.white,
              icon: const Icon(Icons.chevron_right),
              tooltip: 'Variante successiva',
            ),
          ],
        ),
      ),
    );
  }
}
