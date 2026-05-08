import 'dossier.dart';
import 'evidence_item.dart';
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
    this.openingStatement = '',
    this.boundaryStatement = '',
    this.verificationSummary = const [],
    this.provisionResults = const [],
  });

  final String openingStatement;
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
  final String boundaryStatement;
  final List<VerificationSummaryItem> verificationSummary;
  final List<ProvisionResultItem> provisionResults;

  factory CivicRatificationRecord.fromJson(Map<String, dynamic> json) {
    final participation =
        (json['participationSummary'] as Map<String, dynamic>?) ?? {};
    final states = (json['stateResults'] as List<dynamic>? ?? [])
        .whereType<Map<String, dynamic>>()
        .map(StatePulse.fromJson)
        .toList();
    final evidence = (json['evidenceIndex'] as List<dynamic>? ?? [])
        .whereType<Map<String, dynamic>>()
        .map(EvidenceItem.fromJson)
        .toList();
    final verificationSummary =
        (json['verificationSummary'] as List<dynamic>? ?? [])
            .whereType<Map<String, dynamic>>()
            .map(VerificationSummaryItem.fromJson)
            .toList();
    final provisionResults = (json['provisionResults'] as List<dynamic>? ?? [])
        .whereType<Map<String, dynamic>>()
        .map(ProvisionResultItem.fromJson)
        .toList();

    return CivicRatificationRecord(
      openingStatement: (json['openingStatement'] ?? '').toString(),
      recordId: (json['recordId'] ?? '').toString(),
      version: (json['version'] ?? '').toString(),
      publicationDate: (json['publishedAt'] ?? '').toString(),
      dossier: Dossier(
        id: (json['dossierId'] ?? '').toString(),
        title: (json['dossierTitle'] ?? '').toString(),
        summary: (json['plainLanguageSummary'] ?? '').toString(),
        scope: (json['boundaryStatement'] ?? '').toString(),
        questions: const [],
        evidenceItems: evidence,
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
      boundaryStatement: (json['boundaryStatement'] ?? '').toString(),
      verificationSummary: verificationSummary,
      provisionResults: provisionResults,
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

class VerificationSummaryItem {
  const VerificationSummaryItem({
    required this.verificationLevel,
    required this.participantCount,
    required this.percentage,
  });

  final String verificationLevel;
  final int participantCount;
  final double percentage;

  factory VerificationSummaryItem.fromJson(Map<String, dynamic> json) {
    return VerificationSummaryItem(
      verificationLevel: (json['verification_level'] ?? '').toString(),
      participantCount: CivicRatificationRecord._readInt(
        json['participant_count'],
      ),
      percentage: _readDouble(json['percentage']),
    );
  }

  static double _readDouble(Object? value) {
    if (value is double) {
      return value;
    }
    if (value is num) {
      return value.toDouble();
    }
    return double.tryParse(value?.toString() ?? '') ?? 0;
  }
}

class ProvisionResultItem {
  const ProvisionResultItem({
    required this.provisionText,
    required this.agreeCount,
    required this.disagreeCount,
  });

  final String provisionText;
  final int agreeCount;
  final int disagreeCount;

  factory ProvisionResultItem.fromJson(Map<String, dynamic> json) {
    return ProvisionResultItem(
      provisionText: (json['provision_text'] ?? '').toString(),
      agreeCount: CivicRatificationRecord._readInt(json['agree_count']),
      disagreeCount: CivicRatificationRecord._readInt(json['disagree_count']),
    );
  }
}
