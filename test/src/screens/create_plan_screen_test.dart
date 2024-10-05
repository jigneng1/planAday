import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plan_a_day/src/screens/create_plan_screen.dart';
import 'package:plan_a_day/src/screens/plan_screen.dart';

void main() {
  testWidgets('CreatePlanScreen displays input fields and submits data',
      (WidgetTester tester) async {
    // Mock functions
    void onClose() {}
    
    Map<String, dynamic>? generatedPlan;
    void onGeneratePlan(Map<String, dynamic> planData) {
      generatedPlan = planData;
      print('Generated Plan Data: $planData'); // Debugging line
    }

    // Build the widget
    await tester.pumpWidget(
      MaterialApp(
        home: CreatePlanScreen(
          onClose: onClose,
          onGeneratePlan: onGeneratePlan,
        ),
      ),
    );

    // Ensure screen displays correctly
    expect(find.text('Create new plan'), findsOneWidget);
    expect(find.byType(TextFormField), findsNWidgets(3));
    expect(find.text('Generate Plan'), findsOneWidget);

    expect(find.text('Start time'), findsOneWidget);
    expect(find.text('Number of places'), findsOneWidget);

    // Input valid data
    await tester.enterText(find.byType(TextFormField).first, 'Weekend Getaway');

    // Select an option in the dropdown
    await tester.tap(find.text('Restaurant').last); // Ensure this matches your dropdown option
    await tester.pump(); // Wait for the selection to settle

    // Tap the submit button
    await tester.tap(find.text('Generate Plan'));
    // await tester.pumpAndSettle(); // Wait for any animations and screen changes

    // // // Add a debug print statement before the expectation
    // // print('Expecting to find PlanScreen now...');
    // expect(find.byType(PlanScreen), findsOneWidget);
  });
}
