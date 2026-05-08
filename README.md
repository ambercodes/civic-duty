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

## Viewing And Running The Sandbox

The app is a Flutter Web sandbox backed by Firebase Functions and Neon
PostgreSQL. Public education pages can render without backend data, but the
civic flow needs the API and database:

```text
Dashboard -> Dossier -> Read Confirmation -> Ratification -> Civic Ratification Record
```

### Requirements

Install or create:

- Flutter SDK
- Node.js 22
- Firebase CLI
- Firebase project with Authentication, Hosting, and Functions enabled
- Neon PostgreSQL project/database
- Git

You do not need `psql` if you prefer to run schema and seed files in the Neon
SQL Editor.

### Fork And Clone

Fork the repository on GitHub, then clone your fork:

```sh
git clone https://github.com/YOUR_USERNAME/civic_duty.git
cd civic_duty
```

Install Firebase Functions dependencies:

```sh
npm --prefix functions install
```

### Environment Setup

Copy the example environment file:

```sh
cp .env.example .env
```

Fill in `.env` with your own values:

```sh
APP_ENV=sandbox
FIREBASE_PROJECT_ID=your-firebase-project-id
API_BASE_URL=/api
NEON_DATABASE_URL=postgresql://...
FIREBASE_API_KEY=...
FIREBASE_AUTH_DOMAIN=your-project.firebaseapp.com
FIREBASE_STORAGE_BUCKET=...
FIREBASE_MESSAGING_SENDER_ID=...
FIREBASE_APP_ID=...
```

Do not commit `.env` or real database credentials.

### Ownership And Access Control

Forks should use their own Firebase project, Neon database, deployment targets,
and environment secrets. Do not request or reuse the official Civic Duty
production credentials for local development or independent deployments.

The official Civic Duty maintainers should retain control over:

- Firebase ownership
- Neon ownership
- GitHub ownership and repository administration
- deployment permissions
- environment secrets
- administrator and steward access

Public forks are independent unless explicitly adopted into the official
project. A fork may run the same open-source code, but it does not receive
authority over the official sandbox, production data, deployment pipeline, or
administrative accounts.

For Neon, use the Node.js connection string from the Neon dashboard. For local
development, `?sslmode=require` is expected. If your string includes
`&channel_binding=require` and local Node connections fail, remove only the
`channel_binding` parameter.

VPNs, corporate firewalls, or network filters may block direct Neon database
connections. If the app cannot load backend data, first run:

```sh
node scripts/check_neon_connection.mjs
```

Expected output:

```json
{"ok":true,"dossierCount":1}
```

### Database Setup

Run these SQL files against your Neon database in order:

```text
schemas/001_phase4_core.sql
schemas/002_phase5_users.sql
schemas/003_phase6_concerns.sql
schemas/seeds/001_sample_phase4.sql
```

You can run them with `psql`:

```sh
psql "$NEON_DATABASE_URL" -f schemas/001_phase4_core.sql
psql "$NEON_DATABASE_URL" -f schemas/002_phase5_users.sql
psql "$NEON_DATABASE_URL" -f schemas/003_phase6_concerns.sql
psql "$NEON_DATABASE_URL" -f schemas/seeds/001_sample_phase4.sql
```

Or paste each file into the Neon SQL Editor on the same Neon branch/database
your app connection string uses.

Verify seed data:

```sql
select count(*) from dossiers;
select count(*) from dossier_evidence;
select count(*) from civic_ratification_records;
```

### Firebase Setup

Log in and select your Firebase project:

```sh
firebase login
firebase use your-firebase-project-id
```

Enable in the Firebase Console:

- Email/password authentication
- Firebase Hosting
- Firebase Functions

### Run Locally

Use two terminals.

Terminal 1 starts the API:

```sh
firebase emulators:start --only functions
```

Terminal 2 starts Flutter Web and points it at the Functions emulator:

```sh
flutter run -d chrome \
  --dart-define=API_BASE_URL=http://127.0.0.1:5001/your-firebase-project-id/us-central1/api/api \
  --dart-define=FIREBASE_API_KEY="$FIREBASE_API_KEY" \
  --dart-define=FIREBASE_AUTH_DOMAIN="$FIREBASE_AUTH_DOMAIN" \
  --dart-define=FIREBASE_PROJECT_ID="$FIREBASE_PROJECT_ID" \
  --dart-define=FIREBASE_STORAGE_BUCKET="$FIREBASE_STORAGE_BUCKET" \
  --dart-define=FIREBASE_MESSAGING_SENDER_ID="$FIREBASE_MESSAGING_SENDER_ID" \
  --dart-define=FIREBASE_APP_ID="$FIREBASE_APP_ID"
```

If you are using the default project name from the docs, the local API base URL
is:

```text
http://127.0.0.1:5001/civic-duty-sandbox/us-central1/api/api
```

Test the API directly:

```sh
curl http://127.0.0.1:5001/your-firebase-project-id/us-central1/api/api/health
curl http://127.0.0.1:5001/your-firebase-project-id/us-central1/api/api/dossiers
curl http://127.0.0.1:5001/your-firebase-project-id/us-central1/api/api/records
```

### Common Local Notes

- Keep the Functions emulator running while viewing backend-connected pages.
- Restart the Functions emulator after changing `.env` or Functions code.
- `API_BASE_URL=/api` is for Firebase Hosting rewrites. Plain `flutter run`
  needs the full Functions emulator URL.
- `Concerns` will be empty until Phase 6 concern data exists or a Level 2 user
  submits a concern.
- A Level 1 user can read, confirm, ratify, and signal. Concern submission
  requires `level_2_proof_of_human` or `level_3_high_assurance` in the database.

### Deploy Your Fork

Build Flutter Web for Firebase Hosting:

```sh
flutter build web \
  --dart-define=API_BASE_URL=/api \
  --dart-define=FIREBASE_API_KEY="$FIREBASE_API_KEY" \
  --dart-define=FIREBASE_AUTH_DOMAIN="$FIREBASE_AUTH_DOMAIN" \
  --dart-define=FIREBASE_PROJECT_ID="$FIREBASE_PROJECT_ID" \
  --dart-define=FIREBASE_STORAGE_BUCKET="$FIREBASE_STORAGE_BUCKET" \
  --dart-define=FIREBASE_MESSAGING_SENDER_ID="$FIREBASE_MESSAGING_SENDER_ID" \
  --dart-define=FIREBASE_APP_ID="$FIREBASE_APP_ID"
```

Deploy Functions and Hosting:

```sh
firebase deploy --only functions,hosting
```

For deeper setup notes, see [Local Development](docs/local-development.md) and
[Deployment Architecture](docs/deployment-architecture.md).

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
