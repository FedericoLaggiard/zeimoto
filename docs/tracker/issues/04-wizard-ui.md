# A4 — Wizard UI 3 step collegato al seam

Status: done

## Parent

[PLAN.md — App Shell MVP (Issue #3)](../PLAN.md)

## What to build

Implementare il wizard full-page a 3 step (Foto → Specie → Nickname) che consuma il seam `PlantCreationFlow` (A3). Nessuna logica di dominio vive nel widget: il wizard raccoglie input e delega tutto al seam.

Step 1 — Foto: mostra una griglia di `PlaceholderPhoto` selezionabili; il pulsante "Avanti" è disabilitato finché non si sceglie una foto.

Step 2 — Specie: lista scrollabile da `kSeedSpecies` + campo testo per inserimento manuale; il pulsante "Avanti" è disabilitato finché `species` è vuota.

Step 3 — Nickname: campo testo opzionale con hint che mostra il default che verrà generato; pulsante "Salva" attivo sempre (il nickname può essere vuoto).

Il wizard è chiudibile in ogni step (icona ✕ in alto). Un progress indicator mostra lo step corrente. Al salvataggio viene invocato il seam e la schermata si chiude.

## Acceptance criteria

- [ ] Il wizard si apre come route full-page (navigazione push o modal)
- [ ] Il pulsante "Avanti" nello step Foto è disabilitato se nessuna foto è selezionata
- [ ] Il pulsante "Avanti" nello step Specie è disabilitato se la specie è vuota
- [ ] È possibile inserire una specie manualmente oltre a sceglierla dalla lista
- [ ] Il pulsante "Salva" nello step Nickname è sempre abilitato
- [ ] Chiudere il wizard in qualsiasi step non salva nulla e non modifica il repository
- [ ] Al salvataggio la pianta compare nel repository (verificabile tramite `PlantRepository`)
- [ ] Il wizard non contiene logica di dominio: delega al seam
- [ ] Nessun `print` / log con dati utente

## Blocked by

[03-plant-creation-flow-seam.md](./03-plant-creation-flow-seam.md)
