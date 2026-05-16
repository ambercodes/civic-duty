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
    required this.purpose,
    required this.costRows,
    required this.costGrowthNote,
    required this.intendedToSupport,
    required this.requiredComplexity,
    required this.publicVisibilityConcerns,
    required this.publicReviewsIdentified,
    required this.civicDutyQuestion,
    required this.civicDutyApproach,
    required this.closingNotes,
    required this.sourceLinks,
  });

  final String title;
  final String summary;
  final String purpose;
  final List<ComparisonCostRow> costRows;
  final List<String> costGrowthNote;
  final List<String> intendedToSupport;
  final List<String> requiredComplexity;
  final List<String> publicVisibilityConcerns;
  final List<String> publicReviewsIdentified;
  final String civicDutyQuestion;
  final List<String> civicDutyApproach;
  final List<String> closingNotes;
  final List<ComparisonSourceLink> sourceLinks;
}

class ComparisonCostRow {
  const ComparisonCostRow({required this.item, required this.amount});

  final String item;
  final String amount;
}

class ComparisonSourceLink {
  const ComparisonSourceLink({required this.label, required this.url});

  final String label;
  final String url;
}
