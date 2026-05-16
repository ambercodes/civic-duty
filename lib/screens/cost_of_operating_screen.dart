import 'package:flutter/material.dart';

import '../data/cost_of_operating_data.dart';
import '../models/cost_of_operating.dart';
import '../widgets/civic_layout.dart';

class CostOfOperatingScreen extends StatelessWidget {
  const CostOfOperatingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CivicLayout(
      title: 'Cost of Operating Independent Civic Infrastructure',
      subtitle:
          'A public note on visible labor, infrastructure, and stewardship behind independent civic software.',
      showHeroHeader: true,
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _WhyExistsSection(),
          SizedBox(height: 22),
          _SupportSection(),
          SizedBox(height: 22),
          _PublicInfrastructureLaborSection(),
          SizedBox(height: 22),
          _MarketLaborMethodologySection(),
          SizedBox(height: 22),
          _LaborSection(),
          SizedBox(height: 22),
          _OperatingExpenseSummarySection(summary: CostOfOperatingData.summary),
          SizedBox(height: 22),
          _OngoingDevelopmentNoticeSection(),
          SizedBox(height: 22),
          _OperationalCostsSection(),
          SizedBox(height: 22),
          _ComparisonArchiveSection(),
        ],
      ),
    );
  }
}

class _WhyExistsSection extends StatelessWidget {
  const _WhyExistsSection();

  @override
  Widget build(BuildContext context) {
    return CivicPanel(
      children: [
        Text(
          'Why This Page Exists',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 10),
        const Text(
          'Civic Duty was independently created to explore whether ordinary people could participate more directly and visibly in foundational constitutional review without relying entirely on opaque institutional processes or delegated political interpretation.',
        ),
        const SizedBox(height: 12),
        const Text(
          'The project was not commissioned, institutionally funded, or directed by any governing body.',
        ),
        const SizedBox(height: 12),
        const Text(
          'It emerged from the observation that many foundational constitutional questions, technological realities, and public governance concerns are rarely presented in a way that allows ordinary people to visibly examine, understand, and measure their own civic participation.',
        ),
        const SizedBox(height: 12),
        const Text(
          'Building independent civic infrastructure requires real labor, engineering, research, maintenance, hosting, and ongoing operational stewardship.',
        ),
        const SizedBox(height: 12),
        const Text(
          'This section exists to make those realities visible in a practical and understandable way.',
        ),
      ],
    );
  }
}

class _PublicInfrastructureLaborSection extends StatelessWidget {
  const _PublicInfrastructureLaborSection();

