import {initializeApp} from "firebase-admin/app";
import {getAuth} from "firebase-admin/auth";
import {setGlobalOptions} from "firebase-functions";
import {onRequest} from "firebase-functions/https";
import {Pool} from "pg";

initializeApp();
setGlobalOptions({maxInstances: 10});

const pool = new Pool({
  connectionString: process.env.NEON_DATABASE_URL,
  ssl: process.env.APP_ENV === "sandbox" ?
    {rejectUnauthorized: false} :
    undefined,
});

const writeAttempts = new Map<string, number[]>();
const writeLimitWindowMs = 60 * 1000;
const writeLimitMaxAttempts = 20;

type ApiMeta = {
  requestId: string;
  version: string;
};

type JsonResponder = {
  json: (body: unknown) => void;
};

type RequestLike = {
  headers: Record<string, string | string[] | undefined>;
  body?: unknown;
  path: string;
  method: string;
};

type ResponseLike = {
  req: RequestLike;
  status: (code: number) => JsonResponder;
};

type ApiErrorCode =
  "AUTH_REQUIRED" |
  "TOKEN_INVALID" |
  "EMAIL_VERIFICATION_REQUIRED" |
  "ELIGIBILITY_REQUIRED" |
  "READ_CONFIRMATION_REQUIRED" |
  "DUPLICATE_PARTICIPATION" |
  "DOSSIER_NOT_FOUND" |
  "CRR_NOT_FOUND" |
  "PROVISION_NOT_FOUND" |
  "CONCERN_NOT_FOUND" |
  "SIMILAR_CONCERN_EXISTS" |
  "VALIDATION_FAILED" |
  "VERIFICATION_LEVEL_REQUIRED" |
  "RATE_LIMITED" |
  "METHOD_NOT_ALLOWED" |
  "SERVER_ERROR";

type AuthContext = {
  firebaseUid: string;
  email: string;
  emailVerified: boolean;
};

type UserRow = {
  id: string;
  firebase_uid: string;
  email: string;
  email_verified: boolean;
  display_alias: string | null;
  birth_year: number | null;
  date_of_birth: string | null;
  is_18_plus: boolean;
  state_code: string | null;
  citizenship_attested: boolean;
  verification_level: string;
  profile_completed_at: string | null;
  created_at: string;
  updated_at: string;
};

type DossierRow = {
  id: string;
  slug: string;
  title: string;
  summary: string;
  scope: string;
  issue_statement: string;
  why_review_exists: string;
  participation_boundaries: string;
  status: string;
  version: string;
  published_at: string | null;
};

type EvidenceRow = {
  id: string;
  external_id: string;
  title: string;
  source: string;
  summary: string;
  why_it_matters: string;
  url: string | null;
  display_order: number;
};

type QuestionRow = {
  id: string;
  question_text: string;
  display_order: number;
};

type ProvisionRow = {
  id: string;
  slug: string;
  provision_text: string;
  display_order: number;
};

type RecordRow = {
  id: string;
  dossier_id: string;
  slug: string;
  record_id: string;
  version: string;
  opening_statement: string;
  plain_language_summary: string;
  outcome: string;
  methodology_disclosure: string;
  boundary_statement: string;
  published_at: string;
  dossier_title: string;
};

type ConcernRow = {
  id: string;
  slug: string;
  title: string;
  plain_language_summary: string;
  review_domain: string;
  issue_statement: string;
  why_review_matters: string;
  constitutional_relevance: string;
  participation_boundaries: string;
  proposed_review_question: string;
  external_evidence_url: string | null;
  creator_verification_level: string;
  status: string;
  signal_window_opened_at: string;
  signal_window_closes_at: string;
  duplicate_of_concern_id: string | null;
  created_at: string;
  signal_count?: number;
};

type ConcernEvidenceRow = {
  id: string;
  title: string;
  url: string;
  description: string | null;
  display_order: number;
};

type ConcernVariantRow = {
  id: string;
  parent_concern_id: string;
  concern_id: string | null;
  shared_summary: string;
  difference_summary: string;
  evidence_difference: string;
  review_question_difference: string;
  provision_language: string;
  created_at: string;
};

const officialReviewDomains = new Set([
  "delegated_authority",
  "civic_consent_visibility",
  "separation_of_powers",
  "constitutional_rights_tension",
  "public_accountability_transparency",
  "constitutional_continuity",
  "emergency_powers",
  "civic_participation_integrity",
  "natural_rights_foundational_principles",
]);

function meta(req: RequestLike): ApiMeta {
  const requestHeader = req.headers["x-request-id"];
  const requestId = Array.isArray(requestHeader) ?
    requestHeader[0] :
    requestHeader;

  return {
    requestId: requestId || `req_${Date.now()}`,
    version: "v1",
  };
}

function sendOk(response: ResponseLike, data: unknown) {
  response.status(200).json({ok: true, data, meta: meta(response.req)});
}

function sendCreated(response: ResponseLike, data: unknown) {
  response.status(201).json({ok: true, data, meta: meta(response.req)});
}

