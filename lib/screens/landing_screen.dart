import 'package:flutter/material.dart';

import '../routes/app_routes.dart';
import '../widgets/civic_layout.dart';
import '../widgets/primary_button.dart';

class LandingScreen extends StatefulWidget {
  const LandingScreen({super.key});

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  void _openCivicReview() {
    Navigator.of(context).pushNamed(AppRoutes.dashboard);
  }

  @override
  Widget build(BuildContext context) {
    return CivicLayout(
      header: const CivicHeroHeader(),
      title: 'Civic Duty',
      subtitle:
          'A public civic review framework for understanding concerns, reviewing evidence, and recording measurable participation.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          PrimaryButton(
            label: 'Open Civic Review',
            icon: Icons.assessment_outlined,
            onPressed: _openCivicReview,
          ),
          const SizedBox(height: 34),
          const _SandboxDisclaimer(),
          const SizedBox(height: 30),
          const _WhatIsCivicDuty(),
          const SizedBox(height: 30),
          const _HowItWorks(),
          const SizedBox(height: 30),
          const _WhyThisExists(),
          const SizedBox(height: 30),
          _LandingActions(onOpenReview: _openCivicReview),
        ],
      ),
    );
  }
}

class _SandboxDisclaimer extends StatelessWidget {
  const _SandboxDisclaimer();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return CivicPanel(
      children: [
        Text(
          'Civic Duty Constitutional Review Sandbox',
          style: textTheme.titleLarge,
        ),
        const SizedBox(height: 10),
        Text(
          'This is a public civic review demonstration environment intended for constitutional review experimentation, methodology visibility, and participation flow testing.',
          style: textTheme.bodyMedium,
        ),
        const SizedBox(height: 10),
        Text(
          'The sandbox does not constitute governmental authority, legal adjudication, binding constitutional interpretation, or official public policy determination.',
          style: textTheme.bodyMedium,
        ),
      ],
    );
  }
}

class _LandingActions extends StatelessWidget {
  const _LandingActions({required this.onOpenReview});

  final VoidCallback onOpenReview;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return CivicPanel(
      children: [
        Text('Ready to Review?', style: textTheme.titleLarge),
        const SizedBox(height: 10),
        Text(
          'Start with the current civic review packet when you are ready.',
          style: textTheme.bodyMedium,
        ),
        const SizedBox(height: 18),
        PrimaryButton(
          label: 'Open Civic Review',
          icon: Icons.assessment_outlined,
          onPressed: onOpenReview,
        ),
      ],
    );
  }
}

class _WhatIsCivicDuty extends StatelessWidget {
  const _WhatIsCivicDuty();

  static const items = [
    'review organized civic concerns',
    'read supporting evidence',
    'confirm understanding',
    'record a position',
    'generate measurable public participation records',
  ];

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return CivicPanel(
      children: [
        Text('What Is Civic Duty?', style: textTheme.titleLarge),
        const SizedBox(height: 12),
        Text(
          'Civic Duty is a public review framework. It helps people review the same material, understand what is being asked, and record participation in a measured public process.',
          style: textTheme.bodyMedium,
        ),
        const SizedBox(height: 14),
        for (final item in items) ...[
          Text('- $item', style: textTheme.bodyMedium),
          if (item != items.last) const SizedBox(height: 6),
        ],
        const SizedBox(height: 14),
        Text(
          'The system does not replace government, courts, or elections. It exists to make public participation visible and measurable during foundational civic review.',
          style: textTheme.bodyMedium,
        ),
      ],
    );
  }
}

class _HowItWorks extends StatelessWidget {
  const _HowItWorks();

  static const steps = [
    (
      '01',
      'Open Review',
      'A civic review is opened around a clearly defined issue.',
    ),
    (
      '02',
      'Read the Dossier',
      'A dossier organizes the evidence, context, questions, and review boundaries into one readable packet.',
    ),
    (
      '03',
      'Confirm Understanding',
      'Participants confirm they reviewed the material before recording a position.',
    ),
    (
      '04',
      'Record Position',
      'Participants choose whether they ratify or do not ratify the review findings.',
    ),
    (
      '05',
      'Public Record',
      'Participation results are compiled into a public Civic Ratification Record.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return CivicPanel(
      children: [
        Text('How It Works', style: textTheme.titleLarge),
        const SizedBox(height: 16),
        for (final step in steps) ...[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 42,
                child: Text(step.$1, style: textTheme.titleMedium),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(step.$2, style: textTheme.titleLarge),
                    const SizedBox(height: 4),
                    Text(step.$3, style: textTheme.bodyMedium),
                  ],
                ),
              ),
            ],
          ),
          if (step != steps.last) const SizedBox(height: 18),
        ],
      ],
    );
  }
}

class _WhyThisExists extends StatelessWidget {
  const _WhyThisExists();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return CivicPanel(
      children: [
        Text('Why This Exists', style: textTheme.titleLarge),
        const SizedBox(height: 12),
        Text(
          'Modern public consensus is often interpreted indirectly through media, institutions, polling, and fragmented discourse.',
          style: textTheme.bodyMedium,
        ),
        const SizedBox(height: 10),
        Text(
          'Civic Duty creates a transparent participation layer where people can review the same material, confirm understanding, and record a position through a structured public process.',
          style: textTheme.bodyMedium,
        ),
      ],
    );
  }
}
