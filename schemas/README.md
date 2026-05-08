# Civic Duty Schema Planning

This directory will contain Phase 4 PostgreSQL schema scripts for the Neon `civic-duty-sandbox` database.

## Purpose

Schema files should make the Civic Duty civic model concrete while keeping the backend portable. Firebase Auth identifies users, but PostgreSQL stores the civic records, participation constraints, public artifacts, threshold events, and audit trails.

## Planned Tables

Identity and verification:

- `users`
- `verification_events`
- `participant_security_fingerprints`
- `participant_flags`

State baselines:

- `states`
- `state_population_baselines`

Foundational concern pipeline:

- `foundational_concerns`
- `concern_variants`
- `concern_evidence`
- `concern_signals`
- `concern_status_history`

Dossiers:

- `dossiers`
- `dossier_sections`
- `dossier_evidence`
- `dossier_questions`
- `dossier_provisions`
- `dossier_status_history`

Participation:

- `read_confirmations`
- `comprehension_checks`
- `comprehension_responses`
- `ratifications`
- `provision_responses`

Civic Ratification Records:

- `civic_ratification_records`
- `crr_state_results`
- `crr_verification_summary`
- `crr_provision_results`
- `crr_evidence_index`

Methodology and thresholds:

- `methodologies`
- `threshold_rules`
- `threshold_events`

Archive, audit, and transparency:

- `public_archive_entries`
- `change_logs`
- `admin_actions`
- `donations`
- `labor_logs`
- `expenses`
- `withdrawals`
- `civic_project_comparisons`

## Required Constraints

- unique Firebase UID per user
- verified email required before participation
- 18+ validation required before participation
- state declaration required before participation
- citizenship attestation required before participation
- Level 2+ required before foundational concern creation
- one user / one concern signal
- one user / one dossier ratification
- one user / one provision response
- immutable pre-dossier snapshot after submission
- append-only CRR after publication

## Recommended File Order

Phase 4 should add scripts in a deterministic order, for example:

```text
001_enums.sql
002_states.sql
003_users.sql
004_verification.sql
005_concerns.sql
006_dossiers.sql
007_participation.sql
008_crrs.sql
009_methodologies_thresholds.sql
010_archive_audit_transparency.sql
```

## References

See:

- [database-architecture.md](../docs/database-architecture.md)
- [phase-3-architecture.md](../docs/phase-3-architecture.md)
- [security-architecture.md](../docs/security-architecture.md)
