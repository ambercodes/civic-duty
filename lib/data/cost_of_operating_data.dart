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
      title: 'Cost Comparison: HealthCare.gov',
      summary:
          'HealthCare.gov is a useful public comparison because it demonstrates how large public-facing civic software systems can become expensive, operationally complex, and difficult for ordinary people to inspect in real time.',
      purpose:
          'The purpose of this comparison is not partisan criticism. It is to examine how public software costs, contractor structures, management visibility, and transparency practices affect public trust and civic accountability.',
      costRows: [
        ComparisonCostRow(
          item: 'CGI Federal initial base contract',
          amount: r'~$55.7 million',
        ),
        ComparisonCostRow(
          item: 'CGI Federal total possible contract value',
          amount: r'~$93.7 million',
        ),
        ComparisonCostRow(
          item: 'Later reported CGI-related increase',
          amount: r'~$292 million',
        ),
        ComparisonCostRow(
          item: 'HHS OIG 60-contract review',
          amount:
              r'nearly $800 million obligated; nearly $500 million expended as of Feb. 2014',
        ),
        ComparisonCostRow(
          item: 'HHS OIG estimated total contract value',
          amount: r'~$1.7 billion',
        ),
        ComparisonCostRow(
          item: 'Bloomberg Government broader estimate',
          amount: r'~$2.1 billion',
        ),
      ],
      costGrowthNote: [
        'The original CGI Federal contract was announced in 2011 with a two-year base value of approximately \$55.7 million and a total possible contract value of approximately \$93.7 million.',
        'As the project expanded, publicly reported costs increased substantially through additional contractors, integrations, operational requirements, and remediation efforts.',
      ],
      intendedToSupport: [
        'federal health insurance enrollment',
        'account creation',
        'identity verification',
        'subsidy eligibility determination',
        'insurer integrations',
        'federal database connections',
        'public insurance marketplace participation',
      ],
      requiredComplexity: [
        'large-scale infrastructure',
        'multi-agency interoperability',
        'contractor coordination',
        'significant operational complexity',
      ],
      publicVisibilityConcerns: [
        'how budgets expanded over time',
        'how many contractors were involved',
        'what software methodologies were being used',
        'how management decisions were made',
        'what testing standards existed prior to launch',
        'how risks were evaluated',
        'how public funding translated into measurable software outcomes',
      ],
      publicReviewsIdentified: [
        'planning deficiencies',
        'oversight problems',
        'compressed testing timelines',
        'contractor coordination difficulties',
      ],
      civicDutyQuestion:
          'If public-facing civic software is funded by the public, how visible should its labor, costs, methods, architecture, development structure, and operational stewardship be?',
      civicDutyApproach: [
        'open-source development',
        'visible project phases',
        'readable methodology',
        'public civic records',
        'cost-of-operating visibility',
        'equivalent labor transparency',
      ],
      closingNotes: [
        'This does not suggest that independent software projects can replace large institutional systems.',
        'It demonstrates that the public should be able to compare different models of software development, operational transparency, civic visibility, and public accountability.',
      ],
      sourceLinks: [
        ComparisonSourceLink(
          label:
              'CGI - CGI selected to build U.S.-wide competitive health insurance exchange',
          url:
              'https://www.cgi.com/en/CGI-selected-build-US-wide-competitive-health-insurance-exchange',
        ),
        ComparisonSourceLink(
          label:
              'HHS OIG - An Overview of 60 Contracts That Contributed to the Development and Operation of the Federal Marketplace',
          url:
              'https://oig.hhs.gov/reports/all/2014/an-overview-of-60-contracts-that-contributed-to-the-development-and-operation-of-the-federal-marketplace/',
        ),
        ComparisonSourceLink(
          label:
              'Bloomberg Government - Obamacare Website Costs Exceed \$2 Billion, Study Finds',
          url:
              'https://www.bloomberg.com/news/articles/2014-09-24/obamacare-website-costs-exceed-2-billion-study-finds',
        ),
        ComparisonSourceLink(
          label:
              'TIME - Report: Cost of HealthCare.Gov Approaching \$1 Billion',
          url: 'https://time.com/3060276/obamacare-affordable-care-act-cost/',
        ),
        ComparisonSourceLink(
          label:
              'GAO - Healthcare.gov: Ineffective Planning and Oversight Practices Underscore the Need for Improved Contract Management',
          url: 'https://www.gao.gov/products/gao-14-694',
        ),
      ],
    ),
    CivicComparisonArticle(
      title:
          'Cost Comparison: VA Electronic Health Record Modernization (EHRM)',
      summary:
          'The Department of Veterans Affairs Electronic Health Record Modernization initiative is another example of large-scale public civic software infrastructure that experienced major cost growth, operational complexity, deployment delays, and public oversight concerns.',
      purpose:
          'The purpose of this comparison is not partisan criticism. It is to examine how public-facing institutional software systems can become difficult for ordinary citizens to visibly inspect as operational scale, contractor ecosystems, and governance complexity increase.',
      costRows: [
        ComparisonCostRow(
          item: 'Original VA modernization estimate (2019)',
          amount: r'~$16.1 billion',
        ),
        ComparisonCostRow(
          item: 'Original Cerner contract (2018)',
          amount: r'nearly $10 billion',
        ),
        ComparisonCostRow(
          item: 'Infrastructure + program management estimate',
          amount: r'~$6.1 billion',
        ),
        ComparisonCostRow(
          item: 'Independent Institute for Defense Analyses estimate (2022)',
          amount: r'~$49.8 billion',
        ),
        ComparisonCostRow(
          item: '13-year implementation estimate',
          amount: r'~$32.7 billion',
        ),
        ComparisonCostRow(
          item: '15-year sustainment estimate',
          amount: r'~$17.1 billion',
        ),
        ComparisonCostRow(
          item:
              'Remaining VA medical centers still not deployed as of mid-2026',
          amount: '~160 centers (94%)',
        ),
      ],
      costGrowthNote: [
        'As implementation expanded, publicly reported cost projections increased substantially due to infrastructure complexity, interoperability challenges, deployment delays, operational remediation, contractor coordination, and long-term maintenance requirements.',
        'Public oversight reports also identified approximately 1,800 unresolved complex configuration change requests as of February 2025, deployment pauses, user dissatisfaction, schedule uncertainty, interoperability challenges, and concerns surrounding long-term lifecycle cost visibility.',
        'GAO testimony noted that existing cost estimates did not fully reflect delays, deployment pauses, operational changes, or updated implementation realities.',
      ],
      intendedToSupport: [
        'patient medical records',
        'provider workflows',
        'federal interoperability systems',
        'healthcare infrastructure modernization',
        'scheduling systems',
        'prescription systems',
        'large-scale data integration across healthcare environments',
      ],
      requiredComplexity: [
        'multiple agencies',
        'contractor coordination',
        'federal healthcare environments',
        'large-scale operational deployment',
        'long-term sustainment requirements',
      ],
      publicVisibilityConcerns: [
        'how technical decisions were being made',
        'how deployment risks were evaluated',
        'how contractor accountability was structured',
        'how costs continued to expand',
        'how timelines were adjusted',
        'how operational governance decisions translated into measurable public outcomes',
      ],
      publicReviewsIdentified: [
        'deployment pauses',
        'operational failures',
        'interoperability concerns',
        'governance and oversight problems',
        'patient safety concerns',
        'implementation delays',
        'incomplete updated lifecycle cost estimates',
        'incomplete integrated scheduling years into deployment',
      ],
      civicDutyQuestion:
          'How visible should the operational structure, methodology, costs, labor, and accountability systems of publicly impactful civic software be to ordinary citizens?',
      civicDutyApproach: [
        'open-source development',
        'visible methodology',
        'readable civic architecture',
        'public participation systems',
        'operational visibility',
        'equivalent labor transparency',
      ],
      closingNotes: [
        'This comparison is not intended to suggest that independent civic projects can replace large institutional healthcare systems.',
        'It demonstrates that different models of software development, visibility, accountability, and operational stewardship can be publicly compared and examined.',
        'Public reports repeatedly emphasized that updated lifecycle cost estimates and integrated scheduling were still incomplete years into deployment.',
        'This created situations where ordinary citizens, oversight bodies, and even lawmakers were attempting to evaluate large-scale public software modernization efforts without fully updated operational visibility into total lifecycle cost, implementation timelines, deployment realities, or ongoing sustainment requirements.',
      ],
      sourceLinks: [
        ComparisonSourceLink(
          label:
              'GAO - Electronic Health Records: VA Making Incremental Improvements in New System but Needs Updated Cost Estimate and Schedule',
          url: 'https://www.gao.gov/products/gao-25-106874',
        ),
        ComparisonSourceLink(
          label: 'GAO Testimony - VA Electronic Health Record Modernization',
          url:
              'https://www.gao.gov/video/testimony-va-electronic-health-record-modernization-0',
        ),
        ComparisonSourceLink(
          label:
              'Associated Press - VA electronic health records overhaul faces mounting costs and delays',
          url:
              'https://apnews.com/article/veterans-affairs-electronic-health-record-oracle-3b6f5f0d0f6b4fd2d9c4b2a5c71cb9db',
        ),
        ComparisonSourceLink(
          label:
              'VA Office of Inspector General - Unreliable Information Technology Infrastructure Cost Estimates for the Electronic Health Record Modernization Program',
          url:
              'https://www.vaoig.gov/sites/default/files/reports/2021-07/VAOIG-20-03185-151.pdf',
        ),
      ],
    ),
  ];
}
