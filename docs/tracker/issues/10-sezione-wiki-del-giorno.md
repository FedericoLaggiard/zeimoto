# A10 — Sezione Wiki del Giorno (statica)

Status: ready-for-agent

## Parent

[PLAN.md — App Shell MVP (Issue #3)](../PLAN.md)

## What to build

Implementare la sezione "Wiki del Giorno" come widget autonomo che pesca casualmente un articolo dalla lista mock del prototipo all'apertura della home. Il contenuto è statico (nessuna chiamata a servizi, nessun retrieval). Serve a fissare la struttura visiva e il posizionamento nella home.

## Acceptance criteria

- [ ] La sezione è visibile nella home come widget autonomo
- [ ] L'articolo mostrato viene selezionato casualmente dalla lista mock all'apertura della home
- [ ] Il contenuto non cambia durante la sessione (stessa selezione fino al prossimo avvio)
- [ ] Nessuna chiamata a servizi esterni
- [ ] Nessun comportamento interattivo oltre alla lettura (in questo slice)

## Blocked by

[01-app-shell-skeleton.md](./01-app-shell-skeleton.md)
