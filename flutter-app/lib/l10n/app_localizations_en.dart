// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get wizard_close => 'Close';

  @override
  String get wizard_step_photo_heading => 'Choose a photo';

  @override
  String get wizard_step_species_heading => 'Select the species';

  @override
  String get wizard_step_nickname_heading => 'Give it a name';

  @override
  String get wizard_button_next => 'Next';

  @override
  String get wizard_button_save => 'Save';

  @override
  String get wizard_species_field_hint => 'Enter a species…';

  @override
  String wizard_nickname_field_hint(String defaultName) {
    return 'Leave empty to use: $defaultName';
  }

  @override
  String get collection_section_title => 'Your Collection';

  @override
  String get collection_empty => 'No plants in your collection yet';

  @override
  String get ai_assistant_section_title => 'AI Assistant';

  @override
  String get ai_assistant_card_label => 'Contextual observations';

  @override
  String get ai_assistant_card_message =>
      'The app observes, suggests, and remembers your collection context, but it does not replace the bonsai grower.';

  @override
  String get plant_detail_coming_soon => 'Full details coming soon';

  @override
  String get agent_bar_hint_text => 'What would you like to do today?';

  @override
  String get agent_bar_new_plant_tooltip => 'New plant';
}
