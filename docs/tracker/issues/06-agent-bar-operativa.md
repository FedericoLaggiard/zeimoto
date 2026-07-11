# A6 — Agent bar operativa

Status: ready-for-agent

## Parent

[PLAN.md — App Shell MVP (Issue #3)](../PLAN.md)

## What to build

Rendere l'agent bar (già presente come inerte in A1) operativa: il campo "Cosa vuoi fare oggi?" ha una CTA visibile (es. icona o pulsante "Nuova Pianta") che apre il wizard A4. Il testo libero digitato nel campo viene ignorato in questo slice (nessuna intent detection); resta solo l'affordance visuale del campo.

L'agent bar rimane pinned in basso; la home scrolla sotto senza coprirla.

## Acceptance criteria

- [ ] L'agent bar mostra il campo "Cosa vuoi fare oggi?" con una CTA "Nuova Pianta"
- [ ] Il tap sulla CTA apre il wizard (A4) come route full-page
- [ ] Dopo il salvataggio dal wizard, l'agent bar è nuovamente visibile e la home è aggiornata
- [ ] Il testo digitato nel campo non produce alcuna azione (nessun crash, nessuna chiamata esterna)
- [ ] L'agent bar è pinned: non scorre con il contenuto

## Blocked by

[04-wizard-ui.md](./04-wizard-ui.md)
