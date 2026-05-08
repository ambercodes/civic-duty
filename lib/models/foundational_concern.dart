class FoundationalConcern {
  const FoundationalConcern({
    required this.id,
    required this.slug,
    required this.title,
    required this.plainLanguageSummary,
    required this.reviewDomain,
    required this.issueStatement,
    required this.whyReviewMatters,
    required this.constitutionalRelevance,
    required this.participationBoundaries,
    required this.proposedReviewQuestion,
    required this.status,
    required this.signalCount,
    required this.signalWindowClosesAt,
    this.externalEvidenceUrl,
    this.evidence = const [],
    this.variants = const [],
  });

  final String id;
  final String slug;
  final String title;
  final String plainLanguageSummary;
  final String reviewDomain;
  final String issueStatement;
  final String whyReviewMatters;
  final String constitutionalRelevance;
  final String participationBoundaries;
  final String proposedReviewQuestion;
  final String? externalEvidenceUrl;
  final String status;
  final int signalCount;
  final String signalWindowClosesAt;
  final List<ConcernEvidence> evidence;
  final List<ConcernVariant> variants;

  factory FoundationalConcern.fromJson(Map<String, dynamic> json) {
    return FoundationalConcern(
      id: (json['id'] ?? '').toString(),
      slug: (json['slug'] ?? '').toString(),
      title: (json['title'] ?? '').toString(),
      plainLanguageSummary: (json['plainLanguageSummary'] ?? '').toString(),
      reviewDomain: (json['reviewDomain'] ?? '').toString(),
      issueStatement: (json['issueStatement'] ?? '').toString(),
      whyReviewMatters: (json['whyReviewMatters'] ?? '').toString(),
      constitutionalRelevance: (json['constitutionalRelevance'] ?? '')
          .toString(),
      participationBoundaries: (json['participationBoundaries'] ?? '')
          .toString(),
      proposedReviewQuestion: (json['proposedReviewQuestion'] ?? '').toString(),
      externalEvidenceUrl: json['externalEvidenceUrl']?.toString(),
      status: (json['status'] ?? '').toString(),
      signalCount: _readInt(json['signalCount']),
      signalWindowClosesAt: (json['signalWindowClosesAt'] ?? '').toString(),
      evidence: (json['evidence'] as List<dynamic>? ?? [])
          .whereType<Map<String, dynamic>>()
          .map(ConcernEvidence.fromJson)
          .toList(),
      variants: (json['variants'] as List<dynamic>? ?? [])
          .whereType<Map<String, dynamic>>()
          .map(ConcernVariant.fromJson)
          .toList(),
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

class ConcernEvidence {
  const ConcernEvidence({
    required this.id,
    required this.title,
    required this.url,
    this.description,
  });

  final String id;
  final String title;
  final String url;
  final String? description;

  factory ConcernEvidence.fromJson(Map<String, dynamic> json) {
    return ConcernEvidence(
      id: (json['id'] ?? '').toString(),
      title: (json['title'] ?? '').toString(),
      url: (json['url'] ?? '').toString(),
      description: json['description']?.toString(),
    );
  }
}

class ConcernVariant {
  const ConcernVariant({
    required this.id,
    required this.sharedSummary,
    required this.differenceSummary,
    required this.provisionLanguage,
  });

  final String id;
  final String sharedSummary;
  final String differenceSummary;
  final String provisionLanguage;

  factory ConcernVariant.fromJson(Map<String, dynamic> json) {
    return ConcernVariant(
      id: (json['id'] ?? '').toString(),
      sharedSummary: (json['sharedSummary'] ?? '').toString(),
      differenceSummary: (json['differenceSummary'] ?? '').toString(),
      provisionLanguage: (json['provisionLanguage'] ?? '').toString(),
    );
  }
}

class ConcernThresholdStatus {
  const ConcernThresholdStatus({
    required this.thresholdMet,
    required this.statesMeetingThreshold,
    required this.requiredStates,
    required this.requiredPercent,
    required this.signalWindowDays,
  });

  final bool thresholdMet;
  final int statesMeetingThreshold;
  final int requiredStates;
  final double requiredPercent;
  final int signalWindowDays;

  factory ConcernThresholdStatus.fromJson(Map<String, dynamic> json) {
    return ConcernThresholdStatus(
      thresholdMet: json['thresholdMet'] == true,
      statesMeetingThreshold: FoundationalConcern._readInt(
        json['statesMeetingThreshold'],
      ),
      requiredStates: FoundationalConcern._readInt(json['requiredStates']),
      requiredPercent: _readDouble(json['requiredPercent']),
      signalWindowDays: FoundationalConcern._readInt(json['signalWindowDays']),
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
