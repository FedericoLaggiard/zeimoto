# AGENTS

**RISPONDI SEMPRE IN ITALIANO**

## Agent skills

### Issue tracker

Issue e PRD vivono come file markdown in `docs/tracker/`. Le issue singole stanno in `docs/tracker/issues/`. Non usare mai `.scratch/`.

### Triage labels

Vocabolario label standard. Vedi `docs/agents/triage-labels.md`.

### Domain docs

Repo single-context. Vedi `docs/agents/domain.md`.

# Linee Guida di Sicurezza per lo Sviluppo Mobile in Flutter

Questo documento definisce i vincoli, gli standard e le best practice di sicurezza obbligatorie per lo sviluppo di applicazioni mobile cross-platform utilizzando il framework **Flutter**. L'obiettivo è garantire la protezione dei dati degli utenti, l'integrità del codice sorgente e la sicurezza delle comunicazioni di rete.

---

## 1. Archiviazione Sicura dei Dati (Data Storage)

Non memorizzare mai dati sensibili (token di autenticazione, password, chiavi API, dati personali) in chiaro all'interno delle preferenze standard (`SharedPreferences` su Android o `NSUserDefaults` su iOS).

*   **Utilizzo di Storage Crittografato:** Utilizzare esclusivamente pacchetti che si interfacciano con le controparti native sicure: **Android Keystore** e **iOS Keychain**. Il pacchetto di riferimento standard è `flutter_secure_storage`.
*   **Database Locali:** Se l'applicazione richiede un database locale per dati sensibili, utilizzare una soluzione crittografata come **Isar** o **Hive** con crittografia AES abilitata, oppure **SQFlite** integrato con **SQLCipher**.
*   **Prevenzione del Leak nei Log:** Disabilitare completamente i log di debug (`print`, `debugPrint`, `log`) in ambiente di produzione. Utilizzare macro di compilazione o framework di logging che oscurano i dati sensibili.

```dart
// Esempio corretto di archiviazione sicura
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final storage = const FlutterSecureStorage();
await storage.write(key: 'auth_token', value: secureToken);
```

---

## 2. Sicurezza della Rete e Comunicazioni (Network Security)

Tutte le comunicazioni esterne devono avvenire tramite protocolli cifrati e protetti da intercettazioni (Man-in-the-Middle).

*   **HTTPS e TLS:** Consentire esclusivamente connessioni HTTPS con versioni TLS 1.2 o 1.3. Configurare esplicitamente i file nativi (`network_security_config.xml` per Android e `Info.plist` per iOS) per vietare il traffico HTTP in chiaro (*Cleartext Traffic*).
*   **SSL Pinning (Certificato / Chiave Pubblica):** Per le API critiche, implementare l'SSL Pinning per validare i certificati del server. Utilizzare client HTTP robusti come `dio` combinato con `http_certificate_pinning` o configurando esplicitamente il `SecurityContext` del client `HttpClient` nativo di Dart.
*   **Gestione dei Session Token:** I token JWT o OAuth2 devono avere una durata limitata (Short-lived Access Tokens) e l'applicazione deve implementare un meccanismo sicuro di rinnovo automatico tramite *Refresh Token*.

---

## 3. Offuscamento e Protezione del Codice (Reverse Engineering)

Il codice Dart viene compilato in codice macchina AOT (Ahead-Of-Time), il che lo rende più difficile da analizzare rispetto al bytecode Java/Kotlin non offuscato. Tuttavia, i metadati e le stringhe rimangono visibili se non adeguatamente protetti.

*   **Offuscamento di Flutter:** Abilitare l'offuscamento nativo di Flutter durante il processo di build industriale utilizzando i flag dedicati. Questo comando rimuove i simboli e offusca i nomi di classi e metodi.
    ```bash
    flutter build apk --obfuscate --split-debug-info=/<directory-dei-simboli>
    flutter build ipa --obfuscate --split-debug-info=/<directory-dei-simboli>
    ```
*   **Protezione delle Chiavi API di Terze Parti:** Non inserire mai chiavi API o segreti hard-coded nel codice Dart. Utilizzare variabili d'ambiente a tempo di build (es. tramite il pacchetto `flutter_dotenv` o `--dart-define-from-file`) e, se possibile, limitare le chiavi lato cloud alle sole restrizioni di pacchetto/bundle ID dell'app.

---

## 4. Autenticazione e Gestione delle Sessioni

