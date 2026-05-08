import 'evidence_item.dart';

class Dossier {
  const Dossier({
    required this.id,
    required this.title,
    required this.summary,
    required this.scope,
    required this.questions,
    required this.evidenceItems,
    required this.version,
    required this.publishedDate,
    required this.estimatedReadingMinutes,
    this.slug,
    this.status = 'published',
    this.provisions = const [],
  });

  final String id;
  final String? slug;
  final String title;
  final String summary;
  final String scope;
  final List<String> questions;
  final List<EvidenceItem> evidenceItems;
  final String version;
  final String publishedDate;
  final int estimatedReadingMinutes;
  final String status;
  final List<DossierProvision> provisions;

  factory Dossier.fromJson(Map<String, dynamic> json) {
    final evidence = (json['evidence'] as List<dynamic>? ?? [])
        .whereType<Map<String, dynamic>>()
        .map(EvidenceItem.fromJson)
        .toList();
    final questions = (json['questions'] as List<dynamic>? ?? [])
        .whereType<Map<String, dynamic>>()
        .map((item) => (item['text'] ?? '').toString())
        .where((item) => item.isNotEmpty)
        .toList();
    final provisions = (json['provisions'] as List<dynamic>? ?? [])
        .whereType<Map<String, dynamic>>()
        .map(DossierProvision.fromJson)
        .toList();

    return Dossier(
      id: (json['id'] ?? '').toString(),
      slug: json['slug']?.toString(),
      title: (json['title'] ?? '').toString(),
      summary: (json['summary'] ?? '').toString(),
      scope: (json['scope'] ?? '').toString(),
      questions: questions,
      evidenceItems: evidence,
      version: (json['version'] ?? '').toString(),
      publishedDate: (json['publishedAt'] ?? '').toString(),
      estimatedReadingMinutes: 6,
      status: (json['status'] ?? 'published').toString(),
      provisions: provisions,
    );
  }
}

class DossierProvision {
  const DossierProvision({
    required this.id,
    required this.slug,
    required this.text,
  });

  final String id;
  final String slug;
  final String text;

  factory DossierProvision.fromJson(Map<String, dynamic> json) {
    return DossierProvision(
      id: (json['id'] ?? '').toString(),
      slug: (json['slug'] ?? '').toString(),
      text: (json['text'] ?? '').toString(),
    );
  }
}
