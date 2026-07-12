# Feature: Aggiunta Pianta (add_plant)

Wizard a 3 step che permette all'utente di creare una nuova pianta scegliendo foto, specie e nickname. Tutta la logica di business risiede in `PlantCreationCubit`; i widget sono stateless (salvo un thin wrapper per i `TextEditingController`).

**File:** `lib/features/add_plant/`

---

## Macchina a stati del Cubit

```mermaid
stateDiagram-v2
    [*] --> PlantCreationCollecting

    PlantCreationCollecting --> PlantCreationCollecting : selectPhoto()\nchangeSpecies()\nchangeNickname()\nadvance()

    PlantCreationCollecting --> PlantCreationSaved : save()

    PlantCreationSaved --> [*]
```

---

## Passi del wizard

```mermaid
stateDiagram-v2
    [*] --> Foto : stato iniziale

    Foto --> Foto : selectPhoto()
    Foto --> Specie : advance()\n[foto selezionata]
    Foto --> [*] : close (maybePop)

    Specie --> Specie : changeSpecies()
    Specie --> Nickname : advance()\n[species non vuota]
    Specie --> [*] : close (maybePop)

    Nickname --> Nickname : changeNickname()
    Nickname --> [*] : save() → PlantCreationSaved
    Nickname --> [*] : close (maybePop)
```

---

## Sequence diagram — flusso completo

```mermaid
sequenceDiagram
    actor Utente
    participant W as AddPlantWizard
    participant C as PlantCreationCubit
    participant R as PlantRepository

    Utente->>W: tap su una foto
    W->>C: selectPhoto(photo)
    C-->>W: PlantCreationCollecting(foto, canAdvance=true)

    Utente->>W: tap "Avanti"
    W->>C: advance()
    C-->>W: PlantCreationCollecting(step=specie)

    Utente->>W: seleziona/digita specie
    W->>C: changeSpecies(value)
    C-->>W: PlantCreationCollecting(specie, canAdvance=true)

    Utente->>W: tap "Avanti"
    W->>C: advance()
    C-->>W: PlantCreationCollecting(step=nickname)

    Utente->>W: tap "Salva" (nickname vuoto ok)
    W->>C: save()
    C->>C: _normaliseNickname(raw) → null
    C->>R: add(species, nickname=null, cover)
    R-->>C: Plant
    C-->>W: PlantCreationSaved(plant)
    W->>W: Navigator.maybePop()
```

---

## Sequence diagram — chiusura senza salvataggio

```mermaid
sequenceDiagram
    actor Utente
    participant W as AddPlantWizard
    participant R as PlantRepository

    Utente->>W: tap ✕ (qualsiasi step)
    W->>W: Navigator.maybePop()
    Note over R: Repository invariato
```

---

## Modello delle classi

```mermaid
classDiagram
    class PlantCreationCubit {
        -PlantRepository _repository
        +selectPhoto(PlaceholderPhoto)
        +changeSpecies(String)
        +changeNickname(String)
        +advance()
        +save()
        -_normaliseNickname(String) String?
    }

    class PlantCreationState {
        <<sealed>>
    }

    class PlantCreationCollecting {
        +WizardStep step
        +PlaceholderPhoto? selectedPhoto
        +String species
        +String nickname
        +bool canAdvance
        +copyWith(...) PlantCreationCollecting
    }

    class PlantCreationSaved {
        +Plant plant
    }

    class WizardStep {
        <<enum>>
        foto
        specie
        nickname
    }

    PlantCreationCubit --> PlantCreationState : emette
    PlantCreationState <|-- PlantCreationCollecting
    PlantCreationState <|-- PlantCreationSaved
    PlantCreationCollecting --> WizardStep : step
```

---

## Albero dei widget

```mermaid
graph TD
    APW[AddPlantWizard\nStatelessWidget] --> BP[BlocProvider&lt;PlantCreationCubit&gt;\ncrea dal RepositoryProvider]
    BP --> WV[_WizardView\nStatefulWidget — solo TextEditingController]
    WV --> BL[BlocListener\nnaviga su PlantCreationSaved]
    BL --> BB[BlocBuilder\nbuildWhen: solo Collecting]
    BB --> Scaffold
    Scaffold --> AppBar
    Scaffold --> Body
    Body -->|step=foto| SF[_StepFoto\nStatelessWidget]
    Body -->|step=specie| SS[_StepSpecie\nStatelessWidget]
    Body -->|step=nickname| SN[_StepNickname\nStatelessWidget]
```

---

## Regole di validazione del nickname

| Condizione | Comportamento |
|-----------|---------------|
| Vuoto / solo spazi | `null` → il repository genera il nickname di default |
| Lunghezza > 100 caratteri | `ArgumentError` |
| Contiene caratteri di controllo (U+0000–U+001F, U+007F) | `ArgumentError` |
| Valido non vuoto | Trimmed e usato così com'è |

I messaggi di errore non includono mai il valore fornito dall'utente.

---

## `canAdvance` per step

| Step | Condizione per `canAdvance = true` |
|------|------------------------------------|
| `foto` | `selectedPhoto != null` |
| `specie` | `species.trim().isNotEmpty` |
| `nickname` | sempre `true` |

---

## Copertura dei test

### `test/features/add_plant/plant_creation_cubit_test.dart` (14 test)

| Gruppo | Comportamenti |
|--------|---------------|
| Stato iniziale | Step = foto, nessuna foto, specie vuota |
| Step Foto | canAdvance false → true, advance no-op senza foto, advance avanza |
| Step Specie | canAdvance false → true, whitespace non conta, advance avanza |
| Step Nickname | canAdvance sempre true |
| save | Emette Saved, pianta nel repo, nickname di default, nickname trimmed, errori validazione |

### `test/features/add_plant/add_plant_wizard_test.dart` (11 test widget)

| Scenario | Comportamento |
|----------|---------------|
| Step Foto | Grid visibile, Avanti disabilitato, tap foto abilita e avanza |
| Step Specie | Avanti disabilitato, digitare abilita, tap dalla lista abilita |
| Step Nickname | Salva sempre abilitato |
| Chiusura | Nessuna pianta nel repo |
| Happy path | Pianta salvata con specie corretta |
