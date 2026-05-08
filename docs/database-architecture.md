# Database Architecture

Phase 4 stores civic records in Neon PostgreSQL. Firebase Auth provides identity tokens, but PostgreSQL remains the system of record for eligibility state, civic participation, dossiers, ratifications, public records, thresholds, transparency logs, and operating records.

## Principles

- Keep civic logic portable across backend providers.
- Store public civic records separately from private verification metadata.
- Use append-only status histories for civic state transitions.
- Preserve immutable concern submissions and published CRRs.
- Enforce one participant / one participation with database constraints.
- Do not store raw secrets, raw IP addresses, raw device fingerprints, or unnecessary identity material.

## Table Plan

### Identity And Verification

`users`

- app user profile linked to Firebase UID
- stores email verification status, DOB eligibility result, state declaration, citizenship self-attestation, current verification level, and timestamps
- unique constraint on `firebase_uid`

`verification_events`

- append-only verification history
- records level changes, provider, method, result, metadata reference, reviewer/admin actor when applicable, and timestamps

`participant_security_fingerprints`

- hashed fingerprint signals for duplicate and abuse detection
- no raw device fingerprint storage
- linked to user and scoped by purpose

`participant_flags`

- operational flags for suspected duplication, rate-limit abuse, eligibility concerns, or account review
- flags do not secretly alter civic outcomes

### Geography And Baselines

`states`

- canonical state records and abbreviations

`state_population_baselines`

- CVAP/state-level baselines for U.S. citizen population age 18+
- includes source, source year, methodology, effective dates, and version

### Foundational Concerns

`foundational_concerns`

- immutable pre-dossier submission snapshot
- stores title, summary, issue statement, declared domains, creator, creator verification level, submitted timestamp, status, and duplicate/variant references

`concern_variants`

- preserves meaningful differences among grouped concerns
- links variant text and rationale to a parent concern group

`concern_evidence`

- evidence links for concerns and variants
- stores external URL, repository/folder reference, title, source, description, and content hash when available

`concern_signals`

- one user signal per concern or grouped concern
- stores state-at-participation, verification level at signal time, and timestamp

`concern_status_history`

- append-only concern lifecycle changes from submission through archive/reactivation

### Dossiers

`dossiers`

- official review packet metadata
- links to source concerns, domains, methodology, status, version, publication timestamps, and archival state

`dossier_sections`

- structured content sections such as summary, issue statement, why review exists, boundaries, methodology, and status text

`dossier_evidence`

- official dossier evidence/readings index
- supports external links, repository references, content hashes, source metadata, and display order

`dossier_questions`

- questions under review
- stores prompt text, order, required status, and version

`dossier_provisions`

- variant provisions presented during ratification
- responses are Agree or Disagree only

`dossier_status_history`

- append-only dossier lifecycle events

### Participation And Ratification

`read_confirmations`

- records that a participant confirmed reviewing a dossier
- one active confirmation per user/dossier/version where applicable

`comprehension_checks`

- dossier-specific questions used to support informed participation

`comprehension_responses`

- participant responses to comprehension checks
- linked to dossier version and read confirmation

`ratifications`

- binary Ratify / Do Not Ratify responses
- one user response per dossier
- stores state-at-participation and verification level at response time

`provision_responses`

- Agree / Disagree responses to dossier provisions
- one user response per provision

### Civic Ratification Records

`civic_ratification_records`

- public CRR metadata, version, publication timestamp, linked dossier, outcome summary, and boundary statement

`crr_state_results`

- state participation totals and rates at CRR publication time

`crr_verification_summary`

- verification level distribution at CRR publication time

`crr_provision_results`

- provision Agree / Disagree totals and percentages

`crr_evidence_index`

- frozen evidence archive index for the CRR

### Methodology And Thresholds

`methodologies`

- versioned methodology definitions for participation, verification, state baselines, thresholds, and CRR generation

`threshold_rules`

- configured threshold tiers, signal windows, state requirements, and advancement rules

`threshold_events`

- threshold evaluation results and transition triggers
- records inputs and outputs for auditability

### Archive And Transparency

`public_archive_entries`

- public archive index for concerns, dossiers, CRRs, reactivations, and superseded records

`change_logs`

- public changelog entries for published civic artifacts and methodology changes

`admin_actions`

- append-only operational audit log for administrative actions

### Financial And Labor Transparency

`donations`

- donation records visible through transparency reporting where legally and operationally appropriate

`labor_logs`

- project labor records for public transparency and stewardship accounting

`expenses`

- project expense records

`withdrawals`

- withdrawal records from project funds

`civic_project_comparisons`

- optional public comparisons between Civic Duty and related civic projects or forks

## Key Constraints

- `users.firebase_uid` must be unique.
- `users.email_verified` must be true before participation.
- `users.is_18_plus` must be true before participation.
- `users.citizenship_attested` must be true before participation.
- `concern_signals` must enforce one user / one concern signal.
- `ratifications` must enforce one user / one dossier.
- `provision_responses` must enforce one user / one provision.
- `read_confirmations` must link participation to a reviewed dossier version.
- `foundational_concerns` must preserve original submitted content.
- `civic_ratification_records` must be append-only after publication.

## State Locking

The participant's declared state is copied into participation records at submission time. Later profile state changes do not rewrite historical participation.

Records that require state locking:

- `concern_signals`
- `read_confirmations`
- `ratifications`
- `provision_responses`
- threshold snapshots
- CRR state results

## Migration Plan

Schema scripts should live under `schemas/` during Phase 4. Each script should be deterministic, reviewed, and safe to run in order against a fresh Neon database.

Recommended order:

1. enums and reference tables
2. identity and verification tables
3. state baseline tables
4. concern pipeline tables
5. dossier tables
6. participation tables
7. CRR tables
8. methodology and threshold tables
9. archive, changelog, admin action tables
10. transparency accounting tables
