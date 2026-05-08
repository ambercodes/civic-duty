import 'package:flutter/material.dart';

import '../../models/foundational_concern.dart';
import '../../routes/app_routes.dart';
import '../../services/concern_service.dart';
import '../../widgets/civic_layout.dart';

class ConcernArchiveScreen extends StatelessWidget {
  const ConcernArchiveScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CivicLayout(
      title: 'Concern Archives',
      subtitle:
          'Archived concerns remain publicly viewable as constitutional civic memory.',
      showHeroHeader: true,
      child: FutureBuilder<List<FoundationalConcern>>(
        future: ConcernService().listArchive(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final concerns = snapshot.data ?? const <FoundationalConcern>[];
          return Column(
            children: [
              for (final concern in concerns) ...[
                CivicPanel(
                  children: [
                    Text(
                      concern.title,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(concern.plainLanguageSummary),
                    Text('Status: ${concern.status}'),
                    const SizedBox(height: 10),
                    OutlinedButton(
                      onPressed: () => Navigator.of(
                        context,
                      ).pushNamed('${AppRoutes.concerns}/${concern.slug}'),
                      child: const Text('View Archived Concern'),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
              ],
            ],
          );
        },
      ),
    );
  }
}
