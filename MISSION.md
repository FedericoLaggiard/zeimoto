# Mission.md — Bonsai AI Companion - 

## Vision

Creare un assistente operativo visuale per la crescita e l’evoluzione dei bonsai, con memoria persistente e workflow AI contestuali.

L’applicazione non deve essere un semplice gestionale, ma un sistema operativo personale per bonsai:
- osserva
- ricorda
- suggerisce
- collega conoscenza
- accompagna l’evoluzione della pianta nel tempo

La filosofia del prodotto è:

> "L’app osserva, suggerisce e ricorda — ma non sostituisce il bonsaista."

---

# Product Identity

## Obiettivo principale

Combinazione di:
- gestionale bonsai
- coach AI contestuale
- knowledge base bonsai personale

## Centro del sistema

La singola pianta è l’entità principale.

Tutto ruota attorno alla pianta:
- timeline
- immagini
- eventi
- stato
- memoria AI
- task
- wiki correlata
- workflow
- analisi evolutiva

---

# Filosofia UX

L’app deve essere:
- visuale
- moderna
- minimal
- naturale
- ispirata al Giappone
- contemplativa
- estremamente semplice da usare

Non deve sembrare:
- un gestionale
- un Excel
- un clone ChatGPT
- un social network

## Design language

Minimal organic Japanese:
- colori naturali e desaturati
- verde salvia
- crema carta washi
- carbone
- animazioni morbide
- foto protagoniste
- grandi spazi visivi

La parte visuale è fondamentale.

---

# Core Product Loop

```text
OSSERVA
↓
LAVORA
↓
DOCUMENTA
↓
ANALIZZA
↓
PIANIFICA
↓
OSSERVA
```

---

# MVP Scope

## Inclusi nel MVP

### Gestione piante
- creazione pianta
- specie
- nickname automatico
- foto cover
- timeline
- stato corrente

### Work Session
- apertura sessione
- foto-first workflow
- aggiunta eventi rapidi
- note veloci
- chiusura sessione
- summary AI

### Eventi base
- rinvaso
- potatura
- filo
- pinzatura
- defogliazione
- trattamento
- concimazione
- osservazione
- styling

Nel MVP ogni evento deve avere un tipo canonico tra quelli supportati; “osservazione” è il fallback esplicito quando non si vuole classificare più in dettaglio.

### Timeline visuale
- filtro eventi
- slider temporale
- confronto before/after
- auto alignment immagini
- overlay disegno multilayer persistente

### AI contestuale
- chat globale
- chat contestuale pianta
- retrieval timeline
- retrieval wiki
- generazione task
- confidence layer

### Calendario intelligente
- vista mensile
- vista stagionale
- task AI
- workflow follow-up
- reminder locali

### Wiki personale
- link YouTube
- link web
- tagging
- retrieval automatico contestuale

---

# Non in scope MVP

- social/community
- marketplace
- gamification
- ingestion avanzata video
- summarization automatica video
- computer vision custom avanzata
- sync immagini avanzata
- desktop app
- web app
- offline completo
- training modelli custom
- styling AI avanzato
- cloud photo storage
- note vocali salvate
- autonomia completa AI

---

# Architettura Generale

## Frontend
- Flutter
- Bloc state management

## Storage locale
- Isar

Contiene:
- immagini
- cache timeline
- drafts
- overlay disegni
- cache AI recente

## Backend
- Supabase
- PostgreSQL
- pgvector
- edge functions leggere

Contiene:
- metadata piante
- eventi
- embeddings
- AI memory
- task
- wiki
- retrieval

## AI orchestration
Backend Python leggero.

NO:
- microservizi complessi
- Kubernetes
- framework agentici pesanti

## AI Providers
BYOK (Bring Your Own Key)

Supportati:
- OpenAI
- OpenRouter
- Anthropic (future)

Le immagini vengono inviate direttamente al provider AI.

---

# Strategia immagini

## Filosofia

Le immagini restano sul dispositivo.

Upload solo temporaneo per:
- analisi AI
- vision
- confronti

## Obiettivi immagini

Le immagini sono il cuore del sistema.

