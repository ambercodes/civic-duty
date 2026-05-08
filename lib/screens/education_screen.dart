import 'package:flutter/material.dart';

import '../widgets/civic_layout.dart';
import '../widgets/education_blocks.dart';

class EducationPageData {
  const EducationPageData({
    required this.title,
    required this.subtitle,
    required this.sections,
  });

  final String title;
  final String subtitle;
  final List<Widget> sections;
}

class EducationScreen extends StatelessWidget {
  const EducationScreen({super.key, required this.page});

  final EducationPageData page;

  @override
  Widget build(BuildContext context) {
    return CivicLayout(
      title: page.title,
      subtitle: page.subtitle,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (final section in page.sections) ...[
            section,
            if (section != page.sections.last) const SizedBox(height: 22),
          ],
        ],
      ),
    );
  }
}

class EducationPages {
  const EducationPages._();

  static final whatIsCivicDuty = EducationPageData(
    title: 'What Is Civic Duty?',
    subtitle:
        'A plain-language guide to the Civic Duty Constitutional Review Sandbox.',
    sections: [
      const InfoSection(
        title: 'Overview',
        children: [
          Text(
            'Civic Duty is a public constitutional review framework designed to help people examine foundational governance concerns through structured civic participation.',
          ),
          SizedBox(height: 10),
          Text(
            'The project is built around transparency, public inspectability, and readable civic review rather than partisan campaigning or institutional authority.',
          ),
        ],
      ),
      const BoundaryNotice(
        title: 'Important Boundaries',
        body:
            'Civic Duty is not a replacement government. It does not create law. It does not issue legal rulings.',
      ),
      const InfoSection(
        title: 'What The Process Provides',
        children: [
          PlainBulletList(
            items: [
              'reviewing foundational constitutional concerns',
              'organizing evidence',
              'measuring civic participation visibility',
              'preserving public civic records',
            ],
          ),
        ],
      ),
      const MethodologyCard(
        title: 'Sandbox Purpose',
        body:
            'The Civic Duty Constitutional Review Sandbox exists as a public demonstration environment for constitutional civic review experimentation, transparency, and participation methodology.',
      ),
    ],
  );

  static final whatIsADossier = EducationPageData(
    title: 'What Is a Dossier?',
    subtitle: 'How Civic Duty organizes public review material.',
    sections: [
      const InfoSection(
        title: 'Definition',
        children: [
          Text(
            'A dossier is a structured civic review packet that organizes a constitutional concern into a readable public review framework.',
          ),
        ],
      ),
      const InfoSection(
        title: 'What A Dossier May Include',
        children: [
          PlainBulletList(
            items: [
              'the issue under review',
              'supporting evidence',
              'contextual explanation',
              'constitutional review domains',
              'participation boundaries',
              'provisions or variants',
              'review questions',
            ],
          ),
        ],
      ),
      const MethodologyCard(
        title: 'Why Dossiers Exist',
        body:
            'Dossiers exist to help people examine important constitutional concerns in a more organized and understandable way.',
      ),
      const BoundaryNotice(
        title: 'Important Boundary',
        body:
            'A dossier is not a criminal indictment, legal judgment, or legislative action. It is a structured civic review document.',
      ),
    ],
  );

  static final ratificationMeaning = EducationPageData(
    title: 'What Does Ratification Mean?',
    subtitle: 'What participation records mean inside Civic Duty.',
    sections: [
      const ParticipationRuleCard(
        rule: 'Main Definition',
        explanation:
            '"I believe this concern warrants structured civic review and formal civic recording based on the evidence presented."',
      ),
      const InfoSection(
        title: 'Ratification Does Not Mean',
        children: [
          PlainBulletList(
            items: [
              'criminal guilt',
              'legal liability',
              'constitutional amendment',
              'binding government action',
              'universal agreement',
            ],
          ),
        ],
      ),
      const MethodologyCard(
        title: 'What It Does Mean',
        body:
            'It means the participant believes the concern deserves organized civic review and public civic recording.',
      ),
      const BoundaryNotice(
        title: 'Provisions And Variants',
        body:
            'Some dossiers may contain provisions or variants. Participants may agree or disagree with individual provisions while still participating in the larger civic review process.',
      ),
    ],
  );

