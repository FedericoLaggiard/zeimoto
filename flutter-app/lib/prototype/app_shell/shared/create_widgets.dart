import 'package:flutter/material.dart';

import '../shared/design.dart';
import '../shared/plant.dart';

/// Reusable "photo hero" cell for the create flow: shows the chosen placeholder,
/// or a soft dashed target that suggests "tap to add a photo".
class PhotoTargetCell extends StatelessWidget {
  const PhotoTargetCell({
    super.key,
    required this.photo,
    required this.onTap,
    this.height = 260,
    this.hint = 'Tocca per scattare o importare',
  });

  final PlaceholderPhoto? photo;
  final VoidCallback onTap;
  final double height;
  final String hint;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        height: height,
        width: double.infinity,
        child: photo != null
            ? PhotoTile(photo: photo!, borderRadius: 20)
            : DecoratedBox(
                decoration: BoxDecoration(
                  color: ZeimotoColors.washiDeep,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: ZeimotoColors.sage.withValues(alpha: 0.6),
                    width: 1.2,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.camera_alt_outlined,
                      size: 48,
                      color: ZeimotoColors.moss.withValues(alpha: 0.85),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      hint,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: ZeimotoColors.moss,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Foto obbligatoria',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: ZeimotoColors.cinnabar,
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}

class SpeciesPickerField extends StatelessWidget {
  const SpeciesPickerField({
    super.key,
    required this.value,
    required this.onChanged,
    this.dense = false,
  });

  final String? value;
  final ValueChanged<String> onChanged;
  final bool dense;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        final choice = await showModalBottomSheet<String>(
          context: context,
          backgroundColor: ZeimotoColors.washi,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          builder: (ctx) => _SpeciesSheet(current: value),
        );
        if (choice != null) onChanged(choice);
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 16,
          vertical: dense ? 12 : 18,
        ),
        decoration: BoxDecoration(
          color: ZeimotoColors.washiDeep,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: value == null
                ? ZeimotoColors.cinnabar.withValues(alpha: 0.5)
                : ZeimotoColors.sage.withValues(alpha: 0.5),
          ),
        ),
        child: Row(
          children: [
            Icon(Icons.eco_outlined, size: 20, color: ZeimotoColors.moss),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                value ?? 'Seleziona specie (obbligatoria)',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: value == null
                      ? ZeimotoColors.cinnabar
                      : ZeimotoColors.charcoal,
                  fontSize: 15,
                ),
              ),
            ),
            const Icon(Icons.chevron_right, color: ZeimotoColors.charcoalSoft),
          ],
        ),
      ),
    );
  }
}

class _SpeciesSheet extends StatefulWidget {
  const _SpeciesSheet({required this.current});
  final String? current;

  @override
  State<_SpeciesSheet> createState() => _SpeciesSheetState();
}

class _SpeciesSheetState extends State<_SpeciesSheet> {
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: ZeimotoColors.charcoalSoft.withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                controller: _controller,
                autofocus: false,
                decoration: InputDecoration(
                  hintText: 'Cerca o digita specie custom',
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: ZeimotoColors.washiDeep,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
                onSubmitted: (v) =>
                    Navigator.pop(context, v.trim().isEmpty ? null : v.trim()),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 320,
              child: ListView(
                children: [
                  for (final s in kSeedSpecies)
                    ListTile(
                      leading: const Icon(
                        Icons.local_florist_outlined,
                        color: ZeimotoColors.moss,
                      ),
                      title: Text(s),
                      trailing: widget.current == s
                          ? const Icon(Icons.check, color: ZeimotoColors.moss)
                          : null,
                      onTap: () => Navigator.pop(context, s),
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

Future<void> showPrototypeSnack(BuildContext context, String message) async {
  ScaffoldMessenger.of(context).clearSnackBars();
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      duration: const Duration(seconds: 2),
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 88),
    ),
  );
}