  @override
  Widget build(BuildContext context) {
    return CivicPanel(
      children: [
        Text(
          'Public Infrastructure Requires Real Labor',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 10),
        Text(
          'Civic Duty - Quick Project Overview',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        const Text(
          'Civic Duty is an independently developed public civic review website focused on foundational constitutional review, transparent civic participation, and publicly inspectable civic records.',
        ),
        const SizedBox(height: 12),
        const Text(
          'The project explores whether ordinary people can participate more visibly in constitutional review and civic accountability without relying entirely on opaque institutional systems or delegated political interpretation.',
        ),
        const SizedBox(height: 12),
        const Text('Current development includes:'),
        const SizedBox(height: 10),
        const _BulletList(
          items: [
            'constitutional review dossiers',
            'civic participation records',
            'foundational concern submission systems',
            'participation methodology',
            'public transparency infrastructure',
            'open-source civic architecture',
          ],
        ),
        const SizedBox(height: 12),
        const Text(
          'Civic Duty is currently developed and maintained without institutional funding.',
        ),
        const SizedBox(height: 12),
        Text(
          'Completed Through Phases 1-7:',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        const _BulletList(
          items: [
            'Completed Professional Labor Hours: 1,315 hrs',
            'Equivalent Market Labor Value: \$150,975',
          ],
        ),
        const SizedBox(height: 12),
        const Text(
          'The project remains actively under development and additional phases, infrastructure, and operational systems are still being built.',
        ),
        const SizedBox(height: 12),
        const Text('Public support may be used for:'),
        const SizedBox(height: 10),
        const _BulletList(
          items: [
            'development',
            'infrastructure',
            'hosting',
            'research',
            'maintenance',
            'continued operational stewardship',
          ],
        ),
        const SizedBox(height: 12),
        Text(
          'ADA Support Address:',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        const Text('[PLACEHOLDER ADA ADDRESS]'),
        const SizedBox(height: 18),
        const Text(
          'Large institutional software systems often distribute responsibilities across:',
        ),
        const SizedBox(height: 10),
        const _BulletList(
          items: [
            'multiple departments',
            'salaried teams',
            'contractors',
            'agencies',
            'legal staff',
            'infrastructure vendors',
            'publicly funded operational budgets',
          ],
        ),
        const SizedBox(height: 12),
        const Text(
          'Independent civic infrastructure projects frequently compress many of those responsibilities into a much smaller operational footprint.',
        ),
        const SizedBox(height: 12),
        const Text(
          'Civic Duty is currently being independently developed and maintained without institutional sponsorship.',
        ),
        const SizedBox(height: 12),
        const Text(
          'The labor estimates below are intended to help make otherwise invisible civic infrastructure work more understandable and publicly inspectable.',
        ),
      ],
    );
  }
}

class _MarketLaborMethodologySection extends StatelessWidget {
  const _MarketLaborMethodologySection();

  @override
  Widget build(BuildContext context) {
    return CivicPanel(
      children: [
        Text(
          'Equivalent Market Labor Methodology',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 10),
        const Text(
          'The labor estimates displayed within Civic Duty are intended to represent approximate market-equivalent professional labor across multiple specialized roles involved in designing, engineering, researching, documenting, and operating independent civic infrastructure.',
        ),
        const SizedBox(height: 12),
        const Text(
          'These estimates are not intended as invoices, salary demands, or fundraising targets.',
        ),
        const SizedBox(height: 12),
        const Text(
          'The figures are derived using publicly observable U.S. professional market ranges for comparable work categories, adjusted for:',
        ),
        const SizedBox(height: 10),
        const _BulletList(
          items: [
            'approximately 10 years of professional development experience',
            'full-stack software engineering responsibilities',
            'systems architecture responsibilities',
            'infrastructure and deployment work',
            'UI/UX design responsibilities',
            'technical documentation',
            'constitutional/civic methodology research',
          ],
        ),
        const SizedBox(height: 12),
        const Text(
          'Estimated labor values represent equivalent professional market value, not necessarily realized compensation.',
        ),
      ],
    );
  }
}

class _OperatingExpenseSummarySection extends StatelessWidget {
  const _OperatingExpenseSummarySection({required this.summary});

  final CostOfOperatingSummary summary;

  @override
  Widget build(BuildContext context) {
    return CivicPanel(
      children: [
        Text(
          'Current Completed Equivalent Labor Summary',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 14),
        _OverviewGrid(
          children: [
            _OverviewTile(
              label: 'Estimated Completed Professional Labor Hours',
              value: summary.estimatedDevelopmentHours,
            ),
            _OverviewTile(
              label: 'Estimated Completed Market-Equivalent Labor Value',
              value: summary.estimatedLaborValue,
            ),
            _OverviewTile(
              label: 'Visible infrastructure costs',
              value: summary.visibleInfrastructureCosts,
            ),
            _OverviewTile(
              label: 'Total public support received',
              value: summary.totalPublicSupportReceived,
            ),
            _OverviewTile(
              label: 'Operational status',
              value: summary.operationalStatus,
            ),
            _OverviewTile(
              label: 'Last updated',
              value: summary.lastUpdatedDate,
            ),
          ],
        ),
      ],
    );
  }
}

class _OverviewGrid extends StatelessWidget {
  const _OverviewGrid({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isNarrow = constraints.maxWidth < 720;

        if (isNarrow) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (var index = 0; index < children.length; index++) ...[
                children[index],
                if (index != children.length - 1) const SizedBox(height: 12),
              ],
            ],
          );
        }

        return Column(
          children: [
            for (var index = 0; index < children.length; index += 2) ...[
              IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(child: children[index]),
                    const SizedBox(width: 12),
                    if (index + 1 < children.length)
                      Expanded(child: children[index + 1])
                    else
                      const Expanded(child: SizedBox.shrink()),
                  ],
                ),
              ),
              if (index + 2 < children.length) const SizedBox(height: 12),
            ],
          ],
        );
      },
    );
  }
}

