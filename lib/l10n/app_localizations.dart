import 'package:flutter/widgets.dart';
import 'package:flutter/services.dart';
import 'dart:convert';

class AppLocalizations {
  final Locale locale;
  final Map<String, String> _map;
  const AppLocalizations(this.locale, this._map);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  static const List<Locale> supportedLocales = [Locale('it'), Locale('en')];

  String t(String key) => _map[key] ?? key;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();
  @override
  bool isSupported(Locale locale) => ['it', 'en'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) async {
    final code = ['it', 'en'].contains(locale.languageCode) ? locale.languageCode : 'en';
    final path = 'lib/l10n/$code.json';
    try {
      final raw = await rootBundle.loadString(path);
      final Map<String, dynamic> data = json.decode(raw) as Map<String, dynamic>;
      final map = data.map((k, v) => MapEntry(k, v.toString()));
      return AppLocalizations(locale, map);
    } catch (_) {
      final raw = await rootBundle.loadString('lib/l10n/it.json');
      final Map<String, dynamic> data = json.decode(raw) as Map<String, dynamic>;
      final map = data.map((k, v) => MapEntry(k, v.toString()));
      return AppLocalizations(locale, map);
    }
  }

  @override
  bool shouldReload(covariant LocalizationsDelegate<AppLocalizations> old) => false;
}
