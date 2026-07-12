// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get wizardClose => 'Close';

  @override
  String get wizardStepPhotoHeading => 'Choose a photo';

  @override
  String get wizardStepSpeciesHeading => 'Select the species';

  @override
  String get wizardStepNicknameHeading => 'Give it a name';

  @override
  String get wizardButtonNext => 'Next';

  @override
  String get wizardButtonSave => 'Save';

  @override
  String get wizardSpeciesFieldHint => 'Enter a species…';

  @override
  String wizardNicknameFieldHint(String defaultName) {
    return 'Leave empty to use: $defaultName';
  }

  @override
  String get collectionSectionTitle => 'Your Collection';

  @override
  String get collectionEmpty => 'No plants in your collection yet';

  @override
  String get plantDetailComingSoon => 'Full details coming soon';

  @override
  String get agent_bar_hint_text => 'What would you like to do today?';

  @override
  String get agent_bar_new_plant_tooltip => 'New plant';
}
