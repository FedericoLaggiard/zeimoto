import 'package:flutter/material.dart';
import 'package:zeimoto/models/enums.dart';
import 'package:zeimoto/services/plant_repository.dart';

class AddPlantScreen extends StatefulWidget {
  const AddPlantScreen({super.key});
  @override
  State<AddPlantScreen> createState() => _AddPlantScreenState();
}

class _AddPlantScreenState extends State<AddPlantScreen> {
  final _form = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _species = TextEditingController();
  WorkStage _stage = WorkStage.nursery;
  bool _saving = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nuova pianta')),
      body: Form(
        key: _form,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _name,
              decoration: const InputDecoration(labelText: 'Nome'),
              validator: (v) => (v == null || v.isEmpty) ? 'Obbligatorio' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _species,
              decoration: const InputDecoration(labelText: 'Specie'),
              validator: (v) => (v == null || v.isEmpty) ? 'Obbligatorio' : null,
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<WorkStage>(
              initialValue: _stage,
              decoration: const InputDecoration(labelText: 'Grado di lavorazione'),
              items: WorkStage.values.map((e) => DropdownMenuItem(value: e, child: Text(_label(e)))).toList(),
              onChanged: (v) => setState(() => _stage = v ?? WorkStage.nursery),
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: _saving ? null : () async {
                if (!_form.currentState!.validate()) return;
                setState(() => _saving = true);
                final repo = PlantRepository();
                await repo.add(name: _name.text.trim(), species: _species.text.trim(), stage: _stage);
                if (!context.mounted) return;
                Navigator.of(context).pop();
              },
              child: _saving ? const CircularProgressIndicator() : const Text('Salva'),
            ),
          ],
        ),
      ),
    );
  }

  String _label(WorkStage s) {
    switch (s) {
      case WorkStage.nursery: return 'Nursery';
      case WorkStage.firstSetup: return 'Prima impostazione';
      case WorkStage.refinement: return 'Rifinitura';
      case WorkStage.mature: return 'Bonsai maturo';
    }
  }
}
