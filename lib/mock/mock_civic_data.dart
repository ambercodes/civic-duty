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
        'Explains the purpose of the review and the participation process.',
    whyItMatters:
        'It gives every participant the same starting point before they decide how to respond.',
    actionLabel: 'Read Document',
  ),
  EvidenceItem(
    id: 'EV-002',
    title: 'State Participation Baseline',
    source: 'Mock state population model',
    summary:
        'Shows how participation can be measured across state populations.',
    whyItMatters:
        'It helps show whether participation is geographically broad or concentrated in only a few places.',
    actionLabel: 'View Data',
  ),
  EvidenceItem(
    id: 'EV-003',
    title: 'Read Confirmation Method',
    source: 'Civic Duty Process Standard',
    summary:
        'Describes why participants confirm review before recording a position.',
    whyItMatters:
        'It keeps participation tied to reviewed material instead of quick reactions or unclear prompts.',
    actionLabel: 'Review Method',
  ),
];

const mockDossier = Dossier(
  id: 'DOS-2026-001',
  title: 'Foundational Consent Civic Review',
  summary:
      'A public review packet about foundational civic consent and how participation can be measured in a transparent way.',
  scope:
      'This review asks participants to read the same material, confirm understanding, and record a position. This prototype uses mock data only and does not submit real responses.',
  questions: [
    'Do you believe the evidence presented justifies continued civic review and public ratification consideration?',
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
