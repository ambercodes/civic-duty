class CostOfOperatingSummary {
  const CostOfOperatingSummary({
    required this.totalPublicSupportReceived,
    required this.estimatedDevelopmentHours,
    required this.estimatedLaborValue,
    required this.visibleInfrastructureCosts,
    required this.operationalStatus,
    required this.lastUpdatedDate,
  });

  final String totalPublicSupportReceived;
  final String estimatedDevelopmentHours;
  final String estimatedLaborValue;
  final String visibleInfrastructureCosts;
  final String operationalStatus;
  final String lastUpdatedDate;
}

class LaborCategorySummary {
  const LaborCategorySummary({
    required this.category,
    required this.estimatedHours,
    required this.estimatedLaborValue,
    required this.includes,
  });

  final String category;
  final String estimatedHours;
  final String estimatedLaborValue;
  final List<String> includes;
}

class PublicSupportEntry {
  const PublicSupportEntry({
    required this.supportType,
    required this.amount,
    required this.timestamp,
    this.donorAlias,
    this.isAnonymous = true,
    this.transactionHash,
    this.explorerLink,
    this.message,
  });

  final String supportType;
  final String amount;
  final String timestamp;
  final String? donorAlias;
  final bool isAnonymous;
  final String? transactionHash;
  final String? explorerLink;
  final String? message;
}

class OperationalCostEntry {
  const OperationalCostEntry({
    required this.category,
    required this.amount,
    required this.date,
    required this.explanation,
    this.referenceLink,
  });

  final String category;
  final String amount;
  final String date;
  final String explanation;
  final String? referenceLink;
}

class CivicComparisonArticle {
  const CivicComparisonArticle({
    required this.title,
    required this.summary,
    required this.publiclyReportedCost,
    required this.timeline,
    required this.transparencyObservations,
    required this.sourceLinks,
  });

  final String title;
  final String summary;
  final String publiclyReportedCost;
  final String timeline;
  final String transparencyObservations;
  final List<ComparisonSourceLink> sourceLinks;
}

class ComparisonSourceLink {
  const ComparisonSourceLink({required this.label, required this.url});

  final String label;
  final String url;
}
