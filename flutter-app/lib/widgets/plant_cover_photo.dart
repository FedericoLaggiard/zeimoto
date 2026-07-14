import 'dart:io';

import 'package:flutter/material.dart';

import '../domain/plants.dart';

/// Renders the cover photo of a plant from a local file path.
///
/// Handles the common ClipRRect + Image.file + error-fallback pattern used
/// across [CollectionSection], [FocusPlantSection] and [PlantDetailPlaceholder].
///
/// Callers are responsible for sizing (wrap with [Expanded] or [SizedBox]).
class PlantCoverPhoto extends StatelessWidget {
  const PlantCoverPhoto({
    super.key,
    required this.path,
    this.iconSize = 48.0,
    this.borderRadius = 20.0,
  });

  /// Typed path to the cover photo on the local filesystem.
  final PhotoPath path;

  /// Size of the fallback icon when the image cannot be loaded.
  final double iconSize;

  /// Corner radius applied via [ClipRRect].
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: Image.file(
        File(path.value),
        fit: BoxFit.cover,
        width: double.infinity,
        errorBuilder: (_, __, ___) => Container(
          color: Colors.grey[300],
          child: Icon(Icons.eco, size: iconSize, color: Colors.grey),
        ),
      ),
    );
  }
}
