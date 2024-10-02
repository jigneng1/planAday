import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plan_a_day/src/screens/create_plan_screen.dart';
import 'package:plan_a_day/src/screens/home_screen.dart';
import 'package:network_image_mock/network_image_mock.dart';

void main() {
  setUpAll(() {
    print("setUpAll");
  });

  setUp(() {
    print("setUp");
  });

  tearDownAll(() {
    print("tearDownAll");
  });

  tearDown(() {
    print("tearDown");
  });
  group('HomeScreen Widget Test', () {
    // Mock data for all plans and ongoing plan
    final allPlans = [
      {
        'selectedPlaces': {
          'place1': {'photosUrl': 'http://example.com/image1.png'},
        },
        'planName': 'Trip to the mountains',
        'category': ['Adventure', 'Hiking'],
        'numberOfPlaces': 3,
      },
      {
        'selectedPlaces': {
          'place2': {'photosUrl': 'http://example.com/image2.png'},
        },
        'planName': 'Beach Holiday',
        'category': ['Relaxation', 'Beach'],
        'numberOfPlaces': 5,
      },
    ];

    final ongoingPlanID = 'plan_1';
    final planData = {
      'selectedPlaces': {
        'place1': {'photosUrl': 'http://example.com/image1.png'},
      },
      'planName': 'Ongoing Plan',
      'category': ['Adventure'],
      'numberOfPlaces': 3,
    };
    // Given When Then: Given Create Plan Button when it's clicked then go to create Plan Screen
    // Testing existence / Displayed may not necessarily for now
    testWidgets('Logo is displayed', (WidgetTester tester) async {
      // Create a testable widget
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: Center(
            child: Image.asset(
              'assets/images/Asset_14x.png',
              height: 50,
            ),
          ),
        ),
      ));

      // Ensure that the image is found
      final imageFinder = find.byType(Image);
      expect(imageFinder, findsOneWidget);

      // Ensure the image is visible
      expect(
          find.byWidgetPredicate(
            (widget) => widget is Image && widget.height == 50,
          ),
          findsOneWidget);
    });
    testWidgets('Existence: Verify elements on HomeScreen',
        (WidgetTester tester) async {
      await mockNetworkImagesFor(() async {
        // Pump the HomeScreen widget with mock data
        await tester.pumpWidget(MaterialApp(
          home: HomeScreen(
            onCreatePlan: () {}, // Mock function for creating plans
            onPlan: (String id) {}, // Mock function when a plan is selected
            allPlans: allPlans,
            ongoingPlanID:
                '', // Use an empty string to display "Create new plan"
            onGoingPlan: planData,
            onViewOngoingPlan:
                (String id) {}, // Mock function for viewing the ongoing plan
            onEndGoingPlan: () {}, // Mock function for ending the ongoing plan
          ),
        ));

        // Allow time for the widget to settle and fully render
        await tester.pumpAndSettle();

        // Print all the text in the current widget tree for debugging
        final allTextWidgets = find.byType(Text);
        final allTexts = tester
            .widgetList(allTextWidgets)
            .map((widget) => (widget as Text).data)
            .toList();
        print('Rendered Texts: $allTexts');

        // Try to find the "Create new plan" text widget
        final createPlanButtonFinder = find.text('Create new plan');

        // Ensure the "Create new plan" button is visible
        if (createPlanButtonFinder.evaluate().isNotEmpty) {
          await tester.ensureVisible(createPlanButtonFinder);
          expect(createPlanButtonFinder, findsOneWidget);
        } else {
          fail('The "Create new plan" button was not found.');
        }

        final createPlanButton = find.text('Create new plan');
        await tester.tap(createPlanButton);
        await tester.pump();
        expect(find.byType(CreatePlanScreen), findsOneWidget);

        // Check for partial text match for "Where you want to" (in case of small differences)
        expect(find.textContaining('Where you want to'), findsOneWidget);

        // Verify 'All Plans' heading is displayed
        expect(find.text('All Plans'), findsOneWidget);

        // Verify that a specific plan name is visible (from the mock plans)
        expect(find.text('Trip to the mountains'), findsOneWidget);
        expect(find.text('Beach Holiday'), findsOneWidget);

        // Verify that 'No recent plans' text is absent since there are plans in the list
        expect(find.text('No recent plans'), findsNothing);
      });
    });
  });
}
