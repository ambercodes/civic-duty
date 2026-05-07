import 'package:flutter/material.dart';

import '../routes/app_routes.dart';
import '../widgets/civic_layout.dart';
import '../widgets/primary_button.dart';

class RecordScreen extends StatelessWidget {
  const RecordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return CivicLayout(
      title: 'Public Record',
      subtitle: 'A placeholder for auditable civic ratification records.',
      child: CivicPanel(
        children: [
          Text('Record Components', style: textTheme.titleLarge),
          const SizedBox(height: 10),
          Text(
            'Records will include version, timestamp, methodology, participation counts, state breakdown, evidence index, and ratification outcome.',
            style: textTheme.bodyMedium,
          ),
          const SizedBox(height: 20),
          PrimaryButton(
            label: 'Return Home',
            icon: Icons.home_outlined,
            onPressed: () => Navigator.of(context).pushNamed(AppRoutes.landing),
          ),
        ],
      ),
    );
  }
}