function sendError(
  response: ResponseLike,
  status: number,
  code: ApiErrorCode,
  message: string,
) {
  response.status(status).json({
    ok: false,
    error: {code, message},
    meta: meta(response.req),
  });
}

function routePath(path: string): string {
  if (path === "/") {
    return "/health";
  }

  return path.startsWith("/api") ? path.slice(4) || "/health" : path;
}

function clientKey(request: RequestLike): string {
  const forwarded = request.headers["x-forwarded-for"];
  const value = Array.isArray(forwarded) ? forwarded[0] : forwarded;
  return value?.split(",")[0]?.trim() || "unknown";
}

function rateLimitWrite(request: RequestLike): boolean {
  const key = clientKey(request);
  const now = Date.now();
  const recent = (writeAttempts.get(key) || [])
    .filter((timestamp) => now - timestamp < writeLimitWindowMs);
  if (recent.length >= writeLimitMaxAttempts) {
    writeAttempts.set(key, recent);
    return false;
  }

  recent.push(now);
  writeAttempts.set(key, recent);
  return true;
}

function bodyValue(body: unknown, key: string): unknown {
  if (typeof body !== "object" || body === null) {
    return undefined;
  }

  return (body as Record<string, unknown>)[key];
}

function isString(value: unknown): value is string {
  return typeof value === "string" && value.trim().length > 0;
}

function normalizeState(value: unknown): string | null {
  if (!isString(value)) {
    return null;
  }

  const state = value.trim().toUpperCase();
  return /^[A-Z]{2}$/.test(state) ? state : null;
}

function isAdult(dateOfBirth: string): boolean {
  const dob = new Date(`${dateOfBirth}T00:00:00.000Z`);
  if (Number.isNaN(dob.getTime())) {
    return false;
  }

  const today = new Date();
  let age = today.getUTCFullYear() - dob.getUTCFullYear();
  const monthDelta = today.getUTCMonth() - dob.getUTCMonth();
  const dayDelta = today.getUTCDate() - dob.getUTCDate();
  if (monthDelta < 0 || (monthDelta === 0 && dayDelta < 0)) {
    age -= 1;
  }

  return age >= 18;
}

function isAdultBirthYear(birthYear: number): boolean {
  const currentYear = new Date().getUTCFullYear();
  return currentYear - birthYear >= 18;
}

async function verifyAuth(request: RequestLike): Promise<AuthContext> {
  const rawHeader = request.headers.authorization;
  const header = Array.isArray(rawHeader) ? rawHeader[0] : rawHeader;
  if (!header || !header.startsWith("Bearer ")) {
    throw new Error("AUTH_REQUIRED");
  }

  try {
    const token = header.slice("Bearer ".length);
    const decoded = await getAuth().verifyIdToken(token);
    return {
      firebaseUid: decoded.uid,
      email: decoded.email || "",
      emailVerified: decoded.email_verified === true,
    };
  } catch (error) {
    if ((error as Error).message === "AUTH_REQUIRED") {
      throw error;
    }
    throw new Error("TOKEN_INVALID");
  }
}

async function ensureUser(auth: AuthContext): Promise<UserRow> {
  const result = await pool.query<UserRow>(
    `insert into users (firebase_uid, email, email_verified)
     values ($1, $2, $3)
     on conflict (firebase_uid) do update
       set email = excluded.email,
           email_verified = excluded.email_verified,
           updated_at = now()
     returning *`,
    [auth.firebaseUid, auth.email, auth.emailVerified],
  );

  return result.rows[0];
}

function profileComplete(user: UserRow): boolean {
  return user.email_verified &&
    user.is_18_plus &&
    !!user.state_code &&
    user.citizenship_attested;
}

function verificationRank(level: string): number {
  if (level === "level_3_high_assurance") {
    return 3;
  }
  if (level === "level_2_proof_of_human") {
    return 2;
  }
  return 1;
}

function slugify(value: string): string {
  const slug = value
    .toLowerCase()
    .replace(/[^a-z0-9]+/g, "-")
    .replace(/(^-|-$)/g, "")
    .slice(0, 60);
  return `${slug || "concern"}-${Date.now()}`;
}

async function protectedUser(
  request: RequestLike,
  requireCompleteProfile: boolean,
): Promise<UserRow> {
  const auth = await verifyAuth(request);
  if (!auth.emailVerified) {
    throw new Error("EMAIL_VERIFICATION_REQUIRED");
  }

  const user = await ensureUser(auth);
  if (requireCompleteProfile && !profileComplete(user)) {
    throw new Error("ELIGIBILITY_REQUIRED");
  }

  return user;
}

function authError(
  response: ResponseLike,
  error: Error,
): boolean {
  if (error.message === "AUTH_REQUIRED") {
    sendError(response, 401, "AUTH_REQUIRED", "Authentication is required.");
    return true;
  }
  if (error.message === "TOKEN_INVALID") {
    sendError(response, 401, "TOKEN_INVALID", "Firebase token is invalid.");
    return true;
  }
  if (error.message === "EMAIL_VERIFICATION_REQUIRED") {
    sendError(response, 403, "EMAIL_VERIFICATION_REQUIRED",
      "Email verification is required.");
    return true;
  }
  if (error.message === "ELIGIBILITY_REQUIRED") {
    sendError(response, 403, "ELIGIBILITY_REQUIRED",
      "A complete civic profile is required.");
    return true;
  }

  return false;
}

