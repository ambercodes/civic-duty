import 'package:flutter/material.dart';

import '../../models/foundational_concern.dart';
import '../../routes/app_routes.dart';
import '../../services/concern_service.dart';
import '../../widgets/civic_layout.dart';
import '../../widgets/primary_button.dart';

class ConcernDetailScreen extends StatefulWidget {
  const ConcernDetailScreen({super.key, required this.concernIdOrSlug});

  final String concernIdOrSlug;

  @override
  State<ConcernDetailScreen> createState() => _ConcernDetailScreenState();
}

class _ConcernDetailScreenState extends State<ConcernDetailScreen> {
  late Future<FoundationalConcern> _concernFuture = ConcernService().getConcern(
    widget.concernIdOrSlug,
  );
  bool viewedSummary = false;
  bool viewedScope = false;
  bool viewedEvidence = false;
  bool confirmedSignalMeaning = false;
  bool isSubmitting = false;
  String? message;

  bool get canSignal =>
      viewedSummary &&
      viewedScope &&
      viewedEvidence &&
      confirmedSignalMeaning &&
      !isSubmitting;

  Future<void> _signal() async {
    setState(() {
      isSubmitting = true;
      message = null;
    });
    try {
      await ConcernService().signalConcern(widget.concernIdOrSlug);
      setState(() {
        _concernFuture = ConcernService().getConcern(widget.concernIdOrSlug);
        message = 'Signal recorded.';
        isSubmitting = false;
      });
    } catch (error) {
      setState(() {
        message = error.toString().contains('DUPLICATE_PARTICIPATION')
            ? 'You have already signaled this concern.'
            : 'Signal could not be recorded.';
        isSubmitting = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<FoundationalConcern>(
      future: _concernFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CivicLayout(
            title: 'Loading Concern',
            child: Center(child: CircularProgressIndicator()),
          );
        }
        if (snapshot.hasError || !snapshot.hasData) {
          return const CivicLayout(
            title: 'Concern Unavailable',
            child: CivicPanel(
              children: [Text('The concern could not be loaded.')],
            ),
          );
        }
        final concern = snapshot.data!;
        final textTheme = Theme.of(context).textTheme;

        return CivicLayout(
          title: concern.title,
          subtitle:
              'Supporting a concern means you believe it deserves organized public review.',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CivicPanel(
                children: [
                  Text('Summary', style: textTheme.titleLarge),
                  const SizedBox(height: 8),
                  Text(concern.plainLanguageSummary),
                  const SizedBox(height: 10),
                  Text('Domain: ${concern.reviewDomain}'),
                  Text('Status: ${concern.status}'),
                  Text('Signals: ${concern.signalCount}'),
                ],
              ),
              const SizedBox(height: 16),
              CivicPanel(
                children: [
                  Text('Issue Statement', style: textTheme.titleLarge),
                  const SizedBox(height: 8),
                  Text(concern.issueStatement),
                  const SizedBox(height: 14),
                  Text('Why This Review Matters', style: textTheme.titleLarge),
                  const SizedBox(height: 8),
                  Text(concern.whyReviewMatters),
                  const SizedBox(height: 14),
                  Text('Review Question', style: textTheme.titleLarge),
                  const SizedBox(height: 8),
                  Text(concern.proposedReviewQuestion),
                ],
              ),
              const SizedBox(height: 16),
              CivicPanel(
                children: [
                  Text('Scope And Evidence', style: textTheme.titleLarge),
                  const SizedBox(height: 8),
                  Text(concern.participationBoundaries),
                  const Divider(height: 24),
                  for (final item in concern.evidence) ...[
                    Text(item.title, style: textTheme.titleMedium),
                    Text(item.url),
                    if (item.description != null) Text(item.description!),
                    const SizedBox(height: 10),
                  ],
                  if (concern.externalEvidenceUrl != null)
                    Text('External folder: ${concern.externalEvidenceUrl}'),
                ],
              ),
              const SizedBox(height: 16),
              CivicPanel(
                children: [
                  Text('Signal Integrity Check', style: textTheme.titleLarge),
                  CheckboxListTile(
                    value: viewedSummary,
                    onChanged: (value) =>
                        setState(() => viewedSummary = value ?? false),
                    title: const Text('I opened and read the summary.'),
                  ),
                  CheckboxListTile(
                    value: viewedScope,
                    onChanged: (value) =>
                        setState(() => viewedScope = value ?? false),
                    title: const Text('I viewed the domain and scope.'),
                  ),
                  CheckboxListTile(
                    value: viewedEvidence,
                    onChanged: (value) =>
                        setState(() => viewedEvidence = value ?? false),
                    title: const Text('I viewed the evidence section.'),
                  ),
                  CheckboxListTile(
                    value: confirmedSignalMeaning,
                    onChanged: (value) =>
                        setState(() => confirmedSignalMeaning = value ?? false),
                    title: const Text(
                      'I understand signal means warrants review, not final agreement.',
                    ),
                  ),
                  if (message != null) Text(message!),
                  const SizedBox(height: 12),
                  PrimaryButton(
                    label: isSubmitting
                        ? 'Recording...'
                        : 'This Concern Warrants Structured Civic Review',
                    icon: Icons.how_to_vote_outlined,
                    onPressed: canSignal ? _signal : null,
                  ),
                  const SizedBox(height: 12),
                  OutlinedButton.icon(
                    onPressed: () => Navigator.of(context).pushNamed(
                      '${AppRoutes.concernThreshold}/${concern.slug}',
                    ),
                    icon: const Icon(Icons.query_stats_outlined),
                    label: const Text('View Threshold Status'),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
