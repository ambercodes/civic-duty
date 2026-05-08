import 'package:flutter/material.dart';

import '../mock/mock_civic_data.dart';
import '../models/civic_ratification_record.dart';
import '../routes/app_routes.dart';
import '../services/crr_service.dart';
import '../utils/formatters.dart';
import '../widgets/civic_layout.dart';
import '../widgets/primary_button.dart';

class RecordScreen extends StatefulWidget {
  const RecordScreen({super.key});

  @override
  State<RecordScreen> createState() => _RecordScreenState();
}

class _RecordScreenState extends State<RecordScreen> {
  late final Future<CivicRatificationRecord> _recordFuture = CrrService()
      .getRecord('foundational-consent-civic-review-sandbox-record')
      .catchError((_) => mockCivicRatificationRecord);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<CivicRatificationRecord>(
      future: _recordFuture,
      builder: (context, snapshot) {
        final record = snapshot.data ?? mockCivicRatificationRecord;
        return _RecordContent(record: record);
      },
    );
  }
}

class _RecordContent extends StatelessWidget {
  const _RecordContent({required this.record});

  final CivicRatificationRecord record;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return CivicLayout(
      title: 'Civic Ratification Record',
      subtitle:
          'We the people of the United States have convened to review the following matters in relation to foundational consent.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CivicPanel(
            children: [
              Text('Record Identity', style: textTheme.titleLarge),
              const SizedBox(height: 12),
              _RecordLine(label: 'Record ID', value: record.recordId),
              _RecordLine(label: 'Version', value: record.version),
              _RecordLine(
                label: 'Publication date',
                value: record.publicationDate,
              ),
              _RecordLine(label: 'Dossier', value: record.dossier.title),
            ],
          ),
          const SizedBox(height: 18),
          CivicPanel(
            children: [
              Text('Participation Summary', style: textTheme.titleLarge),
              const SizedBox(height: 12),
              _RecordLine(
                label: 'Total participants',
                value: Formatters.compactNumber(record.totalParticipants),
              ),
              _RecordLine(
                label: 'Ratified',
                value: Formatters.compactNumber(record.ratifiedCount),
              ),
              _RecordLine(
                label: 'Not ratified',
                value: Formatters.compactNumber(record.notRatifiedCount),
              ),
              _RecordLine(
                label: 'States represented',
                value: '${record.statesRepresented}',
              ),
            ],
          ),
          const SizedBox(height: 18),
          CivicPanel(
            children: [
              Text('State Participation', style: textTheme.titleLarge),
              const SizedBox(height: 12),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: const [
                    DataColumn(label: Text('State')),
                    DataColumn(label: Text('Participants')),
                    DataColumn(label: Text('Coverage')),
                  ],
                  rows: [
                    for (final pulse in record.stateParticipation)
                      DataRow(
                        cells: [
                          DataCell(Text(pulse.state)),
                          DataCell(
                            Text(Formatters.compactNumber(pulse.participants)),
                          ),
                          DataCell(
                            Text(Formatters.percent(pulse.coveragePercent)),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          CivicPanel(
            children: [
              Text('Evidence Index', style: textTheme.titleLarge),
              const SizedBox(height: 12),
              for (final item in mockDossier.evidenceItems) ...[
                Text('${item.id}: ${item.title}', style: textTheme.titleMedium),
                const SizedBox(height: 4),
                Text(item.source, style: textTheme.bodyMedium),
                if (item != mockDossier.evidenceItems.last)
                  const Divider(height: 24),
              ],
            ],
          ),
          const SizedBox(height: 18),
          CivicPanel(
            children: [
              Text('Ratification Outcome', style: textTheme.titleLarge),
              const SizedBox(height: 8),
              Text(record.outcome, style: textTheme.bodyMedium),
              const SizedBox(height: 18),
              Text('Methodology', style: textTheme.titleLarge),
              const SizedBox(height: 8),
              Text(record.methodology, style: textTheme.bodyMedium),
            ],
          ),
          const SizedBox(height: 24),
          PrimaryButton(
            label: 'Return Home',
            icon: Icons.home_outlined,
            onPressed: () => Navigator.of(context).pushNamed(AppRoutes.landing),
          ),
        ],
      ),
    );
  }
}

class _RecordLine extends StatelessWidget {
  const _RecordLine({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 150,
            child: Text(label, style: textTheme.titleMedium),
          ),
          Expanded(child: Text(value, style: textTheme.bodyMedium)),
        ],
      ),
    );
  }
}