function serializeUser(user: UserRow) {
  return {
    id: user.id,
    firebaseUid: user.firebase_uid,
    email: user.email,
    emailVerified: user.email_verified,
    displayAlias: user.display_alias,
    birthYear: user.birth_year,
    dateOfBirth: user.date_of_birth,
    is18Plus: user.is_18_plus,
    stateCode: user.state_code,
    citizenshipAttested: user.citizenship_attested,
    verificationLevel: user.verification_level,
    profileCompletedAt: user.profile_completed_at,
    createdAt: user.created_at,
    updatedAt: user.updated_at,
  };
}

async function dossierByIdOrSlug(idOrSlug: string): Promise<DossierRow | null> {
  const result = await pool.query<DossierRow>(
    `select *
     from dossiers
     where id::text = $1 or slug = $1
     limit 1`,
    [idOrSlug],
  );
  return result.rows[0] || null;
}

async function serializeDossier(dossier: DossierRow) {
  const [evidence, questions, provisions] = await Promise.all([
    pool.query<EvidenceRow>(
      `select *
       from dossier_evidence
       where dossier_id = $1
       order by display_order, title`,
      [dossier.id],
    ),
    pool.query<QuestionRow>(
      `select *
       from dossier_questions
       where dossier_id = $1
       order by display_order, question_text`,
      [dossier.id],
    ),
    pool.query<ProvisionRow>(
      `select *
       from dossier_provisions
       where dossier_id = $1
       order by display_order, provision_text`,
      [dossier.id],
    ),
  ]);

  return {
    id: dossier.id,
    slug: dossier.slug,
    title: dossier.title,
    summary: dossier.summary,
    scope: dossier.scope,
    issueStatement: dossier.issue_statement,
    whyReviewExists: dossier.why_review_exists,
    participationBoundaries: dossier.participation_boundaries,
    status: dossier.status,
    version: dossier.version,
    publishedAt: dossier.published_at,
    evidence: evidence.rows.map((item) => ({
      id: item.id,
      externalId: item.external_id,
      title: item.title,
      source: item.source,
      summary: item.summary,
      whyItMatters: item.why_it_matters,
      url: item.url,
      displayOrder: item.display_order,
    })),
    questions: questions.rows.map((item) => ({
      id: item.id,
      text: item.question_text,
      displayOrder: item.display_order,
    })),
    provisions: provisions.rows.map((item) => ({
      id: item.id,
      slug: item.slug,
      text: item.provision_text,
      displayOrder: item.display_order,
    })),
  };
}

async function listDossiers() {
  const result = await pool.query<DossierRow>(
    `select *
     from dossiers
     where status = 'published'
     order by published_at desc nulls last, created_at desc`,
  );

  return Promise.all(result.rows.map(serializeDossier));
}

async function serializeRecord(record: RecordRow) {
  const [
    stateResults,
    verificationSummary,
    provisionResults,
    totals,
    evidenceIndex,
  ] =
    await Promise.all([
      pool.query(
        `select
           baseline.state_code,
           baseline.state_name,
           count(ratifications.id)::int as participants,
           baseline.citizen_voting_age_population,
           case
             when baseline.citizen_voting_age_population = 0 then 0
             else count(ratifications.id)::numeric /
               baseline.citizen_voting_age_population
           end as participation_rate
         from state_population_baselines baseline
         left join ratifications
           on ratifications.state_at_participation = baseline.state_code
          and ratifications.dossier_id = $1
         group by baseline.state_code,
           baseline.state_name,
           baseline.citizen_voting_age_population
         order by baseline.state_code`,
        [record.dossier_id],
      ),
      pool.query(
        `select
           verification_level_at_participation as verification_level,
           count(*)::int as participant_count,
           case
             when count(*) over () = 0 then 0
             else count(*)::numeric / sum(count(*)) over () * 100
           end as percentage
         from ratifications
         where dossier_id = $1
         group by verification_level_at_participation
         order by verification_level_at_participation`,
        [record.dossier_id],
      ),
      pool.query(
        `select
           dossier_provisions.id as provision_id,
           dossier_provisions.provision_text,
           count(provision_responses.id)
             filter (where provision_responses.position = 'agree')::int
             as agree_count,
           count(provision_responses.id)
             filter (where provision_responses.position = 'disagree')::int
             as disagree_count
         from dossier_provisions
         left join provision_responses
           on provision_responses.provision_id = dossier_provisions.id
         where dossier_provisions.dossier_id = $1
         group by dossier_provisions.id, dossier_provisions.provision_text
         order by dossier_provisions.display_order`,
        [record.dossier_id],
      ),
      pool.query(
        `select
           count(*)::int as total_participants,
           count(*) filter (where position = 'ratify')::int as ratified_count,
           count(*) filter (where position = 'do_not_ratify')::int
             as not_ratified_count,
           count(distinct state_at_participation)::int as states_represented
         from ratifications
         where dossier_id = $1`,
        [record.dossier_id],
      ),
      pool.query<EvidenceRow>(
        `select *
         from dossier_evidence
         where dossier_id = $1
         order by display_order, title`,
        [record.dossier_id],
      ),
    ]);

  return {
    id: record.id,
    slug: record.slug,
    recordId: record.record_id,
    version: record.version,
    openingStatement: record.opening_statement,
    plainLanguageSummary: record.plain_language_summary,
    outcome: record.outcome,
    methodologyDisclosure: record.methodology_disclosure,
    boundaryStatement: record.boundary_statement,
    publishedAt: record.published_at,
    dossierId: record.dossier_id,
    dossierTitle: record.dossier_title,
    participationSummary: totals.rows[0],
    stateResults: stateResults.rows,
    verificationSummary: verificationSummary.rows,
    provisionResults: provisionResults.rows,
    evidenceIndex: evidenceIndex.rows.map((item) => ({
      id: item.id,
      externalId: item.external_id,
      title: item.title,
      source: item.source,
      summary: item.summary,
      whyItMatters: item.why_it_matters,
      url: item.url,
      displayOrder: item.display_order,
    })),
  };
}

