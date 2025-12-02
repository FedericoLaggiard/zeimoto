import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:zeimoto/models/photo.dart';

class PhotoGrid extends StatelessWidget {
  final List<PhotoEntry> photos;
  final VoidCallback onAddFromGallery;
  final VoidCallback onAddFromCamera;
  const PhotoGrid({super.key, required this.photos, required this.onAddFromGallery, required this.onAddFromCamera});

  @override
  Widget build(BuildContext context) {
    final items = [
      ...photos.map((p) => _PhotoTile(entry: p)),
      _AddTile(onAddFromGallery: onAddFromGallery, onAddFromCamera: onAddFromCamera),
    ];
    return GridView.builder(
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, crossAxisSpacing: 8, mainAxisSpacing: 8),
      itemCount: items.length,
      itemBuilder: (_, i) => items[i],
    );
  }
}

class _PhotoTile extends StatelessWidget {
  final PhotoEntry entry;
  const _PhotoTile({required this.entry});
  @override
  Widget build(BuildContext context) {
    final img = kIsWeb || entry.path.startsWith('data:')
        ? Image.network(entry.path, fit: BoxFit.cover)
        : Image.network(entry.path, fit: BoxFit.cover);
    return Stack(children: [
      Positioned.fill(child: img),
      Positioned(
        bottom: 4,
        left: 4,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          color: Colors.black54,
          child: Text(entry.dateTaken.toLocal().toString().substring(0, 10), style: const TextStyle(color: Colors.white, fontSize: 11)),
        ),
      ),
    ]);
  }
}

class _AddTile extends StatelessWidget {
  final VoidCallback onAddFromGallery;
  final VoidCallback onAddFromCamera;
  const _AddTile({required this.onAddFromGallery, required this.onAddFromCamera});
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        IconButton(onPressed: onAddFromGallery, icon: const Icon(Icons.photo_library)),
        IconButton(onPressed: onAddFromCamera, icon: const Icon(Icons.camera_alt)),
      ]),
    );
  }
}
