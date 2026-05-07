import 'package:flutter/material.dart';

import '../routes/app_routes.dart';
import '../widgets/civic_layout.dart';
import '../widgets/metric_card.dart';
import '../widgets/primary_button.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CivicLayout(
      title: 'Civic Duty',
      subtitle:
          'An open-source civic measurement framework for reviewing public signals, confirming understanding, and preserving auditable records.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          PrimaryButton(
            label: 'Open Dashboard',
            icon: Icons.assessment_outlined,
            onPressed: () =>
                Navigator.of(context).pushNamed(AppRoutes.dashboard),
          ),
          const SizedBox(height: 24),
          const _ProcessOverview(),
          const SizedBox(height: 24),
          CivicPanel(
            children: [
              Text(
                'Open Civic Foundation',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Text(
                'This prototype uses mock data only. It demonstrates the Civic Duty flow before any authentication, database, or API layer is connected.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
          const SizedBox(height: 24),
          const MetricCardGroup(
            children: [
              MetricCard(
                label: 'Framework',
                value: '4 steps',
                description: 'Signal, review, ratify, and record.',
              ),
              MetricCard(
                label: 'Posture',
                value: 'Neutral',
                description: 'Measures participation without persuasion.',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ProcessOverview extends StatelessWidget {
  const _ProcessOverview();

  static const steps = [
    ('Signal', 'Capture civic pulse indicators.'),
    ('Review', 'Organize evidence-based dossiers.'),
    ('Ratify', 'Confirm understanding and record a position.'),
    ('Record', 'Generate public civic records.'),
  ];

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return CivicPanel(
      children: [
        Text(
          'Signal -> Review -> Ratify -> Record',
          style: textTheme.titleLarge,
        ),
        const SizedBox(height: 18),
        for (final step in steps) ...[
          Text(step.$1, style: textTheme.titleLarge),
          const SizedBox(height: 4),
          Text(step.$2, style: textTheme.bodyMedium),
          if (step != steps.last) const SizedBox(height: 14),
        ],
      ],
    );
  }
}
