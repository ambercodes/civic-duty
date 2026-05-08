import 'package:flutter/material.dart';

import '../routes/app_routes.dart';
import '../services/auth_service.dart';
import '../theme/app_theme.dart';

class CivicLayout extends StatelessWidget {
  const CivicLayout({
    super.key,
    required this.title,
    required this.child,
    this.header,
    this.subtitle,
  });

  final String title;
  final String? subtitle;
  final Widget? header;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Civic Duty'),
        actions: [_RouteMenuButton()],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 32),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 920),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (header != null) ...[header!, const SizedBox(height: 30)],
                  Text(title, style: textTheme.displaySmall),
                  if (subtitle != null) ...[
                    const SizedBox(height: 12),
                    Text(subtitle!, style: textTheme.bodyLarge),
                  ],
                  const SizedBox(height: 28),
                  child,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _RouteMenuButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      tooltip: 'Navigate',
      icon: const Icon(Icons.menu),
      onSelected: (route) async {
        if (route == '_logout') {
          await AuthService().logout();
          if (context.mounted) {
            Navigator.of(context).pushNamed(AppRoutes.landing);
          }
          return;
        }
        if (context.mounted) {
          Navigator.of(context).pushNamed(route);
        }
      },
      itemBuilder: (context) => const [
        PopupMenuItem(value: AppRoutes.landing, child: Text('Landing')),
        PopupMenuItem(value: AppRoutes.login, child: Text('Log In')),
        PopupMenuItem(value: AppRoutes.signup, child: Text('Sign Up')),
        PopupMenuItem(
          value: AppRoutes.completeProfile,
          child: Text('Civic Profile'),
        ),
        PopupMenuItem(value: '_logout', child: Text('Log Out')),
        PopupMenuDivider(),
        PopupMenuItem(value: AppRoutes.dashboard, child: Text('Dashboard')),
        PopupMenuItem(value: AppRoutes.dossier, child: Text('Dossier')),
        PopupMenuItem(value: AppRoutes.confirmReview, child: Text('Confirm')),
        PopupMenuItem(value: AppRoutes.ratify, child: Text('Ratify')),
        PopupMenuItem(value: AppRoutes.record, child: Text('Record')),
        PopupMenuDivider(),
        PopupMenuItem(value: AppRoutes.concerns, child: Text('Concerns')),
        PopupMenuItem(
          value: AppRoutes.submitConcern,
          child: Text('Submit Concern'),
        ),
        PopupMenuItem(
          value: AppRoutes.concernArchive,
          child: Text('Concern Archive'),
        ),
        PopupMenuDivider(),
        PopupMenuItem(
          value: AppRoutes.whatIsCivicDuty,
          child: Text('What Is Civic Duty?'),
        ),
        PopupMenuItem(
          value: AppRoutes.whatIsADossier,
          child: Text('What Is a Dossier?'),
        ),
        PopupMenuItem(
          value: AppRoutes.ratificationMeaning,
          child: Text('Ratification Meaning'),
        ),
        PopupMenuItem(
          value: AppRoutes.verificationLevels,
          child: Text('Verification Levels'),
        ),
        PopupMenuItem(
          value: AppRoutes.participationMethodology,
          child: Text('Participation Methodology'),
        ),
        PopupMenuItem(
          value: AppRoutes.scopeBoundaries,
          child: Text('Scope Boundaries'),
        ),
        PopupMenuItem(
          value: AppRoutes.sandboxDisclaimer,
          child: Text('Sandbox Disclaimer'),
        ),
      ],
    );
  }
}

class CivicPanel extends StatelessWidget {
  const CivicPanel({super.key, required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppTheme.paper,
        border: Border.all(color: AppTheme.softGray),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: children,
        ),
      ),
    );
  }
}
