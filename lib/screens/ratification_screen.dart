import 'package:flutter/material.dart';

import '../models/dossier.dart';
import '../routes/app_routes.dart';
import '../services/dossier_service.dart';
import '../services/participation_service.dart';
import '../services/ratification_service.dart';
import '../widgets/civic_layout.dart';
import '../widgets/primary_button.dart';

class RatificationScreen extends StatefulWidget {
  const RatificationScreen({
    super.key,
    this.dossierIdOrSlug = 'foundational-consent-civic-review',
  });

  final String dossierIdOrSlug;

  @override
  State<RatificationScreen> createState() => _RatificationScreenState();
}

class _RatificationScreenState extends State<RatificationScreen> {
  late final Future<Dossier> _dossierFuture = DossierService().getDossier(
    widget.dossierIdOrSlug,
  );
  final Map<String, String> _provisionResponses = {};
  String? selectedOutcome;
  bool isSubmitting = false;
  String? message;

  void _selectOutcome(String outcome) {
    setState(() {
      selectedOutcome = outcome;
    });
  }

  Future<void> _submit(Dossier dossier) async {
    final outcome = selectedOutcome;
    if (outcome == null) {
      return;
    }

    setState(() {
      isSubmitting = true;
      message = null;
    });

    try {
      for (final provision in dossier.provisions) {
        final response = _provisionResponses[provision.id];
        if (response != null) {
          await ParticipationService().respondToProvision(
            provisionId: provision.id,
            position: response,
          );
        }
      }

      if (outcome == 'ratify') {
        await RatificationService().ratify(dossier.slug ?? dossier.id);
      } else {
        await RatificationService().doNotRatify(dossier.slug ?? dossier.id);
      }

      if (!mounted) {
        return;
      }
      Navigator.of(context).pushNamed(
        '${AppRoutes.record}/foundational-consent-civic-review-sandbox-record',
      );
    } catch (error) {
      setState(() {
        message = error.toString().contains('DUPLICATE_PARTICIPATION')
            ? 'Your ratification was already recorded.'
            : 'Ratification could not be saved.';
        isSubmitting = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Dossier>(
      future: _dossierFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CivicLayout(
            title: 'Loading Ratification',
            child: Center(child: CircularProgressIndicator()),
          );
        }
        if (snapshot.hasError || !snapshot.hasData) {
          return const CivicLayout(
            title: 'Ratification Unavailable',
            child: CivicPanel(
              children: [
                Text(
                  'The ratification packet could not be loaded from the backend.',
                ),
              ],
            ),
          );
        }

        return _RatificationContent(
          dossier: snapshot.data!,
          selectedOutcome: selectedOutcome,
          provisionResponses: _provisionResponses,
          message: message,
          isSubmitting: isSubmitting,
          onSelectOutcome: _selectOutcome,
          onSelectProvision: (provisionId, response) {
            setState(() {
              _provisionResponses[provisionId] = response;
            });
          },
          onSubmit: () => _submit(snapshot.data!),
        );
      },
    );
  }
}

class _RatificationContent extends StatelessWidget {
  const _RatificationContent({
    required this.dossier,
    required this.selectedOutcome,
    required this.provisionResponses,
    required this.message,
    required this.isSubmitting,
    required this.onSelectOutcome,
    required this.onSelectProvision,
    required this.onSubmit,
  });

  final Dossier dossier;
  final String? selectedOutcome;
  final Map<String, String> provisionResponses;
  final String? message;
  final bool isSubmitting;
  final ValueChanged<String> onSelectOutcome;
  final void Function(String provisionId, String response) onSelectProvision;
  final VoidCallback onSubmit;

  bool get allProvisionsAnswered {
    return dossier.provisions.every(
      (provision) => provisionResponses.containsKey(provision.id),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return CivicLayout(
      title: 'Ratification',
      subtitle: 'Record a civic position after review confirmation.',
      child: CivicPanel(
        children: [
          Text('Question Under Review', style: textTheme.titleLarge),
          const SizedBox(height: 10),
          Text(
            dossier.questions.isEmpty
                ? 'Do you believe this concern warrants structured civic review?'
                : dossier.questions.last,
            style: textTheme.bodyMedium,
          ),
          const SizedBox(height: 18),
          Text('Select a position', style: textTheme.titleLarge),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              FilledButton.icon(
                onPressed: () => onSelectOutcome('ratify'),
                icon: const Icon(Icons.check_circle_outline),
                label: const Text('Ratify'),
              ),
              OutlinedButton.icon(
                onPressed: () => onSelectOutcome('do_not_ratify'),
                icon: const Icon(Icons.cancel_outlined),
                label: const Text('Do Not Ratify'),
              ),
            ],
          ),
          if (dossier.provisions.isNotEmpty) ...[
            const SizedBox(height: 22),
            Text('Provision Responses', style: textTheme.titleLarge),
            const SizedBox(height: 10),
            for (final provision in dossier.provisions) ...[
              Text(provision.text, style: textTheme.bodyMedium),
              const SizedBox(height: 8),
              SegmentedButton<String>(
                segments: const [
                  ButtonSegment(value: 'agree', label: Text('Agree')),
                  ButtonSegment(value: 'disagree', label: Text('Disagree')),
                ],
                selected: {
                  if (provisionResponses[provision.id] != null)
                    provisionResponses[provision.id]!,
                },
                emptySelectionAllowed: true,
                onSelectionChanged: (selection) {
                  if (selection.isEmpty) {
                    return;
                  }
                  onSelectProvision(provision.id, selection.first);
                },
              ),
              const SizedBox(height: 14),
            ],
          ],
          if (message != null) ...[
            const SizedBox(height: 12),
            Text(message!, style: textTheme.bodyMedium),
          ],
          const SizedBox(height: 22),
          PrimaryButton(
            label: isSubmitting ? 'Saving...' : 'Submit Ratification',
            icon: Icons.fact_check_outlined,
            onPressed:
                selectedOutcome == null ||
                    !allProvisionsAnswered ||
                    isSubmitting
                ? null
                : onSubmit,
          ),
        ],
      ),
    );
  }
}
