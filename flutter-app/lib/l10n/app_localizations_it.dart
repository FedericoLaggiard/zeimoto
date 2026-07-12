// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class AppLocalizationsIt extends AppLocalizations {
  AppLocalizationsIt([String locale = 'it']) : super(locale);

  @override
  String get wizardClose => 'Chiudi';

  @override
  String get wizardStepPhotoHeading => 'Scegli una foto';

  @override
  String get wizardStepSpeciesHeading => 'Seleziona la specie';

  @override
  String get wizardStepNicknameHeading => 'Dai un nome';

  @override
  String get wizardButtonNext => 'Avanti';

  @override
  String get wizardButtonSave => 'Salva';

  @override
  String get wizardSpeciesFieldHint => 'Inserisci una specie…';

  @override
  String wizardNicknameFieldHint(String defaultName) {
    return 'Lascia vuoto per usare: $defaultName';
  }
}
