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
  });

  final String id;
  final String title;
  final String summary;
  final String scope;
  final List<String> questions;
  final List<EvidenceItem> evidenceItems;
  final String version;
  final String publishedDate;
  final int estimatedReadingMinutes;
}