Devono supportare:
- evoluzione nel tempo
- confronti longitudinali
- AI vision
- overlay
- alignment
- stato storico

## Alignment immagini

Approccio iniziale:
- alignment semplificato
- riferimento bordo vaso
- supporto manuale opzionale

Future:
- AI-assisted alignment
- matching prospettiva

## Camera guidance

L’app deve aiutare la cattura immagini con:
- silhouette precedente
- guida bordo vaso
- suggerimento inclinazione
- supporto framing

Soft guidance, non rigida.

---

# Modello Pianta

## Dati minimi obbligatori
- almeno una foto
- specie

Creazione pianta: non è possibile salvare una pianta senza almeno una foto (camera o import).

## Nickname

Non obbligatorio.

Default:
`specie_numero`

## Specie

- selezione da elenco predefinito
- inserimento manuale possibile

## Metadati opzionali
- categoria bonsai/prebonsai/yamadori
- posizione
- substrato
- ecc.

---

# Modello Work Session

## Filosofia

La work session rappresenta un momento operativo.

Non è legata a una durata esplicita.

È opzionale: gli eventi possono essere creati anche senza sessione (quick actions). La sessione serve a raggruppare e dare contesto (foto-first, note, summary AI).
Non viene creata automaticamente: la sessione esiste solo se avviata esplicitamente dall’utente.

## Contiene
- obiettivo opzionale
- eventi
- immagini
- stato pre/post
- suggerimenti AI
- wiki correlata
- summary AI finale

## Workflow ideale

```text
apri pianta
↓
inizia sessione
↓
fai foto
↓
aggiungi nota rapida
↓
AI suggerisce contesto
↓
chiudi sessione
```

Massimo focus sulla riduzione attrito.

---

# Modello Eventi

## Eventi semi-strutturati

Schema unificato:

```text
Event
- id
- plant_id
- type
- timestamp
- notes
- photos
- metadata_json
- ai_summary
- pre_state
- post_state
```

## Filosofia

Ogni evento:
- suggerisce campi
- ma mantiene flessibilità

Un evento può esistere standalone oppure essere associato a una work session.

Le foto sono obbligatorie.
Un evento può contenere più foto.
Nel MVP le foto sono una lista ordinata; non esistono ruoli formali (before/after).

Questo include anche gli eventi creati via quick actions: se non c’è una sessione, il flusso deve comunque essere photo-first (scatto/import prima di salvare l’evento).

---

# Stato Pianta

## Stato multidimensionale

NON singolo enum.

Dimensioni esempio:
- Health
- Stress
- Development
- Seasonal Phase
- Readiness

Esempio:

```text
Health:
- vigoroso
- stabile

Stress:
- moderato post-rinvaso

Development:
- raffinazione primaria
```

## Generazione stato

- manuale
- AI propone + utente conferma (mai auto-applicato)
Le proposte AI restano in stato “pending” finché l’utente non approva.

---

# AI System

## Filosofia

L’AI deve essere:
- contestuale
- persistente
- proattiva
- prudente

NON deve operare autonomamente.

## Modalità

- chat globale
- chat contestuale pianta

Se il contesto è una pianta specifica, l’AI deve tenerne conto automaticamente.

## Architettura AI

### 1. Context Builder
Recupera:
- pianta
- timeline
- stato
- task
- stagione
- wiki
- memoria sintetica

### 2. Intent Classifier
Capisce:
- domanda operativa
- analisi salute
- pianificazione
- retrieval
- timeline query

### 3. Retrieval Layer
Recupera:
- eventi
- task
- wiki
- memoria
- pattern storici

### 4. Specialist Executors
Esempi:
- planner
- health analyzer
- workflow generator
- timeline summarizer

### 5. Response Composer
Genera:
- risposta
- task
- follow-up
- suggerimenti wiki

---

# AI Memory

## Memoria separata per pianta

La memoria AI NON è centrata sull’utente.

## Struttura memoria

### Raw History
Eventi reali.

### Synthetic Memory
Riassunti AI.

