# Local Development

Phase 4 uses Flutter Web, Firebase Auth, Firebase Hosting, Firebase Functions, and Neon PostgreSQL.

## Prerequisites

- Flutter SDK
- Firebase CLI
- Node 22 for Firebase Functions
- Neon PostgreSQL database
- Firebase project `civic-duty-sandbox`

This repo's Functions package declares Node 22. If your default `node` is older, run commands with Node 22 on `PATH`.

Example:

```sh
PATH=/Users/acodes/.nvm/versions/node/v22.18.0/bin:$PATH npm --prefix functions run build
```

## Environment Variables

Copy `.env.example` to a local environment file and fill in real values.

Required values:

```sh
APP_ENV=sandbox
FIREBASE_PROJECT_ID=civic-duty-sandbox
API_BASE_URL=/api
NEON_DATABASE_URL=postgresql://...
FIREBASE_API_KEY=...
FIREBASE_AUTH_DOMAIN=civic-duty-sandbox.firebaseapp.com
FIREBASE_STORAGE_BUCKET=...
FIREBASE_MESSAGING_SENDER_ID=...
FIREBASE_APP_ID=...
```

Do not commit real `.env` files or database URLs.

For Firebase Functions local runs, export the variables in the shell that starts the emulator:

```sh
export APP_ENV=sandbox
export FIREBASE_PROJECT_ID=civic-duty-sandbox
export NEON_DATABASE_URL="postgresql://..."
```

## Database Setup

Run the Phase 4 schema against Neon:

```sh
psql "$NEON_DATABASE_URL" -f schemas/001_phase4_core.sql
psql "$NEON_DATABASE_URL" -f schemas/002_phase5_users.sql
```

Seed sandbox data:

```sh
psql "$NEON_DATABASE_URL" -f schemas/seeds/001_sample_phase4.sql
```

## Firebase CLI Setup

Log in and select the sandbox project:

```sh
firebase login
firebase use civic-duty-sandbox
```

Enable these Firebase services in the console:

- Email/password authentication
- Email verification
- Firebase Hosting
- Firebase Functions

## Functions Development

Install dependencies:

```sh
npm --prefix functions install
```

Build:

```sh
npm --prefix functions run build
```

Lint:

```sh
npm --prefix functions run lint
```

Run emulators:

```sh
firebase emulators:start --only functions,hosting
```

Validate public API routes:

```sh
curl http://127.0.0.1:5001/civic-duty-sandbox/us-central1/api/api/health
curl http://127.0.0.1:5001/civic-duty-sandbox/us-central1/api/api/dossiers
curl http://127.0.0.1:5001/civic-duty-sandbox/us-central1/api/api/records
```

Protected routes require a Firebase ID token:

```sh
curl \
  -H "Authorization: Bearer $FIREBASE_ID_TOKEN" \
  http://127.0.0.1:5001/civic-duty-sandbox/us-central1/api/api/users/me
```

## Flutter Development

Run the web app against Firebase Hosting rewrites:

```sh
flutter run -d chrome \
  --dart-define=API_BASE_URL=/api \
  --dart-define=FIREBASE_API_KEY="$FIREBASE_API_KEY" \
  --dart-define=FIREBASE_AUTH_DOMAIN="$FIREBASE_AUTH_DOMAIN" \
  --dart-define=FIREBASE_PROJECT_ID="$FIREBASE_PROJECT_ID" \
  --dart-define=FIREBASE_STORAGE_BUCKET="$FIREBASE_STORAGE_BUCKET" \
  --dart-define=FIREBASE_MESSAGING_SENDER_ID="$FIREBASE_MESSAGING_SENDER_ID" \
  --dart-define=FIREBASE_APP_ID="$FIREBASE_APP_ID"
```

If calling a deployed API directly:

```sh
flutter run -d chrome \
  --dart-define=API_BASE_URL=https://us-central1-civic-duty-sandbox.cloudfunctions.net/api/api
```

## Validation Commands

Format:

```sh
dart format lib test
```

Analyze:

```sh
flutter analyze
```

Test:

```sh
flutter test
```

Functions:

```sh
npm --prefix functions run lint
npm --prefix functions run build
```

## Deployment

Build Flutter Web:

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

Deploy only Functions:

```sh
firebase deploy --only functions
```

Deploy only Hosting:

```sh
firebase deploy --only hosting
```

## Sandbox Disclaimer

The public sandbox must display this disclaimer:

```text
Civic Duty Constitutional Review Sandbox is a public civic review demonstration environment intended for constitutional review experimentation, methodology visibility, and participation flow testing.
The sandbox does not constitute governmental authority, legal adjudication, binding constitutional interpretation, or official public policy determination.
```
