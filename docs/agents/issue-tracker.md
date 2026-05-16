# Issue tracker: Local Markdown

Issues e PRD per questo repo vivono come file markdown in `.scratch/`.

## Convenzioni

- Una feature per directory: `.scratch/<feature-slug>/`
- Il PRD è `.scratch/<feature-slug>/PRD.md`
- Le issue di implementazione sono `.scratch/<feature-slug>/issues/<NN>-<slug>.md`, numerate da `01`
- Lo stato di triage è una riga `Status:` vicino all’inizio del file (vedi `triage-labels.md` per i ruoli canonici)
- Commenti e cronologia conversazione si appendono in fondo sotto `## Comments`

## Quando una skill dice "pubblica nell’issue tracker"

Crea un nuovo file sotto `.scratch/<feature-slug>/` (creando directory se necessario).

## Quando una skill dice "recupera il ticket"

Leggi il file al path referenziato. Tipicamente l’utente passerà il path o il numero issue.
