# Internazionalizzazione (i18n)

Zeimoto usa il sistema ufficiale di Flutter `flutter gen-l10n` con file ARB. Tutte le stringhe visibili all'utente devono utilizzare `AppLocalizations` — questa è un vincolo architetturale valido per tutto il progetto (vedi ADR-0002).

**Lingue iniziali:** Italiano (`it`, template) · Inglese (`en`)

---

## Struttura dei file

```
flutter-app/
├── l10n.yaml                        # Configurazione gen-l10n
└── lib/l10n/
    ├── app_it.arb                   # Template (italiano)
    ├── app_en.arb                   # Inglese
    ├── app_localizations.dart       # Generato — classe base + delegati
    ├── app_localizations_it.dart    # Generato — implementazione IT
    └── app_localizations_en.dart    # Generato — implementazione EN
```

`l10n.yaml`:
```yaml
arb-dir: lib/l10n
template-arb-file: app_it.arb
output-localization-file: app_localizations.dart
```

---

## Configurazione in `main.dart`

```dart
MaterialApp(
  localizationsDelegates: AppLocalizations.localizationsDelegates,
  supportedLocales: AppLocalizations.supportedLocales,
  ...
)
```

`AppLocalizations.localizationsDelegates` include già i delegate di `flutter_localizations` (Material, Cupertino, Widgets).

---

## Riferimento chiavi ARB

| Chiave | Tipo | IT | EN |
|--------|------|----|----|
| `wizardClose` | stringa | Chiudi | Close |
| `wizardStepPhotoHeading` | stringa | Scegli una foto | Choose a photo |
| `wizardStepSpeciesHeading` | stringa | Seleziona la specie | Select the species |
| `wizardStepNicknameHeading` | stringa | Dai un nome | Give it a name |
| `wizardButtonNext` | stringa | Avanti | Next |
| `wizardButtonSave` | stringa | Salva | Save |
| `wizardSpeciesFieldHint` | stringa | Inserisci una specie… | Enter a species… |
| `wizardNicknameFieldHint` | stringa parametrica (`defaultName`) | Lascia vuoto per usare: {defaultName} | Leave empty to use: {defaultName} |

---

## Convezione di naming

```
<schermata>_<elemento>_<ruolo>
```

**camelCase**. Esempi: `wizardButtonNext`, `wizardStepPhotoHeading`, `wizardNicknameFieldHint`.

---

## Come aggiungere una nuova lingua

1. Creare `lib/l10n/app_<locale>.arb` con tutte le chiavi presenti in `app_it.arb`.
2. Aggiungere il locale a `supportedLocales` (automatico con `flutter gen-l10n` se il file ARB è presente).
3. Eseguire `flutter gen-l10n` nella cartella `flutter-app/`.

---

## Come aggiungere una nuova chiave

1. Aggiungere la chiave in `lib/l10n/app_it.arb` (template) con il campo `@<chiave>` di metadati.
2. Aggiungere la stessa chiave in tutti i file ARB delle altre lingue.
3. Eseguire `flutter gen-l10n`.
4. Usare `AppLocalizations.of(context)!.<chiave>` nei widget.

---

## Uso nei test

I test widget che usano `AppLocalizations` devono avvolgere il widget con:

```dart
MaterialApp(
  localizationsDelegates: AppLocalizations.localizationsDelegates,
  supportedLocales: AppLocalizations.supportedLocales,
  locale: const Locale('it'),
  home: ...,
)
```

Le stringhe localizzate non vengono cercate direttamente nei test: si usano `Key` widget per trovare i componenti interattivi.
