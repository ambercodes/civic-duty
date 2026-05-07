import '../models/civic_ratification_record.dart';
import '../models/dossier.dart';
import '../models/evidence_item.dart';
import '../models/state_pulse.dart';

const mockEvidenceItems = [
  EvidenceItem(
    id: 'EV-001',
    title: 'Foundational Consent Review Brief',
    source: 'Civic Duty Research Desk',
    summary:
        'Summarizes the civic question, review boundaries, and participation method for this static prototype.',
  ),
  EvidenceItem(
    id: 'EV-002',
    title: 'State Participation Baseline',
    source: 'Mock state population model',
    summary:
        'Provides a state-calibrated baseline for measuring where participation is represented.',
  ),
  EvidenceItem(
    id: 'EV-003',
    title: 'Read Confirmation Method',
    source: 'Civic Duty Process Standard',
    summary:
        'Defines how participants confirm review before recording a ratification position.',
  ),
];

const mockDossier = Dossier(
  id: 'DOS-2026-001',
  title: 'Foundational Consent Civic Review',
  summary:
      'A mock dossier demonstrating how Civic Duty organizes evidence, questions, and review status before a participant ratifies or rejects a finding.',
  scope:
      'This static phase covers the public civic review flow only. It does not authenticate users, submit votes, or generate permanent records.',
  questions: [
    'Has the participant reviewed the evidence presented in this dossier?',
    'Does the dossier provide enough structure for an informed civic position?',
    'Should this mock finding be marked ratified for prototype demonstration?',
  ],
  evidenceItems: mockEvidenceItems,
  version: 'v0.2.0-static',
  publishedDate: 'May 7, 2026',
  estimatedReadingMinutes: 6,
);

const mockStateParticipation = [
  StatePulse(
    state: 'California',
    participants: 18420,
    populationBaseline: 30760000,
  ),
  StatePulse(state: 'Texas', participants: 15110, populationBaseline: 21950000),
  StatePulse(
    state: 'Florida',
    participants: 10340,
    populationBaseline: 17100000,
  ),
  StatePulse(
    state: 'New York',
    participants: 9280,
    populationBaseline: 15450000,
  ),
  StatePulse(
    state: 'Pennsylvania',
    participants: 4760,
    populationBaseline: 10170000,
  ),
];

const mockCivicRatificationRecord = CivicRatificationRecord(
  recordId: 'CRR-2026-0001',
  version: 'v0.2.0-static',
  publicationDate: 'May 7, 2026',
  dossier: mockDossier,
  totalParticipants: 57910,
  ratifiedCount: 42184,
  notRatifiedCount: 15726,
  statesRepresented: 5,
  stateParticipation: mockStateParticipation,
  outcome: 'Mock finding ratified for static prototype review.',
  methodology:
      'Participants review a structured dossier, confirm understanding, and record a ratification position. This prototype uses mock data only and does not submit or persist records.',
);
