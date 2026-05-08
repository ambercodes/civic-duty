# Civic Duty

Civic Duty is an open-source civic measurement framework for foundational constitutional and structural governance review.

The system provides a structured process for verified participants to:

- signal foundational civic concern
- review evidence-based dossiers
- confirm understanding before participation
- ratify or decline ratification
- generate public Civic Ratification Records

The minimal civic flow is:

```text
Signal -> Review -> Ratify -> Record
```

## Official Scope

Civic Duty is intended for structured civic review involving foundational constitutional concerns, structural governance questions, delegated authority, civic consent visibility, and measurable constitutional participation.

The platform is not intended for ordinary partisan disputes, routine legislation, candidate campaigning, or generalized political polling.

While the framework may be adaptable to other civic or organizational review systems, the official Civic Duty implementation intentionally limits its scope to foundational constitutional and structural governance review.

## What Civic Duty Is

Civic Duty is:

- a civic measurement framework
- a structured participation system
- a public record generator
- a state-aware civic pulse layer
- an open-source foundation others may audit, fork, and extend

## What Civic Duty Is Not

Civic Duty is not:

- a social platform
- a campaign system
- a court system
- a political party
- a persuasion engine
- a law enforcement mechanism
- a replacement government

The system measures and records participation. It does not enforce outcomes.

## Architecture

Architecture docs:

- [Phase 3 Architecture](docs/phase-3-architecture.md)
- [Verification Philosophy](docs/verification-philosophy.md)
- [API Routes And Service Layer](docs/api-routes.md)
- [Security Architecture](docs/security-architecture.md)
- [Deployment Architecture](docs/deployment-architecture.md)
- [Database Architecture](docs/database-architecture.md)
- [Administrative Governance](docs/administrative-governance.md)
- [Local Development](docs/local-development.md)
- [Schema Planning](schemas/README.md)
- [Developer Guidelines](docs/dev-guidelines.md)

## Verification Model

Civic Duty uses three verification levels:

- Level 1 = Self-Attested Civic Participation
- Level 2 = Proof-of-Human Verified
- Level 3 = High Assurance Verification

MVP ordinary participation uses Level 1.

Core rule:

```text
One participant = one participation.
Verification level is disclosed, not weighted.
```

Concern creators require Level 2 or higher.

## Dossier And Ratification

A dossier is a structured civic review packet that organizes an issue, supporting evidence, contextual explanation, participation boundaries, and review questions into a single readable framework for public examination.

Ratification means:

```text
I believe this concern warrants structured civic review and formal civic recording based on the evidence presented.
```

Ratification does not mean a legal ruling, criminal determination, universal agreement, constitutional amendment, or binding governmental action.

## Measurement

Civic Duty measures participation against U.S. citizen population age 18+ using Census CVAP/state-level data.

Participation formula:

```text
state participation rate = participants from state / state citizen voting-age population
```

Threshold tiers:

- Emerging Signal = 0.01%
- Substantial Signal = 0.10%
- Major Civic Signal = 1.00%
- Historic Civic Signal = 10.00%

Dossier advancement threshold:

```text
Substantial Signal across at least 10 states within a 90-day signal window
```

## Public Sandbox

Public environment:

```text
Civic Duty Constitutional Review Sandbox
```

Stack:

- Flutter Web
- Firebase Hosting
- Firebase Auth
- Firebase Functions
- Neon PostgreSQL
- GitHub

Sandbox disclaimer:

```text
Civic Duty Constitutional Review Sandbox is a public civic review demonstration environment intended for constitutional review experimentation, methodology visibility, and participation flow testing.
The sandbox does not constitute governmental authority, legal adjudication, binding constitutional interpretation, or official public policy determination.
```

## Development Principles

Civic Duty should remain:

- modular
- backend portable
- open source
- mobile first
- easy to audit
- easy to fork
- easy to extend

Backend providers are implementation layers, not permanent dependencies. Civic logic should remain portable between Firebase, Neon, Supabase, self-hosted PostgreSQL, and alternative identity providers.

## License

License to be added.