async function listRecords() {
  const result = await pool.query<RecordRow>(
    `select crr.*, dossiers.title as dossier_title
     from civic_ratification_records crr
     join dossiers on dossiers.id = crr.dossier_id
     order by crr.published_at desc`,
  );

  return Promise.all(result.rows.map(serializeRecord));
}

async function recordBySlug(slug: string) {
  const result = await pool.query<RecordRow>(
    `select crr.*, dossiers.title as dossier_title
     from civic_ratification_records crr
     join dossiers on dossiers.id = crr.dossier_id
     where crr.slug = $1 or crr.record_id = $1
     limit 1`,
    [slug],
  );

  return result.rows[0] ? serializeRecord(result.rows[0]) : null;
}

async function updateProfile(
  request: RequestLike,
  response: ResponseLike,
) {
  let user: UserRow;
  try {
    user = await protectedUser(request, false);
  } catch (error) {
    if (authError(response, error as Error)) {
      return;
    }
    throw error;
  }

  const displayAlias = bodyValue(request.body, "displayAlias");
  const birthYearValue = bodyValue(request.body, "birthYear");
  const dateOfBirth = bodyValue(request.body, "dateOfBirth");
  const citizenshipAttested = bodyValue(request.body, "citizenshipAttested");
  const stateCode = normalizeState(bodyValue(request.body, "stateCode"));
  const birthYear = typeof birthYearValue === "number" ?
    birthYearValue :
    Number.parseInt(String(birthYearValue || ""), 10);

  if (!isString(displayAlias) ||
    Number.isNaN(birthYear) ||
    typeof citizenshipAttested !== "boolean" ||
    stateCode === null) {
    sendError(response, 400, "VALIDATION_FAILED",
      "displayAlias, birthYear, stateCode, and citizenshipAttested " +
      "are required.");
    return;
  }

  const is18Plus = isString(dateOfBirth) ?
    isAdult(dateOfBirth) :
    isAdultBirthYear(birthYear);
  const completed = user.email_verified &&
    is18Plus &&
    citizenshipAttested &&
    !!stateCode;

  const result = await pool.query<UserRow>(
    `update users
     set date_of_birth = $2,
         display_alias = $3,
         birth_year = $4,
         is_18_plus = $5,
         state_code = $6,
         citizenship_attested = $7,
         profile_completed_at = case
           when $8 then coalesce(profile_completed_at, now())
           else null
         end,
         updated_at = now()
     where id = $1
     returning *`,
    [
      user.id,
      isString(dateOfBirth) ? dateOfBirth : null,
      String(displayAlias).trim(),
      birthYear,
      is18Plus,
      stateCode,
      citizenshipAttested,
      completed,
    ],
  );

  sendOk(response, {user: serializeUser(result.rows[0])});
}

async function createReadConfirmation(
  request: RequestLike,
  response: ResponseLike,
  dossierIdOrSlug: string,
) {
  const user = await protectedUser(request, true);
  const dossier = await dossierByIdOrSlug(dossierIdOrSlug);
  if (!dossier) {
    sendError(response, 404, "DOSSIER_NOT_FOUND", "Dossier was not found.");
    return;
  }

  const result = await pool.query(
    `insert into read_confirmations (
       user_id,
       dossier_id,
       dossier_version,
       state_at_participation,
       verification_level_at_participation
     )
     values ($1, $2, $3, $4, $5)
     on conflict (user_id, dossier_id) do nothing
     returning id, confirmed_at`,
    [
      user.id,
      dossier.id,
      dossier.version,
      user.state_code,
      user.verification_level,
    ],
  );

  if (result.rowCount === 0) {
    sendError(response, 409, "DUPLICATE_PARTICIPATION",
      "Read confirmation already exists for this dossier.");
    return;
  }

  sendCreated(response, result.rows[0]);
}

