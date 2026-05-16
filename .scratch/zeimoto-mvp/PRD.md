# PRD — Zeimoto MVP (Bonsai AI Companion)

Status: ready-for-agent

## Problem Statement

Gestire la crescita di una collezione di bonsai nel tempo richiede memoria visiva, continuità di decisioni e contesto operativo. Oggi queste informazioni sono frammentate (foto in galleria, note sparse, calendario generico), rendendo difficile:

- ricostruire cosa è stato fatto e quando
- confrontare l’evoluzione visiva nel tempo
- trasformare osservazioni in azioni concrete con il giusto timing
- mantenere una memoria “della pianta” che migliori con l’uso senza sostituire il bonsaista

## Solution

Un assistente operativo visuale, centrato sulla singola Pianta, che permette di:

- catturare foto e creare Eventi (anche via Quick Actions) con flusso photo-first
- visualizzare una Timeline ricca e filtrabile basata su eventi canonici
- avviare Work Session quando serve più contesto (note, raggruppamento, summary AI)
- offrire AI contestuale (chat e suggerimenti) con Confidence Layer e postura prudente
- generare Task AI solo suggeriti (mai auto-imposti), e mantenere memoria AI per Pianta (Synthetic Memory versionata append-only + Active State corrente)

## User Stories

1. Come bonsaista, voglio creare una Pianta con una foto obbligatoria, così da avere subito un riferimento visivo affidabile.
2. Come bonsaista, voglio scegliere la specie della Pianta da una lista o manualmente, così da contestualizzare consigli e calendario.
3. Come bonsaista, voglio un nickname automatico della Pianta, così da identificarla velocemente senza attrito.
4. Come bonsaista, voglio vedere una griglia di Piante con foto protagonista, così da navigare visivamente la collezione.
5. Come bonsaista, voglio aprire il dettaglio Pianta e vedere lo stato corrente, così da capire “come sta” adesso.
6. Come bonsaista, voglio una Timeline visuale della Pianta, così da ricostruire la storia operativa.
7. Come bonsaista, voglio filtrare la Timeline per tipo evento canonico, così da isolare lavorazioni specifiche.
8. Come bonsaista, voglio creare un Evento standalone senza aprire una Work Session, così da registrare rapidamente ciò che ho fatto.
9. Come bonsaista, voglio creare un Evento via Quick Action, così da ridurre al minimo i passaggi.
10. Come bonsaista, voglio che anche le Quick Actions siano photo-first e richiedano foto prima del salvataggio, così da mantenere coerenza visiva.
11. Come bonsaista, voglio che ogni Evento abbia un tipo canonico (rinvaso, potatura, filo, pinzatura, defogliazione, trattamento, concimazione, osservazione, styling), così da mantenere la Timeline “pulita”.
12. Come bonsaista, voglio poter usare “osservazione” come fallback esplicito, così da non essere forzato a classificazioni troppo granulari.
13. Come bonsaista, voglio allegare più foto a un singolo Evento, così da registrare scatti utili nello stesso contesto.
14. Come bonsaista, voglio che le foto dentro l’Evento siano una lista ordinata (senza ruoli before/after nel MVP), così da mantenere il modello semplice.
15. Come bonsaista, voglio aggiungere note rapide a un Evento, così da registrare dettagli non visibili in foto.
16. Come bonsaista, voglio avviare una Work Session quando sto lavorando sulla Pianta, così da raggruppare eventi, foto e note di quel momento.
17. Come bonsaista, voglio chiudere una Work Session e ottenere un summary AI, così da avere una sintesi consultabile.
18. Come bonsaista, voglio che non esistano Work Session “implicite”, così da evitare oggetti invisibili o confusi.
19. Come bonsaista, voglio una chat contestuale della Pianta, così da fare domande avendo già contesto (timeline, stato, task, stagione, wiki).
20. Come bonsaista, voglio una chat globale, così da fare domande generiche senza scegliere una Pianta.
21. Come bonsaista, voglio che l’AI recuperi informazioni dalla Timeline e dalla Wiki personale, così da non dover ripetere dettagli.
22. Come bonsaista, voglio che l’AI sia prudente e dichiari quando non ha abbastanza dati, così da non ricevere consigli ingannevoli.
23. Come bonsaista, voglio che ogni suggerimento AI abbia confidence e motivazione, così da capire perché viene proposto.
24. Come bonsaista, voglio che l’AI mantenga una memoria per Pianta (non centrata sull’utente), così da far emergere pattern specifici della pianta.
25. Come bonsaista, voglio che la Synthetic Memory sia persistente e versionata append-only, così da vedere l’evoluzione dell’interpretazione nel tempo.
26. Come bonsaista, voglio che l’Active State rappresenti solo lo stato corrente (sovrascrivibile), così da avere un “adesso” chiaro.
27. Come bonsaista, voglio che lo Stato Pianta sia multidimensionale (non un singolo enum), così da descrivere meglio salute, stress, fase stagionale e sviluppo.
28. Come bonsaista, voglio che l’AI possa proporre aggiornamenti di stato, così da ridurre sforzo e aumentare insight.
29. Come bonsaista, voglio che le proposte AI sullo stato restino pending finché non approvo, così da mantenere pieno controllo.
30. Come bonsaista, voglio accettare/rifiutare una proposta di stato con un’azione semplice, così da ridurre frizione.
31. Come bonsaista, voglio un calendario intelligente con vista mensile/stagionale, così da pianificare lavori con contesto.
32. Come bonsaista, voglio che i task AI siano pochi ma ad alto valore, così da non avere rumore.
33. Come bonsaista, voglio che i task AI siano solo suggeriti e non auto-creati, così da rispettare il ruolo del bonsaista.
34. Come bonsaista, voglio accettare un task suggerito e inserirlo nel calendario, così da trasformare insight in azione.
35. Come bonsaista, voglio una wiki personale basata su link (YouTube/web), così da mantenere riferimenti utili per specie e lavorazioni.
36. Come bonsaista, voglio che l’AI suggerisca risorse wiki rilevanti durante una Work Session, così da imparare mentre opero.
37. Come bonsaista, voglio che le immagini restino sul dispositivo e vengano inviate al provider solo temporaneamente per analisi, così da mantenere privacy e controllo.
38. Come bonsaista, voglio che la homepage sia un centro operativo visuale (“Cosa vuoi fare oggi?”), così da entrare subito in azione.
39. Come bonsaista, voglio vedere warning e follow-up contestuali in home, così da non perdere cose importanti.
40. Come bonsaista, voglio confrontare immagini nel tempo (base), così da valutare crescita e risposta alle lavorazioni.

