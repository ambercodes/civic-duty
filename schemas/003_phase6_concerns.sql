create table if not exists foundational_concerns (
  id uuid primary key default gen_random_uuid(),
  slug text not null unique,
  title text not null,
  plain_language_summary text not null,
  review_domain text not null,
  issue_statement text not null,
  why_review_matters text not null,
  constitutional_relevance text not null,
  participation_boundaries text not null,
  proposed_review_question text not null,
  external_evidence_url text,
  creator_user_id uuid not null references users(id),
  creator_verification_level verification_level not null,
  status text not null default 'open_civic_signal',
  signal_window_opened_at timestamptz not null default now(),
  signal_window_closes_at timestamptz not null default now() + interval '90 days',
  duplicate_of_concern_id uuid references foundational_concerns(id),
  created_at timestamptz not null default now()
);

create table if not exists concern_variants (
  id uuid primary key default gen_random_uuid(),
  parent_concern_id uuid not null references foundational_concerns(id) on delete cascade,
  concern_id uuid references foundational_concerns(id) on delete set null,
  shared_summary text not null,
  difference_summary text not null,
  evidence_difference text not null,
  review_question_difference text not null,
  provision_language text not null,
  created_at timestamptz not null default now()
);

create table if not exists concern_evidence (
  id uuid primary key default gen_random_uuid(),
  concern_id uuid not null references foundational_concerns(id) on delete cascade,
  title text not null,
  url text not null,
  description text,
  display_order integer not null default 0,
  created_at timestamptz not null default now()
);

create table if not exists concern_signals (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references users(id) on delete cascade,
  concern_id uuid not null references foundational_concerns(id) on delete cascade,
  state_at_participation char(2) not null,
  verification_level_at_participation verification_level not null,
  confirmed_signal_meaning boolean not null default false,
  signaled_at timestamptz not null default now(),
  unique (user_id, concern_id)
);

create table if not exists concern_status_history (
  id uuid primary key default gen_random_uuid(),
  concern_id uuid not null references foundational_concerns(id) on delete cascade,
  from_status text,
  to_status text not null,
  reason text not null,
  created_at timestamptz not null default now()
);

create table if not exists threshold_events (
  id uuid primary key default gen_random_uuid(),
  concern_id uuid not null references foundational_concerns(id) on delete cascade,
  threshold_name text not null,
  states_meeting_threshold integer not null default 0,
  required_states integer not null default 10,
  required_percent numeric(8,4) not null default 0.1000,
  signal_window_days integer not null default 90,
  threshold_met boolean not null default false,
  evaluated_at timestamptz not null default now(),
  details jsonb not null default '{}'::jsonb
);

create index if not exists idx_foundational_concerns_status
  on foundational_concerns(status);
create index if not exists idx_foundational_concerns_domain
  on foundational_concerns(review_domain);
create index if not exists idx_concern_signals_concern
  on concern_signals(concern_id);
