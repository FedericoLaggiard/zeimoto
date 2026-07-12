# A6 — Agent bar operativa

Status: done

## Parent

[PLAN.md — App Shell MVP (Issue #3)](../PLAN.md)

## What to build

Rendere l'agent bar (già presente come inerte in A1) operativa: il campo "Cosa vuoi fare oggi?" ha una CTA visibile (FAB) che apre il wizard A4. Il testo libero digitato nel campo viene ignorato in questo slice (nessuna intent detection); resta solo l'affordance visuale del campo.

L'agent bar rimane pinned in basso; la home scrolla sotto senza coprirla.

## Acceptance criteria

- [x] L'agent bar mostra il campo "Cosa vuoi fare oggi?" (affordance visiva, non interattivo)
- [x] Un FAB (`FloatingActionButton`, key `add_plant_fab`) sopra l'agent bar apre il wizard (A4) come route full-page
- [x] Dopo il salvataggio dal wizard, l'agent bar è nuovamente visibile e la home è aggiornata (test: `after saving a plant the collection shows the new plant`)
- [x] Il testo digitato nel campo non produce alcuna azione (nessun crash, nessuna chiamata esterna)
- [x] L'agent bar è pinned: non scorre con il contenuto

## Note architetturali

- Introdotto ADR-0004: routing centralizzato con go_router
- `lib/routing/app_router.dart` è la sorgente unica di verità per tutta la navigazione

## Blocked by

[04-wizard-ui.md](./04-wizard-ui.md)
