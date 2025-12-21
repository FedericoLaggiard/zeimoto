import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:zeimoto/models/enums.dart';
import 'package:zeimoto/screens/work_wizard/wizard_state.dart';

class StepWork extends StatefulWidget {
  const StepWork({super.key});

  @override
  State<StepWork> createState() => _StepWorkState();
}

class _StepWorkState extends State<StepWork> {
  // Removed unused _picker here, moved to _WorkEntryCard

  @override
  Widget build(BuildContext context) {
    final state = context.watch<WizardState>();
    final entries = state.workEntries;

    return Column(
      children: [
        // Top Photo Section
        if (state.initialPhoto != null)
          SizedBox(
            height: 150,
            width: double.infinity,
            child: Image.file(
              File(state.initialPhoto!.path),
              fit: BoxFit.cover,
            ),
          )
        else
          Container(
            height: 150,
            width: double.infinity,
            color: Colors.grey[300],
            child: const Center(
              child: Icon(Icons.image_not_supported, size: 50),
            ),
          ),

        // Accordion List
        Expanded(
          child: entries.isEmpty
              ? Center(
                  child: ElevatedButton.icon(
                    onPressed: _addNewEntry,
                    icon: const Icon(Icons.add),
                    label: const Text('Aggiungi Lavorazione'),
                  ),
                )
              : ListView.builder(
                  itemCount:
                      entries.length + 1, // +1 for the Add button at bottom
                  itemBuilder: (context, index) {
                    if (index == entries.length) {
                      return Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: OutlinedButton.icon(
                          onPressed: _addNewEntry,
                          icon: const Icon(Icons.add),
                          label: const Text('Aggiungi altra lavorazione'),
                        ),
                      );
                    }
                    final entry = entries[index];
                    return _WorkEntryCard(
                      key: ValueKey(entry.id),
                      entry: entry,
                      index: index,
                      onDelete: () => _confirmDelete(entry.id),
                    );
                  },
                ),
        ),

        // Bottom Bar
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: () => context.read<WizardState>().prevStep(),
                child: const Text('INDIETRO'),
              ),
              ElevatedButton(
                onPressed: entries.isNotEmpty
                    ? () => context.read<WizardState>().nextStep()
                    : null,
                child: const Text('AVANTI'),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _addNewEntry() {
    final newEntry = WorkEntry(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      type: InterventionType.pruning, // Default
    );
    context.read<WizardState>().addWorkEntry(newEntry);
  }

  void _confirmDelete(String id) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Conferma cancellazione'),
        content: const Text('Vuoi davvero cancellare questa lavorazione?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Annulla'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              context.read<WizardState>().removeWorkEntry(id);
            },
            child: const Text('Cancella'),
          ),
        ],
      ),
    );
  }
}

class _WorkEntryCard extends StatefulWidget {
  final WorkEntry entry;
  final int index;
  final VoidCallback onDelete;

  const _WorkEntryCard({
    required Key key,
    required this.entry,
    required this.index,
    required this.onDelete,
  }) : super(key: key);

  @override
  State<_WorkEntryCard> createState() => _WorkEntryCardState();
}

class _WorkEntryCardState extends State<_WorkEntryCard> {
  late TextEditingController _notesCtrl;
  final ImagePicker _picker = ImagePicker();
  bool _isExpanded = true; // Initially expanded

  @override
  void initState() {
    super.initState();
    _notesCtrl = TextEditingController(text: widget.entry.notes);
  }

  @override
  void dispose() {
    _notesCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Map InterventionType to label
    final Map<InterventionType, String> typeLabels = {
      InterventionType.pruning: 'Potatura',
      InterventionType.repotting: 'Rinvaso',
      InterventionType.fertilization: 'Concimazione',
      InterventionType.phytosanitary: 'Trattamento',
      InterventionType.wiring: 'Legatura',
      InterventionType.cleaning: 'Pulizia', // Extra
      InterventionType.deadwood: 'Legna secca', // Extra
    };

    // Filter to requested types + others if needed. The user requested specific list.
    final requestedTypes = [
      InterventionType.pruning,
      InterventionType.repotting,
      InterventionType.fertilization,
      InterventionType.phytosanitary,
      InterventionType.wiring,
    ];

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ExpansionTile(
        initiallyExpanded: _isExpanded,
        onExpansionChanged: (v) => setState(() => _isExpanded = v),
        title: Text(
          'Lavorazione ${widget.index + 1}: ${typeLabels[widget.entry.type]}',
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete, color: Colors.red),
          onPressed: widget.onDelete,
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DropdownButtonFormField<InterventionType>(
                  initialValue: requestedTypes.contains(widget.entry.type)
                      ? widget.entry.type
                      : requestedTypes.first,
                  decoration: const InputDecoration(
                    labelText: 'Tipo di lavoro',
                  ),
                  items: requestedTypes.map((t) {
                    return DropdownMenuItem(
                      value: t,
                      child: Text(typeLabels[t] ?? t.toString()),
                    );
                  }).toList(),
                  onChanged: (v) {
                    if (v != null) {
                      setState(() {
                        widget.entry.type = v;
                      });
                      context.read<WizardState>().updateWorkEntry(widget.entry);
                    }
                  },
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _notesCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Note di lavoro',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                  onChanged: (v) {
                    widget.entry.notes = v;
                    context.read<WizardState>().updateWorkEntry(widget.entry);
                  },
                ),
                const SizedBox(height: 16),
                const Text(
                  'Foto di dettaglio:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  height: 80,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: widget.entry.detailPhotos.length + 1,
                    itemBuilder: (ctx, i) {
                      if (i == widget.entry.detailPhotos.length) {
                        return GestureDetector(
                          onTap: _showPhotoSourceDialog,
                          child: Container(
                            width: 80,
                            margin: const EdgeInsets.only(right: 8),
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(Icons.add_a_photo),
                          ),
                        );
                      }
                      return Container(
                        width: 80,
                        margin: const EdgeInsets.only(right: 8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          image: DecorationImage(
                            image: FileImage(
                              File(widget.entry.detailPhotos[i].path),
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showPhotoSourceDialog() {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Scatta foto'),
              onTap: () {
                Navigator.pop(ctx);
                _pickDetailPhoto(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Scegli da galleria'),
              onTap: () {
                Navigator.pop(ctx);
                _pickDetailPhoto(ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickDetailPhoto(ImageSource source) async {
    try {
      final image = await _picker.pickImage(source: source);
      if (image != null) {
        setState(() {
          widget.entry.detailPhotos = [...widget.entry.detailPhotos, image];
        });
        if (mounted) {
          context.read<WizardState>().updateWorkEntry(widget.entry);
        }
      }
    } catch (e) {
      debugPrint('Error picking image: $e');
      if (source == ImageSource.camera && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Camera non disponibile. Prova la galleria.'),
          ),
        );
      }
    }
  }
}
