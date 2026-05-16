import 'package:civic_duty/app.dart';
import 'package:civic_duty/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('renders Civic Duty landing shell', (tester) async {
    await tester.pumpWidget(const CivicDutyApp());

    expect(find.text('Civic Duty'), findsWidgets);
    expect(find.text('What Is Civic Duty?'), findsOneWidget);
    expect(find.text('How It Works'), findsOneWidget);
    expect(find.text('Open Civic Review'), findsWidgets);
    expect(find.text('Ready to Review?'), findsOneWidget);
    expect(find.text('Back to Top'), findsNothing);
  });

  testWidgets('navigates from landing to dashboard', (tester) async {
    await tester.pumpWidget(const CivicDutyApp());

    final topReviewButton = find.byIcon(Icons.assessment_outlined).first;
    await tester.ensureVisible(topReviewButton);
    await tester.tap(topReviewButton);
    await tester.pumpAndSettle();

    expect(find.text('Civic Review Dashboard'), findsOneWidget);
    expect(find.byType(Scaffold), findsOneWidget);
  });

  testWidgets('read confirmation blocks ratification until checked', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        routes: AppRoutes.routes,
        onGenerateRoute: AppRoutes.onGenerateRoute,
        initialRoute: AppRoutes.confirmReview,
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Read Confirmation'), findsOneWidget);

    final continueButton = find.widgetWithText(
      FilledButton,
      'Continue to Ratification',
    );
    expect(tester.widget<FilledButton>(continueButton).onPressed, isNull);

    await tester.tap(find.byType(CheckboxListTile).at(0));
    await tester.pump();
    expect(tester.widget<FilledButton>(continueButton).onPressed, isNull);

    await tester.tap(find.byType(CheckboxListTile).at(1));
    await tester.pump();
    expect(tester.widget<FilledButton>(continueButton).onPressed, isNotNull);
  });

  testWidgets('ratification route builds without mock data', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        routes: AppRoutes.routes,
        onGenerateRoute: AppRoutes.onGenerateRoute,
        initialRoute: AppRoutes.ratify,
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(Scaffold), findsOneWidget);
  });

  testWidgets('all initial routes build', (tester) async {
    for (final route in AppRoutes.routes.keys) {
      await tester.pumpWidget(
        MaterialApp(routes: AppRoutes.routes, initialRoute: route),
      );
      await tester.pumpAndSettle();

      expect(find.byType(Scaffold), findsOneWidget);
    }
  });

  testWidgets('phase 9 education routes render required headings', (
    tester,
  ) async {
    const expectedHeadings = {
      AppRoutes.whatIsCivicDuty: 'What Is Civic Duty?',
      AppRoutes.whatIsADossier: 'What Is a Dossier?',
      AppRoutes.ratificationMeaning: 'What Does Ratification Mean?',
      AppRoutes.verificationLevels: 'Verification Levels',
      AppRoutes.participationMethodology: 'Participation Methodology',
      AppRoutes.scopeBoundaries: 'Scope Boundaries',
      AppRoutes.sandboxDisclaimer: 'Sandbox Disclaimer',
      AppRoutes.costOfOperating:
          'Cost of Operating Independent Civic Infrastructure',
    };

    for (final entry in expectedHeadings.entries) {
      await tester.pumpWidget(
        MaterialApp(
          key: ValueKey(entry.key),
          routes: AppRoutes.routes,
          initialRoute: entry.key,
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text(entry.value), findsOneWidget);
      expect(find.byType(Scaffold), findsOneWidget);
    }
  });
}
