import 'package:flutter/material.dart';

import '../../routes/app_routes.dart';
import '../../services/user_service.dart';
import '../../widgets/civic_layout.dart';
import '../../widgets/primary_button.dart';

class CompleteProfileScreen extends StatefulWidget {
  const CompleteProfileScreen({super.key});

  @override
  State<CompleteProfileScreen> createState() => _CompleteProfileScreenState();
}

class _CompleteProfileScreenState extends State<CompleteProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _aliasController = TextEditingController();
  final _birthYearController = TextEditingController();
  String? _stateCode;
  bool _citizenshipAttested = false;
  bool _isSubmitting = false;
  String? _error;

  static const _states = [
    'AL',
    'AK',
    'AZ',
    'AR',
    'CA',
    'CO',
    'CT',
    'DE',
    'FL',
    'GA',
    'HI',
    'ID',
    'IL',
    'IN',
    'IA',
    'KS',
    'KY',
    'LA',
    'ME',
    'MD',
    'MA',
    'MI',
    'MN',
    'MS',
    'MO',
    'MT',
    'NE',
    'NV',
    'NH',
    'NJ',
    'NM',
    'NY',
    'NC',
    'ND',
    'OH',
    'OK',
    'OR',
    'PA',
    'RI',
    'SC',
    'SD',
    'TN',
    'TX',
    'UT',
    'VT',
    'VA',
    'WA',
    'WV',
    'WI',
    'WY',
    'DC',
  ];

  @override
  void dispose() {
    _aliasController.dispose();
    _birthYearController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate() || !_citizenshipAttested) {
      setState(() {
        _error = _citizenshipAttested
            ? null
            : 'Citizenship attestation is required.';
      });
      return;
    }

    setState(() {
      _isSubmitting = true;
      _error = null;
    });

    try {
      await UserService().saveProfile(
        displayAlias: _aliasController.text.trim(),
        birthYear: int.parse(_birthYearController.text.trim()),
        stateCode: _stateCode!,
        citizenshipAttested: _citizenshipAttested,
      );
      if (!mounted) {
        return;
      }
      Navigator.of(context).pushReplacementNamed(AppRoutes.dashboard);
    } catch (error) {
      setState(() {
        _error = 'Profile could not be saved. Check your entries.';
      });
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return CivicLayout(
      title: 'Complete Civic Profile',
      subtitle: 'Participation remains locked until this profile is complete.',
      child: CivicPanel(
        children: [
          Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _aliasController,
                  decoration: const InputDecoration(labelText: 'Display Alias'),
                  validator: (value) => value == null || value.trim().length < 2
                      ? 'Enter a display alias.'
                      : null,
                ),
                const SizedBox(height: 14),
                TextFormField(
                  controller: _birthYearController,
                  decoration: const InputDecoration(labelText: 'Birth Year'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    final year = int.tryParse(value ?? '');
                    final currentYear = DateTime.now().year;
                    if (year == null || year < 1900 || year > currentYear) {
                      return 'Enter a valid birth year.';
                    }
                    if (currentYear - year < 18) {
                      return 'Participants must be 18 or older.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 14),
                DropdownButtonFormField<String>(
                  initialValue: _stateCode,
                  decoration: const InputDecoration(labelText: 'State'),
                  items: [
                    for (final state in _states)
                      DropdownMenuItem(value: state, child: Text(state)),
                  ],
                  onChanged: (value) => setState(() => _stateCode = value),
                  validator: (value) =>
                      value == null ? 'Declare your state.' : null,
                ),
                const SizedBox(height: 14),
                CheckboxListTile(
                  contentPadding: EdgeInsets.zero,
                  controlAffinity: ListTileControlAffinity.leading,
                  title: const Text('I self-attest that I am a U.S. citizen.'),
                  value: _citizenshipAttested,
                  onChanged: (value) {
                    setState(() => _citizenshipAttested = value ?? false);
                  },
                ),
                if (_error != null) ...[
                  const SizedBox(height: 12),
                  Text(
                    _error!,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                ],
                const SizedBox(height: 20),
                PrimaryButton(
                  label: _isSubmitting ? 'Saving...' : 'Save Civic Profile',
                  icon: Icons.verified_user_outlined,
                  onPressed: _isSubmitting ? null : _submit,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
