import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zeimoto/screens/work_wizard/wizard_state.dart';
import 'package:zeimoto/screens/work_wizard/step_match_plant.dart';
import 'package:zeimoto/screens/work_wizard/step_work.dart';
import 'package:zeimoto/screens/work_wizard/step_end_work.dart';

class WizardScreen extends StatefulWidget {
  const WizardScreen({super.key});

  @override
  State<WizardScreen> createState() => _WizardScreenState();
}

class _WizardScreenState extends State<WizardScreen> {
  late final WizardState _wizardState;

  @override
  void initState() {
    super.initState();
    _wizardState = WizardState();
  }

  @override
  void dispose() {
    _wizardState.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'work_wizard_icon',
      child: ChangeNotifierProvider.value(
        value: _wizardState,
        child: const _WizardContent(),
      ),
    );
  }
}

class _WizardContent extends StatelessWidget {
  const _WizardContent();

  @override
  Widget build(BuildContext context) {
    final state = context.watch<WizardState>();

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.handyman),
            const SizedBox(width: 10),
            const Text('Wizard Lavorazione'),
          ],
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4.0),
          child: LinearProgressIndicator(
            value: (state.currentStep + 1) / 3,
            backgroundColor: Colors.grey[200],
            valueColor: AlwaysStoppedAnimation<Color>(
              Theme.of(context).primaryColor,
            ),
          ),
        ),
      ),
      body: IndexedStack(
        index: state.currentStep,
        children: const [StepMatchPlant(), StepWork(), StepEndWork()],
      ),
    );
  }
}
