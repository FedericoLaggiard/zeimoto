import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../domain/plants.dart';
import '../../l10n/app_localizations.dart';
import 'plant_creation_cubit.dart';
import 'plant_creation_state.dart';

/// Full-page 3-step wizard for adding a new plant.
///
/// Step 1 — Foto: pick one of the [PlaceholderPhoto] palette items.
/// Step 2 — Specie: choose from [kSeedSpecies] or type manually.
/// Step 3 — Nickname: optional free-text; defaults to [defaultNickname].
///
/// The wizard is navigation-agnostic: it creates its own [PlantCreationCubit]
/// from the ambient [PlantRepository] (via [RepositoryProvider]) and pops the
/// route when [PlantCreationSaved] is emitted.
class AddPlantWizard extends StatelessWidget {
  const AddPlantWizard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (ctx) => PlantCreationCubit(ctx.read<PlantRepository>()),
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
          context.pop();
        }
      },
      child: BlocBuilder<PlantCreationCubit, PlantCreationState>(
        // Only rebuild while collecting; the listener handles the saved state.
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
                palette: PlaceholderPhoto.palette,
                selected: collecting.selectedPhoto,
                onSelect: cubit.selectPhoto,
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
                onSave: cubit.save,
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
            l10n.wizard_step_photo_heading,
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
            child: Text(l10n.wizard_button_next),
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
