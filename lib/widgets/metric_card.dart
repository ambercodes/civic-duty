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
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(label, style: textTheme.titleMedium),
            const SizedBox(height: 10),
            Text(value, style: textTheme.headlineMedium),
            if (description != null) ...[
              const SizedBox(height: 8),
              Text(description!, style: textTheme.bodyMedium),
            ],
          ],
        ),
      ),
    );
  }
}
