import '../models/civic_ratification_record.dart';
import '../models/dossier.dart';
import '../models/evidence_item.dart';
import '../models/state_pulse.dart';

class StaticSandboxData {
  const StaticSandboxData._();

  static const dossierSlug = 'foundational-consent-civic-review';
  static const recordSlug = 'foundational-consent-civic-review-sandbox-record';

  static const dossier = Dossier(
    id: dossierSlug,
    slug: dossierSlug,
    title: 'Foundational Consent Civic Review',
    summary:
        'A public review packet about foundational civic consent and how participation can be measured in a transparent way.',
    scope:
        'This review asks participants to read the same material, confirm understanding, and record whether the concern warrants structured civic review and formal civic recording.',
    questions: [
      'Do you believe this concern warrants structured civic review and formal civic recording based on the evidence presented?',
    ],
    evidenceItems: [
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
        source: 'Sample state population model',
        summary:
            'Shows how participation can be measured across state populations.',
        whyItMatters:
            'It helps show whether participation is geographically broad or concentrated in only a few places.',
        actionLabel: 'Read Document',
      ),
      EvidenceItem(
        id: 'EV-003',
        title: 'Read Confirmation Method',
        source: 'Civic Duty Process Standard',
        summary:
            'Describes why participants confirm review before recording a position.',
        whyItMatters:
            'It keeps participation tied to reviewed material instead of quick reactions or unclear prompts.',
        actionLabel: 'Read Document',
      ),
    ],
    version: 'v1.0.0-sandbox',
    publishedDate: 'Sandbox demo',
    estimatedReadingMinutes: 6,
    status: 'published',
    provisions: [
      DossierProvision(
        id: 'review-warranted',
        slug: 'review-warranted',
        text:
            'This concern warrants structured civic review and formal civic recording based on the evidence presented.',
      ),
    ],
  );

  static const record = CivicRatificationRecord(
    openingStatement:
        'This record reflects structured civic participation and constitutional review activity within the Civic Duty framework.',
    recordId: 'CRR-2026-0001',
    version: 'v1.0.0-sandbox',
    publicationDate: 'Sandbox demo',
    dossier: dossier,
    totalParticipants: 0,
    ratifiedCount: 0,
    notRatifiedCount: 0,
    statesRepresented: 5,
    stateParticipation: [
      StatePulse(
        state: 'California',
        participants: 0,
        populationBaseline: 30760000,
      ),
      StatePulse(state: 'Texas', participants: 0, populationBaseline: 21950000),
      StatePulse(
        state: 'Florida',
        participants: 0,
        populationBaseline: 17100000,
      ),
      StatePulse(
        state: 'New York',
        participants: 0,
        populationBaseline: 15450000,
      ),
      StatePulse(
        state: 'Pennsylvania',
        participants: 0,
        populationBaseline: 10170000,
      ),
    ],
    outcome: 'Sandbox record published for static demo viewing.',
    methodology:
        'Participants review a structured dossier, confirm review, and record a binary ratification position. Verification level is disclosed, not weighted.',
    boundaryStatement:
        'This record reflects structured civic participation and constitutional review activity within the Civic Duty framework. It does not constitute a judicial ruling, legislative enactment, criminal determination, or binding government action.',
    verificationSummary: [
      VerificationSummaryItem(
        verificationLevel: 'level_1_self_attested',
        participantCount: 0,
        percentage: 0,
      ),
      VerificationSummaryItem(
        verificationLevel: 'level_2_proof_of_human',
        participantCount: 0,
        percentage: 0,
      ),
      VerificationSummaryItem(
        verificationLevel: 'level_3_high_assurance',
        participantCount: 0,
        percentage: 0,
      ),
    ],
    provisionResults: [
      ProvisionResultItem(
        provisionText:
            'This concern warrants structured civic review and formal civic recording based on the evidence presented.',
        agreeCount: 0,
        disagreeCount: 0,
      ),
    ],
  );

  static Dossier dossierByIdOrSlug(String idOrSlug) {
    if (idOrSlug == dossier.id || idOrSlug == dossier.slug) {
      return dossier;
    }
    return dossier;
  }

  static CivicRatificationRecord recordBySlug(String slug) {
    if (slug == recordSlug) {
      return record;
    }
    return record;
  }
}