async function createRatification(
  request: RequestLike,
  response: ResponseLike,
  dossierIdOrSlug: string,
) {
  const user = await protectedUser(request, true);
  const position = bodyValue(request.body, "position");
  if (position !== "ratify" && position !== "do_not_ratify") {
    sendError(response, 400, "VALIDATION_FAILED",
      "position must be ratify or do_not_ratify.");
    return;
  }

  const dossier = await dossierByIdOrSlug(dossierIdOrSlug);
  if (!dossier) {
    sendError(response, 404, "DOSSIER_NOT_FOUND", "Dossier was not found.");
    return;
  }

  const confirmation = await pool.query(
    `select id from read_confirmations
     where user_id = $1 and dossier_id = $2
     limit 1`,
    [user.id, dossier.id],
  );

  if (confirmation.rowCount === 0) {
    sendError(response, 403, "READ_CONFIRMATION_REQUIRED",
      "Read confirmation is required before ratification.");
    return;
  }

  const result = await pool.query(
    `insert into ratifications (
       user_id,
       dossier_id,
       position,
       state_at_participation,
       verification_level_at_participation
     )
     values ($1, $2, $3, $4, $5)
     on conflict (user_id, dossier_id) do nothing
     returning id, submitted_at`,
    [user.id, dossier.id, position, user.state_code, user.verification_level],
  );

  if (result.rowCount === 0) {
    sendError(response, 409, "DUPLICATE_PARTICIPATION",
      "Ratification already exists for this dossier.");
    return;
  }

  sendCreated(response, result.rows[0]);
}

async function createProvisionResponse(
  request: RequestLike,
  response: ResponseLike,
  provisionId: string,
) {
  const user = await protectedUser(request, true);
  const position = bodyValue(request.body, "position");
  if (position !== "agree" && position !== "disagree") {
    sendError(response, 400, "VALIDATION_FAILED",
      "position must be agree or disagree.");
    return;
  }

  const provision = await pool.query(
    "select id from dossier_provisions where id::text = $1 limit 1",
    [provisionId],
  );

  if (provision.rowCount === 0) {
    sendError(response, 404, "PROVISION_NOT_FOUND",
      "Provision was not found.");
    return;
  }

  const result = await pool.query(
    `insert into provision_responses (
       user_id,
       provision_id,
       position,
       state_at_participation,
       verification_level_at_participation
     )
     values ($1, $2, $3, $4, $5)
     on conflict (user_id, provision_id) do nothing
     returning id, submitted_at`,
    [
      user.id,
      provisionId,
      position,
      user.state_code,
      user.verification_level,
    ],
  );

  if (result.rowCount === 0) {
    sendError(response, 409, "DUPLICATE_PARTICIPATION",
      "Provision response already exists.");
    return;
  }

  sendCreated(response, result.rows[0]);
}

function serializeConcern(row: ConcernRow) {
  return {
    id: row.id,
    slug: row.slug,
    title: row.title,
    plainLanguageSummary: row.plain_language_summary,
    reviewDomain: row.review_domain,
    issueStatement: row.issue_statement,
    whyReviewMatters: row.why_review_matters,
    constitutionalRelevance: row.constitutional_relevance,
    participationBoundaries: row.participation_boundaries,
    proposedReviewQuestion: row.proposed_review_question,
    externalEvidenceUrl: row.external_evidence_url,
    creatorVerificationLevel: row.creator_verification_level,
    status: row.status,
    signalWindowOpenedAt: row.signal_window_opened_at,
    signalWindowClosesAt: row.signal_window_closes_at,
    duplicateOfConcernId: row.duplicate_of_concern_id,
    createdAt: row.created_at,
    signalCount: Number(row.signal_count || 0),
  };
}

async function concernByIdOrSlug(idOrSlug: string):
  Promise<ConcernRow | null> {
  const result = await pool.query<ConcernRow>(
    `select foundational_concerns.*,
       count(concern_signals.id)::int as signal_count
     from foundational_concerns
     left join concern_signals
       on concern_signals.concern_id = foundational_concerns.id
     where foundational_concerns.id::text = $1
        or foundational_concerns.slug = $1
     group by foundational_concerns.id
     limit 1`,
    [idOrSlug],
  );
  return result.rows[0] || null;
}

async function serializeConcernDetail(concern: ConcernRow) {
  const [evidence, variants] = await Promise.all([
    pool.query<ConcernEvidenceRow>(
      `select *
       from concern_evidence
       where concern_id = $1
       order by display_order, title`,
      [concern.id],
    ),
    pool.query<ConcernVariantRow>(
      `select *
       from concern_variants
       where parent_concern_id = $1
       order by created_at desc`,
      [concern.id],
    ),
  ]);

  return {
    ...serializeConcern(concern),
    evidence: evidence.rows.map((item) => ({
      id: item.id,
      title: item.title,
      url: item.url,
      description: item.description,
      displayOrder: item.display_order,
    })),
    variants: variants.rows.map((item) => ({
      id: item.id,
      parentConcernId: item.parent_concern_id,
      concernId: item.concern_id,
      sharedSummary: item.shared_summary,
      differenceSummary: item.difference_summary,
      evidenceDifference: item.evidence_difference,
      reviewQuestionDifference: item.review_question_difference,
      provisionLanguage: item.provision_language,
      createdAt: item.created_at,
    })),
  };
}

