# Phase 3 Architecture

Phase 3 finalizes the Civic Duty architecture that Phase 4 will implement. This document is the top-level source of truth for civic scope, identity, dossier structure, concern flow, ratification, measurement, public records, and backend boundaries.

## Official Scope

Civic Duty is intended for structured civic review involving foundational constitutional concerns, structural governance questions, delegated authority, civic consent visibility, and measurable constitutional participation.

The platform is not intended for ordinary partisan disputes, routine legislation, candidate campaigning, or generalized political polling.

While the Civic Duty framework may be adaptable to other civic or organizational review systems, the official Civic Duty implementation intentionally limits its scope to foundational constitutional and structural governance review.

## Official Review Domains

Approved dossier domains:

- `delegated_authority`
- `civic_consent_visibility`
- `separation_of_powers`
- `constitutional_rights_tension`
- `public_accountability_transparency`
- `constitutional_continuity`
- `emergency_powers`
- `civic_participation_integrity`
- `natural_rights_foundational_principles`

Each official dossier must declare at least one approved domain. A dossier may declare multiple domains when the review crosses structural boundaries.

## Civic Identity And Eligibility

Civic Duty uses progressive verification levels.

- Level 1 = Self-Attested Civic Participation
- Level 2 = Proof-of-Human Verified
- Level 3 = High Assurance Verification

MVP ordinary participation uses Level 1.

Participants must provide:

- verified email
- date of birth entry
- 18+ validation
- state declaration
- self-attested U.S. citizenship

Concern creators require Level 2 or higher. Only proof-of-human verified users may create new foundational concerns or pre-dossiers.

Core participation rule:

```text
One participant = one participation.
Verification level is disclosed, not weighted.
```

See [verification-philosophy.md](verification-philosophy.md).

## Dossier Architecture

A dossier is a structured civic review packet that organizes an issue, supporting evidence, contextual explanation, participation boundaries, and review questions into a single readable framework for public examination.

Each dossier must include:

- metadata
- plain-language summary
- issue statement
- why this review exists
- participation boundaries
- evidence/readings
- questions under review
- participation methodology
- status

Dossier metadata should include `id`, `version`, `title`, `domains`, `status`, `created_at`, `published_at`, `source_concern_ids`, and `methodology_id`.

Participation boundaries must disclose what the review is and is not asking participants to determine.

## Foundational Concern And Pre-Dossier Pipeline

Civic Duty uses a self-feeding concern system that can transform qualified public concern into official review.

Flow:

```text
Pre-Dossier Submitted
-> Immutable Civic Snapshot
-> Open Civic Signal
-> Variant Grouping
-> Threshold Evaluation
-> Official Civic Review
-> Ratification
-> Civic Ratification Record
-> Archive / Reactivation
```

Rules:

- pre-dossiers are immutable after submission
- no amendments are allowed after submission
- external evidence may be linked through public folders or repositories
- similar concerns are grouped
- exact duplicates redirect to an existing or archived concern
- variants preserve meaningful differences
- archived concerns may be reintroduced later

An immutable civic snapshot preserves the submitted concern text, declared domain, evidence links, creator verification level, timestamp, and version. Later discussion, grouping, threshold calculation, or archival status must not rewrite the original submission.

## Ratification

Ratification means:

```text
I believe this concern warrants structured civic review and formal civic recording based on the evidence presented.
```

Ratification does not mean:

- legal ruling
- criminal determination
- universal agreement
- constitutional amendment
- binding governmental action

Core ratification remains binary:

- Ratify
- Do Not Ratify

Variant provisions use:

- Agree
- Disagree

There is no skip or neutral state. Participants who do not want to answer a ratification or provision question should not submit a response.

## Civic Ratification Record

A Civic Ratification Record is the public artifact produced after an official review. It records the dossier, participation methodology, ratification results, evidence archive, and limits of the review.

Required CRR sections:

- opening civic statement
- record metadata
- plain-language summary
- participation summary
- verification summary
- constitutional review domains
- provision results
- evidence archive
- methodology disclosure
- participation boundaries
- archival continuity

Required boundary statement:

```text
This record reflects structured civic participation and constitutional review activity within the Civic Duty framework.
It does not constitute a judicial ruling, legislative enactment, criminal determination, or binding government action.
```

Published CRRs are append-only records. Corrections, superseding records, or methodology clarifications must appear through public changelogs rather than silent replacement.

## Threshold And Measurement Methodology

Civic Duty measures participation against the U.S. citizen population age 18+ using Census CVAP/state-level data.

Do not use:

- voter registration
- party affiliation
- turnout
- county political maps

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
Substantial Signal across at least 10 states
```

Signal window:

```text
90 days
```

Threshold-qualified dossiers advance automatically to official civic review.

## Public Sandbox

Public environment name:

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

See [deployment-architecture.md](deployment-architecture.md).

## Governance Boundaries

Operational roles:

- Public Participant
- Verified Concern Creator
- Maintainer / Steward
- Administrator

Rules:

- threshold-qualified dossiers advance automatically
- admins do not ideologically reject qualified dossiers
- admins may manage repository, deployment, access, archives, and operations
- published CRRs are not silently changed
- changes appear in public changelogs
- forks are independent unless adopted into the main repo

See [administrative-governance.md](administrative-governance.md).

## Backend Architecture

Phase 4 uses Firebase Functions as the API layer, Firebase Auth for identity, Firebase Hosting for Flutter Web, and Neon PostgreSQL for civic records.

Provider-specific code must remain isolated from civic logic. Service modules should expose stable operations for users, concerns, dossiers, participation, ratification, CRRs, methodologies, and transparency records.

See:

- [database-architecture.md](database-architecture.md)
- [api-routes.md](api-routes.md)
- [security-architecture.md](security-architecture.md)
- [schemas/README.md](../schemas/README.md)

## Phase 4 Implementation Order

1. Firebase project + hosting
2. Neon database
3. schema scripts
4. Firebase Functions API shell
5. Firebase token verification
6. user profile endpoints
7. dossier endpoints
8. read confirmation endpoint
9. ratification endpoint
10. CRR endpoints
11. methodology/state baseline endpoints
12. sandbox deployment
