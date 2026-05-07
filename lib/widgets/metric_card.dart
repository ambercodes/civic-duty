import 'package:flutter/material.dart';

class MetricCard extends StatelessWidget {
  const MetricCard({
    super.key,
    required this.label,
    required this.value,
    this.description,
  });

  final String label;
  final String value;
  final String? description;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Card(
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 154),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(label, style: textTheme.titleMedium, softWrap: true),
              const SizedBox(height: 10),
              Text(value, style: textTheme.headlineMedium, softWrap: true),
              if (description != null) ...[
                const SizedBox(height: 8),
                Text(description!, style: textTheme.bodyMedium, softWrap: true),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class MetricCardGroup extends StatelessWidget {
  const MetricCardGroup({
    super.key,
    required this.children,
    this.spacing = 12,
    this.mobileBreakpoint = 680,
  });

  final List<Widget> children;
  final double spacing;
  final double mobileBreakpoint;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < mobileBreakpoint) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (var index = 0; index < children.length; index++) ...[
                children[index],
                if (index != children.length - 1) SizedBox(height: spacing),
              ],
            ],
          );
        }

        return IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (var index = 0; index < children.length; index++) ...[
                Expanded(child: children[index]),
                if (index != children.length - 1) SizedBox(width: spacing),
              ],
            ],
          ),
        );
      },
    );
  }
}