*   **Biometria Sicura:** Per l'autenticazione biometrica (Impronta digitale, FaceID), utilizzare il pacchetto ufficiale `local_auth`. Assicurarsi di impostare il flag `stickyAuth: true` per gestire correttamente le interruzioni di sistema e verificare sempre l'autenticità lato backend se il processo sblocca operazioni transazionali.
*   **Rilevamento Jailbreak / Root:** Implementare controlli a runtime per verificare se il dispositivo ospite ha subito alterazioni dei privilegi (Root su Android, Jailbreak su iOS). Pacchetti come `flutter_jailbreak_detection` aiutano a identificare ambienti compromessi, consentendo all'applicazione di terminare la sessione in sicurezza.
*   **Rilevamento degli Emulatori:** Per applicazioni ad alto rischio (es. Fintech), impedire l'esecuzione o limitare le funzionalità se l'applicazione viene eseguita su un emulatore o all'interno di un ambiente di debug clonato.

---

## 5. Sicurezza della UI e della Componente Nativa

*   **Oscuramento dello Schermo in Background:** Proteggere la privacy dell'utente impedendo il posizionamento di screenshot del contenuto dell'applicazione nel task switcher del sistema operativo. Utilizzare pacchetti come `secure_application` o configurare i flag nativi:
    *   **Android:** `getWindow().addFlags(WindowManager.LayoutParams.FLAG_SECURE);` all'interno dell'Activity principale.
    *   **iOS:** Sovrapporre una schermata di sfocatura (Blur view) o un'immagine di splash quando l'applicazione passa nello stato `AppLifecycleState.inactive` o `paused`.
*   **Sanificazione degli Input:** Validare e sanificare rigorosamente tutti gli input utente nei campi `TextFormField` per prevenire attacchi di tipo Injection o Cross-Site Scripting (XSS) nel caso in cui i dati vengano visualizzati all'interno di componenti `WebView`.
*   **Uso Sicuro delle WebView:** Se l'uso di `webview_flutter` è strettamente necessario, disabilitare il supporto JavaScript se non richiesto (`javascriptMode: JavascriptMode.disabled`) e bloccare l'accesso al file system locale del dispositivo.

---

## 6. Gestione delle Dipendenze (Supply Chain Security)

*   **Verifica dei Pacchetti (pub.dev):** Prima di integrare un pacchetto di terze parti, verificarne la popolarità, il punteggio di manutenzione e l'editore (Publisher verificato).
*   **Analisi delle Vulnerabilità:** Eseguire periodicamente lo scanning delle dipendenze per identificare vulnerabilità note nei pacchetti Dart ed enterprise nativi:
    ```bash
    dart pub deps
    # Monitorare regolarmente i report di sicurezza automatizzati (es. GitHub Dependabot)
    ```
*   **Fissaggio delle Versioni:** Nei file `pubspec.yaml` di produzione, evitare l'uso di intervalli di versione troppo permissivi per evitare l'introduzione automatica di codice non verificato o breaking change malevole durante le build di CI/CD.

---

## Checklist di Rilascio (Production Readiness)

1. [ ] Il flag `--debug` è disattivato e la build è generata in modalità `--release`.
2. [ ] I log di debug contenenti dati sensibili sono stati rimossi o spenti tramite `kReleaseMode`.
3. [ ] L'offuscamento del codice (`--obfuscate`) è configurato nella pipeline di CI/CD.
4. [ ] La protezione da Screenshot / Background App Switcher è attiva.
5. [ ] I permessi nel file `AndroidManifest.xml` e `Info.plist` sono ridotti al minimo indispensabile (Principio del minimo privilegio).
6. [ ] L'SSL Pinning è configurato e testato con i certificati di produzione.

---

# Core Principles

The AI assistant must always:

- follow Secure by Design principles
- follow Least Privilege
- follow Defense in Depth
- follow Fail Secure
- follow Zero Trust assumptions
- minimize attack surface
- validate every external input
- sanitize every output where appropriate

---

# Mandatory Security Review

Every generated code must be reviewed against:

- OWASP Top 10
- OWASP API Top 10
- CWE Top 25
- SANS Secure Coding Guidelines

Before completing any task the AI must perform an internal security review.

If vulnerabilities are found:

- explain them
- fix them
- explain why they occurred

Never ignore security warnings.

---

# Authentication

Always prefer:

- OAuth2
- OpenID Connect
- MFA compatibility
- short-lived tokens
- refresh tokens rotation
- PKCE where applicable

Never:

- implement custom authentication
- store passwords
- suggest weak hashing algorithms

Password hashing:

- Argon2id
- bcrypt (acceptable)
- scrypt (acceptable)

Never:

- MD5
- SHA1
- unsalted hashes

