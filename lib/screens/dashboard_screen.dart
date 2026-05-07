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
      title: 'Dashboard',
      subtitle: 'A static civic pulse view built from mock participation data.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          MetricCardGroup(
            mobileBreakpoint: 760,
            children: [
              MetricCard(
                label: 'Active dossier',
                value: '1',
                description: mockDossier.title,
              ),
              MetricCard(
                label: 'Participation',
                value: Formatters.compactNumber(
                  mockCivicRatificationRecord.totalParticipants,
                ),
                description: 'Mock participants in current review.',
              ),
              MetricCard(
                label: 'States represented',
                value: '${mockCivicRatificationRecord.statesRepresented}',
                description: 'State-calibrated sample coverage.',
              ),
            ],
          ),
          const SizedBox(height: 12),
          const MetricCardGroup(
            children: [
              MetricCard(
                label: 'Current status',
                value: 'Review',
                description:
                    'The active dossier is ready for participant review.',
              ),
              MetricCard(
                label: 'Record progress',
                value: 'Static',
                description: 'A mock CRR is available after ratification.',
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
