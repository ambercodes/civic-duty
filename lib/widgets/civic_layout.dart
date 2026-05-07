import 'package:flutter/material.dart';

import '../routes/app_routes.dart';
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
      onSelected: (route) => Navigator.of(context).pushNamed(route),
      itemBuilder: (context) => const [
        PopupMenuItem(value: AppRoutes.landing, child: Text('Landing')),
        PopupMenuItem(value: AppRoutes.dashboard, child: Text('Dashboard')),
        PopupMenuItem(value: AppRoutes.dossier, child: Text('Dossier')),
        PopupMenuItem(value: AppRoutes.confirmReview, child: Text('Confirm')),
        PopupMenuItem(value: AppRoutes.ratify, child: Text('Ratify')),
        PopupMenuItem(value: AppRoutes.record, child: Text('Record')),
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