class _OverviewTile extends StatelessWidget {
  const _OverviewTile({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).dividerColor),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: textTheme.titleMedium),
            const SizedBox(height: 6),
            Text(value, style: textTheme.bodyMedium),
          ],
        ),
      ),
    );
  }
}

class _LaborSection extends StatelessWidget {
  const _LaborSection();

  @override
  Widget build(BuildContext context) {
    return CivicPanel(
      children: [
        Text(
          'Current Estimated Equivalent Labor (Completed Through Phases 1-7)',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 16),
        for (final category in CostOfOperatingData.laborCategories) ...[
          LaborCategoryCard(category: category),
          if (category != CostOfOperatingData.laborCategories.last)
            const SizedBox(height: 12),
        ],
      ],
    );
  }
}

class LaborCategoryCard extends StatelessWidget {
  const LaborCategoryCard({super.key, required this.category});

  final LaborCategorySummary category;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return SizedBox(
      width: double.infinity,
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: Border.all(color: Theme.of(context).dividerColor),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(category.category, style: textTheme.titleLarge),
              const SizedBox(height: 8),
              Text('Estimated Hours: ${category.estimatedHours}'),
              Text(
                'Estimated Market Equivalent: ${category.estimatedLaborValue}',
              ),
              const SizedBox(height: 10),
              Text('Includes:', style: textTheme.titleMedium),
              const SizedBox(height: 6),
              _BulletList(items: category.includes),
            ],
          ),
        ),
      ),
    );
  }
}

class _SupportSection extends StatelessWidget {
  const _SupportSection();

  @override
  Widget build(BuildContext context) {
    return CivicPanel(
      children: [
        Text('Public Support', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 10),
        const Text('Civic Duty is currently independently funded.'),
        const SizedBox(height: 10),
        const Text(
          'However, if anyone wishes to contribute toward the realistic operational costs, labor, infrastructure, or continued development of the project, public support may be provided through the Civic Duty ADA support address below.',
        ),
        const SizedBox(height: 10),
        const Text('Public support does not purchase:'),
        const SizedBox(height: 10),
        const _BulletList(
          items: [
            'governance authority',
            'civic weighting',
            'institutional influence',
            'preferential treatment within Civic Duty records or participation systems',
          ],
        ),
        const SizedBox(height: 12),
        const Text(
          'Support is treated as voluntary public stewardship of independent civic infrastructure.',
        ),
        const SizedBox(height: 16),
        for (final entry in CostOfOperatingData.supportEntries)
          PublicSupportCard(entry: entry),
      ],
    );
  }
}

class PublicSupportCard extends StatelessWidget {
  const PublicSupportCard({super.key, required this.entry});

