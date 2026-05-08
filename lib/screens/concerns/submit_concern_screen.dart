import 'package:flutter/material.dart';

import '../../models/user_profile.dart';
import '../../routes/app_routes.dart';
import '../../services/api_client.dart';
import '../../services/concern_service.dart';
import '../../services/user_service.dart';
import '../../widgets/civic_layout.dart';
import '../../widgets/primary_button.dart';

class SubmitConcernScreen extends StatefulWidget {
  const SubmitConcernScreen({super.key});

  @override
  State<SubmitConcernScreen> createState() => _SubmitConcernScreenState();
}

class _SubmitConcernScreenState extends State<SubmitConcernScreen> {
  final _formKey = GlobalKey<FormState>();
  final _title = TextEditingController();
  final _summary = TextEditingController();
  final _issue = TextEditingController();
  final _matters = TextEditingController();
  final _relevance = TextEditingController();
  final _boundaries = TextEditingController();
  final _question = TextEditingController();
  final _evidenceUrl = TextEditingController();
  final _externalFolder = TextEditingController();
  String? _domain;
  bool _forceDistinct = false;
  bool _isSubmitting = false;
  String? _message;

  static const domains = [
    'delegated_authority',
    'civic_consent_visibility',
    'separation_of_powers',
    'constitutional_rights_tension',
    'public_accountability_transparency',
    'constitutional_continuity',
    'emergency_powers',
    'civic_participation_integrity',
    'natural_rights_foundational_principles',
  ];

  @override
  void dispose() {
    _title.dispose();
    _summary.dispose();
    _issue.dispose();
    _matters.dispose();
    _relevance.dispose();
    _boundaries.dispose();
    _question.dispose();
    _evidenceUrl.dispose();
    _externalFolder.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    setState(() {
      _isSubmitting = true;
      _message = null;
    });
    try {
      final concern = await ConcernService().submitConcern(
        body: {
          'title': _title.text.trim(),
          'plainLanguageSummary': _summary.text.trim(),
          'reviewDomain': _domain,
          'issueStatement': _issue.text.trim(),
          'whyReviewMatters': _matters.text.trim(),
          'constitutionalRelevance': _relevance.text.trim(),
          'participationBoundaries': _boundaries.text.trim(),
          'proposedReviewQuestion': _question.text.trim(),
          'externalEvidenceUrl': _externalFolder.text.trim().isEmpty
              ? null
              : _externalFolder.text.trim(),
          'forceDistinct': _forceDistinct,
          'evidence': [
            if (_evidenceUrl.text.trim().isNotEmpty)
              {
                'title': 'Submitted Evidence Link',
                'url': _evidenceUrl.text.trim(),
                'description': 'Evidence link submitted with the concern.',
              },
          ],
        },
      );
      if (!mounted) {
        return;
      }
      Navigator.of(
        context,
      ).pushReplacementNamed('${AppRoutes.concerns}/${concern.slug}');
    } on ApiException catch (error) {
      setState(() {
        _message = error.code == 'SIMILAR_CONCERN_EXISTS'
            ? 'A similar foundational concern already exists. You may support it or mark this as clearly distinct.'
            : error.message;
        _isSubmitting = false;
      });
    } catch (_) {
      setState(() {
        _message = 'Concern could not be submitted.';
        _isSubmitting = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<UserProfile>(
      future: UserService().currentUser(),
      builder: (context, snapshot) {
        final profile = snapshot.data;
        final canCreate =
            profile?.verificationLevel == 'level_2_proof_of_human' ||
            profile?.verificationLevel == 'level_3_high_assurance';

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CivicLayout(
            title: 'Submit a Concern',
            showHeroHeader: true,
            child: Center(child: CircularProgressIndicator()),
          );
        }

        if (!canCreate) {
          return const CivicLayout(
            title: 'Submit a Concern',
            showHeroHeader: true,
            child: CivicPanel(
              children: [
                Text(
                  'Concern creation requires Level 2 proof-of-human verification. Level 1 participants may read concerns, signal support, and participate in official reviews.',
                ),
              ],
            ),
          );
        }

        return CivicLayout(
          title: 'Submit a Concern',
          subtitle:
              'Prepare the concern as if it may become a public civic review dossier.',
          showHeroHeader: true,
          child: CivicPanel(
            children: [
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _field(_title, 'Concern Title'),
                    _field(_summary, 'Plain-Language Summary', maxLines: 3),
                    DropdownButtonFormField<String>(
                      initialValue: _domain,
                      decoration: const InputDecoration(
                        labelText: 'Official Review Domain',
                      ),
                      items: [
                        for (final domain in domains)
                          DropdownMenuItem(value: domain, child: Text(domain)),
                      ],
                      onChanged: (value) => setState(() => _domain = value),
                      validator: (value) =>
                          value == null ? 'Select a review domain.' : null,
                    ),
                    _field(_issue, 'Issue Statement', maxLines: 3),
                    _field(_matters, 'Why This Review Matters', maxLines: 3),
                    _field(
                      _relevance,
                      'Constitutional / Foundational Relevance',
                      maxLines: 3,
                    ),
                    _field(
                      _boundaries,
                      'Participation Boundaries',
                      maxLines: 3,
                    ),
                    _field(_question, 'Proposed Review Question', maxLines: 2),
                    _field(_evidenceUrl, 'Evidence Link'),
                    _field(
                      _externalFolder,
                      'External Evidence Folder Link Optional',
                      required: false,
                    ),
                    CheckboxListTile(
                      value: _forceDistinct,
                      onChanged: (value) =>
                          setState(() => _forceDistinct = value ?? false),
                      title: const Text(
                        'This is a clearly distinct variant if similar concerns exist.',
                      ),
                    ),
                    if (_message != null) Text(_message!),
                    const SizedBox(height: 16),
                    PrimaryButton(
                      label: _isSubmitting
                          ? 'Submitting...'
                          : 'Submit Immutable Civic Snapshot',
                      icon: Icons.upload_file_outlined,
                      onPressed: _isSubmitting ? null : _submit,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _field(
    TextEditingController controller,
    String label, {
    int maxLines = 1,
    bool required = true,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        decoration: InputDecoration(labelText: label),
        validator: required
            ? (value) =>
                  value == null || value.trim().isEmpty ? 'Required.' : null
            : null,
      ),
    );
  }
}
