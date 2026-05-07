import 'package:flutter/material.dart';

import '../mock/mock_civic_data.dart';
import '../routes/app_routes.dart';
import '../widgets/civic_layout.dart';
import '../widgets/primary_button.dart';

class DossierScreen extends StatelessWidget {
  const DossierScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return CivicLayout(
      title: mockDossier.title,
      subtitle: mockDossier.summary,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CivicPanel(
            children: [
              Text('Review Details', style: textTheme.titleLarge),
              const SizedBox(height: 12),
              _DetailRow(label: 'Version', value: mockDossier.version),
              _DetailRow(label: 'Date', value: mockDossier.publishedDate),
              _DetailRow(
                label: 'Estimated reading time',
                value: '${mockDossier.estimatedReadingMinutes} minutes',
              ),
              const SizedBox(height: 16),
              Text('Scope', style: textTheme.titleLarge),
              const SizedBox(height: 8),
              Text(mockDossier.scope, style: textTheme.bodyMedium),
            ],
          ),
          const SizedBox(height: 18),
          CivicPanel(
            children: [
              Text('Evidence List', style: textTheme.titleLarge),
              const SizedBox(height: 12),
              for (final item in mockDossier.evidenceItems) ...[
                Text('${item.id}: ${item.title}', style: textTheme.titleMedium),
                const SizedBox(height: 4),
                Text(item.source, style: textTheme.bodyMedium),
                const SizedBox(height: 4),
                Text(item.summary, style: textTheme.bodyMedium),
                if (item != mockDossier.evidenceItems.last)
                  const Divider(height: 24),
              ],
            ],
          ),
          const SizedBox(height: 18),
          CivicPanel(
            children: [
              Text('Questions Under Review', style: textTheme.titleLarge),
              const SizedBox(height: 12),
              for (final question in mockDossier.questions) ...[
                Text('- $question', style: textTheme.bodyMedium),
                if (question != mockDossier.questions.last)
                  const SizedBox(height: 8),
              ],
            ],
          ),
          const SizedBox(height: 24),
          PrimaryButton(
            label: 'Confirm Review',
            icon: Icons.check_circle_outline,
            onPressed: () =>
                Navigator.of(context).pushNamed(AppRoutes.confirmReview),
          ),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 150,
            child: Text(label, style: textTheme.titleMedium),
          ),
          Expanded(child: Text(value, style: textTheme.bodyMedium)),
        ],
      ),
    );
  }
}
