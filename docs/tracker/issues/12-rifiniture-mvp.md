# A12 — Rifiniture MVP

Status: ready-for-agent

## Parent

[PLAN.md — App Shell MVP (Issue #3)](../PLAN.md)

## What to build

Completare i dettagli necessari per avere un MVP stabile e presentabile, senza aggiungere nuove sezioni o funzionalità:

- **Stato vuoto Collezione**: messaggio e CTA coerenti quando non ci sono piante
- **Stato assente Focus Pianta**: messaggio neutro quando il repository è vuoto
- **Pulsanti disabled nel wizard**: verificare che lo stile disabled sia chiaro (non solo opacity ridotta)
- **Feedback salvataggio**: snackbar o transizione leggera al completamento del wizard (conferma visiva che la pianta è stata salvata)

## Acceptance criteria

- [ ] La sezione Collezione con repository vuoto mostra uno stato vuoto con testo e CTA che apre il wizard
- [ ] La sezione Focus Pianta con repository vuoto mostra un messaggio neutro (nessun crash)
- [ ] I pulsanti "Avanti" e "Salva" del wizard hanno uno stile disabled visivamente distinguibile dallo stato enabled
- [ ] Al completamento del wizard compare un feedback visivo (snackbar o transizione) che conferma il salvataggio
- [ ] Il feedback non contiene dati sensibili
- [ ] Tutti i test esistenti (A3, A11) continuano a passare

## Blocked by

[11-composizione-home-navigazione.md](./11-composizione-home-navigazione.md)
