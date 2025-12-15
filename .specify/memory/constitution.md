# Zeimoto App Constitution

## Core Principles

### I. Single Codebase, Multi-Platform
Ship from one Flutter codebase targeting Android, iOS, and Web. Platform-specific code stays behind abstractions; shared UI and logic first, platform channels only when necessary.

### II. UX Parity with Respectful Deviations
Features launch with comparable behavior across mobile and web. Platform conventions (navigation, gestures, keyboard/mouse affordances) are respected when parity would harm usability.

### III. Testable and Observable
Critical flows have widget/unit tests. Logging is structured, errors are captured with stack traces, and crash/analytics hooks are wired for all targets before release.

### IV. Offline-Tolerant Data
Reads cache when possible; writes queue/retry safely. Network failures degrade gracefully with user feedback and recovery paths.

### V. Performance and Bundle Discipline
Keep first meaningful paint responsive: avoid heavy synchronous work on startup, lazy-load large assets, minimize unnecessary packages, and monitor build sizes for each platform.

### VI. Test-First Delivery
New work starts with a failing test capturing expected behavior; implementation follows only after the test exists and fails.

## Design Guidelines

- Simplicity and focus: every element has a purpose; avoid clutter.
- Consistency: uniform colors, typography, and interaction patterns to keep the app predictable.
- User-centric: design for real user needs and contexts.
- Thumb-friendly: place primary actions inside the comfortable thumb zone on handheld devices.
- Intuitive navigation: lean on familiar patterns (tab bars, clear menus).
- Visual hierarchy: use size, color, and spacing to guide attention to what matters.
- Clear feedback and affordance: interactive elements look clickable and reflect state changes.
- Readability and accessibility: legible fonts, strong contrast, large touch targets, accessible labels.
- Performance: fast loading, smooth animations, and graceful handling of network issues.
- Platform guidelines: follow Android Material conventions for a native feel.

## Platform and Delivery Requirements

- Uses stable Flutter SDK; upgrades are coordinated and tested on Android, iOS, and Web.
- Builds produce signed Android app bundles/APKs, iOS archives suitable for App Store/TestFlight, and a web build ready for static hosting with HTTPS.
- Assets and fonts declared in `pubspec.yaml`; responsive layouts support phones, tablets, and common desktop breakpoints.
- Access to device capabilities goes through vetted plugins; any custom platform code includes fallbacks or guards on unsupported platforms.
- Dependencies come from pub.dev by default; adding a new package requires explicit team confirmation before import and use.
- Data access follows the Repository pattern (see https://cubettech.com/resources/blog/introduction-to-repository-design-pattern/) to keep sources swappable and testable.
- Translation keys are English, snake_case, lowercase, and avoid accents or accented characters.
- Translation labels follow the convention `<section>_<ui_element>_<string_name>`.
- Security: code adheres to OWASP Top 10 requirements; production builds are obfuscated.
- API keys are never stored in the repo; prefer runtime retrieval with encryption/decryption, scoped restrictions (app/site/IP), and avoid Firebase Remote Config for sensitive data.

## Development Workflow and Quality Gates

- Code follows analyzer and formatter defaults; no ignored lint without justification.
- All changes include at least one automated test when touching logic or UI states.
- Test-first is enforced: write the test, see it fail, then implement and refactor.
- CI must run analyzer, tests, and a release-mode build for one mobile platform plus web before tagging a release.
- Feature flags or environment configs gate incomplete or platform-limited functionality.
- Release candidates validated on physical Android and iOS devices and at least one modern desktop browser.
- Public APIs, widgets, and services carry `///` Dart doc comments suitable for dartdoc; keep inline comments minimal and purposeful.
- UI components are stateless; application state is managed via Cubit (BLoC pattern) and injected where needed.
- Codebase language is English for identifiers, comments, and documentation; exceptions are rare and documented.

## State Management Rules

- State management uses two types: BLoC for complex pages with multiple user-driven events (including transformations like debounce/throttle), and Cubit for simpler interactions with few parameters.
- BLoC: place event/state/bloc files in a `bloc` folder; events come from the UI and extend an abstract base per bloc; the bloc extends `Bloc<Event, State>` and handles each event with `on`; states implement `copyWith` and derive from an abstract base with `StateLoading`, `StateError`, `StateDone`; only `StateDone` carries data, `StateError` carries the error, and logic/views branch on state type.
- Cubit: place state/cubit files in a `bloc` folder; no separate event layer—UI triggers state emissions; the cubit extends `Cubit<State>` and emits new states; states implement `copyWith` and derive from an abstract base with `StateLoading`, `StateError`, `StateDone`; only `StateDone` carries data, `StateError` carries the error, and logic/views branch on state type.

## Governance

- This constitution supersedes other practice docs for cross-platform concerns.
- Amendments require written rationale, reviewer approval, and noted version bump.
- PR reviewers block merges that violate these principles; exemptions are temporary and documented.

**Version**: 1.0.0 | **Ratified**: 2025-12-15 | **Last Amended**: 2025-12-15
