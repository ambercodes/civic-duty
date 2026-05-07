import 'package:flutter/material.dart';

import '../routes/app_routes.dart';
import '../theme/app_theme.dart';
import '../widgets/civic_layout.dart';
import '../widgets/metric_card.dart';
import '../widgets/primary_button.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CivicLayout(
      header: const _HeroHeader(),
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
          const SizedBox(height: 34),
          const _ProcessOverview(),
          const SizedBox(height: 30),
          CivicPanel(
            children: [
              Text(
                'Open Civic Foundation',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 12),
              Text(
                'This prototype uses mock data only. It demonstrates the Civic Duty flow before any authentication, database, or API layer is connected.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
          const SizedBox(height: 30),
          const MetricCardGroup(
            spacing: 16,
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

class _HeroHeader extends StatelessWidget {
  const _HeroHeader();

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.sizeOf(context).width < 640;

    return IgnorePointer(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: SizedBox(
          width: double.infinity,
          height: isMobile ? 190 : 300,
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.asset(
                'assets/images/we_the_people_hero.jpg',
                fit: BoxFit.cover,
                alignment: isMobile ? Alignment.centerLeft : Alignment.center,
              ),
              DecoratedBox(
                decoration: BoxDecoration(
                  color: AppTheme.offWhite.withValues(alpha: 0.08),
                ),
              ),
            ],
          ),
        ),
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
