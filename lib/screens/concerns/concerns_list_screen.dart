import 'package:flutter/material.dart';

import '../../models/foundational_concern.dart';
import '../../routes/app_routes.dart';
import '../../services/concern_service.dart';
import '../../widgets/civic_layout.dart';
import '../../widgets/primary_button.dart';

class ConcernsListScreen extends StatefulWidget {
  const ConcernsListScreen({super.key});

  @override
  State<ConcernsListScreen> createState() => _ConcernsListScreenState();
}

class _ConcernsListScreenState extends State<ConcernsListScreen> {
  late final Future<List<FoundationalConcern>> _concernsFuture =
      ConcernService().listConcerns();

  @override
  Widget build(BuildContext context) {
    return CivicLayout(
      title: 'Foundational Concerns',
      subtitle:
          'A foundational concern is a structured issue submitted for possible civic review.',
      child: FutureBuilder<List<FoundationalConcern>>(
        future: _concernsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final concerns = snapshot.data ?? const <FoundationalConcern>[];
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              PrimaryButton(
                label: 'Submit Foundational Concern',
                icon: Icons.add_circle_outline,
                onPressed: () =>
                    Navigator.of(context).pushNamed(AppRoutes.submitConcern),
              ),
              const SizedBox(height: 18),
              for (final concern in concerns) ...[
                _ConcernCard(concern: concern),
                const SizedBox(height: 14),
              ],
              if (concerns.isEmpty)
                const CivicPanel(
                  children: [
                    Text('No foundational concerns are open right now.'),
                  ],
                ),
            ],
          );
        },
      ),
    );
  }
}

class _ConcernCard extends StatelessWidget {
  const _ConcernCard({required this.concern});

  final FoundationalConcern concern;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return CivicPanel(
      children: [
        Text(concern.title, style: textTheme.titleLarge),
        const SizedBox(height: 8),
        Text(concern.plainLanguageSummary, style: textTheme.bodyMedium),
        const SizedBox(height: 10),
        Text('Domain: ${concern.reviewDomain}', style: textTheme.titleMedium),
        Text('Signals: ${concern.signalCount}', style: textTheme.bodyMedium),
        const SizedBox(height: 14),
        OutlinedButton.icon(
          onPressed: () => Navigator.of(
            context,
          ).pushNamed('${AppRoutes.concerns}/${concern.slug}'),
          icon: const Icon(Icons.visibility_outlined),
          label: const Text('View Concern'),
        ),
      ],
    );
  }
}
