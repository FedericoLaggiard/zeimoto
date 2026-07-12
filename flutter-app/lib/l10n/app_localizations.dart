import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_it.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('it'),
  ];

  /// Tooltip per il pulsante di chiusura (✕) del wizard
  ///
  /// In it, this message translates to:
  /// **'Chiudi'**
  String get wizard_close;

  /// Titolo del primo step del wizard di creazione pianta
  ///
  /// In it, this message translates to:
  /// **'Scegli una foto'**
  String get wizard_step_photo_heading;

  /// Titolo del secondo step del wizard di creazione pianta
  ///
  /// In it, this message translates to:
  /// **'Seleziona la specie'**
  String get wizard_step_species_heading;

  /// Titolo del terzo step del wizard di creazione pianta
  ///
  /// In it, this message translates to:
  /// **'Dai un nome'**
  String get wizard_step_nickname_heading;

  /// Etichetta del pulsante di avanzamento al passo successivo
  ///
  /// In it, this message translates to:
  /// **'Avanti'**
  String get wizard_button_next;

  /// Etichetta del pulsante finale per salvare la pianta
  ///
  /// In it, this message translates to:
  /// **'Salva'**
  String get wizard_button_save;

  /// Testo segnaposto del campo di inserimento manuale della specie
  ///
  /// In it, this message translates to:
  /// **'Inserisci una specie…'**
  String get wizard_species_field_hint;

  /// Testo segnaposto del campo nickname che mostra il nome generato automaticamente
  ///
  /// In it, this message translates to:
  /// **'Lascia vuoto per usare: {defaultName}'**
  String wizard_nickname_field_hint(String defaultName);

  /// Titolo della sezione carosello nella home
  ///
  /// In it, this message translates to:
  /// **'La Tua Collezione'**
  String get collection_section_title;

  /// Messaggio stato vuoto della sezione Collezione
  ///
  /// In it, this message translates to:
  /// **'Nessuna pianta nella collezione'**
  String get collection_empty;

  /// Titolo della sezione Focus Pianta nella home
  ///
  /// In it, this message translates to:
  /// **'Focus Pianta'**
  String get focus_plant_section_title;

  /// Messaggio stato vuoto della sezione Focus Pianta
  ///
  /// In it, this message translates to:
  /// **'Nessuna pianta disponibile'**
  String get focus_plant_empty;

  /// Titolo della sezione statica Assistente AI nella home
  ///
  /// In it, this message translates to:
  /// **'Assistente AI'**
  String get ai_assistant_section_title;

  /// Etichetta breve della card statica Assistente AI
  ///
  /// In it, this message translates to:
  /// **'Osservazioni contestuali'**
  String get ai_assistant_card_label;

  /// Copy statico della card Assistente AI con postura non decisionale
  ///
  /// In it, this message translates to:
  /// **'L\'app osserva, suggerisce e ricorda il contesto della tua collezione, ma non sostituisce il bonsaista.'**
  String get ai_assistant_card_message;

  /// Titolo della sezione Calendario nella home
  ///
  /// In it, this message translates to:
  /// **'Calendario'**
  String get calendar_section_title;

  /// Titolo del blocco storico con azioni gia' eseguite
  ///
  /// In it, this message translates to:
  /// **'Eventi passati'**
  String get calendar_past_events_title;

  /// Titolo del blocco con task suggeriti dall'AI
  ///
  /// In it, this message translates to:
  /// **'Task suggeriti'**
  String get calendar_suggested_tasks_title;

  /// Badge che indica un task proposto e non ancora approvato
  ///
  /// In it, this message translates to:
  /// **'suggerito'**
  String get calendar_suggested_badge;

  /// No description provided for @calendar_past_event_1_title.
  ///
  /// In it, this message translates to:
  /// **'Rinvaso acero completato'**
  String get calendar_past_event_1_title;

  /// No description provided for @calendar_past_event_1_date.
  ///
  /// In it, this message translates to:
  /// **'10 lug'**
  String get calendar_past_event_1_date;

  /// No description provided for @calendar_past_event_2_title.
  ///
  /// In it, this message translates to:
  /// **'Defogliazione olmo completata'**
  String get calendar_past_event_2_title;

  /// No description provided for @calendar_past_event_2_date.
  ///
  /// In it, this message translates to:
  /// **'7 lug'**
  String get calendar_past_event_2_date;

  /// No description provided for @calendar_past_event_3_title.
  ///
  /// In it, this message translates to:
  /// **'Irrigazione straordinaria completata'**
  String get calendar_past_event_3_title;

  /// No description provided for @calendar_past_event_3_date.
  ///
  /// In it, this message translates to:
  /// **'3 lug'**
  String get calendar_past_event_3_date;

  /// No description provided for @calendar_suggested_task_1_title.
  ///
  /// In it, this message translates to:
  /// **'Controlla umidita\' substrato del pino'**
  String get calendar_suggested_task_1_title;

  /// No description provided for @calendar_suggested_task_1_date.
  ///
  /// In it, this message translates to:
  /// **'domani'**
  String get calendar_suggested_task_1_date;

  /// No description provided for @calendar_suggested_task_2_title.
  ///
  /// In it, this message translates to:
  /// **'Valuta schermatura sole per azalea'**
  String get calendar_suggested_task_2_title;

  /// No description provided for @calendar_suggested_task_2_date.
  ///
  /// In it, this message translates to:
  /// **'tra 2 giorni'**
  String get calendar_suggested_task_2_date;

  /// No description provided for @calendar_suggested_task_3_title.
  ///
  /// In it, this message translates to:
  /// **'Programma fertilizzazione leggera'**
  String get calendar_suggested_task_3_title;

  /// No description provided for @calendar_suggested_task_3_date.
  ///
  /// In it, this message translates to:
  /// **'questa settimana'**
  String get calendar_suggested_task_3_date;

  /// Testo segnaposto nella schermata di dettaglio pianta
  ///
  /// In it, this message translates to:
  /// **'Dettagli completi disponibili a breve'**
  String get plant_detail_coming_soon;

  /// Testo segnaposto del campo dell'agent bar
  ///
  /// In it, this message translates to:
  /// **'Cosa vuoi fare oggi?'**
  String get agent_bar_hint_text;

  /// Tooltip del FAB di apertura del wizard di creazione pianta
  ///
  /// In it, this message translates to:
  /// **'Nuova pianta'**
  String get agent_bar_new_plant_tooltip;

  /// Titolo della sezione Wiki del Giorno nella home
  ///
  /// In it, this message translates to:
  /// **'Wiki del Giorno'**
  String get wiki_section_title;

  /// Etichetta badge sopra la card dell'articolo wiki
  ///
  /// In it, this message translates to:
  /// **'LETTURA CONSIGLIATA'**
  String get wiki_reading_label;

  /// No description provided for @wiki_article_1_title.
  ///
  /// In it, this message translates to:
  /// **'Tecnica del Nebari'**
  String get wiki_article_1_title;

  /// No description provided for @wiki_article_1_body.
  ///
  /// In it, this message translates to:
  /// **'Come sviluppare radici di superficie visibili e armoniose attraverso tecniche di esposizione progressiva.'**
  String get wiki_article_1_body;

  /// No description provided for @wiki_article_2_title.
  ///
  /// In it, this message translates to:
  /// **'Potatura di raffinazione'**
  String get wiki_article_2_title;

  /// No description provided for @wiki_article_2_body.
  ///
  /// In it, this message translates to:
  /// **'Principi guida per la potatura fine: timing, angolatura e strumenti per rami sottili.'**
  String get wiki_article_2_body;

  /// No description provided for @wiki_article_3_title.
  ///
  /// In it, this message translates to:
  /// **'Rinvaso primaverile'**
  String get wiki_article_3_title;

  /// No description provided for @wiki_article_3_body.
  ///
  /// In it, this message translates to:
  /// **'Finestre temporali e indicatori visivi per il corretto rinvaso stagionale.'**
  String get wiki_article_3_body;

  /// No description provided for @wiki_article_4_title.
  ///
  /// In it, this message translates to:
  /// **'Substrati e permeabilità'**
  String get wiki_article_4_title;

  /// No description provided for @wiki_article_4_body.
  ///
  /// In it, this message translates to:
  /// **'Composizioni ottimali per diverse specie: akadama, pomice, lava vulcanica.'**
  String get wiki_article_4_body;

  /// No description provided for @wiki_article_5_title.
  ///
  /// In it, this message translates to:
  /// **'Filo di alluminio vs rame'**
  String get wiki_article_5_title;

  /// No description provided for @wiki_article_5_body.
  ///
  /// In it, this message translates to:
  /// **'Differenze pratiche nell\'uso dei due materiali: forza, impronta e durata stagionale.'**
  String get wiki_article_5_body;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'it'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'it':
      return AppLocalizationsIt();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
