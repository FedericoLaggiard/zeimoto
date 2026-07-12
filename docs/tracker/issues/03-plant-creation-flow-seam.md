# A3 — Plant Creation Flow seam (headless + test)

Status: done

## Parent

[PLAN.md — App Shell MVP (Issue #3)](../PLAN.md)

## What to build

Implementare il seam principale di creazione pianta come componente **senza UI** (puro Dart), osservabile end-to-end attraverso i suoi input/output. Il seam orchestra le regole del dominio e interagisce col repository; nessuna logica di dominio deve trovarsi nei widget.

Responsabilità del seam (`PlantCreationFlow` o simile, sotto `lib/domain/` o `lib/application/`):
- riceve in input: foto scelta (`PlaceholderPhoto`), specie (String), nickname opzionale (String?)
- valida le regole obbligatorie: foto obbligatoria, specie obbligatoria
- genera il nickname di default se assente o whitespace
- chiama `PlantRepository.add(plant)` e restituisce la `Plant` creata

Questo slice non include nessuna UI: il wizard arriverà in A4.

## Acceptance criteria

- [ ] Il flow non può completarsi senza una foto (`PlaceholderPhoto`) — solleva un errore o restituisce un `Either`/`Result` di fallimento
- [ ] Il flow non può completarsi senza una specie non-vuota — stessa gestione
- [ ] Se il nickname è vuoto o solo whitespace, viene generato il default `<ultimoTokenSpecie>_<NN>`
- [ ] Una pianta creata tramite il flow compare in cima alla lista restituita da `PlantRepository`
- [ ] Tutti i casi sopra sono coperti da test puri (no `WidgetTester`)
- [ ] Il seam dipende dall'interfaccia `PlantRepository`, non dall'implementazione in-memory
- [ ] Nessun `print` / log con dati sensibili

## Blocked by

[02-domain-plant-repository.md](./02-domain-plant-repository.md)
