import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../domain/plants.dart';
import '../../l10n/app_localizations.dart';
import 'plant_creation_cubit.dart';
import 'plant_creation_state.dart';

/// Full-page 3-step wizard for adding a new plant.
///
/// Step 1 — Foto: pick a cover photo from camera or gallery via image_picker.
/// Step 2 — Specie: choose from [kSeedSpecies] or type manually.
/// Step 3 — Nickname: optional free-text; defaults to [defaultNickname].
///
/// The wizard is navigation-agnostic: it creates its own [PlantCreationCubit]
/// from the ambient [PlantRepository] (via [RepositoryProvider]) and pops the
/// route when [PlantCreationSaved] is emitted.
///
/// [imagePicker] can be injected for tests to avoid opening the native picker.
class AddPlantWizard extends StatelessWidget {
  const AddPlantWizard({super.key, this.imagePicker});

  final ImagePicker? imagePicker;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (ctx) => PlantCreationCubit(
        ctx.read<PlantRepository>(),
        imagePicker: imagePicker,
      ),
      child: const _WizardView(),
    );
  }
}

// ---------------------------------------------------------------------------
// View — thin StatefulWidget to manage TextEditingController lifecycle only
// ---------------------------------------------------------------------------

class _WizardView extends StatefulWidget {
  const _WizardView();

  @override
  State<_WizardView> createState() => _WizardViewState();
}

class _WizardViewState extends State<_WizardView> {
  final TextEditingController _speciesController = TextEditingController();
  final TextEditingController _nicknameController = TextEditingController();

  @override
  void dispose() {
    _speciesController.dispose();
    _nicknameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocListener<PlantCreationCubit, PlantCreationState>(
      listener: (context, state) {
        if (state is PlantCreationSaved) {
          final l10n = AppLocalizations.of(context)!;
          final messenger = ScaffoldMessenger.of(context);
          context.pop();
          messenger.showSnackBar(
            SnackBar(content: Text(l10n.wizard_save_feedback)),
          );
        }
      },
      child: BlocBuilder<PlantCreationCubit, PlantCreationState>(
        buildWhen: (_, next) => next is PlantCreationCollecting,
        builder: (context, state) {
          final collecting = state as PlantCreationCollecting;
          final cubit = context.read<PlantCreationCubit>();

          return Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              actions: [
                IconButton(
                  key: const Key('wizard_close_button'),
                  icon: const Icon(Icons.close),
                  tooltip: l10n.wizard_close,
                  onPressed: () => context.pop(),
                ),
              ],
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(4),
                child: LinearProgressIndicator(
                  value: (collecting.step.index + 1) / 3,
                  backgroundColor: Colors.black12,
                ),
              ),
            ),
            body: switch (collecting.step) {
              WizardStep.foto => _StepFoto(
                selectedPhotoPath: collecting.selectedPhotoPath,
                onPickCamera: () => cubit.pickPhoto(ImageSource.camera),
                onPickGallery: () => cubit.pickPhoto(ImageSource.gallery),
                onNext: collecting.canAdvance ? cubit.advance : null,
              ),
              WizardStep.specie => _StepSpecie(
                speciesController: _speciesController,
                species: collecting.species,
                onSpeciesChanged: cubit.changeSpecies,
                onNext: collecting.canAdvance ? cubit.advance : null,
              ),
              WizardStep.nickname => _StepNickname(
                nicknameController: _nicknameController,
                defaultName: defaultNickname(collecting.species, 0),
                onNicknameChanged: cubit.changeNickname,
                onSave: () => cubit.save(),
              ),
            },
          );
        },
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Step 1 — Foto
// ---------------------------------------------------------------------------

class _StepFoto extends StatelessWidget {
  const _StepFoto({
    required this.selectedPhotoPath,
    required this.onPickCamera,
    required this.onPickGallery,
    required this.onNext,
  });

  final String? selectedPhotoPath;
  final VoidCallback onPickCamera;
  final VoidCallback onPickGallery;
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
            l10n.wizard_step_photo_heading,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
        ),
        Expanded(
          child: selectedPhotoPath != null
              ? _PhotoPreview(
                  key: const Key('wizard_photo_preview'),
                  path: selectedPhotoPath!,
                )
              : const _PhotoPickerPlaceholder(),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
          child: FilledButton.icon(
            key: const Key('wizard_pick_photo_camera_button'),
            onPressed: onPickCamera,
            icon: const Icon(Icons.camera_alt),
            label: Text(l10n.wizard_pick_photo_camera),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
          child: OutlinedButton.icon(
            key: const Key('wizard_pick_photo_gallery_button'),
            onPressed: onPickGallery,
            icon: const Icon(Icons.photo_library),
            label: Text(l10n.wizard_pick_photo_gallery),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: ElevatedButton(
            key: const Key('wizard_next_button'),
            onPressed: onNext,
            child: Text(l10n.wizard_button_next),
          ),
        ),
      ],
    );
  }
}

class _PhotoPreview extends StatelessWidget {
  const _PhotoPreview({super.key, required this.path});

  final String path;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.file(
          File(path),
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => Container(
            color: Colors.grey[300],
            child: const Icon(Icons.broken_image, size: 48),
          ),
        ),
      ),
    );
  }
}

class _PhotoPickerPlaceholder extends StatelessWidget {
  const _PhotoPickerPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(Icons.add_a_photo, size: 64, color: Colors.grey),
      ),
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
            l10n.wizard_step_species_heading,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: TextField(
            key: const Key('wizard_species_field'),
            controller: speciesController,
            decoration: InputDecoration(
              hintText: l10n.wizard_species_field_hint,
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
            child: Text(l10n.wizard_button_next),
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
    required this.onNicknameChanged,
    required this.onSave,
  });

  final TextEditingController nicknameController;
  final String defaultName;
  final ValueChanged<String> onNicknameChanged;
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
            l10n.wizard_step_nickname_heading,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: TextField(
            key: const Key('wizard_nickname_field'),
            controller: nicknameController,
            decoration: InputDecoration(
              hintText: l10n.wizard_nickname_field_hint(defaultName),
              border: const OutlineInputBorder(),
            ),
            onChanged: onNicknameChanged,
          ),
        ),
        const Spacer(),
        Padding(
          padding: const EdgeInsets.all(16),
          child: ElevatedButton(
            key: const Key('wizard_save_button'),
            onPressed: onSave,
            child: Text(l10n.wizard_button_save),
          ),
        ),
      ],
    );
  }
}


