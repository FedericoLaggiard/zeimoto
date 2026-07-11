# A8 — Sezione Calendario (statica, eventi vs task)

Status: ready-for-agent

## Parent

[PLAN.md — App Shell MVP (Issue #3)](../PLAN.md)

## What to build

Implementare la sezione "Calendario" come widget autonomo con dati mock statici. La sezione deve mostrare **due liste visivamente distinte**:

- **Eventi passati** — ciò che è già stato fatto (sfondo o bordo diverso, tono "storico")
- **Task suggeriti** — ciò che è solo proposto dall'AI (stile diverso, badge o etichetta "suggerito")

Questa distinzione visiva è l'unica cosa rilevante in questo slice. Nessuna interazione, nessun calendario navigabile, nessuna logica di scheduling.

## Acceptance criteria

- [ ] La sezione è visibile nella home come widget autonomo
- [ ] Gli eventi passati e i task suggeriti sono visualizzati in due blocchi distinti e riconoscibili
- [ ] Il contenuto è mock/statico (dati identici o ispirati al prototipo)
- [ ] I task suggeriti non sembrano "già approvati" — devono risultare chiaramente come proposte
- [ ] Nessuna chiamata a servizi esterni
- [ ] Nessun comportamento interattivo (in questo slice)

## Blocked by

[01-app-shell-skeleton.md](./01-app-shell-skeleton.md)
