# Civic Participation Verification Philosophy

## Core Rule

One participant = one participation.

Verification level is disclosed, not weighted.

Civic Duty uses verification levels to describe participation confidence, not to multiply civic influence. A Level 3 participant does not count more than a Level 1 participant in ratification, concern signals, provision responses, or threshold calculations.

## Why Civic Duty Uses Verification Levels

Civic Duty must balance broad civic accessibility with resistance to manipulation. Fully anonymous participation can make public records vulnerable to duplication or automation. Highly invasive identity systems can suppress participation, concentrate sensitive data, and make civic review dependent on a narrow verification provider.

The platform therefore uses a layered verification model. Each level describes how much confidence the system has in participant uniqueness and eligibility while preserving the same civic unit of measure for every eligible participant.

Verification levels make methodology visible. They do not decide whether a participant's civic position is more important.

## Verification Levels

### Level 1 - Self-Attested Civic Participation

Level 1 is the MVP participation level.

Participants must provide:

- verified email
- date of birth entry
- 18+ validation
- state declaration
- self-attested U.S. citizenship

Level 1 allows broad participation while minimizing identity collection. It is acceptable for MVP ratification, concern signaling, read confirmations, and provision responses.

### Level 2 - Proof-of-Human Verified

Level 2 adds proof-of-human or anti-duplication confidence above basic account access and self-attestation.

Level 2 may use methods such as privacy-preserving proof-of-human checks, phone verification, anti-bot verification, or other provider-portable human verification systems.

Concern creators require Level 2 or higher. Only proof-of-human verified users may create new foundational concerns or pre-dossiers.

### Level 3 - High Assurance Verification

Level 3 represents the strongest verification confidence supported by the platform.

Future methods may include privacy-preserving identity attestations, decentralized identity systems, zero-knowledge eligibility proofs, or third-party high assurance verification providers.

Level 3 is disclosed as high assurance participation confidence. It still counts as one participation.

## Disclosed But Not Weighted

Civic Duty discloses verification levels in public methodology summaries because public records should show how participation was gathered. The disclosure helps readers evaluate confidence, coverage, and limits.

The disclosure must not become a hidden weighting system. Participation counts, state participation rates, ratification results, concern signals, and provision responses are calculated on a one participant / one participation basis.

Public Civic Ratification Records may show verification distribution, for example:

```text
Level 1 - Self-Attested Civic Participation: 82.4%
Level 2 - Proof-of-Human Verified: 13.1%
Level 3 - High Assurance Verification: 4.5%
```

This is a confidence transparency measure, not an outcome adjustment.

## Privacy Minimization

Civic Duty should collect the minimum private information needed to support eligibility, uniqueness, security, and auditability.

Public records should not expose:

- legal names
- full dates of birth
- private addresses
- raw IP addresses
- raw device fingerprints
- identity provider secrets
- sensitive verification documents

Where stronger verification is introduced, the preferred approach is to store attestations, timestamps, provider references, and non-reversible hashes instead of raw identity material.

## Public Civic Visibility vs Private Verification Metadata

Civic Duty separates public civic visibility from private verification metadata.

Public civic visibility may include:

- aggregate participation counts
- state-level participation totals
- verification level distribution
- ratification totals
- provision response totals
- methodology and threshold rules

Private verification metadata may include:

- Firebase UID
- verification event records
- eligibility attestations
- DOB validation result
- state declaration history
- hashed security fingerprints
- hashed IP rate-limit signals
- participant flags

Private metadata exists to protect civic integrity and operate the system. It should not be published in Civic Ratification Records or public archive pages.

## Participation Confidence Transparency

Every official Civic Ratification Record should disclose the verification model used for the record, the distribution of participation by verification level, and the known limits of that verification model.

This protects the record from overstating certainty. It also allows later records to improve verification methodology without invalidating earlier Level 1 records.

## MVP Position

The Civic Duty MVP uses Level 1 for ordinary participation.

Level 2 or higher is required for creating foundational concerns or pre-dossiers because concern creation can shape the review agenda. Stronger concern-creator verification protects the pipeline without raising the baseline barrier for ordinary participation.

## Long-Term Philosophy

Civic Duty is not attempting to create a perfect identity system. It is attempting to create an inspectable civic participation framework where eligibility, confidence, and limits are visible.

Verification protects the methodology. It does not replace public judgment, judicial authority, legislative action, or constitutional process.