Persistente e versionata: vengono salvati snapshot nel tempo e aggiornati incrementalmente; non è solo un output rigenerabile “al volo”.
Versioning: append-only (non si riscrive il passato; ogni aggiornamento produce una nuova versione).

Esempio:

```text
Pianta vigorosa.
Storicamente sensibile a stress radicale.
Buona risposta ai rinvasi primaverili.
```

### Active State
Stato corrente.
Non è versionato: viene sovrascritto e rappresenta solo “adesso”.

### Future Roadmap
Possibili evoluzioni.
Nel MVP è non operativa: solo ipotesi/suggerimenti ad alto livello, non genera task né scheduling.

---

# AI Vision

## Obiettivi

L’AI deve poter:
- confrontare immagini nel tempo
- rilevare cambiamenti
- rilevare stress
- rilevare vigore
- rilevare crescita
- suggerire tipo evento
- generare confronti automatici

## Approccio tecnico

Inizialmente:
- LLM vision
- prompting strutturato

NO computer vision custom complessa nel MVP.

---

# AI Confidence Layer

Ogni suggerimento AI deve avere:
- confidence
- priorità
- motivazione

Esempio:

```text
Possibile finestra favorevole al rinvaso

Confidence: media

Motivazioni:
- temperatura stabile
- gemme gonfie
- storico positivo
```

L’AI deve poter dire:

> "Non ho abbastanza dati per consigliarti con sicurezza"

---

# Calendario Intelligente

## Filosofia

Calendario:
- navigabile
- visuale
- contestuale
- event-driven

NON semplice lista reminder.

## Layer calendario

### Layer specie
Attività stagionali generiche.

### Layer pianta
Personalizzazione basata su:
- storico
- AI
- stato
- clima

### Layer workflow
Follow-up automatici.

## Task Engine

Ogni task:

```text
Task
- origine
- confidence
- priorità
- finestra temporale
- dipendenze
- contesto generazione
- stato
```

I task devono essere pochi ma ad alto valore.
Nel MVP i task AI sono solo suggeriti: entrano nel calendario solo se l’utente li accetta/crea esplicitamente.

---

# Wiki System

## Scope MVP

Solo:
- YouTube
- link web

## Alimentazione wiki

Fuori scope MVP.

## AI retrieval

L’AI deve:
- suggerire contenuti rilevanti
- collegare specie
- collegare lavorazioni
- suggerire risorse durante work session
- suggerire risorse nel dettaglio pianta

## Collegamenti

Supportati:
- collegamenti timeline ↔ wiki

---

# Search & Command Layer

## Filosofia

NON semplice search bar.

Semantic command interface.

## Esempi

```text
Mostrami i rinvasi fatti quest’anno

Quali piante sono più deboli?

Cosa dovrei fare questo mese?

Trova tutti gli aceri non potati da 6 mesi
```

---

# Homepage

## Filosofia

La homepage è il centro operativo.

Deve essere:
- dinamica
- contestuale
- situation-aware
- visuale

## Sezioni principali

### Hero contestuale
- attività consigliate
- warning
- follow-up
- stato collezione

### Input agente
Grande input centrale:

> "Cosa vuoi fare oggi?"

### Attenzione piante
Cards visuali.

### Timeline recente
Visuale e immersiva.

### Grid piante
Fotografica.

---

# Quick Actions

Supportate:
- aggiungi concimazione
- inizia rinvaso
- confronta con marzo
- analizza pianta
- pianifica lavori

---

# Voice

Supportati:
- voice chat AI
- dettatura rapida

NON supportati:
- voice notes persistenti

---

# Search & Retrieval

Utilizzare:
- semantic retrieval
- embeddings
- pgvector

Il retrieval deve usare:
- specie
- evento
- stagione
- stato
- obiettivo sessione
- storico

NON solo tag statici.

---

# Product Philosophy

Il valore reale del prodotto non è:
- la chat
- il calendario
- la wiki

Ma:

> la memoria evolutiva persistente della pianta.

L’app deve diventare:
- archivio biologico
- assistente operativo
- memoria visuale
- sistema di continuità bonsai

---

# Future Vision

Possibile evoluzione futura verso prodotto pubblico.

Solo mobile.

Community non prioritaria.
