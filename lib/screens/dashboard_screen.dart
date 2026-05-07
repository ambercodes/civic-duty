import 'package:flutter/material.dart';

import '../mock/mock_civic_data.dart';
import '../routes/app_routes.dart';
import '../utils/formatters.dart';
import '../widgets/civic_layout.dart';
import '../widgets/metric_card.dart';
import '../widgets/primary_button.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CivicLayout(
      title: 'Civic Review Dashboard',
      subtitle:
          'This page shows the current review, how many people are represented in the mock data, and what to do next.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CivicPanel(
            children: [
              Text(
                mockDossier.title,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Text(
                'Status: Open for Review',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 12),
              Text(
                'This review asks participants to read a short public packet, understand the question being reviewed, and record a position. The data shown here is mock data for the static prototype.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
          const SizedBox(height: 20),
          MetricCardGroup(
            mobileBreakpoint: 760,
            children: [
              MetricCard(
                label: 'Participants',
                value: Formatters.compactNumber(
                  mockCivicRatificationRecord.totalParticipants,
                ),
                description: 'People included in this mock review count.',
              ),
              MetricCard(
                label: 'States Represented',
                value: '${mockCivicRatificationRecord.statesRepresented}',
                description: 'States included in the current mock record.',
              ),
              const MetricCard(
                label: 'Review Status',
                value: 'Open',
                description: 'The public review packet is ready to read.',
              ),
            ],
          ),
          const SizedBox(height: 12),
          const MetricCardGroup(
            children: [
              MetricCard(
                label: 'Reading Progress',
                value: 'Not Started',
                description:
                    'Start with the dossier before recording a position.',
              ),
            ],
          ),
          const SizedBox(height: 24),
          PrimaryButton(
            label: 'Review Dossier',
            icon: Icons.description_outlined,
            onPressed: () => Navigator.of(context).pushNamed(AppRoutes.dossier),
          ),
        ],
      ),
    );
  }
}