---

# Authorization

Always:

- verify authorization server-side
- enforce RBAC or ABAC
- validate ownership of every resource
- deny by default

Never trust:

- frontend authorization
- hidden fields
- client-side roles

---

# Secrets

Never generate code that:

- hardcodes secrets
- hardcodes API keys
- hardcodes tokens
- hardcodes passwords
- hardcodes certificates

Always recommend:

- Secret Manager
- Key Vault
- AWS Secrets Manager
- GCP Secret Manager
- environment variables

Never log secrets.

Never expose secrets in examples.

---

# Input Validation

Treat every input as malicious.

Validate:

- length
- type
- encoding
- format
- ranges
- whitelist values

Reject invalid inputs.

Never rely only on frontend validation.

---

# SQL

Always use:

- parameterized queries
- prepared statements
- ORM safe APIs

Never generate:

- string concatenation SQL
- dynamic SQL unless strictly necessary

---

# XSS

Always:

- escape output
- sanitize HTML
- use CSP
- avoid innerHTML

Prefer:

- safe templating
- framework escaping

---

# CSRF

For cookie authentication always require:

- CSRF tokens
- SameSite cookies
- Secure cookies
- HttpOnly cookies

---

# APIs

Every API should:

- authenticate requests
- authorize requests
- validate payloads
- implement rate limiting
- return minimal information
- avoid verbose errors

Sensitive endpoints should:

- require re-authentication
- log security events

---

# Logging

Never log:

- passwords
- tokens
- cookies
- authorization headers
- session IDs
- private keys

Logs should contain:

- timestamp
- request ID
- correlation ID
- severity
- sanitized context

---

# Error Handling

Never expose:

- stack traces
- SQL errors
- framework internals
- filesystem paths
- secrets

Return generic messages to users.

Log detailed errors securely.

---

# Cryptography

Only use modern cryptography.

Preferred:

- AES-256-GCM
- ChaCha20-Poly1305
- Ed25519
- X25519

Never invent cryptographic protocols.

Never implement crypto manually.

Always use vetted libraries.

---

# Dependencies

Prefer:

- actively maintained packages
- official SDKs
- minimal dependencies

Avoid:

- abandoned libraries
- unnecessary packages

Highlight known CVEs when detected.

---

# Secure Defaults

Generated code should:

- deny by default
- disable debug mode
- enable HTTPS
- enable HSTS
- enable CSP
- enable secure cookies

---

# File Upload

Always:

- validate MIME type
- validate extension
- verify file signature
- limit file size
- randomize filenames
- store outside web root

Never trust client filenames.

---

# AI-specific Security

When generating AI systems:

Protect against:

- Prompt Injection
- Indirect Prompt Injection
- Jailbreaks
- Data Exfiltration
- Tool Abuse
- Context Poisoning

Never allow:

- unrestricted tool execution
- arbitrary filesystem access
- unrestricted shell execution

Require explicit approval for:

- deleting files
- executing shell commands
- modifying infrastructure
- accessing secrets

---

# Code Generation Rules

Never disable security checks to make code work.

Never remove:

- authorization
- validation
- encryption
- logging
- auditing

If security and functionality conflict:

choose security.

---

# Pull Request Review

Every implementation should include:

## Security Checklist

- [ ] Authentication verified
- [ ] Authorization verified
- [ ] Input validation
- [ ] Output encoding
- [ ] SQL Injection checked
- [ ] XSS checked
- [ ] CSRF checked
- [ ] SSRF checked
- [ ] Path Traversal checked
- [ ] Command Injection checked
- [ ] File Upload checked
- [ ] Secrets exposure checked
- [ ] Sensitive logging checked
- [ ] Error leakage checked
- [ ] Dependency review
- [ ] Least privilege respected

---

# Secure Coding Standards

Follow whenever possible:

- OWASP ASVS
- NIST Secure Software Development Framework (SSDF)
- CWE
- CERT Secure Coding
- Language-specific secure coding guidelines

---

# AI Behaviour

The AI assistant should:

- explain security implications
- propose safer alternatives
- refuse insecure implementations when possible
- warn when requirements reduce security
- recommend mitigations
- explicitly state assumptions

The AI should act as a senior security engineer.

---

# Final Verification

Before considering a task complete, verify:

1. no obvious vulnerabilities
2. no secrets exposed
3. no unsafe defaults
4. no excessive permissions
5. no unnecessary dependencies
6. all inputs validated
7. all outputs sanitized where required
8. authentication enforced
9. authorization enforced
10. logs sanitized

If any item fails, fix it before finishing.