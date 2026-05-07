import 'package:flutter/material.dart';

import '../mock/mock_civic_data.dart';
import '../routes/app_routes.dart';
import '../widgets/civic_layout.dart';
import '../widgets/primary_button.dart';

class RatificationScreen extends StatefulWidget {
  const RatificationScreen({super.key});

  @override
  State<RatificationScreen> createState() => _RatificationScreenState();
}

class _RatificationScreenState extends State<RatificationScreen> {
  String? selectedOutcome;

  void _selectOutcome(String outcome) {
    setState(() {
      selectedOutcome = outcome;
    });
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return CivicLayout(
      title: 'Ratification',
      subtitle:
          'Record a mock civic position after review confirmation. No backend submission occurs.',
      child: CivicPanel(
        children: [
          Text('Question Under Review', style: textTheme.titleLarge),
          const SizedBox(height: 10),
          Text(mockDossier.questions.last, style: textTheme.bodyMedium),
          const SizedBox(height: 18),
          Text('Select a position', style: textTheme.titleLarge),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              FilledButton.icon(
                onPressed: () => _selectOutcome('Ratified'),
                icon: const Icon(Icons.check_circle_outline),
                label: const Text('Ratify'),
              ),
              OutlinedButton.icon(
                onPressed: () => _selectOutcome('Not Ratified'),
                icon: const Icon(Icons.cancel_outlined),
                label: const Text('Not Ratify'),
              ),
            ],
          ),
          if (selectedOutcome != null) ...[
            const SizedBox(height: 18),
            Text(
              'Mock selection recorded: $selectedOutcome. This position is held locally for demonstration only.',
              style: textTheme.bodyMedium,
            ),
          ],
          const SizedBox(height: 22),
          PrimaryButton(
            label: 'View Civic Ratification Record',
            icon: Icons.fact_check_outlined,
            onPressed: selectedOutcome == null
                ? null
                : () => Navigator.of(context).pushNamed(AppRoutes.record),
          ),
        ],
      ),
    );
  }
}