  static final verificationLevels = EducationPageData(
    title: 'Verification Levels',
    subtitle: 'How Civic Duty explains participation confidence.',
    sections: [
      const InfoSection(
        title: 'Why Verification Exists',
        children: [
          Text(
            'Civic Duty uses verification levels to provide transparency about participation confidence while preserving equal participation weight.',
          ),
        ],
      ),
      const MethodologyCard(
        title: 'Level 1 - Self Attested',
        body:
            'The participant has completed basic account setup, age validation, state declaration, and citizenship attestation.',
      ),
      const MethodologyCard(
        title: 'Level 2 - Proof of Human',
        body:
            'The participant has completed additional verification designed to reduce duplicate or automated participation.',
      ),
      const MethodologyCard(
        title: 'Level 3 - High Assurance',
        body:
            'A future optional verification layer intended for stronger identity assurance scenarios.',
      ),
      const ParticipationRuleCard(
        rule: 'Core Principle',
        explanation:
            'Verification levels are disclosed, not weighted. One participant equals one participation.',
      ),
    ],
  );

  static final participationMethodology = EducationPageData(
    title: 'Participation Methodology',
    subtitle: 'How Civic Duty measures public participation visibility.',
    sections: [
      const InfoSection(
        title: 'Measurement Approach',
        children: [
          Text(
            'Civic Duty measures participation visibility using state-level citizen voting-age population data rather than voter registration or political party affiliation.',
          ),
        ],
      ),
      const InfoSection(
        title: 'The System Uses',
        children: [
          PlainBulletList(
            items: [
              'U.S. citizen population age 18+',
              'state participation density',
              'public thresholds',
              'disclosed methodology rules',
            ],
          ),
        ],
      ),
      const InfoSection(
        title: 'The Platform Avoids',
        children: [
          PlainBulletList(
            items: [
              'voter registration metrics',
              'party affiliation data',
              'county political maps',
              'election turnout assumptions',
            ],
          ),
        ],
      ),
      const MethodologyCard(
        title: 'Thresholds',
        body:
            'Civic Duty uses public civic signal thresholds to determine when a concern advances into structured civic review. Thresholds are publicly visible and methodologically disclosed.',
      ),
    ],
  );

  static final scopeBoundaries = EducationPageData(
    title: 'Scope Boundaries',
    subtitle: 'What Civic Duty is intended to review.',
    sections: [
      const InfoSection(
        title: 'Main Scope',
        children: [
          Text(
            'Civic Duty is intended for structured civic review involving foundational constitutional concerns, structural governance questions, delegated authority, civic consent visibility, and measurable constitutional participation.',
          ),
        ],
      ),
      const InfoSection(
        title: 'Excluded Areas',
        children: [
          PlainBulletList(
            items: [
              'ordinary partisan disputes',
              'routine legislation',
              'candidate campaigning',
              'generalized political polling',
            ],
          ),
        ],
      ),
      const BoundaryNotice(
        title: 'Official Scope Limit',
        body:
            'The official Civic Duty implementation intentionally limits its scope to foundational constitutional and structural governance review.',
      ),
    ],
  );

  static final sandboxDisclaimer = EducationPageData(
    title: 'Sandbox Disclaimer',
    subtitle: 'What the public sandbox is, and what it is not.',
    sections: [
      const InfoSection(
        title: 'Main Disclaimer',
        children: [
          Text(
            'Civic Duty Constitutional Review Sandbox is a public civic review demonstration environment intended for constitutional review experimentation, methodology visibility, and participation flow testing.',
          ),
        ],
      ),
      const InfoSection(
        title: 'The Sandbox Does Not Constitute',
        children: [
          PlainBulletList(
            items: [
              'governmental authority',
              'legal adjudication',
              'binding constitutional interpretation',
              'official public policy determination',
              'legislative action',
            ],
          ),
        ],
      ),
      const MethodologyCard(
        title: 'Why It Exists',
        body:
            'The sandbox exists to explore transparent civic review infrastructure and public constitutional participation methodology.',
      ),
    ],
  );
}