  final PublicSupportEntry entry;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return SizedBox(
      width: double.infinity,
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: Border.all(color: Theme.of(context).dividerColor),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(entry.supportType, style: textTheme.titleLarge),
              const SizedBox(height: 8),
              Text(entry.amount),
              if (entry.transactionHash != null)
                Text('Transaction: ${entry.transactionHash}'),
              if (entry.explorerLink != null)
                Text('Explorer: ${entry.explorerLink}'),
              if (entry.message != null) ...[
                const SizedBox(height: 8),
                Text(entry.message!),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _OperationalCostsSection extends StatelessWidget {
  const _OperationalCostsSection();

  @override
  Widget build(BuildContext context) {
    return CivicPanel(
      children: [
        Text(
          'Operational Costs',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 10),
        const Text(
          'Independent civic infrastructure also requires ongoing operational costs, including:',
        ),
        const SizedBox(height: 10),
        const _BulletList(
          items: [
            'hosting',
            'domains',
            'APIs',
            'infrastructure',
            'software tooling',
            'deployment systems',
            'storage',
            'maintenance services',
          ],
        ),
        const SizedBox(height: 12),
        const Text(
          'These costs are practical realities of operating public software systems.',
        ),
        const SizedBox(height: 16),
        for (final cost in CostOfOperatingData.operationalCosts) ...[
          OperationalCostCard(cost: cost),
          if (cost != CostOfOperatingData.operationalCosts.last)
            const SizedBox(height: 12),
        ],
      ],
    );
  }
}

class OperationalCostCard extends StatelessWidget {
  const OperationalCostCard({super.key, required this.cost});

  final OperationalCostEntry cost;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return SizedBox(
      width: double.infinity,
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: Border.all(color: Theme.of(context).dividerColor),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(cost.category, style: textTheme.titleLarge),
              const SizedBox(height: 8),
              Text('Amount: ${cost.amount}'),
              Text('Date: ${cost.date}'),
              const SizedBox(height: 8),
              Text(cost.explanation),
              if (cost.referenceLink != null) ...[
                const SizedBox(height: 8),
                Text('Reference: ${cost.referenceLink}'),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _OngoingDevelopmentNoticeSection extends StatelessWidget {
  const _OngoingDevelopmentNoticeSection();

  @override
  Widget build(BuildContext context) {
    return CivicPanel(
      children: [
        Text(
          'Ongoing Development Notice',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 10),
        const Text(
          'The figures above represent estimated equivalent labor value for work completed through Phases 1-7 of the Civic Duty project.',
        ),
        const SizedBox(height: 12),
        const Text('As Civic Duty continues to evolve through:'),
        const SizedBox(height: 10),
        const _BulletList(
          items: [
            'additional development phases',
            'infrastructure expansion',
            'public archive systems',
            'AI-assisted accessibility systems',
            'contributor tooling',
            'export systems',
            'verification expansion',
            'operational maintenance',
          ],
        ),
        const SizedBox(height: 12),
        const Text(
          'the estimated labor hours, operational costs, and equivalent market value figures will continue to update over time.',
        ),
      ],
    );
  }
}

class _ComparisonArchiveSection extends StatelessWidget {
  const _ComparisonArchiveSection();

  @override
  Widget build(BuildContext context) {
    return CivicPanel(
      children: [
        Text(
          'Civic Software Comparison Archive',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 10),
        const Text(
          'Civic Duty may also include public-source comparisons involving publicly funded software initiatives, operational timelines, or transparency visibility where reliable public information exists.',
        ),
        const SizedBox(height: 12),
        const Text(
          'The purpose of these comparisons is not partisan hostility.',
        ),
        const SizedBox(height: 12),
        const Text(
          'The purpose is civic examination, public visibility, and operational comparison between different approaches to civic infrastructure development.',
        ),
        const SizedBox(height: 12),
        const Text('All comparison entries are intended to remain:'),
        const SizedBox(height: 10),
        const _BulletList(
          items: [
            'evidence-based',
            'citation-oriented',
            'non-partisan',
            'publicly inspectable',
          ],
        ),
        const SizedBox(height: 16),
        for (final article in CostOfOperatingData.comparisonArticles) ...[
          CivicComparisonCard(article: article),
          if (article != CostOfOperatingData.comparisonArticles.last)
            const SizedBox(height: 12),
        ],
      ],
    );
  }
}

class CivicComparisonCard extends StatelessWidget {
  const CivicComparisonCard({super.key, required this.article});

  final CivicComparisonArticle article;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return SizedBox(
      width: double.infinity,
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: Border.all(color: Theme.of(context).dividerColor),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(article.title, style: textTheme.titleLarge),
              const SizedBox(height: 8),
              Text(article.summary),
              const SizedBox(height: 12),
              Text(article.purpose),
              const SizedBox(height: 18),
              Text(
                'Publicly Reported Cost Growth',
                style: textTheme.titleMedium,
              ),
              const SizedBox(height: 10),
              _ComparisonCostTable(rows: article.costRows),
              const SizedBox(height: 12),
              for (final note in article.costGrowthNote) ...[
                Text(note),
                const SizedBox(height: 10),
              ],
              Text(
                'What the Software Was Intended to Do',
                style: textTheme.titleMedium,
              ),
              const SizedBox(height: 10),
              const Text(
                'HealthCare.gov was not merely a public informational website.',
              ),
              const SizedBox(height: 10),
              const Text('The platform was intended to support:'),
              const SizedBox(height: 8),
              _BulletList(items: article.intendedToSupport),
              const SizedBox(height: 10),
              const Text('This required:'),
              const SizedBox(height: 8),
              _BulletList(items: article.requiredComplexity),
              const SizedBox(height: 14),
              Text('Public Visibility Concerns', style: textTheme.titleMedium),
              const SizedBox(height: 10),
              const Text(
                'From the perspective of ordinary citizens, much of the project structure was difficult to inspect in real time.',
              ),
              const SizedBox(height: 10),
              const Text('The public generally could not clearly see:'),
              const SizedBox(height: 8),
              _BulletList(items: article.publicVisibilityConcerns),
              const SizedBox(height: 10),
              const Text('Public reviews later identified:'),
              const SizedBox(height: 8),
              _BulletList(items: article.publicReviewsIdentified),
              const SizedBox(height: 14),
              Text(
                'Why This Matters for Civic Duty',
                style: textTheme.titleMedium,
              ),
              const SizedBox(height: 10),
              const Text(
                'Civic Duty uses this comparison to explore a broader public infrastructure question:',
              ),
              const SizedBox(height: 8),
              Text(article.civicDutyQuestion),
              const SizedBox(height: 10),
              const Text(
                'Civic Duty takes a different approach by making its own structure publicly visible from the beginning through:',
              ),
              const SizedBox(height: 8),
              _BulletList(items: article.civicDutyApproach),
              const SizedBox(height: 10),
              for (final note in article.closingNotes) ...[
                Text(note),
                const SizedBox(height: 10),
              ],
              const SizedBox(height: 8),
              Text('Works Cited', style: textTheme.titleMedium),
              const SizedBox(height: 6),
              for (var index = 0; index < article.sourceLinks.length; index++)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(
                    '${index + 1}. ${article.sourceLinks[index].label}\n${article.sourceLinks[index].url}',
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ComparisonCostTable extends StatelessWidget {
  const _ComparisonCostTable({required this.rows});

  final List<ComparisonCostRow> rows;

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme.bodyMedium;
    final headerStyle = textStyle?.copyWith(fontWeight: FontWeight.w700);

    return Table(
      columnWidths: const {0: FlexColumnWidth(1.4), 1: FlexColumnWidth(1)},
      border: TableBorder.all(
        color: Theme.of(context).dividerColor,
        borderRadius: BorderRadius.circular(8),
      ),
      children: [
        TableRow(
          children: [
            _TableCell('Item', style: headerStyle),
            _TableCell('Publicly Reported Amount', style: headerStyle),
          ],
        ),
        for (final row in rows)
          TableRow(
            children: [
              _TableCell(row.item, style: textStyle),
              _TableCell(row.amount, style: textStyle),
            ],
          ),
      ],
    );
  }
}

class _TableCell extends StatelessWidget {
  const _TableCell(this.text, {this.style});

  final String text;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Text(text, style: style),
    );
  }
}

class _BulletList extends StatelessWidget {
  const _BulletList({required this.items});

  final List<String> items;

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme.bodyMedium;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final item in items)
          Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('• ', style: textStyle),
                Expanded(child: Text(item, style: textStyle)),
              ],
            ),
          ),
      ],
    );
  }
}
