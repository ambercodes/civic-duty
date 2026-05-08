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
  "VALIDATION_FAILED" |
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
  const [stateResults, verificationSummary, provisionResults, totals] =
    await Promise.all([
      pool.query(
        `select *
         from crr_state_results
         where crr_id = $1
         order by state_code`,
        [record.id],
      ),
      pool.query(
        `select *
         from crr_verification_summary
         where crr_id = $1
         order by verification_level`,
        [record.id],
      ),
      pool.query(
        `select *
         from crr_provision_results
         where crr_id = $1
         order by id`,
        [record.id],
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

  const dateOfBirth = bodyValue(request.body, "dateOfBirth");
  const citizenshipAttested = bodyValue(request.body, "citizenshipAttested");
  const stateCode = normalizeState(bodyValue(request.body, "stateCode"));

  if (!isString(dateOfBirth) ||
    typeof citizenshipAttested !== "boolean" ||
    stateCode === null) {
    sendError(response, 400, "VALIDATION_FAILED",
      "dateOfBirth, stateCode, and citizenshipAttested are required.");
    return;
  }

  const is18Plus = isAdult(dateOfBirth);
  const completed = user.email_verified &&
    is18Plus &&
    citizenshipAttested &&
    !!stateCode;

  const result = await pool.query<UserRow>(
    `update users
     set date_of_birth = $2,
         is_18_plus = $3,
         state_code = $4,
         citizenship_attested = $5,
         profile_completed_at = case
           when $6 then coalesce(profile_completed_at, now())
           else null
         end,
         updated_at = now()
     where id = $1
     returning *`,
    [user.id, dateOfBirth, is18Plus, stateCode, citizenshipAttested, completed],
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

export const api = onRequest({cors: true}, async (request, response) => {
  const req = request as RequestLike;
  const res = response as ResponseLike;
  const path = routePath(req.path);
  const method = req.method.toUpperCase();

  try {
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
