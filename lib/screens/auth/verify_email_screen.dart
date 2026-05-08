import 'package:flutter/material.dart';

import '../../routes/app_routes.dart';
import '../../services/auth_service.dart';
import '../../widgets/civic_layout.dart';
import '../../widgets/primary_button.dart';

class VerifyEmailScreen extends StatefulWidget {
  const VerifyEmailScreen({super.key});

  @override
  State<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen> {
  bool _isChecking = false;
  String? _message;

  Future<void> _resend() async {
    await AuthService().sendEmailVerification();
    setState(() {
      _message = 'Verification email sent.';
    });
  }

  Future<void> _check() async {
    setState(() => _isChecking = true);
    await AuthService().reloadUser();
    final user = AuthService().currentUser;
    if (!mounted) {
      return;
    }
    if (user?.emailVerified == true) {
      Navigator.of(context).pushReplacementNamed(AppRoutes.completeProfile);
      return;
    }
    setState(() {
      _isChecking = false;
      _message = 'Email is not verified yet.';
    });
  }

  @override
  Widget build(BuildContext context) {
    return CivicLayout(
      title: 'Verify Email',
      subtitle: 'Email verification is required before participation.',
      child: CivicPanel(
        children: [
          Text(
            'Check your inbox for a verification link, then return here.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          if (_message != null) ...[
            const SizedBox(height: 12),
            Text(_message!, style: Theme.of(context).textTheme.bodyMedium),
          ],
          const SizedBox(height: 18),
          PrimaryButton(
            label: _isChecking ? 'Checking...' : 'I Verified My Email',
            icon: Icons.mark_email_read_outlined,
            onPressed: _isChecking ? null : _check,
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: _resend,
            icon: const Icon(Icons.email_outlined),
            label: const Text('Resend Email'),
          ),
        ],
      ),
    );
  }
}
