create extension if not exists pgcrypto;

do $$
begin
  create type verification_level as enum (
    'level_1_self_attested',
    'level_2_proof_of_human',
    'level_3_high_assurance'
  );
exception
  when duplicate_object then null;
end $$;

do $$
begin
  create type ratification_position as enum ('ratify', 'do_not_ratify');
exception
  when duplicate_object then null;
end $$;

do $$
begin
  create type provision_position as enum ('agree', 'disagree');
exception
  when duplicate_object then null;
end $$;

create table if not exists users (
  id uuid primary key default gen_random_uuid(),
  firebase_uid text not null unique,
  email text not null,
  email_verified boolean not null default false,
  display_alias text,
  birth_year integer,
  date_of_birth date,
  is_18_plus boolean not null default false,
  state_code char(2),
  citizenship_attested boolean not null default false,
  verification_level verification_level not null default 'level_1_self_attested',
  profile_completed_at timestamptz,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

alter table users add column if not exists display_alias text;
alter table users add column if not exists birth_year integer;

create table if not exists methodologies (
  id uuid primary key default gen_random_uuid(),
  slug text not null unique,
  version text not null,
  title text not null,
  summary text not null,
  details text not null,
  created_at timestamptz not null default now()
);

create table if not exists threshold_rules (
  id uuid primary key default gen_random_uuid(),
  methodology_id uuid not null references methodologies(id),
  signal_window_days integer not null default 90,
  emerging_signal_percent numeric(8,4) not null default 0.0100,
  substantial_signal_percent numeric(8,4) not null default 0.1000,
  major_signal_percent numeric(8,4) not null default 1.0000,
  historic_signal_percent numeric(8,4) not null default 10.0000,
  advancement_required_state_count integer not null default 10,
  advancement_required_percent numeric(8,4) not null default 0.1000,
  active boolean not null default true,
  created_at timestamptz not null default now()
);

create table if not exists state_population_baselines (
  id uuid primary key default gen_random_uuid(),
  state_code char(2) not null,
  state_name text not null,
  citizen_voting_age_population integer not null check (citizen_voting_age_population >= 0),
  source text not null,
  source_year integer not null,
  methodology_id uuid references methodologies(id),
  effective_at timestamptz not null default now(),
  unique (state_code, source_year)
);

create table if not exists dossiers (
  id uuid primary key default gen_random_uuid(),
  slug text not null unique,
  title text not null,
  summary text not null,
  scope text not null,
  issue_statement text not null,
  why_review_exists text not null,
  participation_boundaries text not null,
  status text not null default 'published',
  version text not null,
  methodology_id uuid references methodologies(id),
  published_at timestamptz,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists dossier_evidence (
  id uuid primary key default gen_random_uuid(),
  dossier_id uuid not null references dossiers(id) on delete cascade,
  external_id text not null,
  title text not null,
  source text not null,
  summary text not null,
  why_it_matters text not null,
  url text,
  display_order integer not null default 0,
  unique (dossier_id, external_id)
);

create table if not exists dossier_questions (
  id uuid primary key default gen_random_uuid(),
  dossier_id uuid not null references dossiers(id) on delete cascade,
  question_text text not null,
  display_order integer not null default 0
);

create table if not exists dossier_provisions (
  id uuid primary key default gen_random_uuid(),
  dossier_id uuid not null references dossiers(id) on delete cascade,
  slug text not null,
  provision_text text not null,
  display_order integer not null default 0,
  unique (dossier_id, slug)
);

create table if not exists read_confirmations (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references users(id) on delete cascade,
  dossier_id uuid not null references dossiers(id) on delete cascade,
  dossier_version text not null,
  state_at_participation char(2) not null,
  verification_level_at_participation verification_level not null,
  confirmed_at timestamptz not null default now(),
  unique (user_id, dossier_id)
);

create table if not exists ratifications (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references users(id) on delete cascade,
  dossier_id uuid not null references dossiers(id) on delete cascade,
  position ratification_position not null,
  state_at_participation char(2) not null,
  verification_level_at_participation verification_level not null,
  submitted_at timestamptz not null default now(),
  unique (user_id, dossier_id)
);

create table if not exists provision_responses (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references users(id) on delete cascade,
  provision_id uuid not null references dossier_provisions(id) on delete cascade,
  position provision_position not null,
  state_at_participation char(2) not null,
  verification_level_at_participation verification_level not null,
  submitted_at timestamptz not null default now(),
  unique (user_id, provision_id)
);

create table if not exists civic_ratification_records (
  id uuid primary key default gen_random_uuid(),
  dossier_id uuid not null references dossiers(id),
  slug text not null unique,
  record_id text not null unique,
  version text not null,
  opening_statement text not null,
  plain_language_summary text not null,
  outcome text not null,
  methodology_disclosure text not null,
  boundary_statement text not null,
  published_at timestamptz not null default now(),
  created_at timestamptz not null default now()
);

create table if not exists crr_state_results (
  id uuid primary key default gen_random_uuid(),
  crr_id uuid not null references civic_ratification_records(id) on delete cascade,
  state_code char(2) not null,
  state_name text not null,
  participants integer not null check (participants >= 0),
  citizen_voting_age_population integer not null check (citizen_voting_age_population >= 0),
  participation_rate numeric(12,8) not null default 0,
  unique (crr_id, state_code)
);

create table if not exists crr_verification_summary (
  id uuid primary key default gen_random_uuid(),
  crr_id uuid not null references civic_ratification_records(id) on delete cascade,
  verification_level verification_level not null,
  participant_count integer not null check (participant_count >= 0),
  percentage numeric(8,4) not null default 0,
  unique (crr_id, verification_level)
);

create table if not exists crr_provision_results (
  id uuid primary key default gen_random_uuid(),
  crr_id uuid not null references civic_ratification_records(id) on delete cascade,
  provision_id uuid references dossier_provisions(id),
  provision_text text not null,
  agree_count integer not null default 0,
  disagree_count integer not null default 0
);

create index if not exists idx_dossiers_status on dossiers(status);
create index if not exists idx_read_confirmations_dossier on read_confirmations(dossier_id);
create index if not exists idx_ratifications_dossier on ratifications(dossier_id);
create index if not exists idx_crr_dossier on civic_ratification_records(dossier_id);