async function listConcerns(includeArchive: boolean) {
  const result = await pool.query<ConcernRow>(
    `select foundational_concerns.*,
       count(concern_signals.id)::int as signal_count
     from foundational_concerns
     left join concern_signals
       on concern_signals.concern_id = foundational_concerns.id
     where (
         $1::boolean
         and foundational_concerns.status in (
           'threshold_not_met',
           'archived',
           'duplicate_reference'
         )
       )
        or (
          not $1::boolean
          and foundational_concerns.status not in (
            'threshold_not_met',
            'archived',
            'duplicate_reference'
          )
        )
     group by foundational_concerns.id
     order by foundational_concerns.created_at desc`,
    [includeArchive],
  );

  return result.rows.map(serializeConcern);
}

async function similarConcerns(
  title: string,
  summary: string,
  reviewDomain: string,
) {
  const titleToken = title.trim().split(/\s+/)[0] || title;
  const summaryToken = summary.trim().split(/\s+/)[0] || summary;
  const result = await pool.query<ConcernRow>(
    `select foundational_concerns.*,
       count(concern_signals.id)::int as signal_count
     from foundational_concerns
     left join concern_signals
       on concern_signals.concern_id = foundational_concerns.id
     where lower(title) = lower($1)
        or (
          review_domain = $2
          and (
            plain_language_summary ilike $3
            or title ilike $4
          )
        )
     group by foundational_concerns.id
     order by foundational_concerns.created_at desc
     limit 5`,
    [title, reviewDomain, `%${summaryToken}%`, `%${titleToken}%`],
  );

  return result.rows.map(serializeConcern);
}

async function createConcern(request: RequestLike, response: ResponseLike) {
  const user = await protectedUser(request, true);
  if (verificationRank(user.verification_level) < 2) {
    sendError(response, 403, "VERIFICATION_LEVEL_REQUIRED",
      "Concern creation requires Level 2 proof-of-human verification.");
    return;
  }

  const title = bodyValue(request.body, "title");
  const plainLanguageSummary = bodyValue(request.body, "plainLanguageSummary");
  const reviewDomain = bodyValue(request.body, "reviewDomain");
  const issueStatement = bodyValue(request.body, "issueStatement");
  const whyReviewMatters = bodyValue(request.body, "whyReviewMatters");
  const constitutionalRelevance =
    bodyValue(request.body, "constitutionalRelevance");
  const participationBoundaries =
    bodyValue(request.body, "participationBoundaries");
  const proposedReviewQuestion =
    bodyValue(request.body, "proposedReviewQuestion");
  const externalEvidenceUrl = bodyValue(request.body, "externalEvidenceUrl");
  const forceDistinct = bodyValue(request.body, "forceDistinct") === true;

  if (!isString(title) ||
    !isString(plainLanguageSummary) ||
    !isString(reviewDomain) ||
    !officialReviewDomains.has(reviewDomain) ||
    !isString(issueStatement) ||
    !isString(whyReviewMatters) ||
    !isString(constitutionalRelevance) ||
    !isString(participationBoundaries) ||
    !isString(proposedReviewQuestion)) {
    sendError(response, 400, "VALIDATION_FAILED",
      "All required concern fields and a valid review domain are required.");
    return;
  }

  const similar = await similarConcerns(
    title,
    plainLanguageSummary,
    reviewDomain,
  );
  if (similar.length > 0 && !forceDistinct) {
    sendError(response, 409, "SIMILAR_CONCERN_EXISTS",
      "A similar foundational concern already exists.");
    return;
  }
  const parentConcernId = forceDistinct && similar.length > 0 ?
    similar[0].id :
    null;

  const evidence = Array.isArray(bodyValue(request.body, "evidence")) ?
    bodyValue(request.body, "evidence") as unknown[] :
    [];

  const client = await pool.connect();
  try {
    await client.query("begin");
    const concernResult = await client.query<ConcernRow>(
      `insert into foundational_concerns (
         slug,
         title,
         plain_language_summary,
         review_domain,
         issue_statement,
         why_review_matters,
         constitutional_relevance,
         participation_boundaries,
         proposed_review_question,
         external_evidence_url,
         creator_user_id,
         creator_verification_level
       )
       values ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12)
       returning *`,
      [
        slugify(title),
        title.trim(),
        plainLanguageSummary.trim(),
        reviewDomain,
        issueStatement.trim(),
        whyReviewMatters.trim(),
        constitutionalRelevance.trim(),
        participationBoundaries.trim(),
        proposedReviewQuestion.trim(),
        isString(externalEvidenceUrl) ? externalEvidenceUrl.trim() : null,
        user.id,
        user.verification_level,
      ],
    );
    const concern = concernResult.rows[0];

    if (parentConcernId) {
      await client.query(
        `insert into concern_variants (
           parent_concern_id,
           concern_id,
           shared_summary,
           difference_summary,
           evidence_difference,
           review_question_difference,
           provision_language
         )
         values ($1, $2, $3, $4, $5, $6, $7)`,
        [
          parentConcernId,
          concern.id,
          plainLanguageSummary.trim(),
          constitutionalRelevance.trim(),
          "Submitted as a clearly distinct concern variant.",
          proposedReviewQuestion.trim(),
          title.trim(),
        ],
      );
    }

    for (let index = 0; index < evidence.length; index += 1) {
      const item = evidence[index] as Record<string, unknown>;
      const evidenceUrl = item.url;
      if (!isString(evidenceUrl)) {
        continue;
      }
      const evidenceTitle = item.title;
      const evidenceDescription = item.description;
      await client.query(
        `insert into concern_evidence (
           concern_id,
           title,
           url,
           description,
           display_order
         )
         values ($1, $2, $3, $4, $5)`,
        [
          concern.id,
          isString(evidenceTitle) ?
            evidenceTitle.trim() :
            `Evidence ${index + 1}`,
          evidenceUrl.trim(),
          isString(evidenceDescription) ?
            evidenceDescription.trim() :
            null,
          index,
        ],
      );
    }

    await client.query(
      `insert into concern_status_history (
         concern_id,
         to_status,
         reason
       )
       values ($1, $2, $3)`,
      [
        concern.id,
        "open_civic_signal",
        "Immutable pre-dossier submitted for public civic signal.",
      ],
    );
    await client.query("commit");
    sendCreated(response, {concern: await serializeConcernDetail(concern)});
  } catch (error) {
    await client.query("rollback");
    throw error;
  } finally {
    client.release();
  }
}

