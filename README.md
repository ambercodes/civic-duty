# Civic Duty - Ratification Process Defined

Civic Duty is an open-source civic measurement framework designed for foundational ratification review.

The system provides a structured process for verified participants to:

- signal concern
- review evidence-based dossiers
- confirm understanding before participation
- ratify or reject findings
- generate a public Civic Ratification Record (CRR)

Civic Duty is intentionally minimal:

```text
Signal -> Review -> Ratify -> Record
```

The goal is to create a peaceful, measurable, and transparent civic review layer that makes the citizen body visible in relation to foundational consent.

## Core Principle

Civic Duty exists to make the originating body, the people, visible, measurable, and reviewable in relation to foundational consent.

The system establishes a structured layer for observing and recording participation at the source level, producing verifiable civic records based on informed participation.

## Why Civic Duty Exists

In the absence of a structured, measurable source of civic participation, public sentiment is often inferred indirectly through:

- polling
- media interpretation
- institutional analysis
- political extrapolation

Civic Duty removes those interpretive layers by creating a direct participation framework built on:

- verified participation
- structured review
- read confirmation
- state-calibrated measurement
- public auditability

## What Civic Duty Is

Civic Duty is:

- a civic measurement framework
- a structured participation system
- a public record generator
- a state-aware civic pulse layer
- an open-source foundation others may build upon

## What Civic Duty Is Not

Civic Duty is not:

- a social platform
- a campaign system
- a court system
- a political party
- a persuasion engine
- a law enforcement mechanism
- a replacement government

The system measures and records participation.
It does not enforce outcomes.

## System Flow

```text
Signal -> Review -> Ratify -> Record
```

### Signal

Participants indicate that a matter warrants civic review.

### Review

Participants review structured dossiers and supporting evidence.

### Ratify

Participants confirm understanding and record their position.

### Record

The system generates a Civic Ratification Record (CRR).

## Civic Ratification Record

Each completed review produces a public record containing:

- dossier summary
- methodology
- participation metrics
- state-based participation
- evidence index
- ratification outcome
- timestamp and versioning

The CRR exists to create an auditable artifact of structured civic participation.

## State-Based Civic Pulse

Civic Duty measures participation against state-level population baselines.

The framework is designed to:

- show participation geographically
- measure state representation
- provide transparency around civic coverage
- avoid abstract national extrapolation

Children under 18 are excluded from ratification weight and tracked separately as the future civic body.

## Verification Philosophy

Civic Duty uses verification levels to balance broad civic accessibility with participation confidence.

The purpose of verification is not to erase lower-friction participation. The purpose is to make the participation methodology visible in public records.

Future Civic Ratification Records may include a Participation Verification Summary showing how participation was validated across levels such as:

- self-attested civic participation
- human verification
- high assurance verification

The system should minimize unnecessary collection of sensitive personal information and separate public participation visibility from private verification metadata.

See:

```text
docs/verification-philosophy.md
```

## Technology Goals

Civic Duty is designed to remain:

- modular
- backend portable
- open-source
- mobile-first
- easy to audit
- easy to fork
- easy to extend

The system should not become tightly coupled to any single vendor or infrastructure provider.

## Current Stack

Frontend:

- Flutter (Web/PWA first)

Infrastructure:

- Firebase Auth
- Neon PostgreSQL
- GitHub
- Vercel (planned)

## Open Source Philosophy

Civic Duty is intended to serve as a foundational civic measurement framework that others may build upon.

Possible future forks or extensions may include:

- local civic review systems
- alternative voting systems
- transparency dashboards
- research tooling
- public participation layers
- civic data analysis tools

## Developer Guidelines

See:

```text
docs/dev-guidelines.md
```

## Architectural Principle

Civic Duty should remain infrastructure-portable.

Backend providers are implementation layers, not permanent dependencies.

The civic logic should remain portable between:

- Firebase
- Neon
- Supabase
- self-hosted PostgreSQL
- alternative identity providers

## Contribution Philosophy

Contributors should prioritize:

- readability
- modularity
- composability
- transparency
- maintainability
- auditability
- calm and neutral interface design

Avoid:

- overengineering
- social engagement mechanics
- partisan framing
- unnecessary complexity

## License

License to be added.
