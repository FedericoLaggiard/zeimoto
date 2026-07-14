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
  String get wizard_step_photo_heading => 'Aggiungi una foto';

  @override
  String get wizard_pick_photo_camera => 'Fotocamera';

  @override
  String get wizard_pick_photo_gallery => 'Scegli dalla galleria';

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
  String get collection_add_plant_cta => 'Aggiungi la tua prima pianta';

  @override
  String get wizard_save_feedback => 'Pianta aggiunta alla collezione';

  @override
  String get focus_plant_section_title => 'Focus Pianta';

  @override
  String get focus_plant_empty => 'Nessuna pianta disponibile';

  @override
  String get ai_assistant_section_title => 'Assistente AI';

  @override
  String get ai_assistant_card_label => 'Osservazioni contestuali';

  @override
  String get ai_assistant_card_message =>
      'L\'app osserva, suggerisce e ricorda il contesto della tua collezione, ma non sostituisce il bonsaista.';

  @override
  String get calendar_section_title => 'Calendario';

  @override
  String get calendar_past_events_title => 'Eventi passati';

  @override
  String get calendar_suggested_tasks_title => 'Task suggeriti';

  @override
  String get calendar_suggested_badge => 'suggerito';

  @override
  String get calendar_past_event_1_title => 'Rinvaso acero completato';

  @override
  String get calendar_past_event_1_date => '10 lug';

  @override
  String get calendar_past_event_2_title => 'Defogliazione olmo completata';

  @override
  String get calendar_past_event_2_date => '7 lug';

  @override
  String get calendar_past_event_3_title =>
      'Irrigazione straordinaria completata';

  @override
  String get calendar_past_event_3_date => '3 lug';

  @override
  String get calendar_suggested_task_1_title =>
      'Controlla umidita\' substrato del pino';

  @override
  String get calendar_suggested_task_1_date => 'domani';

  @override
  String get calendar_suggested_task_2_title =>
      'Valuta schermatura sole per azalea';

  @override
  String get calendar_suggested_task_2_date => 'tra 2 giorni';

  @override
  String get calendar_suggested_task_3_title =>
      'Programma fertilizzazione leggera';

  @override
  String get calendar_suggested_task_3_date => 'questa settimana';

  @override
  String get plant_detail_coming_soon =>
      'Dettagli completi disponibili a breve';

  @override
  String get agent_bar_hint_text => 'Cosa vuoi fare oggi?';

  @override
  String get agent_bar_new_plant_tooltip => 'Nuova pianta';

  @override
  String get wiki_section_title => 'Wiki del Giorno';

  @override
  String get wiki_reading_label => 'LETTURA CONSIGLIATA';

  @override
  String get wiki_article_1_title => 'Tecnica del Nebari';

  @override
  String get wiki_article_1_body =>
      'Come sviluppare radici di superficie visibili e armoniose attraverso tecniche di esposizione progressiva.';

  @override
  String get wiki_article_2_title => 'Potatura di raffinazione';

  @override
  String get wiki_article_2_body =>
      'Principi guida per la potatura fine: timing, angolatura e strumenti per rami sottili.';

  @override
  String get wiki_article_3_title => 'Rinvaso primaverile';

  @override
  String get wiki_article_3_body =>
      'Finestre temporali e indicatori visivi per il corretto rinvaso stagionale.';

  @override
  String get wiki_article_4_title => 'Substrati e permeabilità';

  @override
  String get wiki_article_4_body =>
      'Composizioni ottimali per diverse specie: akadama, pomice, lava vulcanica.';

  @override
  String get wiki_article_5_title => 'Filo di alluminio vs rame';

  @override
  String get wiki_article_5_body =>
      'Differenze pratiche nell\'uso dei due materiali: forza, impronta e durata stagionale.';
}