async function createConcernSignal(
  request: RequestLike,
  response: ResponseLike,
  idOrSlug: string,
) {
  const user = await protectedUser(request, true);
  const concern = await concernByIdOrSlug(idOrSlug);
  if (!concern) {
    sendError(response, 404, "CONCERN_NOT_FOUND", "Concern was not found.");
    return;
  }

  const confirmed = bodyValue(request.body, "confirmedSignalMeaning") === true;
  const viewedSummary = bodyValue(request.body, "viewedSummary") === true;
  const viewedScope = bodyValue(request.body, "viewedScope") === true;
  const viewedEvidence = bodyValue(request.body, "viewedEvidence") === true;
  if (!confirmed || !viewedSummary || !viewedScope || !viewedEvidence) {
    sendError(response, 400, "VALIDATION_FAILED",
      "Summary, scope, evidence, and signal meaning must be confirmed.");
    return;
  }

  const result = await pool.query(
    `insert into concern_signals (
       user_id,
       concern_id,
       state_at_participation,
       verification_level_at_participation,
       confirmed_signal_meaning
     )
     values ($1, $2, $3, $4, true)
     on conflict (user_id, concern_id) do nothing
     returning id, signaled_at`,
    [user.id, concern.id, user.state_code, user.verification_level],
  );

  if (result.rowCount === 0) {
    sendError(response, 409, "DUPLICATE_PARTICIPATION",
      "You have already signaled support for this concern.");
    return;
  }

  await evaluateConcernThreshold(concern.id, true);
  sendCreated(response, result.rows[0]);
}

async function evaluateConcernThreshold(
  concernId: string,
  updateStatus: boolean,
) {
  const result = await pool.query(
    `select
       baseline.state_code,
       baseline.state_name,
       count(concern_signals.id)::int as participants,
       baseline.citizen_voting_age_population,
       case
         when baseline.citizen_voting_age_population = 0 then 0
         else count(concern_signals.id)::numeric /
           baseline.citizen_voting_age_population * 100
       end as participation_percent
     from state_population_baselines baseline
     left join concern_signals
       on concern_signals.state_at_participation = baseline.state_code
      and concern_signals.concern_id = $1
      and concern_signals.signaled_at >= now() - interval '90 days'
     group by baseline.state_code,
       baseline.state_name,
       baseline.citizen_voting_age_population
     order by baseline.state_code`,
    [concernId],
  );

  const statesMeetingThreshold = result.rows
    .filter((row) => Number(row.participation_percent) >= 0.1)
    .length;
  const thresholdMet = statesMeetingThreshold >= 10;

  await pool.query(
    `insert into threshold_events (
       concern_id,
       threshold_name,
       states_meeting_threshold,
       required_states,
       required_percent,
       signal_window_days,
       threshold_met,
       details
     )
     values ($1, 'substantial_signal', $2, 10, 0.1000, 90, $3, $4)`,
    [
      concernId,
      statesMeetingThreshold,
      thresholdMet,
      JSON.stringify({states: result.rows}),
    ],
  );

  if (thresholdMet && updateStatus) {
    await pool.query(
      `update foundational_concerns
       set status = 'official_civic_review'
       where id = $1
         and status <> 'official_civic_review'`,
      [concernId],
    );
    await pool.query(
      `insert into concern_status_history (
         concern_id,
         from_status,
         to_status,
         reason
       )
       values ($1, 'open_civic_signal', 'official_civic_review',
        'Substantial Signal threshold met across at least 10 states.')`,
      [concernId],
    );
  }

  return {
    thresholdName: "Substantial Signal",
    thresholdMet,
    statesMeetingThreshold,
    requiredStates: 10,
    requiredPercent: 0.1,
    signalWindowDays: 90,
    states: result.rows,
  };
}

