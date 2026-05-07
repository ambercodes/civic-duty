import 'package:flutter/material.dart';

import '../routes/app_routes.dart';
import '../widgets/civic_layout.dart';
import '../widgets/metric_card.dart';
import '../widgets/primary_button.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CivicLayout(
      title: 'Dashboard',
      subtitle:
          'A placeholder civic pulse view for future state-level metrics.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              SizedBox(
                width: 260,
                child: MetricCard(label: 'Signals', value: 'Pending'),
              ),
              SizedBox(
                width: 260,
                child: MetricCard(label: 'States', value: 'Pending'),
              ),
              SizedBox(
                width: 260,
                child: MetricCard(label: 'Records', value: 'Pending'),
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
