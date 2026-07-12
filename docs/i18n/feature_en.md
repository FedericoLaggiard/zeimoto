# Internationalisation (i18n)

Zeimoto uses Flutter's official `flutter gen-l10n` system with ARB files. All user-visible strings must use `AppLocalizations` — this is a project-wide architectural constraint (see ADR-0002).

**Initial locales:** Italian (`it`, template) · English (`en`)

---

## File structure

```
flutter-app/
├── l10n.yaml                        # gen-l10n configuration
└── lib/l10n/
    ├── app_it.arb                   # Template (Italian)
    ├── app_en.arb                   # English
    ├── app_localizations.dart       # Generated — base class + delegates
    ├── app_localizations_it.dart    # Generated — IT implementation
    └── app_localizations_en.dart    # Generated — EN implementation
```

`l10n.yaml`:
```yaml
arb-dir: lib/l10n
template-arb-file: app_it.arb
output-localization-file: app_localizations.dart
```

---

## Configuration in `main.dart`

```dart
MaterialApp.router(
  localizationsDelegates: AppLocalizations.localizationsDelegates,
  supportedLocales: AppLocalizations.supportedLocales,
  routerConfig: _router,
  ...
)
```

`AppLocalizations.localizationsDelegates` already includes the `flutter_localizations` delegates (Material, Cupertino, Widgets).

---

## ARB key reference

| Key | Type | IT | EN |
|-----|------|----|----|
| `wizard_close` | string | Chiudi | Close |
| `wizardStepPhotoHeading` | string | Scegli una foto | Choose a photo |
| `wizardStepSpeciesHeading` | string | Seleziona la specie | Select the species |
| `wizardStepNicknameHeading` | string | Dai un nome | Give it a name |
| `wizardButtonNext` | string | Avanti | Next |
| `wizardButtonSave` | string | Salva | Save |
| `wizardSpeciesFieldHint` | string | Inserisci una specie… | Enter a species… |
| `wizardNicknameFieldHint` | parametric string (`defaultName`) | Lascia vuoto per usare: {defaultName} | Leave empty to use: {defaultName} || `collectionSectionTitle` | string | La Tua Collezione | Your Collection |
| `collectionEmpty` | string | Nessuna pianta nella collezione | No plants in your collection yet |
| `plantDetailComingSoon` | string | Dettagli completi disponibili a breve | Full details coming soon |
| `agent_bar_hint_text` | string | Cosa vuoi fare oggi? | What would you like to do today? |
| `agent_bar_new_plant_tooltip` | string | Nuova pianta | New plant |
---

## Naming convention

```
<screen>_<element>_<role>
```

**snake_case** — all keys, without exception. Examples: `wizard_button_next`, `collection_empty`, `agent_bar_hint_text`.

---

## How to add a new locale

1. Create `lib/l10n/app_<locale>.arb` with all keys present in `app_it.arb`.
2. Add the locale to `supportedLocales` (automatic with `flutter gen-l10n` if the ARB file is present).
3. Run `flutter gen-l10n` from the `flutter-app/` directory.

---

## How to add a new key

1. Add the key to `lib/l10n/app_it.arb` (template) with the `@<key>` metadata block.
2. Add the same key to all other locale ARB files.
3. Run `flutter gen-l10n`.
4. Use `AppLocalizations.of(context)!.<key>` in widgets.

---

## Usage in tests

Widget tests that require `AppLocalizations` must wrap the subject with:

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

For tests that don’t require navigation (e.g. isolated feature widget tests), a plain `MaterialApp` with `home:` and `localizationsDelegates` is sufficient.

To assert localised strings: use `lookupAppLocalizations(const Locale('it')).<key>` instead of hard-coded string literals.