## Implementation Decisions

- Dominio centrato sulla Pianta come entità principale; tutto (Timeline, Eventi, Stato, Memoria AI, Task, Wiki) ruota attorno alla Pianta.
- Creazione Pianta: foto obbligatoria subito (camera o import) + specie obbligatoria; nickname automatico di default.
- Eventi: esistono standalone; Work Session è opzionale e non viene mai creata implicitamente.
- Foto: obbligatorie per ogni Evento (inclusi quelli creati via Quick Actions); flusso photo-first anche senza sessione.
- Multi-foto per Evento: lista ordinata; nel MVP non esistono ruoli formali before/after.
- Tipi evento: canonici nel MVP; “osservazione” è fallback esplicito.
- Stato Pianta: multidimensionale; l’AI può proporre aggiornamenti ma richiede conferma esplicita; proposte in pending.
- Task Engine: i task AI sono solo suggeriti; entrano nel calendario solo dopo accettazione/creazione da parte dell’utente.
- AI Memory per Pianta: Raw History (eventi), Synthetic Memory persistente versionata append-only, Active State non versionato (solo corrente), Future Roadmap non operativa nel MVP.
- AI posture: prudente con Confidence Layer (confidence/priorità/motivazione) e capacità di rifiutare consigli per mancanza dati.
- BYOK (Bring Your Own Key) per provider AI; immagini inviate direttamente al provider e solo temporaneamente per analisi.

## Testing Decisions

- Testare comportamento esterno e invarianti di dominio (non dettagli di implementazione UI).
- Moduli candidati per test isolati (deep modules):
  - validazione regole di creazione Pianta/Evento (foto obbligatoria, tipo canonico, sessione opzionale)
  - costruzione del contesto AI (quali sorgenti entrano nel contesto, priorità e fallback)
  - versioning della Synthetic Memory (append-only) e gestione Active State “solo corrente”
  - regole di pending/approvazione per proposte di stato e per task suggeriti
- Prior art: se esistono già test nel repo, seguire lo stesso framework e stile; altrimenti introdurre test unitari minimi per le regole di dominio.

## Out of Scope

- Social/community, marketplace, gamification.
- Ingestion avanzata video e summarization automatica video.
- Computer vision custom avanzata nel MVP (solo prompting strutturato su LLM vision).
- Sync immagini avanzata, cloud photo storage, offline completo.
- Styling AI avanzato e autonomia completa AI.
- Desktop app / web app (solo mobile).
- Note vocali persistenti.
- Future Roadmap operativa (niente scheduling automatico da Future Roadmap nel MVP).
- Task AI auto-creati senza approvazione.

## Further Notes

- Filosofia: “L’app osserva, suggerisce e ricorda — ma non sostituisce il bonsaista.”
- La parte visuale è centrale: foto protagoniste, UI minimale e contemplativa (minimal organic Japanese).
