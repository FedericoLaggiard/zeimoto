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
  String get wizard_step_photo_heading => 'Add a photo';

  @override
  String get wizard_pick_photo_camera => 'Camera';

  @override
  String get wizard_pick_photo_gallery => 'Choose from gallery';

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
  String get collection_add_plant_cta => 'Add your first plant';

  @override
  String get wizard_save_feedback => 'Plant added to your collection';

  @override
  String get focus_plant_section_title => 'Plant Focus';

  @override
  String get focus_plant_empty => 'No plants available';

  @override
  String get ai_assistant_section_title => 'AI Assistant';

  @override
  String get ai_assistant_card_label => 'Contextual observations';

  @override
  String get ai_assistant_card_message =>
      'The app observes, suggests, and remembers your collection context, but it does not replace the bonsai grower.';

  @override
  String get calendar_section_title => 'Calendar';

  @override
  String get calendar_past_events_title => 'Past events';

  @override
  String get calendar_suggested_tasks_title => 'Suggested tasks';

  @override
  String get calendar_suggested_badge => 'suggested';

  @override
  String get calendar_past_event_1_title => 'Maple repot completed';

  @override
  String get calendar_past_event_1_date => 'Jul 10';

  @override
  String get calendar_past_event_2_title => 'Elm defoliation completed';

  @override
  String get calendar_past_event_2_date => 'Jul 7';

  @override
  String get calendar_past_event_3_title => 'Extra watering completed';

  @override
  String get calendar_past_event_3_date => 'Jul 3';

  @override
  String get calendar_suggested_task_1_title => 'Check pine substrate moisture';

  @override
  String get calendar_suggested_task_1_date => 'tomorrow';

  @override
  String get calendar_suggested_task_2_title =>
      'Assess sun shielding for azalea';

  @override
  String get calendar_suggested_task_2_date => 'in 2 days';

  @override
  String get calendar_suggested_task_3_title => 'Plan a light fertilization';

  @override
  String get calendar_suggested_task_3_date => 'this week';

  @override
  String get plant_detail_coming_soon => 'Full details coming soon';

  @override
  String get agent_bar_hint_text => 'What would you like to do today?';

  @override
  String get agent_bar_new_plant_tooltip => 'New plant';

  @override
  String get wiki_section_title => 'Wiki of the Day';

  @override
  String get wiki_reading_label => 'RECOMMENDED READING';

  @override
  String get wiki_article_1_title => 'Nebari technique';

  @override
  String get wiki_article_1_body =>
      'How to develop visible and harmonious surface roots through progressive exposure techniques.';

  @override
  String get wiki_article_2_title => 'Refinement pruning';

  @override
  String get wiki_article_2_body =>
      'Guiding principles for fine pruning: timing, angle, and tools for thin branches.';

  @override
  String get wiki_article_3_title => 'Spring repotting';

  @override
  String get wiki_article_3_body =>
      'Time windows and visual indicators for correct seasonal repotting.';

  @override
  String get wiki_article_4_title => 'Substrates and permeability';

  @override
  String get wiki_article_4_body =>
      'Optimal compositions for different species: akadama, pumice, volcanic lava.';

  @override
  String get wiki_article_5_title => 'Aluminium vs copper wire';

  @override
  String get wiki_article_5_body =>
      'Practical differences in using the two materials: strength, imprint, and seasonal durability.';
}
