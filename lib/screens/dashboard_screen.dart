import 'package:flutter/material.dart';

import '../models/civic_ratification_record.dart';
import '../models/dossier.dart';
import '../routes/app_routes.dart';
import '../services/crr_service.dart';
import '../services/dossier_service.dart';
import '../utils/formatters.dart';
import '../widgets/civic_layout.dart';
import '../widgets/metric_card.dart';
import '../widgets/primary_button.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late final Future<_DashboardData> _dataFuture = _loadData();

  Future<_DashboardData> _loadData() async {
    final dossiers = await DossierService().listDossiers();
    final records = await CrrService().listRecords();
    return _DashboardData(
      dossier: dossiers.isEmpty ? null : dossiers.first,
      record: records.isEmpty ? null : records.first,
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<_DashboardData>(
      future: _dataFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CivicLayout(
            title: 'Civic Review Dashboard',
            child: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasError || !snapshot.hasData) {
          return const CivicLayout(
            title: 'Civic Review Dashboard',
            child: CivicPanel(
              children: [
                Text('The dashboard could not load backend data right now.'),
              ],
            ),
          );
        }

        final data = snapshot.data!;
        final dossier = data.dossier;
        final record = data.record;

        return CivicLayout(
          title: 'Civic Review Dashboard',
          subtitle:
              'This page shows the current review and public backend participation record.',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CivicPanel(
                children: [
                  Text(
                    dossier?.title ?? 'No published dossier',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Status: ${dossier?.status ?? 'Unavailable'}',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    dossier?.summary ??
                        'A published dossier has not been loaded yet.',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
              const SizedBox(height: 20),
              MetricCardGroup(
                mobileBreakpoint: 760,
                children: [
                  MetricCard(
                    label: 'Participants',
                    value: Formatters.compactNumber(
                      record?.totalParticipants ?? 0,
                    ),
                    description:
                        'People included in backend ratification rows.',
                  ),
                  MetricCard(
                    label: 'States Represented',
                    value: '${record?.statesRepresented ?? 0}',
                    description: 'States represented in backend data.',
                  ),
                  MetricCard(
                    label: 'Review Status',
                    value: dossier?.status ?? 'Unavailable',
                    description: 'Current dossier publication status.',
                  ),
                ],
              ),
              const SizedBox(height: 24),
              PrimaryButton(
                label: 'Review Dossier',
                icon: Icons.description_outlined,
                onPressed: dossier == null
                    ? null
                    : () => Navigator.of(context).pushNamed(
                        '${AppRoutes.dossier}/${dossier.slug ?? dossier.id}',
                      ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _DashboardData {
  const _DashboardData({required this.dossier, required this.record});

  final Dossier? dossier;
  final CivicRatificationRecord? record;
}
