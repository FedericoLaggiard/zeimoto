# Feature: Add Plant (add_plant)

A 3-step wizard that lets the user create a new plant by choosing a photo, species, and nickname. All business logic resides in `PlantCreationCubit`; widgets are stateless (except for a thin wrapper that manages `TextEditingController` lifecycle).

**Files:** `lib/features/add_plant/`

---

## Cubit state machine

```mermaid
stateDiagram-v2
    [*] --> PlantCreationCollecting

    PlantCreationCollecting --> PlantCreationCollecting : selectPhoto()\nchangeSpecies()\nchangeNickname()\nadvance()

    PlantCreationCollecting --> PlantCreationSaved : save()

    PlantCreationSaved --> [*]
```

---

## Wizard steps

```mermaid
stateDiagram-v2
    [*] --> Photo : initial state

    Photo --> Photo : selectPhoto()
    Photo --> Species : advance()\n[photo selected]
    Photo --> [*] : close (maybePop)

    Species --> Species : changeSpecies()
    Species --> Nickname : advance()\n[species non-blank]
    Species --> [*] : close (maybePop)

    Nickname --> Nickname : changeNickname()
    Nickname --> [*] : save() → PlantCreationSaved
    Nickname --> [*] : close (maybePop)
```

---

## Sequence diagram — full happy path

```mermaid
sequenceDiagram
    actor User
    participant W as AddPlantWizard
    participant C as PlantCreationCubit
    participant R as PlantRepository

    User->>W: tap a photo
    W->>C: selectPhoto(photo)
    C-->>W: PlantCreationCollecting(photo, canAdvance=true)

    User->>W: tap "Avanti"
    W->>C: advance()
    C-->>W: PlantCreationCollecting(step=species)

    User->>W: select / type species
    W->>C: changeSpecies(value)
    C-->>W: PlantCreationCollecting(species, canAdvance=true)

    User->>W: tap "Avanti"
    W->>C: advance()
    C-->>W: PlantCreationCollecting(step=nickname)

    User->>W: tap "Salva" (empty nickname is fine)
    W->>C: save()
    C->>C: _normaliseNickname(raw) → null
    C->>R: add(species, nickname=null, cover)
    R-->>C: Plant
    C-->>W: PlantCreationSaved(plant)
    W->>W: Navigator.maybePop()
```

---

## Sequence diagram — close without saving

```mermaid
sequenceDiagram
    actor User
    participant W as AddPlantWizard
    participant R as PlantRepository

    User->>W: tap ✕ (any step)
    W->>W: Navigator.maybePop()
    Note over R: Repository unchanged
```

---

## Class diagram

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

    PlantCreationCubit --> PlantCreationState : emits
    PlantCreationState <|-- PlantCreationCollecting
    PlantCreationState <|-- PlantCreationSaved
    PlantCreationCollecting --> WizardStep : step
```

---

## Widget tree

```mermaid
graph TD
    APW[AddPlantWizard\nStatelessWidget] --> BP[BlocProvider&lt;PlantCreationCubit&gt;\ncreated from RepositoryProvider]
    BP --> WV[_WizardView\nStatefulWidget — TextEditingController only]
    WV --> BL[BlocListener\nnavigates on PlantCreationSaved]
    BL --> BB[BlocBuilder\nbuildWhen: Collecting only]
    BB --> Scaffold
    Scaffold --> AppBar
    Scaffold --> Body
    Body -->|step=foto| SF[_StepFoto\nStatelessWidget]
    Body -->|step=specie| SS[_StepSpecie\nStatelessWidget]
    Body -->|step=nickname| SN[_StepNickname\nStatelessWidget]
```

---

## Nickname validation rules

| Condition | Behaviour |
|-----------|-----------|
| Empty / whitespace-only | `null` → repository generates default nickname |
| Length > 100 characters | `ArgumentError` |
| Contains control characters (U+0000–U+001F, U+007F) | `ArgumentError` |
| Valid non-empty | Trimmed and used as-is |

Error messages never include the user-supplied value.

---

## `canAdvance` per step

| Step | Condition for `canAdvance = true` |
|------|------------------------------------|
| `foto` | `selectedPhoto != null` |
| `specie` | `species.trim().isNotEmpty` |
| `nickname` | always `true` |

---

## Test coverage

### `test/features/add_plant/plant_creation_cubit_test.dart` (14 tests)

| Group | Behaviours |
|-------|------------|
| Initial state | Step = foto, no photo, empty species |
| Step Photo | canAdvance false → true, advance no-op without photo, advance proceeds |
| Step Species | canAdvance false → true, whitespace doesn't count, advance proceeds |
| Step Nickname | canAdvance always true |
| save | Emits Saved, plant in repo, default nickname, trimmed nickname, validation errors |

### `test/features/add_plant/add_plant_wizard_test.dart` (11 widget tests)

| Scenario | Behaviour |
|----------|-----------|
| Step Photo | Grid visible, Next disabled, tap photo enables and advances |
| Step Species | Next disabled, typing enables, tapping from list enables |
| Step Nickname | Save always enabled |
| Close | No plant in repo |
| Happy path | Plant saved with correct species |
