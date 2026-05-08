# Deployment Architecture

Phase 4 deploys the public sandbox as the Civic Duty Constitutional Review Sandbox.

## Public Environment

Environment name:

```text
Civic Duty Constitutional Review Sandbox
```

Sandbox disclaimer:

```text
Civic Duty Constitutional Review Sandbox is a public civic review demonstration environment intended for constitutional review experimentation, methodology visibility, and participation flow testing.
The sandbox does not constitute governmental authority, legal adjudication, binding constitutional interpretation, or official public policy determination.
```

## Stack

- Frontend: Flutter Web
- Hosting: Firebase Hosting
- Authentication: Firebase Auth
- API layer: Firebase Functions
- Database: Neon PostgreSQL
- Source control and public archive support: GitHub

## Project Names

- Firebase project: `civic-duty-sandbox`
- Neon project: `civic-duty-sandbox`

## Runtime Boundaries

Flutter Web is responsible for:

- public browsing
- account sign-in flow
- profile eligibility entry
- dossier reading
- read confirmation
- ratification submission
- CRR viewing
- public methodology and transparency views

Firebase Functions are responsible for:

- token verification
- request validation
- service orchestration
- database writes
- threshold evaluation jobs
- CRR generation jobs
- admin operations

Neon PostgreSQL is responsible for:

- durable civic records
- immutable concern snapshots
- participation records
- CRRs
- threshold events
- public changelogs
- administrative audit logs

GitHub is responsible for:

- source code history
- public issue/PR review
- public method and architecture docs
- optional external evidence repositories or folders

## Environment Variables

Firebase Functions should receive configuration through managed environment variables/secrets:

- `DATABASE_URL`
- `FIREBASE_PROJECT_ID`
- `APP_ENV`
- `API_VERSION`
- `PUBLIC_BASE_URL`
- provider-specific verification secrets as needed

No secrets should be committed to the repository.

## Phase 4 Setup Order

1. Create Firebase project + hosting for `civic-duty-sandbox`.
2. Create Neon database project `civic-duty-sandbox`.
3. Add schema scripts under `schemas/`.
4. Create Firebase Functions API shell.
5. Add Firebase token verification.
6. Add user profile endpoints.
7. Add dossier endpoints.
8. Add read confirmation endpoint.
9. Add ratification endpoint.
10. Add CRR endpoints.
11. Add methodology/state baseline endpoints.
12. Deploy the sandbox.

## Deployment Checks

Before public sandbox release:

- Flutter Web builds successfully.
- Firebase Hosting serves the current build.
- `/health` returns expected API version.
- Firebase token verification works on protected routes.
- Neon connection works from Firebase Functions.
- Public dossier routes return mock or seeded data.
- Participation writes enforce eligibility and uniqueness.
- CRR routes return public records without private metadata.
- Sandbox disclaimer is visible in public environment.

## Portability Notes

Firebase and Neon are implementation choices for the sandbox. Civic logic should remain portable by keeping provider dependencies behind service and repository boundaries.

Future forks may replace:

- Firebase Auth with another identity provider
- Firebase Functions with another API host
- Neon with another PostgreSQL provider
- Firebase Hosting with another static host

Those changes should not require rewriting dossier, ratification, threshold, or CRR methodology.
