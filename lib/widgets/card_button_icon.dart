import 'package:flutter/material.dart';

class CardButtonIcon extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final String? heroTag;

  const CardButtonIcon({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
    this.heroTag,
  });

  @override
  Widget build(BuildContext context) {
    const Color baseColor = Color(0xFF4C5B4B);
    final hsl = HSLColor.fromColor(baseColor);
    final borderColor = hsl
        .withLightness((hsl.lightness + 0.15).clamp(0.0, 1.0))
        .toColor();
    const double radius = 12.0;
    return LayoutBuilder(
      builder: (ctx, c) {
        final w = c.maxWidth;
        final iconSize = w < 170 ? 24.0 : 28.0;
        final fontSize = w < 170 ? 14.0 : 16.0;
        final maxLines = w < 170 ? 2 : 3;

        Widget iconWidget = Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: borderColor,
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: borderColor, width: 2),
          ),
          child: Icon(icon, color: Colors.white, size: iconSize),
        );

        Widget card = Card(
          color: baseColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius),
            side: const BorderSide(color: Color(0xFF3F4B3D), width: 2),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(radius),
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  iconWidget,
                  const SizedBox(height: 8),
                  const Expanded(child: SizedBox()),
                  Text(
                    label,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: fontSize,
                      fontWeight: FontWeight.w400,
                    ),
                    textAlign: TextAlign.start,
                    maxLines: maxLines,
                    overflow: TextOverflow.ellipsis,
                    softWrap: true,
                  ),
                ],
              ),
            ),
          ),
        );

        if (heroTag != null) {
          return Hero(tag: heroTag!, child: card);
        }

        return card;
      },
    );
  }
}
