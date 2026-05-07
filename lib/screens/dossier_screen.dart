import 'package:flutter/material.dart';

import '../routes/app_routes.dart';
import '../widgets/civic_layout.dart';
import '../widgets/primary_button.dart';

class DossierScreen extends StatelessWidget {
  const DossierScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return CivicLayout(
      title: 'Dossier',
      subtitle:
          'A structured placeholder for evidence, methodology, and review notes.',
      child: CivicPanel(
        children: [
          Text('Evidence Index', style: textTheme.titleLarge),
          const SizedBox(height: 10),
          Text(
            'Future dossiers will organize source material, participation rules, and review status without coupling the UI to a backend provider.',
            style: textTheme.bodyMedium,
          ),
          const SizedBox(height: 20),
          PrimaryButton(
            label: 'Continue to Ratification',
            icon: Icons.how_to_vote_outlined,
            onPressed: () => Navigator.of(context).pushNamed(AppRoutes.ratify),
          ),
        ],
      ),
    );
  }
}
