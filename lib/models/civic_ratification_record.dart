import 'dossier.dart';
import 'state_pulse.dart';

class CivicRatificationRecord {
  const CivicRatificationRecord({
    required this.recordId,
    required this.version,
    required this.publicationDate,
    required this.dossier,
    required this.totalParticipants,
    required this.ratifiedCount,
    required this.notRatifiedCount,
    required this.statesRepresented,
    required this.stateParticipation,
    required this.outcome,
    required this.methodology,
  });

  final String recordId;
  final String version;
  final String publicationDate;
  final Dossier dossier;
  final int totalParticipants;
  final int ratifiedCount;
  final int notRatifiedCount;
  final int statesRepresented;
  final List<StatePulse> stateParticipation;
  final String outcome;
  final String methodology;

  factory CivicRatificationRecord.fromJson(Map<String, dynamic> json) {
    final participation =
        (json['participationSummary'] as Map<String, dynamic>?) ?? {};
    final states = (json['stateResults'] as List<dynamic>? ?? [])
        .whereType<Map<String, dynamic>>()
        .map(StatePulse.fromJson)
        .toList();

    return CivicRatificationRecord(
      recordId: (json['recordId'] ?? '').toString(),
      version: (json['version'] ?? '').toString(),
      publicationDate: (json['publishedAt'] ?? '').toString(),
      dossier: Dossier(
        id: (json['dossierId'] ?? '').toString(),
        title: (json['dossierTitle'] ?? '').toString(),
        summary: (json['plainLanguageSummary'] ?? '').toString(),
        scope: (json['boundaryStatement'] ?? '').toString(),
        questions: const [],
        evidenceItems: const [],
        version: (json['version'] ?? '').toString(),
        publishedDate: (json['publishedAt'] ?? '').toString(),
        estimatedReadingMinutes: 0,
      ),
      totalParticipants: _readInt(participation['total_participants']),
      ratifiedCount: _readInt(participation['ratified_count']),
      notRatifiedCount: _readInt(participation['not_ratified_count']),
      statesRepresented: _readInt(participation['states_represented']),
      stateParticipation: states,
      outcome: (json['outcome'] ?? '').toString(),
      methodology: (json['methodologyDisclosure'] ?? '').toString(),
    );
  }

  static int _readInt(Object? value) {
    if (value is int) {
      return value;
    }
    if (value is num) {
      return value.toInt();
    }
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }
}
