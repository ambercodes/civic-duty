# Civic Duty Developer Guidelines

## Core Principle

Civic Duty is a lean, open-source civic measurement framework.

The codebase should remain modular, readable, reusable, and portable. The system must be easy for others to fork, audit, and extend without becoming tightly coupled to one backend provider, identity provider, or hosting platform.

## Coding Standards

### 1. Keep Code DRY

Avoid repeating UI, business logic, validation rules, or data transformation logic.

Reusable patterns should become shared widgets, services, models, or utilities.

### 2. Use Widget Composition

Flutter apps are built from widgets. Prefer small, focused widgets composed together instead of large screens with deeply nested build methods.

Good:

- `PrimaryButton`
- `MetricCard`
- `RecordStatusBadge`
- `DossierSection`
- `CivicLayout`

Avoid:

- one giant `main.dart`
- massive screens with all UI inline
- duplicated button/card styles

### 3. Separate Concerns

Keep these layers separate:

- `screens/` = full pages/views
- `widgets/` = reusable UI components
- `models/` = typed data structures
- `services/` = backend/API/data access
- `theme/` = colors, typography, spacing
- `routes/` = app route definitions
- `utils/` = helpers and formatters

The UI should not contain database logic.

### 4. Backend Must Remain Replaceable

Civic Duty may use Firebase, Neon, Supabase, or self-hosted services, but no backend should become inseparable from the civic logic.

Business rules should be written so the backend can be replaced later.

### 5. Build Mobile-First

The app should work clearly on a phone first.

Every screen should remain readable, calm, and accessible on small screens.

### 6. Use Typed Models

Avoid passing loose maps through the app when a clear model should exist.

Use models for:

- UserProfile
- Dossier
- EvidenceItem
- ReadConfirmation
- Vote
- StatePulse
- CivicRatificationRecord

### 7. Keep the App Neutral

Do not add:

- comments
- likes
- social feeds
- debate threads
- emotional engagement loops
- campaign mechanics

Civic Duty measures and records. It does not persuade or enforce.

### 8. Prefer Plain Language

The interface should explain what is happening in simple civic language.

Avoid legal complexity unless it is part of a dossier.

### 9. Keep Public Records Auditable

Generated records should include:

- version
- timestamp
- methodology
- participation counts
- state breakdown
- evidence index
- ratification outcome

### 10. Commit in Small Logical Steps

Use clear commit messages:

- `Add app theme`
- `Create landing screen`
- `Add civic pulse dashboard placeholder`
- `Add developer guidelines`
