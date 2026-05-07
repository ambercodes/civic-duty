import 'package:civic_duty/app.dart';
import 'package:civic_duty/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('renders Civic Duty landing shell', (tester) async {
    await tester.pumpWidget(const CivicDutyApp());

    expect(find.text('Civic Duty'), findsWidgets);
    expect(find.text('Signal -> Review -> Ratify -> Record'), findsOneWidget);
    expect(find.text('Open Dashboard'), findsOneWidget);
  });

  testWidgets('navigates from landing to dashboard', (tester) async {
    await tester.pumpWidget(const CivicDutyApp());

    await tester.ensureVisible(find.byIcon(Icons.assessment_outlined));
    await tester.tap(find.byIcon(Icons.assessment_outlined));
    await tester.pumpAndSettle();

    expect(find.text('Dashboard'), findsOneWidget);
    expect(find.text('Review Dossier'), findsOneWidget);
  });

  testWidgets('read confirmation blocks ratification until checked', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(routes: AppRoutes.routes, initialRoute: AppRoutes.dossier),
    );

    await tester.ensureVisible(find.text('Confirm Review'));
    await tester.tap(find.text('Confirm Review'));
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

  testWidgets('ratification selection enables public record view', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(routes: AppRoutes.routes, initialRoute: AppRoutes.ratify),
    );
    await tester.pumpAndSettle();

    final recordButton = find.widgetWithText(
      FilledButton,
      'View Civic Ratification Record',
    );
    expect(tester.widget<FilledButton>(recordButton).onPressed, isNull);

    await tester.tap(find.text('Ratify'));
    await tester.pumpAndSettle();
    expect(tester.widget<FilledButton>(recordButton).onPressed, isNotNull);

    await tester.tap(recordButton);
    await tester.pumpAndSettle();

    expect(find.text('Civic Ratification Record'), findsOneWidget);
    expect(find.text('CRR-2026-0001'), findsOneWidget);
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
}
