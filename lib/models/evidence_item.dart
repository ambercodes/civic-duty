class EvidenceItem {
  const EvidenceItem({
    required this.id,
    required this.title,
    required this.source,
    required this.summary,
    required this.whyItMatters,
    required this.actionLabel,
  });

  final String id;
  final String title;
  final String source;
  final String summary;
  final String whyItMatters;
  final String actionLabel;
}
