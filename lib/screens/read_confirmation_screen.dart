import 'package:flutter/material.dart';

import '../routes/app_routes.dart';
import '../services/participation_service.dart';
import '../widgets/civic_layout.dart';
import '../widgets/primary_button.dart';

class ReadConfirmationScreen extends StatefulWidget {
  const ReadConfirmationScreen({
    super.key,
    this.dossierIdOrSlug = 'foundational-consent-civic-review',
  });

  final String dossierIdOrSlug;

  @override
  State<ReadConfirmationScreen> createState() => _ReadConfirmationScreenState();
}

class _ReadConfirmationScreenState extends State<ReadConfirmationScreen> {
  bool hasConfirmedReview = false;
  bool hasConfirmedComprehension = false;
  bool isSubmitting = false;
  String? message;

  bool get canContinue =>
      hasConfirmedReview && hasConfirmedComprehension && !isSubmitting;

  Future<void> _confirm() async {
    setState(() {
      isSubmitting = true;
      message = null;
    });

    try {
      await ParticipationService().confirmRead(widget.dossierIdOrSlug);
      if (!mounted) {
        return;
      }
      Navigator.of(
        context,
      ).pushNamed('${AppRoutes.ratify}/${widget.dossierIdOrSlug}');
    } catch (error) {
      setState(() {
        message = error.toString().contains('DUPLICATE_PARTICIPATION')
            ? 'Review was already confirmed. Continue to ratification.'
            : 'Read confirmation could not be saved.';
        isSubmitting = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return CivicLayout(
      title: 'Read Confirmation',
      subtitle: 'Confirm review before recording a ratification position.',
      child: CivicPanel(
        children: [
          Text(
            'Participants must confirm that they reviewed the dossier before continuing to ratification.',
            style: textTheme.bodyMedium,
          ),
          const SizedBox(height: 18),
          CheckboxListTile(
            contentPadding: EdgeInsets.zero,
            controlAffinity: ListTileControlAffinity.leading,
            title: Text(
              'I have reviewed and understand the material presented.',
              style: textTheme.bodyMedium,
            ),
            value: hasConfirmedReview,
            onChanged: (value) {
              setState(() {
                hasConfirmedReview = value ?? false;
              });
            },
          ),
          CheckboxListTile(
            contentPadding: EdgeInsets.zero,
            controlAffinity: ListTileControlAffinity.leading,
            title: Text(
              'I understand this is public civic participation, not legal or government action.',
              style: textTheme.bodyMedium,
            ),
            value: hasConfirmedComprehension,
            onChanged: (value) {
              setState(() {
                hasConfirmedComprehension = value ?? false;
              });
            },
          ),
          if (message != null) ...[
            const SizedBox(height: 12),
            Text(message!, style: textTheme.bodyMedium),
          ],
          const SizedBox(height: 18),
          PrimaryButton(
            label: isSubmitting ? 'Saving...' : 'Continue to Ratification',
            icon: Icons.how_to_vote_outlined,
            onPressed: canContinue ? _confirm : null,
          ),
        ],
      ),
    );
  }
}
