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
MaterialApp.router(
  localizationsDelegates: AppLocalizations.localizationsDelegates,
  supportedLocales: AppLocalizations.supportedLocales,
  routerConfig: _router,
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
| `wizardNicknameFieldHint` | stringa parametrica (`defaultName`) | Lascia vuoto per usare: {defaultName} | Leave empty to use: {defaultName} || `collectionSectionTitle` | stringa | La Tua Collezione | Your Collection |
| `collectionEmpty` | stringa | Nessuna pianta nella collezione | No plants in your collection yet |
| `plantDetailComingSoon` | stringa | Dettagli completi disponibili a breve | Full details coming soon |
| `agent_bar_hint_text` | stringa | Cosa vuoi fare oggi? | What would you like to do today? |
| `agent_bar_new_plant_tooltip` | stringa | Nuova pianta | New plant |
---

## Convenzione di naming

```
<schermata>_<elemento>_<ruolo>
```

**snake_case** (dal A6 in poi). Esempi: `agent_bar_hint_text`, `agent_bar_new_plant_tooltip`.

> **Nota storica:** le chiavi precedenti ad A6 (`wizardButtonNext`, `collectionSectionTitle`, ecc.) usano camelCase. Non vengono rinominate per retrocompatibilità. Tutte le chiavi nuove **devono** usare snake_case.

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
RepositoryProvider<PlantRepository>(
  create: (_) => InMemoryPlantRepository(),
  child: MaterialApp.router(
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    locale: const Locale('it'),
    routerConfig: buildAppRouter(),
  ),
)
```

Per test che non necessitano di navigazione (es. unit widget test di una singola feature), è sufficiente `MaterialApp` semplice con `home:` e `localizationsDelegates`.

Per verificare stringhe localizzate: usare `lookupAppLocalizations(const Locale('it')).<chiave>` invece di literal string hard-coded.
