# A9 — Sezione Focus Pianta

Status: ready-for-agent

## Parent

[PLAN.md — App Shell MVP (Issue #3)](../PLAN.md)

## What to build

Implementare la sezione "Focus Pianta" come widget autonomo che legge da `PlantRepository` e seleziona casualmente una pianta all'apertura della home. Mostra la card della pianta selezionata nello stesso stile visivo della Collezione (foto, nickname, specie).

Il tap sulla card apre lo stesso placeholder di dettaglio usato in A5 (nessuna nuova schermata). Se il repository è vuoto, la sezione mostra uno stato assente (testo neutro, nessun crash).

## Acceptance criteria

- [ ] La sezione mostra una pianta selezionata casualmente dal `PlantRepository`
- [ ] La selezione avviene all'apertura della home (non cambia durante la sessione)
- [ ] Il tap sulla card apre il placeholder di dettaglio della pianta selezionata
- [ ] Se il repository è vuoto, la sezione mostra uno stato assente senza crash
- [ ] Il widget dipende dall'interfaccia `PlantRepository`, non dall'implementazione

## Blocked by

[05-sezione-collezione.md](./05-sezione-collezione.md)
