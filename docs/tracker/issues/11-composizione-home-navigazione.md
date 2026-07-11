# A11 — Composizione Home + navigazione end-to-end

Status: ready-for-agent

## Parent

[PLAN.md — App Shell MVP (Issue #3)](../PLAN.md)

## What to build

Assemblare le 5 sezioni (A5–A10) nell'ordine definito dal prototipo dentro l'area scroll di A1, verificare che l'agent bar resti pinned, e coprire il seam Home Section Composition con widget test sulle CTA critiche.

Ordine delle sezioni nella home (dall'alto verso il basso):
1. Assistente AI (A7)
2. Collezione (A5)
3. Calendario (A8)
4. Focus Pianta (A9)
5. Wiki del Giorno (A10)

Seam Home Section Composition — test da coprire:
- le 5 sezioni sono presenti nell'ordine atteso
- il tap sulla CTA dell'agent bar apre il wizard
- il tap su una card della Collezione apre il dettaglio della pianta corrispondente
- il tap sulla card Focus Pianta apre il dettaglio della pianta selezionata

## Acceptance criteria

- [ ] Le 5 sezioni sono composte nell'home nell'ordine corretto
- [ ] L'agent bar resta visibile e pinned mentre si scorre tutta la home
- [ ] Widget test verifica la presenza e l'ordine delle 5 sezioni
- [ ] Widget test verifica che la CTA agent bar apra il wizard
- [ ] Widget test verifica che il tap su card Collezione apra il dettaglio corretto
- [ ] Widget test verifica che il tap su card Focus Pianta apra il dettaglio corretto
- [ ] I test usano `flutter_test` (già in `dev_dependencies`), nessun harness custom

## Blocked by

- [05-sezione-collezione.md](./05-sezione-collezione.md)
- [06-agent-bar-operativa.md](./06-agent-bar-operativa.md)
- [07-sezione-assistente-ai-statica.md](./07-sezione-assistente-ai-statica.md)
- [08-sezione-calendario-statica.md](./08-sezione-calendario-statica.md)
- [09-sezione-focus-pianta.md](./09-sezione-focus-pianta.md)
- [10-sezione-wiki-del-giorno.md](./10-sezione-wiki-del-giorno.md)
