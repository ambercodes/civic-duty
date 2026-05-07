import 'package:flutter/material.dart';

import '../routes/app_routes.dart';
import '../widgets/civic_layout.dart';
import '../widgets/primary_button.dart';

class RatificationScreen extends StatelessWidget {
  const RatificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return CivicLayout(
      title: 'Ratification',
      subtitle:
          'A placeholder flow for confirming read status and civic participation.',
      child: CivicPanel(
        children: [
          Text('Ratification Status', style: textTheme.titleLarge),
          const SizedBox(height: 10),
          Text(
            'This phase will later collect typed confirmations and state-calibrated participation outcomes.',
            style: textTheme.bodyMedium,
          ),
          const SizedBox(height: 20),
          PrimaryButton(
            label: 'View Record',
            icon: Icons.fact_check_outlined,
            onPressed: () => Navigator.of(context).pushNamed(AppRoutes.record),
          ),
        ],
      ),
    );
  }
}
