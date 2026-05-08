# Security And Abuse Prevention Architecture

Security exists to protect civic integrity, participant privacy, and public auditability.

Core rule:

```text
Security protects civic integrity, but it must not secretly alter civic outcomes.
```

Security systems may block ineligible or duplicate participation before submission, rate-limit abusive behavior, flag accounts for review, and create audit records. They must not silently change a Ratify response into Do Not Ratify, discard valid responses without an auditable status, or weight outcomes in secret.

## Eligibility Controls

Required for ordinary MVP participation:

- Firebase UID uniqueness
- verified email
- DOB entry
- 18+ validation
- state declaration
- self-attested U.S. citizenship

Required for foundational concern/pre-dossier creation:

- all ordinary participation requirements
- Level 2 Proof-of-Human Verified or higher

## Uniqueness Rules

Database and service constraints must enforce:

- one Firebase UID per user
- one user / one dossier ratification
- one user / one concern signal
- one user / one provision response
- one active state-at-participation value per participation event

Duplicate attempts should return `DUPLICATE_PARTICIPATION` or the relevant route-specific duplicate error.

## State Lock At Participation

The user's declared state is copied into participation records at the moment of submission.

State lock applies to:

- concern signals
- read confirmations
- ratifications
- provision responses
- threshold event inputs
- CRR state result snapshots

Later profile changes do not rewrite historical participation.

## Fingerprints And Rate Limits

`participant_security_fingerprints` stores non-reversible fingerprint hashes for duplicate and abuse detection. Raw device fingerprints must not be stored.

IP addresses may be used for rate limiting only as non-reversible hashes or provider-managed rate-limit signals. Raw IP addresses should not be retained in civic records.

Rate limits should protect:

- account creation
- verification attempts
- concern submissions
- concern signaling
- read confirmations
- ratification submissions
- provision responses
- admin endpoints

## Participant Flags

Participant flags may identify suspected abuse, duplicate identity risk, eligibility review, excessive failed verification attempts, or operational security review.

Flags must be auditable and should include:

- flag type
- severity
- reason
- source
- created timestamp
- created by
- resolution status

Flags may prevent future writes or put a submission into review before it is counted. Flags must not secretly alter existing public results.

## Verification Metadata Privacy

Public records may disclose aggregate verification distribution. They must not disclose private verification metadata.

Do not publish:

- Firebase UID
- raw email
- full DOB
- raw IP
- raw fingerprint
- verification provider secrets
- private evidence from identity verification

## Read Confirmation And Comprehension

Ratification requires read confirmation for the relevant dossier version. If a dossier uses comprehension checks, required checks must be completed before ratification.

Comprehension checks support informed participation. They should not become ideological screening.

## Administrative Security

Admin and maintainer actions require authenticated accounts with explicit roles.

Admin actions must be logged in `admin_actions`, including:

- actor
- action
- target table/entity
- reason
- timestamp
- before/after references where appropriate

Admins may manage operations, deployment, access, archives, grouping, duplicate routing, and changelogs. They may not ideologically reject threshold-qualified dossiers.

## No Secret Outcome Manipulation

Outcome-affecting rules must be public methodology, public threshold configuration, or visible validation constraints.

Examples of prohibited behavior:

- silently down-weighting Level 1 users
- secretly excluding a state from threshold calculations
- changing a published CRR without changelog entry
- hiding valid Do Not Ratify responses
- altering provision results after publication

Examples of allowed behavior:

- rejecting a duplicate ratification before it is recorded
- rate-limiting automated submissions
- requiring Level 2 for concern creation
- appending a public correction to a CRR
- freezing a suspicious account before future submissions
