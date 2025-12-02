import 'package:flutter/material.dart';
import 'package:zeimoto/models/intervention.dart';
import 'package:zeimoto/models/enums.dart';
import 'package:zeimoto/services/intervention_repository.dart';

class InterventionTimeline extends StatefulWidget {
  final String plantId;
  final List<Intervention> interventions;
  const InterventionTimeline({super.key, required this.plantId, required this.interventions});
  @override
  State<InterventionTimeline> createState() => _InterventionTimelineState();
}

class _InterventionTimelineState extends State<InterventionTimeline> {
  final _repo = InterventionRepository();
  final _desc = TextEditingController();
  InterventionType _type = InterventionType.pruning;

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Expanded(
        child: ListView.separated(
          padding: const EdgeInsets.all(12),
          itemCount: widget.interventions.length,
          separatorBuilder: (context, index) => const SizedBox(height: 8),
          itemBuilder: (_, i) {
            final it = widget.interventions[i];
            return Card(
              child: ListTile(
                title: Text(_label(it.type)),
                subtitle: Text(it.description),
                trailing: Text(it.dateTime.toLocal().toString().substring(0, 16)),
              ),
            );
          },
        ),
      ),
      const Divider(height: 1),
      Padding(
        padding: const EdgeInsets.all(12),
        child: Row(children: [
          Expanded(
            child: DropdownButtonFormField<InterventionType>(
              initialValue: _type,
              items: InterventionType.values.map((e) => DropdownMenuItem(value: e, child: Text(_label(e)))).toList(),
              onChanged: (v) => setState(() => _type = v ?? InterventionType.pruning),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 2,
            child: TextField(controller: _desc, decoration: const InputDecoration(hintText: 'Descrizione')), 
          ),
          const SizedBox(width: 12),
          FilledButton(
            onPressed: () async {
              if (_desc.text.trim().isEmpty) return;
              await _repo.add(plantId: widget.plantId, type: _type, description: _desc.text.trim());
              setState(() { _desc.clear(); });
            },
            child: const Text('Aggiungi'),
          ),
        ]),
      ),
    ]);
  }

  String _label(InterventionType t) {
    switch (t) {
      case InterventionType.pruning: return 'Potatura';
      case InterventionType.wiring: return 'Legatura';
      case InterventionType.fertilization: return 'Concimazione';
      case InterventionType.cleaning: return 'Pulizia';
      case InterventionType.deadwood: return 'Legna secca';
      case InterventionType.repotting: return 'Rinvaso';
      case InterventionType.phytosanitary: return 'Trattamenti fitoterapici';
    }
  }
}
