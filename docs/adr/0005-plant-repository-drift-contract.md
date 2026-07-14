# ADR 0005 — Contratto `PlantRepository` Drift: API, reattività Cubit, injection, test

**Stato:** Accepted  
**Data:** 2026-07-14  
**Contesto:** [Issue #37](https://github.com/FedericoLaggiard/zeimoto/issues/37) — Definire il seam del repository Piante (da `PlantStore` in-memory a repository su Drift)

---

## Contesto

Il MVP aveva un `PlantStore` sincrono con `ChangeNotifier`. Con l'introduzione di Drift (SQLite) il layer di persistenza diventa intrinsecamente asincrono. Occorreva decidere:

1. **API pubblica** — quali metodi esporre nel MVP
2. **Gap sync→async** — come colmare la differenza di interfaccia
3. **Reattività UI** — come la UI osserva le modifiche (Stream diretto, ChangeNotifier wrapper, o Cubit)
4. **Dove vive `AppDatabase`** — singleton globale, provider app-level, o injection via costruttore
5. **Mapping `PlantData` → `Plant`** — serve o è overhead?
6. **Strategia di test** — unit test del repository senza dipendenze reali

---

## Decisioni

### 1. API pubblica del MVP

Esposta solo la triade minima necessaria al flusso attuale:

```dart
abstract interface class PlantRepository {
  Future<List<Plant>> getAll();
  Stream<void> get changes;
  Future<Plant> add({ required String species, String? nickname, required String sourcePhotoPath });
}
```

Metodi `byId`, `watchById`, `watchAll` **non esposti** — nessun caso d'uso nel MVP attuale li richiede. Saranno aggiunti quando una feature li necessiterà (YAGNI).

### 2. Interfaccia completamente asincrona

`getAll()` restituisce `Future<List<Plant>>` e `add()` restituisce `Future<Plant>`. Il vecchio `get plants` sincrono è rimosso. Tutti i Cubit chiamano `await repo.getAll()` esplicitamente dopo ogni evento `changes`.

### 3. Reattività UI — Scelta C (Cubit)

In linea con [ADR 0002](0002-flutter-bloc-state-management.md) e [ADR 0003](0003-business-logic-in-cubits.md), la reattività è gestita dai **Cubit** esistenti:

- Il Cubit sottoscrive `repo.changes` nel proprio `StreamSubscription`.
- Ad ogni evento, chiama `await repo.getAll()` e aggiorna lo stato.
- La UI osserva il Cubit via `BlocBuilder` — nessun `StreamBuilder` diretto in widget, nessun `ChangeNotifier` wrapper.

`changes` è un `Stream<void>` (non `Stream<List<Plant>>`): il Cubit controlla il timing della chiamata `getAll()` e può gestire errori/loading state in modo uniforme.

### 4. `AppDatabase` iniettato via costruttore

```dart
class DriftPlantRepository implements PlantRepository {
  DriftPlantRepository(this._db, { ... });
  final AppDatabase _db;
}
```

- `main.dart` istanzia `AppDatabase` una sola volta e la passa a `DriftPlantRepository`.
- `RepositoryProvider<PlantRepository>` espone l'istanza all'albero widget.
- Nei test si inietta `AppDatabase(NativeDatabase.memory())` — nessun singleton globale, piena testabilità.

### 5. Mapping `PlantData` → `Plant`

Il mapping è necessario: `PlantData` (generata da Drift) è un tipo di persistenza, `Plant` è il tipo di dominio. Il metodo privato `_toPlant(plantRow, photoRow, docsPath)` in `DriftPlantRepository` incapsula il mapping e risolve il percorso relativo in percorso assoluto.

### 6. `PhotoPath` — value object per i percorsi foto

`Plant.coverPhotoPath` è di tipo `PhotoPath` (non `String`), un value object che valida non-emptiness alla costruzione. Previene percorsi vuoti e rende il tipo del campo esplicito nel dominio. L'accesso al valore grezzo avviene tramite `.value` solo ai confini con API di sistema (`File`, `Image.file`).

### 7. Strategia di test

| Layer | Strumento | Nota |
|-------|-----------|------|
| Repository Drift | `NativeDatabase.memory()` iniettato nel costruttore | Hit schema reale senza filesystem per la DB; i test di `add()` usano file temporanei reali per la copia foto |
| Cubit / Widget | `InMemoryPlantRepository` (fake in-memory) | Nessuna dipendenza Drift, veloce, deterministico |

---

## Alternative considerate e scartate

| Alternativa | Motivo dello scarto |
|-------------|---------------------|
| **Opzione A** — `Stream<List<Plant>>` + `StreamBuilder` nei widget | Accoppia la UI direttamente allo stream del DB; difficile gestire loading/error state uniformemente; non allineato con l'uso di Cubit stabilito in ADR 0002/0003 |
| **Opzione B** — `ChangeNotifier` wrapper sul Stream Drift | Layer intermedio che non aggiunge valore: introduce complessità senza benefici rispetto al Cubit già presente |
| **Singleton globale `AppDatabase`** | Non testabile in isolamento; rischio di stato condiviso tra test |
| **Esporre `watchAll()` invece di `changes`** | Costringe la UI a fare `StreamBuilder` diretto (Opzione A); `changes` + `getAll()` separati danno più controllo al Cubit |
