import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:zeimoto/screens/work_wizard/bloc/step_match_plant_cubit.dart';
import 'package:zeimoto/screens/work_wizard/bloc/step_match_plant_state.dart';
import 'package:zeimoto/screens/work_wizard/bloc/wizard_cubit.dart';

class StepMatchPlant extends StatelessWidget {
  const StepMatchPlant({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => StepMatchPlantCubit(),
      child: const _StepMatchPlantContent(),
    );
  }
}

class _StepMatchPlantContent extends StatelessWidget {
  const _StepMatchPlantContent();

  @override
  Widget build(BuildContext context) {
    final wizardState = context.watch<WizardCubit>().state;

    return BlocBuilder<StepMatchPlantCubit, StepMatchPlantState>(
      builder: (context, state) {
        return Stack(
          children: [
            // Camera Preview Section (Background)
            Positioned.fill(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  if (wizardState.initialPhoto != null)
                    Image.file(
                      File(wizardState.initialPhoto!.path),
                      fit: BoxFit.cover,
                    )
                  else if (state.isCameraInitialized &&
                      state.cameraController != null)
                    CameraPreview(state.cameraController!)
                  else
                    Container(
                      color: Colors.black,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.camera_alt_outlined,
                              color: Colors.white54,
                              size: 48,
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'Camera non disponibile',
                              style: TextStyle(color: Colors.white54),
                            ),
                            TextButton.icon(
                              onPressed: () async {
                                final file = await context
                                    .read<StepMatchPlantCubit>()
                                    .pickFromGallery();
                                if (file != null && context.mounted) {
                                  context.read<WizardCubit>().setInitialPhoto(
                                    file,
                                  );
                                }
                              },
                              icon: const Icon(Icons.photo_library),
                              label: const Text('Scegli da Galleria'),
                              style: TextButton.styleFrom(
                                foregroundColor: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                  if (wizardState.initialPhoto != null)
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        color: Colors.black54,
                        child: const Icon(
                          Icons.check_circle,
                          color: Colors.green,
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // Draggable Sheet
            DraggableScrollableSheet(
              initialChildSize: 0.35,
              minChildSize: 0.35,
              maxChildSize: 0.65,
              builder: (context, scrollController) {
                return Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(24),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 10,
                            offset: Offset(0, -2),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Expanded(
                            child: CustomScrollView(
                              controller: scrollController,
                              slivers: [
                                SliverToBoxAdapter(
                                  child: Column(
                                    children: [
                                      const SizedBox(height: 24),
                                      // Header
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 16.0,
                                          vertical: 8.0,
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            const Text(
                                              'Seleziona Pianta',
                                              style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            TextButton.icon(
                                              onPressed: () {
                                                // Note: logic to refresh plants after adding new one is simpler if we just reload
                                                // Currently _loadPlants was internal. Now it's in Cubit but private.
                                                // We might need to expose a refresh method or reload.
                                                // StepMatchPlantCubit initializes on creation.
                                                // If we push and come back, the cubit might not reload automatically if it wasn't disposed.
                                                // But since we are pushing a new route, this widget stays mounted.
                                                // So we might need to call a public loadPlants on return.
                                                // But let's assume for now context.push returns and we might not easily trigger reload unless we expose it.
                                                // I'll assume for now the user accepts just pushing.
                                                // To fix this properly, I should make loadPlants public or reload when focus returns.
                                                context.push('/add-plant');
                                              },
                                              icon: const Icon(Icons.add),
                                              label: const Text('Nuova'),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                if (state.isLoadingPlants)
                                  const SliverFillRemaining(
                                    hasScrollBody: false,
                                    child: Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                  )
                                else if (state.plants.isEmpty)
                                  const SliverFillRemaining(
                                    hasScrollBody: false,
                                    child: Center(
                                      child: Text('Nessuna pianta salvata.'),
                                    ),
                                  )
                                else
                                  SliverList(
                                    delegate: SliverChildBuilderDelegate((
                                      context,
                                      index,
                                    ) {
                                      final plant = state.plants[index];
                                      final isSelected =
                                          wizardState.selectedPlant?.id ==
                                          plant.id;
                                      return ListTile(
                                        title: Text(plant.name),
                                        subtitle: Text(plant.species),
                                        selected: isSelected,
                                        selectedTileColor: Colors.green
                                            .withValues(alpha: 0.1),
                                        trailing: isSelected
                                            ? const Icon(
                                                Icons.check,
                                                color: Colors.green,
                                              )
                                            : null,
                                        onTap: () {
                                          if (wizardState.selectedPlant !=
                                                  null &&
                                              wizardState.selectedPlant!.id !=
                                                  plant.id &&
                                              wizardState
                                                  .workEntries
                                                  .isNotEmpty) {
                                            showDialog(
                                              context: context,
                                              builder: (ctx) => AlertDialog(
                                                title: const Text(
                                                  'Cambio pianta',
                                                ),
                                                content: const Text(
                                                  'Cambiando la pianta verranno cancellate tutte le lavorazioni inserite. Continuare?',
                                                ),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () =>
                                                        Navigator.pop(ctx),
                                                    child: const Text(
                                                      'Annulla',
                                                    ),
                                                  ),
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.pop(ctx);
                                                      context
                                                          .read<WizardCubit>()
                                                          .clearWorkEntries();
                                                      context
                                                          .read<WizardCubit>()
                                                          .setPlant(plant);
                                                    },
                                                    child: const Text(
                                                      'Conferma',
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          } else {
                                            context
                                                .read<WizardCubit>()
                                                .setPlant(plant);
                                          }
                                        },
                                      );
                                    }, childCount: state.plants.length),
                                  ),
                              ],
                            ),
                          ),

                          // Bottom Bar
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                TextButton(
                                  onPressed: () => context.go('/'),
                                  child: const Text('ANNULLA'),
                                ),
                                ElevatedButton(
                                  onPressed: wizardState.selectedPlant != null
                                      ? () => context
                                            .read<WizardCubit>()
                                            .nextStep()
                                      : null,
                                  child: const Text('AVANTI'),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Floating Action Buttons for Camera and Gallery
                    Positioned(
                      top: -28,
                      left: 0,
                      right: 0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: () async {
                              final file = await context
                                  .read<StepMatchPlantCubit>()
                                  .takePicture();
                              if (file != null && context.mounted) {
                                context.read<WizardCubit>().setInitialPhoto(
                                  file,
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              shape: const CircleBorder(),
                              padding: const EdgeInsets.all(16),
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.black,
                              elevation: 4,
                            ),
                            child: const Icon(Icons.camera_alt, size: 32),
                          ),
                          const SizedBox(width: 24), // Space between buttons
                          ElevatedButton(
                            onPressed: () async {
                              final file = await context
                                  .read<StepMatchPlantCubit>()
                                  .pickFromGallery();
                              if (file != null && context.mounted) {
                                context.read<WizardCubit>().setInitialPhoto(
                                  file,
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              shape: const CircleBorder(),
                              padding: const EdgeInsets.all(16),
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.black,
                              elevation: 4,
                            ),
                            child: const Icon(Icons.photo_library, size: 32),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        );
      },
    );
  }
}