export const api = onRequest({cors: true}, async (request, response) => {
  const req = request as RequestLike;
  const res = response as ResponseLike;
  const path = routePath(req.path);
  const method = req.method.toUpperCase();

  try {
    if (method !== "GET" && !rateLimitWrite(req)) {
      sendError(res, 429, "RATE_LIMITED",
        "Too many write attempts. Please wait and try again.");
      return;
    }

    if (method === "GET" && path === "/health") {
      sendOk(res, {
        status: "ok",
        appEnv: process.env.APP_ENV || "sandbox",
        firebaseProjectId: process.env.FIREBASE_PROJECT_ID || null,
      });
      return;
    }

    if (method === "GET" && path === "/dossiers") {
      sendOk(res, {dossiers: await listDossiers()});
      return;
    }

    const dossierMatch = path.match(/^\/dossiers\/([^/]+)$/);
    if (method === "GET" && dossierMatch) {
      const dossier = await dossierByIdOrSlug(dossierMatch[1]);
      if (!dossier) {
        sendError(res, 404, "DOSSIER_NOT_FOUND",
          "Dossier was not found.");
        return;
      }

      sendOk(res, {dossier: await serializeDossier(dossier)});
      return;
    }

    if (method === "GET" && path === "/records") {
      sendOk(res, {records: await listRecords()});
      return;
    }

    if (method === "GET" && path === "/concerns") {
      sendOk(res, {concerns: await listConcerns(false)});
      return;
    }

    if (method === "GET" && path === "/concerns/archive") {
      sendOk(res, {concerns: await listConcerns(true)});
      return;
    }

    if (method === "POST" && path === "/concerns") {
      await createConcern(req, res);
      return;
    }

    const concernVariantsMatch =
      path.match(/^\/concerns\/([^/]+)\/variants$/);
    if (method === "GET" && concernVariantsMatch) {
      const concern = await concernByIdOrSlug(concernVariantsMatch[1]);
      if (!concern) {
        sendError(res, 404, "CONCERN_NOT_FOUND", "Concern was not found.");
        return;
      }
      const detail = await serializeConcernDetail(concern);
      sendOk(res, {variants: detail.variants});
      return;
    }

    const concernSignalMatch = path.match(/^\/concerns\/([^/]+)\/signal$/);
    if (method === "POST" && concernSignalMatch) {
      await createConcernSignal(req, res, concernSignalMatch[1]);
      return;
    }

    const concernThresholdMatch =
      path.match(/^\/concerns\/([^/]+)\/threshold$/);
    if (method === "GET" && concernThresholdMatch) {
      const concern = await concernByIdOrSlug(concernThresholdMatch[1]);
      if (!concern) {
        sendError(res, 404, "CONCERN_NOT_FOUND", "Concern was not found.");
        return;
      }
      sendOk(res, {
        threshold: await evaluateConcernThreshold(concern.id, false),
      });
      return;
    }

    const concernMatch = path.match(/^\/concerns\/([^/]+)$/);
    if (method === "GET" && concernMatch) {
      const concern = await concernByIdOrSlug(concernMatch[1]);
      if (!concern) {
        sendError(res, 404, "CONCERN_NOT_FOUND", "Concern was not found.");
        return;
      }
      sendOk(res, {concern: await serializeConcernDetail(concern)});
      return;
    }

    const recordMatch = path.match(/^\/records\/([^/]+)$/);
    if (method === "GET" && recordMatch) {
      const record = await recordBySlug(recordMatch[1]);
      if (!record) {
        sendError(res, 404, "CRR_NOT_FOUND", "Record was not found.");
        return;
      }

      sendOk(res, {record});
      return;
    }

    if (method === "GET" && path === "/users/me") {
      const user = await protectedUser(req, false);
      sendOk(res, {user: serializeUser(user)});
      return;
    }

    if (method === "POST" && path === "/users/profile") {
      await updateProfile(req, res);
      return;
    }

    const readMatch =
      path.match(/^\/dossiers\/([^/]+)\/read-confirmation$/);
    if (method === "POST" && readMatch) {
      await createReadConfirmation(req, res, readMatch[1]);
      return;
    }

    const ratificationMatch =
      path.match(/^\/dossiers\/([^/]+)\/ratification$/);
    if (method === "POST" && ratificationMatch) {
      await createRatification(req, res, ratificationMatch[1]);
      return;
    }

    const provisionMatch = path.match(/^\/provisions\/([^/]+)\/response$/);
    if (method === "POST" && provisionMatch) {
      await createProvisionResponse(req, res, provisionMatch[1]);
      return;
    }

    sendError(res, 405, "METHOD_NOT_ALLOWED",
      "Route or method is not supported.");
  } catch (error) {
    if (authError(res, error as Error)) {
      return;
    }

    console.error(error);
    sendError(res, 500, "SERVER_ERROR", "Unexpected server error.");
  }
});
