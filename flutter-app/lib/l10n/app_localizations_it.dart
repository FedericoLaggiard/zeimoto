// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class AppLocalizationsIt extends AppLocalizations {
  AppLocalizationsIt([String locale = 'it']) : super(locale);

  @override
  String get wizard_close => 'Chiudi';

  @override
  String get wizard_step_photo_heading => 'Scegli una foto';

  @override
  String get wizard_step_species_heading => 'Seleziona la specie';

  @override
  String get wizard_step_nickname_heading => 'Dai un nome';

  @override
  String get wizard_button_next => 'Avanti';

  @override
  String get wizard_button_save => 'Salva';

  @override
  String get wizard_species_field_hint => 'Inserisci una specie…';

  @override
  String wizard_nickname_field_hint(String defaultName) {
    return 'Lascia vuoto per usare: $defaultName';
  }

  @override
  String get collection_section_title => 'La Tua Collezione';

  @override
  String get collection_empty => 'Nessuna pianta nella collezione';

  @override
  String get ai_assistant_section_title => 'Assistente AI';

  @override
  String get ai_assistant_card_label => 'Osservazioni contestuali';

  @override
  String get ai_assistant_card_message =>
      'L\'app osserva, suggerisce e ricorda il contesto della tua collezione, ma non sostituisce il bonsaista.';

  @override
  String get plant_detail_coming_soon =>
      'Dettagli completi disponibili a breve';

  @override
  String get agent_bar_hint_text => 'Cosa vuoi fare oggi?';

  @override
  String get agent_bar_new_plant_tooltip => 'Nuova pianta';
}
