import 'package:flutter/material.dart';

import '../../models/foundational_concern.dart';
import '../../services/concern_service.dart';
import '../../widgets/civic_layout.dart';

class ConcernThresholdStatusScreen extends StatelessWidget {
  const ConcernThresholdStatusScreen({
    super.key,
    required this.concernIdOrSlug,
  });

  final String concernIdOrSlug;

  @override
  Widget build(BuildContext context) {
    return CivicLayout(
      title: 'Threshold Status',
      subtitle:
          'Substantial Signal requires 0.10% of state CVAP across at least 10 states within 90 days.',
      child: FutureBuilder<ConcernThresholdStatus>(
        future: ConcernService().getThreshold(concernIdOrSlug),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError || !snapshot.hasData) {
            return const CivicPanel(
              children: [Text('Threshold status could not be loaded.')],
            );
          }
          final threshold = snapshot.data!;
          return CivicPanel(
            children: [
              Text(
                threshold.thresholdMet
                    ? 'Threshold met'
                    : 'Threshold not met yet',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 12),
              Text(
                '${threshold.statesMeetingThreshold} of ${threshold.requiredStates} required states currently meet the signal threshold.',
              ),
              const SizedBox(height: 8),
              Text(
                'Required threshold: ${threshold.requiredPercent.toStringAsFixed(2)}% of state citizen voting-age population.',
              ),
              Text('Signal window: ${threshold.signalWindowDays} days.'),
            ],
          );
        },
      ),
    );
  }
}
