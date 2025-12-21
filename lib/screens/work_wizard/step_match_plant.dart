import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:go_router/go_router.dart';
import 'package:zeimoto/models/plant.dart';
import 'package:zeimoto/screens/work_wizard/bloc/wizard_cubit.dart';
import 'package:zeimoto/services/plant_repository.dart';

class StepMatchPlant extends StatefulWidget {
  const StepMatchPlant({super.key});

  @override
  State<StepMatchPlant> createState() => _StepMatchPlantState();
}

class _StepMatchPlantState extends State<StepMatchPlant> {
  CameraController? _cameraController;
  List<CameraDescription>? _cameras;
  List<Plant> _plants = [];
  bool _isLoadingPlants = true;
  final PlantRepository _plantRepo = PlantRepository();

  @override
  void initState() {
    super.initState();
    _initCamera();
    _loadPlants();
  }

  Future<void> _initCamera() async {
    try {
      _cameras = await availableCameras();
      if (_cameras != null && _cameras!.isNotEmpty) {
        _cameraController = CameraController(
          _cameras![0],
          ResolutionPreset.medium,
          enableAudio: false,
        );
        await _cameraController!.initialize();
        if (mounted) {
          setState(() {});
        }
      }
    } catch (e) {
      debugPrint('Camera init error: $e');
    }
    // Ensure we rebuild to show fallback if camera init failed or returned empty
    if (mounted) setState(() {});
  }

  Future<void> _loadPlants() async {
    setState(() => _isLoadingPlants = true);
    // Since Hive is synchronous for reads after open, but let's simulate async if needed or just fetch
    final plants = _plantRepo.all().toList();
    if (mounted) {
      setState(() {
        _plants = plants;
        _isLoadingPlants = false;
      });
    }
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  Future<void> _takePicture() async {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      // Fallback: pick from gallery if camera not available (simulator)
      _pickFromGallery();
      return;
    }
    try {
      final image = await _cameraController!.takePicture();
      if (mounted) {
        context.read<WizardCubit>().setInitialPhoto(image);
      }
    } catch (e) {
      debugPrint('Error taking picture: $e');
      _pickFromGallery();
    }
  }

  Future<void> _pickFromGallery() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null && mounted) {
      context.read<WizardCubit>().setInitialPhoto(image);
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<WizardCubit>().state;
    final size = MediaQuery.of(context).size;

    return Column(
      children: [
        // Camera Preview Section
        SizedBox(
          height: size.height * 0.4,
          width: double.infinity,
          child: Stack(
            fit: StackFit.expand,
            children: [
              if (_cameraController != null &&
                  _cameraController!.value.isInitialized)
                CameraPreview(_cameraController!)
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
                          onPressed: _pickFromGallery,
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

              if (state.initialPhoto != null)
                // Show taken photo preview overlay or indicator?
                // Requirement says "show preview of camera... with button to take NEW photo"
                // So we keep showing camera preview.
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    color: Colors.black54,
                    child: const Icon(Icons.check_circle, color: Colors.green),
                  ),
                ),

              Positioned(
                bottom: 16,
                left: 0,
                right: 0,
                child: Center(
                  child: ElevatedButton(
                    onPressed: _takePicture,
                    child: const Icon(Icons.camera_alt),
                  ),
                ),
              ),
            ],
          ),
        ),

        // Plant List Section
        Expanded(
          child: Container(
            color: Colors.white,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Seleziona Pianta',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextButton.icon(
                        onPressed: () {
                          // Navigate to add plant screen?
                          context.push('/add-plant').then((_) => _loadPlants());
                        },
                        icon: const Icon(Icons.add),
                        label: const Text('Aggiungi nuova'),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: _isLoadingPlants
                      ? const Center(child: CircularProgressIndicator())
                      : _plants.isEmpty
                      ? const Center(child: Text('Nessuna pianta salvata.'))
                      : ListView.builder(
                          itemCount: _plants.length,
                          itemBuilder: (context, index) {
                            final plant = _plants[index];
                            final isSelected =
                                state.selectedPlant?.id == plant.id;
                            return ListTile(
                              title: Text(plant.name),
                              subtitle: Text(plant.species),
                              selected: isSelected,
                              selectedTileColor: Colors.green.withValues(
                                alpha: 0.1,
                              ),
                              trailing: isSelected
                                  ? const Icon(Icons.check, color: Colors.green)
                                  : null,
                              onTap: () {
                                final currentState = context
                                    .read<WizardCubit>()
                                    .state;
                                if (currentState.selectedPlant != null &&
                                    currentState.selectedPlant!.id !=
                                        plant.id &&
                                    currentState.workEntries.isNotEmpty) {
                                  showDialog(
                                    context: context,
                                    builder: (ctx) => AlertDialog(
                                      title: const Text('Cambio pianta'),
                                      content: const Text(
                                        'Cambiando la pianta verranno cancellate tutte le lavorazioni inserite. Continuare?',
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () => Navigator.pop(ctx),
                                          child: const Text('Annulla'),
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
                                          child: const Text('Conferma'),
                                        ),
                                      ],
                                    ),
                                  );
                                } else {
                                  context.read<WizardCubit>().setPlant(plant);
                                }
                              },
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        ),

        // Bottom Bar
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: () => context.go('/'), // Cancel to start screen
                child: const Text('ANNULLA'),
              ),
              ElevatedButton(
                onPressed: state.selectedPlant != null
                    ? () => context.read<WizardCubit>().nextStep()
                    : null,
                child: const Text('AVANTI'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
