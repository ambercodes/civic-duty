import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class InfoSection extends StatelessWidget {
  const InfoSection({super.key, required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: textTheme.titleLarge),
        const SizedBox(height: 10),
        ...children,
      ],
    );
  }
}

class MethodologyCard extends StatelessWidget {
  const MethodologyCard({
    super.key,
    required this.title,
    required this.body,
    this.icon = Icons.article_outlined,
  });

  final String title;
  final String body;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppTheme.paper,
        border: Border.all(color: AppTheme.softGray),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: AppTheme.mutedBronze),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: textTheme.titleMedium),
                  const SizedBox(height: 6),
                  Text(body, style: textTheme.bodyMedium),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BoundaryNotice extends StatelessWidget {
  const BoundaryNotice({super.key, required this.title, required this.body});

  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppTheme.offWhite,
        border: Border.all(color: AppTheme.mutedBronze.withValues(alpha: 0.42)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: textTheme.titleMedium),
            const SizedBox(height: 8),
            Text(body, style: textTheme.bodyMedium),
          ],
        ),
      ),
    );
  }
}

class ParticipationRuleCard extends StatelessWidget {
  const ParticipationRuleCard({
    super.key,
    required this.rule,
    required this.explanation,
  });

  final String rule;
  final String explanation;

  @override
  Widget build(BuildContext context) {
    return MethodologyCard(
      icon: Icons.rule_outlined,
      title: rule,
      body: explanation,
    );
  }
}

class GlossaryTerm extends StatelessWidget {
  const GlossaryTerm({super.key, required this.term, required this.definition});

  final String term;
  final String definition;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: definition,
      child: Text(
        term,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          decoration: TextDecoration.underline,
          decorationStyle: TextDecorationStyle.dotted,
        ),
      ),
    );
  }
}

class PlainBulletList extends StatelessWidget {
  const PlainBulletList({super.key, required this.items});

  final List<String> items;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final item in items) ...[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('- '),
              Expanded(child: Text(item, style: textTheme.bodyMedium)),
            ],
          ),
          if (item != items.last) const SizedBox(height: 8),
        ],
      ],
    );
  }
}
