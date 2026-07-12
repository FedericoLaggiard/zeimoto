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
MaterialApp(
  localizationsDelegates: AppLocalizations.localizationsDelegates,
  supportedLocales: AppLocalizations.supportedLocales,
  ...
)
```

`AppLocalizations.localizationsDelegates` already includes the `flutter_localizations` delegates (Material, Cupertino, Widgets).

---

## ARB key reference

| Key | Type | IT | EN |
|-----|------|----|----|
| `wizardClose` | string | Chiudi | Close |
| `wizardStepPhotoHeading` | string | Scegli una foto | Choose a photo |
| `wizardStepSpeciesHeading` | string | Seleziona la specie | Select the species |
| `wizardStepNicknameHeading` | string | Dai un nome | Give it a name |
| `wizardButtonNext` | string | Avanti | Next |
| `wizardButtonSave` | string | Salva | Save |
| `wizardSpeciesFieldHint` | string | Inserisci una specie… | Enter a species… |
| `wizardNicknameFieldHint` | parametric string (`defaultName`) | Lascia vuoto per usare: {defaultName} | Leave empty to use: {defaultName} |

---

## Naming convention

```
<screen>_<element>_<role>
```

**camelCase.** Examples: `wizardButtonNext`, `wizardStepPhotoHeading`, `wizardNicknameFieldHint`.

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
MaterialApp(
  localizationsDelegates: AppLocalizations.localizationsDelegates,
  supportedLocales: AppLocalizations.supportedLocales,
  locale: const Locale('it'),
  home: ...,
)
```

Localised strings are not searched for directly in tests — widget `Key`s are used to locate interactive components instead.
