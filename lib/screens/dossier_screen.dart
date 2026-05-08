import 'package:flutter/material.dart';

import '../mock/mock_civic_data.dart';
import '../models/evidence_item.dart';
import '../models/dossier.dart';
import '../routes/app_routes.dart';
import '../services/dossier_service.dart';
import '../widgets/civic_layout.dart';
import '../widgets/primary_button.dart';

class DossierScreen extends StatefulWidget {
  const DossierScreen({super.key});

  @override
  State<DossierScreen> createState() => _DossierScreenState();
}

class _DossierScreenState extends State<DossierScreen> {
  late final Future<Dossier> _dossierFuture = DossierService()
      .getDossier('foundational-consent-civic-review')
      .catchError((_) => mockDossier);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Dossier>(
      future: _dossierFuture,
      builder: (context, snapshot) {
        final dossier = snapshot.data ?? mockDossier;
        return _DossierContent(dossier: dossier);
      },
    );
  }
}

class _DossierContent extends StatelessWidget {
  const _DossierContent({required this.dossier});

  final Dossier dossier;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return CivicLayout(
      title: dossier.title,
      subtitle:
          'This is the public review packet for the current civic review.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CivicPanel(
            children: [
              Text('What Is This Dossier?', style: textTheme.titleLarge),
              const SizedBox(height: 12),
              Text(
                'This dossier is a structured review packet. It gathers the issue being reviewed, supporting evidence, participation boundaries, and the question participants are being asked to consider before recording a position.',
                style: textTheme.bodyMedium,
              ),
              const SizedBox(height: 16),
              _DetailRow(label: 'Version', value: dossier.version),
              _DetailRow(label: 'Date', value: dossier.publishedDate),
              _DetailRow(
                label: 'Reading time',
                value: '${dossier.estimatedReadingMinutes} minutes',
              ),
            ],
          ),
          const SizedBox(height: 18),
          CivicPanel(
            children: [
              Text('What You Are Reviewing', style: textTheme.titleLarge),
              const SizedBox(height: 12),
              Text(dossier.summary, style: textTheme.bodyMedium),
              const SizedBox(height: 12),
              Text(dossier.scope, style: textTheme.bodyMedium),
            ],
          ),
          const SizedBox(height: 18),
          CivicPanel(
            children: [
              Text('Why This Matters', style: textTheme.titleLarge),
              const SizedBox(height: 12),
              Text(
                'A civic review works best when people are looking at the same material and answering the same question. The evidence below is gathered so participation can be based on shared reading instead of scattered impressions.',
                style: textTheme.bodyMedium,
              ),
              const SizedBox(height: 12),
              Text(
                'Your role in this prototype is simple: read the packet, confirm understanding, and then record whether you ratify or do not ratify the review finding.',
                style: textTheme.bodyMedium,
              ),
            ],
          ),
          const SizedBox(height: 18),
          CivicPanel(
            children: [
              Text('Evidence & Reading Material', style: textTheme.titleLarge),
              const SizedBox(height: 12),
              Text(
                'These static items stand in for future PDFs, data files, articles, documents, and external sources.',
                style: textTheme.bodyMedium,
              ),
              const SizedBox(height: 18),
              for (final item in dossier.evidenceItems) ...[
                _EvidenceCard(item: item),
                if (item != dossier.evidenceItems.last)
                  const SizedBox(height: 14),
              ],
            ],
          ),
          const SizedBox(height: 18),
          CivicPanel(
            children: [
              Text('Question Under Review', style: textTheme.titleLarge),
              const SizedBox(height: 12),
              Text(
                'After reviewing the material above, participants are being asked to consider the following question:',
                style: textTheme.bodyMedium,
              ),
              const SizedBox(height: 12),
              Text(dossier.questions.first, style: textTheme.titleLarge),
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

class _EvidenceCard extends StatelessWidget {
  const _EvidenceCard({required this.item});

  final EvidenceItem item;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(item.title, style: textTheme.titleLarge),
            const SizedBox(height: 6),
            Text(item.source, style: textTheme.titleMedium),
            const SizedBox(height: 12),
            Text(item.summary, style: textTheme.bodyMedium),
            const SizedBox(height: 10),
            Text('Why it matters', style: textTheme.titleMedium),
            const SizedBox(height: 4),
            Text(item.whyItMatters, style: textTheme.bodyMedium),
            const SizedBox(height: 14),
            OutlinedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      '${item.actionLabel} is a static prototype action.',
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.article_outlined),
              label: Text(item.actionLabel),
            ),
          ],
        ),
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
            width: 120,
            child: Text(label, style: textTheme.titleMedium),
          ),
          Expanded(child: Text(value, style: textTheme.bodyMedium)),
        ],
      ),
    );
  }
}
