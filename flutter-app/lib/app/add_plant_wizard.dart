import 'package:flutter/material.dart';

import '../domain/plant_creation_flow.dart';
import '../domain/plants.dart';
import '../l10n/app_localizations.dart';

/// Full-page 3-step wizard for adding a new plant.
///
/// Step 1 — Foto: pick one of the [PlaceholderPhoto] palette items.
/// Step 2 — Specie: choose from [kSeedSpecies] or type manually.
/// Step 3 — Nickname: optional free-text; defaults to [defaultNickname].
///
/// The wizard contains no domain logic; it only collects input and delegates
/// to [PlantCreationFlow.execute]. No sensitive data is ever logged.
class AddPlantWizard extends StatefulWidget {
  const AddPlantWizard({super.key, required this.flow});

  final PlantCreationFlow flow;

  @override
  State<AddPlantWizard> createState() => _AddPlantWizardState();
}

class _AddPlantWizardState extends State<AddPlantWizard> {
  int _step = 0; // 0 = Foto, 1 = Specie, 2 = Nickname

  PlaceholderPhoto? _selectedPhoto;
  String _species = '';
  final TextEditingController _speciesController = TextEditingController();
  final TextEditingController _nicknameController = TextEditingController();

  static final List<PlaceholderPhoto> _palette = PlaceholderPhoto.palette;

  @override
  void dispose() {
    _speciesController.dispose();
    _nicknameController.dispose();
    super.dispose();
  }

  void _close() => Navigator.of(context).pop();

  void _next() => setState(() => _step++);

  void _save() {
    widget.flow.execute(
      cover: _selectedPhoto!,
      species: _species,
      nickname: _nicknameController.text.trim().isEmpty
          ? null
          : _nicknameController.text.trim(),
    );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            key: const Key('wizard_close_button'),
            icon: const Icon(Icons.close),
            tooltip: l10n.wizardClose,
            onPressed: _close,
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4),
          child: LinearProgressIndicator(
            value: (_step + 1) / 3,
            backgroundColor: Colors.black12,
          ),
        ),
      ),
      body: switch (_step) {
        0 => _StepFoto(
          palette: _palette,
          selected: _selectedPhoto,
          onSelect: (photo) => setState(() => _selectedPhoto = photo),
          onNext: _selectedPhoto != null ? _next : null,
        ),
        1 => _StepSpecie(
          speciesController: _speciesController,
          species: _species,
          onSpeciesChanged: (value) => setState(() {
            _species = value;
          }),
          onNext: _species.trim().isNotEmpty ? _next : null,
        ),
        _ => _StepNickname(
          nicknameController: _nicknameController,
          defaultName: defaultNickname(_species, 0),
          onSave: _save,
        ),
      },
    );
  }
}

// ---------------------------------------------------------------------------
// Step 1 — Foto
// ---------------------------------------------------------------------------
class _StepFoto extends StatelessWidget {
  const _StepFoto({
    required this.palette,
    required this.selected,
    required this.onSelect,
    required this.onNext,
  });

  final List<PlaceholderPhoto> palette;
  final PlaceholderPhoto? selected;
  final ValueChanged<PlaceholderPhoto> onSelect;
  final VoidCallback? onNext;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
          child: Text(
            l10n.wizardStepPhotoHeading,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
        ),
        Expanded(
          child: GridView.builder(
            key: const Key('wizard_photo_grid'),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
            ),
            itemCount: palette.length,
            itemBuilder: (context, index) {
              final photo = palette[index];
              final isSelected = photo == selected;
              return GestureDetector(
                key: Key('wizard_photo_item_$index'),
                onTap: () => onSelect(photo),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [photo.top, photo.bottom],
                    ),
                    borderRadius: BorderRadius.circular(12),
                    border: isSelected
                        ? Border.all(
                            color: Theme.of(context).colorScheme.primary,
                            width: 3,
                          )
                        : null,
                  ),
                  child: Center(
                    child: Text(
                      photo.glyph,
                      style: const TextStyle(fontSize: 32),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: ElevatedButton(
            key: const Key('wizard_next_button'),
            onPressed: onNext,
            child: Text(l10n.wizardButtonNext),
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Step 2 — Specie
// ---------------------------------------------------------------------------
class _StepSpecie extends StatelessWidget {
  const _StepSpecie({
    required this.speciesController,
    required this.species,
    required this.onSpeciesChanged,
    required this.onNext,
  });

  final TextEditingController speciesController;
  final String species;
  final ValueChanged<String> onSpeciesChanged;
  final VoidCallback? onNext;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
          child: Text(
            l10n.wizardStepSpeciesHeading,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: TextField(
            key: const Key('wizard_species_field'),
            controller: speciesController,
            decoration: InputDecoration(
              hintText: l10n.wizardSpeciesFieldHint,
              border: const OutlineInputBorder(),
            ),
            onChanged: onSpeciesChanged,
          ),
        ),
        const SizedBox(height: 8),
        Expanded(
          child: ListView.builder(
            itemCount: kSeedSpecies.length,
            itemBuilder: (context, index) {
              return ListTile(
                key: Key('wizard_species_item_$index'),
                title: Text(kSeedSpecies[index]),
                selected: species == kSeedSpecies[index],
                onTap: () {
                  speciesController.text = kSeedSpecies[index];
                  onSpeciesChanged(kSeedSpecies[index]);
                },
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: ElevatedButton(
            key: const Key('wizard_next_button'),
            onPressed: onNext,
            child: Text(l10n.wizardButtonNext),
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Step 3 — Nickname
// ---------------------------------------------------------------------------
class _StepNickname extends StatelessWidget {
  const _StepNickname({
    required this.nicknameController,
    required this.defaultName,
    required this.onSave,
  });

  final TextEditingController nicknameController;
  final String defaultName;
  final VoidCallback onSave;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
          child: Text(
            l10n.wizardStepNicknameHeading,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: TextField(
            key: const Key('wizard_nickname_field'),
            controller: nicknameController,
            decoration: InputDecoration(
              hintText: l10n.wizardNicknameFieldHint(defaultName),
              border: const OutlineInputBorder(),
            ),
          ),
        ),
        const Spacer(),
        Padding(
          padding: const EdgeInsets.all(16),
          child: ElevatedButton(
            key: const Key('wizard_save_button'),
            onPressed: onSave,
            child: Text(l10n.wizardButtonSave),
          ),
        ),
      ],
    );
  }
}
