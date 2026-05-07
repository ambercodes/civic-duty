import 'package:flutter/material.dart';

import '../mock/mock_civic_data.dart';
import '../routes/app_routes.dart';
import '../widgets/civic_layout.dart';
import '../widgets/primary_button.dart';

class ReadConfirmationScreen extends StatefulWidget {
  const ReadConfirmationScreen({super.key});

  @override
  State<ReadConfirmationScreen> createState() => _ReadConfirmationScreenState();
}

class _ReadConfirmationScreenState extends State<ReadConfirmationScreen> {
  bool hasConfirmedReview = false;
  bool hasConfirmedComprehension = false;

  bool get canContinue => hasConfirmedReview && hasConfirmedComprehension;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return CivicLayout(
      title: 'Read Confirmation',
      subtitle:
          'Confirm review before recording a ratification position. This static prototype does not submit data.',
      child: CivicPanel(
        children: [
          Text(mockDossier.title, style: textTheme.titleLarge),
          const SizedBox(height: 10),
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
              'I understand this is a mock prototype and no record is submitted.',
              style: textTheme.bodyMedium,
            ),
            value: hasConfirmedComprehension,
            onChanged: (value) {
              setState(() {
                hasConfirmedComprehension = value ?? false;
              });
            },
          ),
          const SizedBox(height: 18),
          PrimaryButton(
            label: 'Continue to Ratification',
            icon: Icons.how_to_vote_outlined,
            onPressed: canContinue
                ? () => Navigator.of(context).pushNamed(AppRoutes.ratify)
                : null,
          ),
        ],
      ),
    );
  }
}
