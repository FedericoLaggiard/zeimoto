import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zeimoto/screens/add_wizard/wizard_state.dart';
import 'package:zeimoto/screens/add_wizard/step1_match_plant.dart';
import 'package:zeimoto/screens/add_wizard/step2_work.dart';
import 'package:zeimoto/screens/add_wizard/step3_close_work.dart';

class WizardScreen extends StatelessWidget {
  const WizardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => WizardState(),
      child: const _WizardContent(),
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
        title: const Text('Wizard Lavorazione'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4.0),
          child: LinearProgressIndicator(
            value: (state.currentStep + 1) / 3,
            backgroundColor: Colors.grey[200],
            valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
          ),
        ),
      ),
      body: IndexedStack(
        index: state.currentStep,
        children: const [
          Step1MatchPlant(),
          Step2Work(),
          Step3CloseWork(),
        ],
      ),
    );
  }
}
