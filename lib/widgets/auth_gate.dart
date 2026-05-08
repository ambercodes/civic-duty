import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../models/user_profile.dart';
import '../routes/app_routes.dart';
import '../services/auth_service.dart';
import '../services/user_service.dart';
import '../widgets/civic_layout.dart';
import '../widgets/primary_button.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key, required this.child, this.requireProfile = false});

  final Widget child;
  final bool requireProfile;

  @override
  Widget build(BuildContext context) {
    if (!AuthService.isConfigured) {
      return child;
    }

    final authService = AuthService();
    return StreamBuilder<User?>(
      stream: authService.authStateChanges,
      initialData: authService.currentUser,
      builder: (context, snapshot) {
        final user = snapshot.data;
        if (user == null) {
          return _LockedRoute(
            title: 'Login Required',
            message: 'Please log in before continuing civic participation.',
            actionLabel: 'Log In',
            route: AppRoutes.login,
          );
        }

        if (!user.emailVerified) {
          return const VerifyEmailScreenRedirect();
        }

        if (!requireProfile) {
          return child;
        }

        return FutureBuilder<UserProfile>(
          future: UserService().currentUser(),
          builder: (context, profileSnapshot) {
            if (profileSnapshot.connectionState == ConnectionState.waiting) {
              return const _LoadingRoute();
            }

            final profile = profileSnapshot.data;
            if (profile == null || !profile.isComplete) {
              return _LockedRoute(
                title: 'Civic Profile Required',
                message:
                    'Complete your civic profile before recording participation.',
                actionLabel: 'Complete Profile',
                route: AppRoutes.completeProfile,
              );
            }

            return child;
          },
        );
      },
    );
  }
}

class VerifyEmailScreenRedirect extends StatelessWidget {
  const VerifyEmailScreenRedirect({super.key});

  @override
  Widget build(BuildContext context) {
    return _LockedRoute(
      title: 'Email Verification Required',
      message: 'Verify your email address before civic participation.',
      actionLabel: 'Verify Email',
      route: AppRoutes.verifyEmail,
    );
  }
}

class _LoadingRoute extends StatelessWidget {
  const _LoadingRoute();

  @override
  Widget build(BuildContext context) {
    return const CivicLayout(
      title: 'Checking Access',
      child: Center(child: CircularProgressIndicator()),
    );
  }
}

class _LockedRoute extends StatelessWidget {
  const _LockedRoute({
    required this.title,
    required this.message,
    required this.actionLabel,
    required this.route,
  });

  final String title;
  final String message;
  final String actionLabel;
  final String route;

  @override
  Widget build(BuildContext context) {
    return CivicLayout(
      title: title,
      child: CivicPanel(
        children: [
          Text(message, style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 18),
          PrimaryButton(
            label: actionLabel,
            icon: Icons.login_outlined,
            onPressed: () => Navigator.of(context).pushNamed(route),
          ),
        ],
      ),
    );
  }
}
