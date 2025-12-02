import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zeimoto/models/plant.dart';

class WikiScreen extends StatelessWidget {
  final Plant plant;
  const WikiScreen({super.key, required this.plant});

  @override
  Widget build(BuildContext context) {
    final species = plant.species;
    final queries = [
      'Bonsai $species tecniche',
      'Bonsai $species potatura',
      'Bonsai $species legatura',
      'Bonsai $species rinvaso stagione',
    ];
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text('Video YouTube suggeriti'),
        const SizedBox(height: 12),
        ...queries.map((q) => ListTile(
              title: Text(q),
              trailing: const Icon(Icons.open_in_new),
              onTap: () => _open('https://www.youtube.com/results?search_query=${Uri.encodeComponent(q)}'),
            )),
      ],
    );
  }

  Future<void> _open(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      await launchUrl(uri, mode: LaunchMode.inAppWebView);
    }
  }
}
