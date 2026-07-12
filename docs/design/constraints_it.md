# Design System — Vincoli e Convenzioni

Linee guida obbligatorie per garantire coerenza visiva e corretta usabilità su tutti gli schermi (notch iOS, home indicator, status bar, ecc.).

---

## Safe Area Constraint

### Regola

**Ogni elemento visivo della UI deve rispettare `SafeArea` su iOS e Android.**

- Status bar e notch: protetti da `SafeArea(top: true)`
- Home indicator (iOS): protetto da `SafeArea(bottom: true)`
- Elementi pinned (es. barre): gestire manualmente se devono stare fuori da `SafeArea`

### Implementazione

#### Aree scrollabili (CustomScrollView, ListView, ecc.)

Wrappare in `SafeArea` con parametri specifici al contesto:

```dart
SafeArea(
  bottom: false, // CustomScrollView manage bottom spacing
  child: CustomScrollView(slivers: [...]),
)
```

#### Pagine di dettaglio (Scaffold.body)

Wrappare il body in `SafeArea`:

```dart
Scaffold(
  appBar: AppBar(...),
  body: SafeArea(
    child: SingleChildScrollView(...),
  ),
)
```

#### Barre pinned (nav bar, agent bar)

Se pinned al bottom con `Positioned(bottom: 0)`, wrappare in `SafeArea(top: false)` per risparmiare lo spazio in cima senza inghiottire l'home indicator:

```dart
Positioned(bottom: 0, left: 0, right: 0,
  child: SafeArea(
    top: false,
    child: AgentBar(...),
  ),
)
```

### Verifiche

- **iOS**: verificare che il contenuto non sia nascosto dal notch (top) o dall'home indicator (bottom)
- **Android**: verificare che il contenuto non sia nascosto dalla status bar (top)
- **Orizzontale (landscape)**: verificare che il notch laterale non nasconda testo importante

---

## Spacing e Layout

| Elemento | Padding | Nota |
|----------|---------|------|
| Sezione title | `EdgeInsets.fromLTRB(20, 16, 20, 8)` | Sopra il contenuto scrollabile |
| Card interna | `EdgeInsets.symmetric(horizontal: 20, vertical: 16)` | Interno della card |
| Carosello PageView | Gestire con `itemBuilder` | Ogni card imposta padding proprio |

---

## Colori e Contrasto

- **Background principale**: `#F5F1E8` (washi)
- **Testo primario**: `#2E2E2E` (charcoal)
- **Testo secondario**: `#6B6B6B` (charcoalSoft)
- **Rapporto di contrasto**: ≥ 4.5:1 (WCAG AA)

---

## Animazioni

Non vincolate al momento; suggerimento futuro:
- Duration standard: `Duration(milliseconds: 200)` per transizioni UI rapide
- Curve: `Curves.easeInOut` per movimenti naturali
