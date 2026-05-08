class EvidenceItem {
  const EvidenceItem({
    required this.id,
    required this.title,
    required this.source,
    required this.summary,
    required this.whyItMatters,
    required this.actionLabel,
    this.url,
  });

  final String id;
  final String title;
  final String source;
  final String summary;
  final String whyItMatters;
  final String actionLabel;
  final String? url;

  factory EvidenceItem.fromJson(Map<String, dynamic> json) {
    return EvidenceItem(
      id: (json['externalId'] ?? json['id'] ?? '').toString(),
      title: (json['title'] ?? '').toString(),
      source: (json['source'] ?? '').toString(),
      summary: (json['summary'] ?? '').toString(),
      whyItMatters: (json['whyItMatters'] ?? '').toString(),
      actionLabel: 'Read Document',
      url: json['url']?.toString(),
    );
  }
}
