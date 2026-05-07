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

    await tester.tap(find.byIcon(Icons.assessment_outlined));
    await tester.pumpAndSettle();

    expect(find.text('Dashboard'), findsOneWidget);
    expect(find.text('Review Dossier'), findsOneWidget);
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
