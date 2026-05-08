insert into methodologies (slug, version, title, summary, details)
values (
  'phase-4-sandbox-methodology',
  'v1.0.0-sandbox',
  'Phase 4 Sandbox Methodology',
  'Measures structured civic participation using Level 1 MVP eligibility, state-at-participation locking, and CVAP/state-level baselines.',
  'Participation is counted as one participant equals one participation. Verification level is disclosed, not weighted. State participation rate equals participants from state divided by state citizen voting-age population.'
)
on conflict (slug) do update
set version = excluded.version,
    title = excluded.title,
    summary = excluded.summary,
    details = excluded.details;

insert into threshold_rules (methodology_id)
select id
from methodologies
where slug = 'phase-4-sandbox-methodology'
and not exists (
  select 1
  from threshold_rules
  join methodologies existing_methodology
    on existing_methodology.id = threshold_rules.methodology_id
  where existing_methodology.slug = 'phase-4-sandbox-methodology'
);

insert into state_population_baselines (
  state_code,
  state_name,
  citizen_voting_age_population,
  source,
  source_year,
  methodology_id
)
select state_code, state_name, citizen_voting_age_population, source, source_year, methodology_id
from (
  values
    ('CA', 'California', 30760000, 'Sample CVAP baseline for sandbox testing', 2024),
    ('TX', 'Texas', 21950000, 'Sample CVAP baseline for sandbox testing', 2024),
    ('FL', 'Florida', 17100000, 'Sample CVAP baseline for sandbox testing', 2024),
    ('NY', 'New York', 15450000, 'Sample CVAP baseline for sandbox testing', 2024),
    ('PA', 'Pennsylvania', 10170000, 'Sample CVAP baseline for sandbox testing', 2024)
) as seed(state_code, state_name, citizen_voting_age_population, source, source_year)
cross join (
  select id as methodology_id from methodologies where slug = 'phase-4-sandbox-methodology'
) methodology
on conflict (state_code, source_year) do update
set state_name = excluded.state_name,
    citizen_voting_age_population = excluded.citizen_voting_age_population,
    source = excluded.source,
    methodology_id = excluded.methodology_id;

insert into dossiers (
  slug,
  title,
  summary,
  scope,
  issue_statement,
  why_review_exists,
  participation_boundaries,
  status,
  version,
  methodology_id,
  published_at
)
select
  'foundational-consent-civic-review',
  'Foundational Consent Civic Review',
  'A public review packet about foundational civic consent and how participation can be measured in a transparent way.',
  'This review asks participants to read the same material, confirm understanding, and record whether the concern warrants structured civic review and formal civic recording.',
  'The issue under review is whether foundational civic consent concerns warrant structured public review within the Civic Duty framework.',
  'This sandbox review exists to test the dossier, confirmation, ratification, and record-generation flow before broader backend implementation.',
  'This review is a sandbox demonstration. It is not a legal ruling, legislative action, criminal determination, constitutional amendment, or binding government action.',
  'published',
  'v1.0.0-sandbox',
  id,
  now()
from methodologies
where slug = 'phase-4-sandbox-methodology'
on conflict (slug) do update
set title = excluded.title,
    summary = excluded.summary,
    scope = excluded.scope,
    issue_statement = excluded.issue_statement,
    why_review_exists = excluded.why_review_exists,
    participation_boundaries = excluded.participation_boundaries,
    version = excluded.version,
    methodology_id = excluded.methodology_id;

insert into dossier_evidence (
  dossier_id,
  external_id,
  title,
  source,
  summary,
  why_it_matters,
  url,
  display_order
)
select dossier_id, external_id, title, source, summary, why_it_matters, url, display_order
from (
  values
    ('EV-001', 'Foundational Consent Review Brief', 'Civic Duty Research Desk', 'Explains the purpose of the review and the participation process.', 'It gives every participant the same starting point before they decide how to respond.', null, 1),
    ('EV-002', 'State Participation Baseline', 'Sample state population model', 'Shows how participation can be measured across state populations.', 'It helps show whether participation is geographically broad or concentrated in only a few places.', null, 2),
    ('EV-003', 'Read Confirmation Method', 'Civic Duty Process Standard', 'Describes why participants confirm review before recording a position.', 'It keeps participation tied to reviewed material instead of quick reactions or unclear prompts.', null, 3)
) as seed(external_id, title, source, summary, why_it_matters, url, display_order)
cross join (
  select id as dossier_id from dossiers where slug = 'foundational-consent-civic-review'
) dossier
on conflict (dossier_id, external_id) do update
set title = excluded.title,
    source = excluded.source,
    summary = excluded.summary,
    why_it_matters = excluded.why_it_matters,
    url = excluded.url,
    display_order = excluded.display_order;

insert into dossier_questions (dossier_id, question_text, display_order)
select id,
  'Do you believe this concern warrants structured civic review and formal civic recording based on the evidence presented?',
  1
from dossiers
where slug = 'foundational-consent-civic-review'
and not exists (
  select 1 from dossier_questions where dossier_id = dossiers.id and display_order = 1
);

insert into dossier_provisions (dossier_id, slug, provision_text, display_order)
select id,
  'review-warranted',
  'This concern warrants structured civic review and formal civic recording based on the evidence presented.',
  1
from dossiers
where slug = 'foundational-consent-civic-review'
on conflict (dossier_id, slug) do update
set provision_text = excluded.provision_text,
    display_order = excluded.display_order;

insert into civic_ratification_records (
  dossier_id,
  slug,
  record_id,
  version,
  opening_statement,
  plain_language_summary,
  outcome,
  methodology_disclosure,
  boundary_statement,
  published_at
)
select
  id,
  'foundational-consent-civic-review-sandbox-record',
  'CRR-2026-0001',
  'v1.0.0-sandbox',
  'This record reflects structured civic participation and constitutional review activity within the Civic Duty framework.',
  'Sandbox record for the foundational consent civic review flow.',
  'Sandbox record published for backend integration testing.',
  'Participants review a structured dossier, confirm review, and record a binary ratification position. Verification level is disclosed, not weighted.',
  'This record reflects structured civic participation and constitutional review activity within the Civic Duty framework. It does not constitute a judicial ruling, legislative enactment, criminal determination, or binding government action.',
  now()
from dossiers
where slug = 'foundational-consent-civic-review'
on conflict (slug) do nothing;

insert into crr_state_results (
  crr_id,
  state_code,
  state_name,
  participants,
  citizen_voting_age_population,
  participation_rate
)
select crr.id, baseline.state_code, baseline.state_name, 0, baseline.citizen_voting_age_population, 0
from civic_ratification_records crr
join state_population_baselines baseline on baseline.state_code in ('CA', 'TX', 'FL', 'NY', 'PA')
where crr.slug = 'foundational-consent-civic-review-sandbox-record'
on conflict (crr_id, state_code) do nothing;

insert into crr_verification_summary (
  crr_id,
  verification_level,
  participant_count,
  percentage
)
select crr.id, level::verification_level, 0, 0
from civic_ratification_records crr
cross join (
  values
    ('level_1_self_attested'),
    ('level_2_proof_of_human'),
    ('level_3_high_assurance')
) as levels(level)
where crr.slug = 'foundational-consent-civic-review-sandbox-record'
on conflict (crr_id, verification_level) do nothing;
