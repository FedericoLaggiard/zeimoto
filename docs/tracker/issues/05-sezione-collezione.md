# A5 — Sezione Collezione (carosello)

Status: ready-for-agent

## Parent

[PLAN.md — App Shell MVP (Issue #3)](../PLAN.md)

## What to build

Implementare la sezione Collezione come widget autonomo che legge le piante da `PlantRepository` e le mostra in un carosello orizzontale di card, riprendendo il visual del prototipo (foto protagonista, nickname, specie).

Il tap su una card apre un placeholder di dettaglio: una schermata minima che mostra nickname e specie della pianta selezionata. Questo placeholder è sufficiente per A5; il dettaglio ricco è fuori scope di questo piano.

Se il repository è vuoto, la sezione mostra uno stato vuoto (testo + eventuale CTA).

## Acceptance criteria

- [ ] La sezione mostra le piante presenti nel `PlantRepository` ordinate per `createdAt` decrescente (la più recente a sinistra)
- [ ] Ogni card mostra `PlaceholderPhoto`, nickname e specie
- [ ] Il tap su una card naviga al placeholder di dettaglio della pianta corrispondente
- [ ] Il placeholder di dettaglio mostra nickname e specie
- [ ] Se il repository è vuoto, la sezione mostra uno stato vuoto
- [ ] Una pianta appena creata tramite il wizard compare in cima al carosello senza riavvio dell'app
- [ ] Il widget dipende dall'interfaccia `PlantRepository`, non dall'implementazione

## Blocked by

[02-domain-plant-repository.md](./02-domain-plant-repository.md)
