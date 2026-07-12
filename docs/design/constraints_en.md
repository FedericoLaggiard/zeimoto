# Design System — Constraints and Conventions

Mandatory guidelines to ensure visual consistency and correct usability across all screens (iOS notch, home indicator, status bar, etc.).

---

## Safe Area Constraint

### Rule

**Every UI element must respect `SafeArea` on iOS and Android.**

- Status bar and notch: protected by `SafeArea(top: true)`
- Home indicator (iOS): protected by `SafeArea(bottom: true)`
- Pinned elements (e.g. bars): manage manually if they must sit outside `SafeArea`

### Implementation

#### Scrollable areas (CustomScrollView, ListView, etc.)

Wrap in `SafeArea` with context-specific parameters:

```dart
SafeArea(
  bottom: false, // CustomScrollView manages bottom spacing
  child: CustomScrollView(slivers: [...]),
)
```

#### Detail pages (Scaffold.body)

Wrap the body in `SafeArea`:

```dart
Scaffold(
  appBar: AppBar(...),
  body: SafeArea(
    child: SingleChildScrollView(...),
  ),
)
```

#### Pinned bars (nav bar, agent bar)

If pinned to bottom with `Positioned(bottom: 0)`, wrap in `SafeArea(top: false)` to save top space without consuming the home indicator:

```dart
Positioned(bottom: 0, left: 0, right: 0,
  child: SafeArea(
    top: false,
    child: AgentBar(...),
  ),
)
```

### Verification checklist

- **iOS**: verify content is not hidden by notch (top) or home indicator (bottom)
- **Android**: verify content is not hidden by status bar (top)
- **Landscape (notch on side)**: verify critical text is not obscured

---

## Spacing and Layout

| Element | Padding | Note |
|---------|---------|------|
| Section title | `EdgeInsets.fromLTRB(20, 16, 20, 8)` | Above scrollable content |
| Card interior | `EdgeInsets.symmetric(horizontal: 20, vertical: 16)` | Inside card |
| Carousel PageView | Manage in `itemBuilder` | Each card sets its own padding |

---

## Colours and Contrast

- **Main background**: `#F5F1E8` (washi)
- **Primary text**: `#2E2E2E` (charcoal)
- **Secondary text**: `#6B6B6B` (charcoalSoft)
- **Contrast ratio**: ≥ 4.5:1 (WCAG AA)

---

## Animations

Unconstrained for now; future recommendation:
- Standard duration: `Duration(milliseconds: 200)` for quick UI transitions
- Curve: `Curves.easeInOut` for natural motion
