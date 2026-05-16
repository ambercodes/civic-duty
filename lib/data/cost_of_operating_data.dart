import '../models/cost_of_operating.dart';

class CostOfOperatingData {
  const CostOfOperatingData._();

  static const summary = CostOfOperatingSummary(
    totalPublicSupportReceived: '0 ADA publicly recorded in this demo',
    estimatedDevelopmentHours: '1,315 hours',
    estimatedLaborValue: r'$150,975',
    visibleInfrastructureCosts: r'$0.00 published static demo cost',
    operationalStatus: 'Static public sandbox online',
    lastUpdatedDate: 'May 16, 2026',
  );

  static const laborCategories = [
    LaborCategorySummary(
      category: 'Full-Stack Application Development',
      estimatedHours: '420 hrs',
      estimatedLaborValue: r'$52,500',
      includes: [
        'Flutter development',
        'frontend implementation',
        'backend integration',
        'API architecture',
        'Firebase integration',
        'Neon/PostgreSQL integration',
        'deployment systems',
      ],
    ),
    LaborCategorySummary(
      category: 'Systems Architecture',
      estimatedHours: '240 hrs',
      estimatedLaborValue: r'$34,800',
      includes: [
        'civic systems design',
        'participation architecture',
        'verification systems',
        'constitutional review flows',
        'operational framework design',
      ],
    ),
    LaborCategorySummary(
      category: 'Civic / Constitutional Research',
      estimatedHours: '170 hrs',
      estimatedLaborValue: r'$16,150',
      includes: [
        'constitutional review methodology',
        'public participation structure research',
        'governance analysis',
        'public methodology drafting',
      ],
    ),
    LaborCategorySummary(
      category: 'UI / UX Design',
      estimatedHours: '120 hrs',
      estimatedLaborValue: r'$11,400',
      includes: [
        'public readability',
        'responsive layouts',
        'onboarding clarity',
        'visual hierarchy',
        'accessible civic interface design',
      ],
    ),
    LaborCategorySummary(
      category: 'Technical Documentation',
      estimatedHours: '150 hrs',
      estimatedLaborValue: r'$12,000',
      includes: [
        'architecture documentation',
        'development planning',
        'methodology explanation',
        'public guidance',
        'contributor-facing documentation',
      ],
    ),
    LaborCategorySummary(
      category: 'Infrastructure / Deployment',
      estimatedHours: '80 hrs',
      estimatedLaborValue: r'$9,200',
      includes: [
        'Firebase configuration',
        'deployment architecture',
        'environment management',
        'hosting',
        'operational setup',
        'infrastructure maintenance',
      ],
    ),
    LaborCategorySummary(
      category: 'Security / Participation Integrity',
      estimatedHours: '70 hrs',
      estimatedLaborValue: r'$8,750',
      includes: [
        'participation eligibility rules',
        'duplicate participation boundaries',
        'verification-level architecture',
        'abuse-prevention planning',
        'security documentation',
      ],
    ),
    LaborCategorySummary(
      category: 'Public Transparency & Stewardship Infrastructure',
      estimatedHours: '65 hrs',
      estimatedLaborValue: r'$6,175',
      includes: [
        'public transparency pages',
        'sandbox disclaimers',
        'methodology visibility',
        'cost-of-operating documentation',
        'public stewardship framing',
      ],
    ),
  ];

  static const supportEntries = [
    PublicSupportEntry(
      supportType: 'ADA Support Address',
      amount: '[PLACEHOLDER ADA ADDRESS]',
      timestamp: 'May 16, 2026',
      message:
          'Support is treated as voluntary public stewardship of independent civic infrastructure.',
    ),
  ];

  static const operationalCosts = [
    OperationalCostEntry(
      category: 'Hosting',
      amount: r'$0.00 visible static demo cost',
      date: 'May 16, 2026',
      explanation:
          'The public demo is currently deployed as a static Firebase Hosting preview.',
    ),
    OperationalCostEntry(
      category: 'Domains',
      amount: r'$0.00 visible custom domain cost',
      date: 'May 16, 2026',
      explanation:
          'The demo currently uses the Firebase Hosting project URL instead of a custom domain.',
    ),
    OperationalCostEntry(
      category: 'APIs',
      amount: r'$0.00 visible API usage in static demo',
      date: 'May 16, 2026',
      explanation:
          'Static public pages use bundled sandbox data when a backend API is not deployed.',
    ),
    OperationalCostEntry(
      category: 'Infrastructure',
      amount: r'$0.00 visible public demo cost',
      date: 'May 16, 2026',
      explanation:
          'Backend infrastructure exists for local development, but the public demo does not require live database writes.',
    ),
    OperationalCostEntry(
      category: 'Software Services',
      amount: r'$0.00 visible public demo cost',
      date: 'May 16, 2026',
      explanation:
          'No paid software-service cost is currently published for the static demo.',
    ),
    OperationalCostEntry(
      category: 'Security',
      amount: r'$0.00 visible public demo cost',
      date: 'May 16, 2026',
      explanation:
          'Security architecture and eligibility rules are documented; live enforcement depends on backend deployment.',
    ),
    OperationalCostEntry(
      category: 'Design Tools',
      amount: r'$0.00 visible public demo cost',
      date: 'May 16, 2026',
      explanation:
          'The current public demo does not publish a separate paid design-tool cost.',
    ),
    OperationalCostEntry(
      category: 'Miscellaneous',
      amount: r'$0.00 visible public demo cost',
      date: 'May 16, 2026',
      explanation:
          'No additional published miscellaneous operating cost is listed for this demo snapshot.',
    ),
  ];

  static const comparisonArticles = [
    CivicComparisonArticle(
      title: 'Federal Marketplace Software Launches',
      summary:
          'Large public software systems often require policy coordination, engineering, hosting, vendor management, maintenance, and public communication at the same time.',
      publiclyReportedCost:
          'Public reports vary by program scope; GAO reviews have emphasized oversight, acquisition, and implementation risk rather than one simple software-only number.',
      timeline:
          'Public launch, remediation, and continuing operations occurred across multiple years.',
      transparencyObservations:
          'Public reporting can show that civic technology is not only code. It also includes governance, support, security, operations, and public trust work.',
      sourceLinks: [
        ComparisonSourceLink(
          label: 'GAO reports on HealthCare.gov and marketplace oversight',
          url: 'https://www.gao.gov/products/gao-15-238',
        ),
      ],
    ),
  ];
}
