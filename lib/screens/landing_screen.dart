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
          'A neutral civic measurement framework for reviewing public signals, ratifying participation, and preserving auditable records.',
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
          const Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              SizedBox(
                width: 280,
                child: MetricCard(
                  label: 'Framework',
                  value: '4 steps',
                  description: 'Signal, review, ratify, and record.',
                ),
              ),
              SizedBox(
                width: 280,
                child: MetricCard(
                  label: 'Posture',
                  value: 'Neutral',
                  description: 'Measures participation without persuasion.',
                ),
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
    ('Review', 'Organize dossiers and evidence.'),
    ('Ratify', 'Confirm participation by state.'),
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
          Text(step.$1, style: textTheme.titleMedium),
          const SizedBox(height: 4),
          Text(step.$2, style: textTheme.bodyMedium),
          if (step != steps.last) const SizedBox(height: 14),
        ],
      ],
    );
  }
}
