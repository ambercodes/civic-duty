# API Routes And Service Layer

Phase 4 exposes Civic Duty through Firebase Functions. Flutter Web calls HTTPS endpoints. Firebase Auth verifies identity, and Neon PostgreSQL stores civic records.

## Backend Portability Principle

Firebase Functions are the first API host, not the civic logic boundary. Route handlers should remain thin and delegate to service modules that can be moved to another host later.

Provider-specific code should be isolated to:

- Firebase token verification
- Firebase Functions request/response wrappers
- database connection setup
- deployment configuration

## Authentication

Protected routes require a Firebase ID token in:

```text
Authorization: Bearer <firebase_id_token>
```

The API verifies the token, resolves `firebase_uid`, loads the user profile from PostgreSQL, and enforces eligibility rules before accepting participation writes.

## API Response Format

Successful response:

```json
{
  "ok": true,
  "data": {},
  "meta": {
    "requestId": "req_...",
    "version": "v1"
  }
}
```

Error response:

```json
{
  "ok": false,
  "error": {
    "code": "ELIGIBILITY_REQUIRED",
    "message": "Participant eligibility requirements have not been completed."
  },
  "meta": {
    "requestId": "req_...",
    "version": "v1"
  }
}
```

## Error Codes

- `AUTH_REQUIRED`
- `TOKEN_INVALID`
- `EMAIL_VERIFICATION_REQUIRED`
- `ELIGIBILITY_REQUIRED`
- `AGE_REQUIREMENT_NOT_MET`
- `STATE_REQUIRED`
- `CITIZENSHIP_ATTESTATION_REQUIRED`
- `VERIFICATION_LEVEL_REQUIRED`
- `DUPLICATE_PARTICIPATION`
- `DUPLICATE_CONCERN`
- `DOSSIER_NOT_FOUND`
- `CONCERN_NOT_FOUND`
- `CRR_NOT_FOUND`
- `READ_CONFIRMATION_REQUIRED`
- `COMPREHENSION_CHECK_REQUIRED`
- `THRESHOLD_NOT_MET`
- `RATE_LIMITED`
- `FLAGGED_FOR_REVIEW`
- `VALIDATION_FAILED`
- `FORBIDDEN`
- `SERVER_ERROR`

## Public Routes

`GET /health`

- returns API health and build version

`GET /methodologies`

- lists public methodology versions

`GET /methodologies/:id`

- returns one methodology

`GET /states`

- lists supported states and abbreviations

`GET /states/population-baselines`

- returns public CVAP/state-level baselines and source metadata

`GET /threshold-rules`

- returns current public threshold tiers and advancement rules

`GET /concerns`

- lists public concerns, grouped variants, statuses, and signal summaries

`GET /concerns/:id`

- returns public concern snapshot, variant links, evidence links, and status history

`GET /dossiers`

- lists official dossiers

`GET /dossiers/:id`

- returns dossier metadata, sections, evidence, questions, provisions, methodology, and status

`GET /crrs`

- lists published Civic Ratification Records

`GET /crrs/:id`

- returns one published CRR

`GET /archive`

- lists public archive entries

`GET /change-logs`

- lists public changelog entries

`GET /transparency-ledger`

- returns public donations, labor logs, expenses, withdrawals, and comparison summaries as configured for public release

## Protected Participant Routes

`GET /me`

- returns authenticated user profile, eligibility status, verification level, and participation readiness

`POST /me/profile`

- creates or updates profile fields such as DOB entry, state declaration, and citizenship attestation

`POST /me/verification-events`

- records verification provider callbacks or user-initiated verification outcomes where supported

`POST /concerns`

- submits a foundational concern/pre-dossier
- requires Level 2 or higher
- creates immutable civic snapshot

`POST /concerns/:id/signals`

- records one concern signal per participant

`POST /dossiers/:id/read-confirmations`

- records read confirmation for a dossier version

`POST /dossiers/:id/comprehension-responses`

- records comprehension responses when required by the dossier

`POST /dossiers/:id/ratifications`

- records Ratify or Do Not Ratify
- requires read confirmation and eligibility

`POST /dossier-provisions/:id/responses`

- records Agree or Disagree for one provision

## Protected Maintainer/Admin Routes

`POST /admin/concerns/:id/group`

- groups similar concerns or variants

`POST /admin/concerns/:id/duplicate`

- marks exact duplicate and redirects to existing or archived concern

`POST /admin/concerns/:id/archive`

- archives a concern with public reason

`POST /admin/concerns/:id/reactivate`

- reactivates an archived concern

`POST /admin/dossiers`

- creates official dossier from qualified concern group

`PATCH /admin/dossiers/:id/status`

- updates dossier lifecycle status

`POST /admin/threshold-evaluations`

- runs or records threshold evaluation

`POST /admin/crrs`

- publishes CRR after ratification process completes

`POST /admin/change-logs`

- appends public changelog entry

`POST /admin/archive`

- creates public archive entry

`POST /admin/transparency-ledger/*`

- manages donations, labor logs, expenses, withdrawals, and project comparison entries

## Service Boundaries

Flutter services:

- `AuthService`
- `UserService`
- `DossierService`
- `ConcernService`
- `ParticipationService`
- `RatificationService`
- `CrrService`
- `MethodologyService`
- `TransparencyLedgerService`

Backend service modules:

- `AuthContextService`
- `UserService`
- `VerificationService`
- `ConcernService`
- `DossierService`
- `ParticipationService`
- `RatificationService`
- `CrrService`
- `MethodologyService`
- `ThresholdService`
- `ArchiveService`
- `AdminAuditService`
- `TransparencyLedgerService`

## Participation Write Rules

Before accepting a participation write, the backend must verify:

- Firebase UID exists and maps to a user
- email is verified
- DOB validation confirms 18+
- state declaration exists
- U.S. citizenship is self-attested
- required verification level is met
- state is copied into the participation row
- duplicate participation constraints are checked
- participant is not blocked by an explicit operational flag

Security controls may reject or hold a write for review, but they must not secretly alter recorded civic outcomes.
