import {readFileSync} from "node:fs";
import {createRequire} from "node:module";

const require = createRequire(import.meta.url);
const {Pool} = require("../functions/node_modules/pg");

function readEnv() {
  const env = {};
  const lines = readFileSync(new URL("../.env", import.meta.url), "utf8")
    .split(/\r?\n/);

  for (const line of lines) {
    const trimmed = line.trim();
    if (!trimmed || trimmed.startsWith("#") || !trimmed.includes("=")) {
      continue;
    }

    const separator = trimmed.indexOf("=");
    const key = trimmed.substring(0, separator).trim();
    const value = trimmed
      .substring(separator + 1)
      .trim()
      .replace(/^['"]|['"]$/g, "");
    env[key] = value;
  }

  return env;
}

function databaseUrl(raw) {
  if (!raw) {
    throw new Error("NEON_DATABASE_URL is missing from .env");
  }

  const url = new URL(raw);
  url.searchParams.delete("channel_binding");
  if (!url.searchParams.has("sslmode")) {
    url.searchParams.set("sslmode", "require");
  }
  return url;
}

const env = readEnv();
const url = databaseUrl(env.NEON_DATABASE_URL);

console.log(JSON.stringify({
  host: url.host,
  database: url.pathname.slice(1),
  sslmode: url.searchParams.get("sslmode"),
  channelBinding: url.searchParams.get("channel_binding"),
  hasUser: Boolean(url.username),
  hasPassword: Boolean(url.password),
}));

const pool = new Pool({
  connectionString: url.toString(),
  connectionTimeoutMillis: 15000,
  keepAlive: true,
});

try {
  const result = await pool.query(
    "select count(*)::int as dossier_count from dossiers",
  );
  console.log(JSON.stringify({
    ok: true,
    dossierCount: result.rows[0].dossier_count,
  }));
} catch (error) {
  console.error(JSON.stringify({
    ok: false,
    message: error.message,
    code: error.code,
    syscall: error.syscall,
  }));
  process.exitCode = 1;
} finally {
  await pool.end();
}
