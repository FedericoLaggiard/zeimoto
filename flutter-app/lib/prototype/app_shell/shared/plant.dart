import 'package:flutter/material.dart';

/// In-memory Plant model for the prototype.
/// Real domain model lives elsewhere once a variant wins.
class Plant {
  Plant({
    required this.id,
    required this.species,
    required this.nickname,
    required this.cover,
    this.createdAt,
  });

  final String id;
  final String species;
  final String nickname;
  final PlaceholderPhoto cover;
  final DateTime? createdAt;
}

/// Deterministic placeholder used in place of real photos.
/// A "photo" is just two gradient colors + an emoji glyph, so the prototype
/// runs with zero platform permissions.
class PlaceholderPhoto {
  const PlaceholderPhoto({
    required this.top,
    required this.bottom,
    required this.glyph,
  });

  final Color top;
  final Color bottom;
  final String glyph;

  static const _palette = <PlaceholderPhoto>[
    PlaceholderPhoto(
      top: Color(0xFF6E8B6A),
      bottom: Color(0xFF2F3F2C),
      glyph: '🌲',
    ),
    PlaceholderPhoto(
      top: Color(0xFFB2A57A),
      bottom: Color(0xFF5A4A2E),
      glyph: '🍁',
    ),
    PlaceholderPhoto(
      top: Color(0xFF9DB7C8),
      bottom: Color(0xFF3A5468),
      glyph: '🌿',
    ),
    PlaceholderPhoto(
      top: Color(0xFFC49A82),
      bottom: Color(0xFF5C382A),
      glyph: '🌳',
    ),
    PlaceholderPhoto(
      top: Color(0xFFA3C4A3),
      bottom: Color(0xFF3D5A3F),
      glyph: '🎋',
    ),
    PlaceholderPhoto(
      top: Color(0xFFD4B896),
      bottom: Color(0xFF6B4423),
      glyph: '🌱',
    ),
  ];

  static PlaceholderPhoto random([int? seed]) {
    final s = seed ?? DateTime.now().microsecondsSinceEpoch;
    return _palette[s.abs() % _palette.length];
  }
}

class PhotoTile extends StatelessWidget {
  const PhotoTile({
    super.key,
    required this.photo,
    this.borderRadius = 12,
    this.label,
  });

  final PlaceholderPhoto photo;
  final double borderRadius;
  final String? label;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [photo.top, photo.bottom],
          ),
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Center(
              child: Text(photo.glyph, style: const TextStyle(fontSize: 56)),
            ),
            if (label != null)
              Positioned(
                left: 12,
                right: 12,
                bottom: 12,
                child: Text(
                  label!,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 15,
                    shadows: [
                      Shadow(
                        blurRadius: 4,
                        color: Colors.black45,
                        offset: Offset(0, 1),
                      ),
                    ],
                  ),
                ),
              ),
            Positioned(
              top: 8,
              right: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.35),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text(
                  'PLACEHOLDER',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 8,
                    letterSpacing: 0.6,
                    fontWeight: FontWeight.w600,
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

/// Canonical species pool for the prototype's picker.
const kSeedSpecies = <String>[
  'Juniperus chinensis',
  'Acer palmatum',
  'Pinus parviflora',
  'Ficus retusa',
  'Ulmus parvifolia',
  'Carpinus turczaninowii',
  'Prunus mume',
  'Zelkova serrata',
  'Cryptomeria japonica',
  'Punica granatum',
];

String defaultNickname(String species, int index) {
  final base = species.split(' ').last.toLowerCase();
  return '${base}_${(index + 1).toString().padLeft(2, '0')}';
}
