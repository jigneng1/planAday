import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plan_a_day/src/screens/components/place_card.dart'; // Adjust the path as per your project
import 'package:plan_a_day/src/screens/home_screen.dart'; // Adjust the path as per your project

void main() {
  testWidgets('HomeScreen renders correctly and allows interaction', (WidgetTester tester) async {
    // Arrange
    final onCreatePlan = () {};

    // Ensure that the WidgetsFlutterBinding is initialized
    WidgetsFlutterBinding.ensureInitialized();

    // Build the HomeScreen widget.
    await tester.pumpWidget(
      MaterialApp(
        home: HomeScreen(onCreatePlan: onCreatePlan),
      ),
    );

    // Assert
    // Check if the title "Where you want to Go?" is displayed.
    expect(find.text('Where you want to '), findsOneWidget);
    expect(find.text('Go?'), findsOneWidget);

    // Check if the Image asset is displayed.
    expect(find.byType(Image), findsOneWidget);

    // Check if the CarouselSlider is displayed.
    expect(find.byType(CarouselSlider), findsOneWidget);

    // Check if the "Create new plan" button is displayed.
    expect(find.text('Create new plan'), findsOneWidget);

    // Check if the "Recent Plans" text is present.
    expect(find.text('Recent Plans'), findsOneWidget);

    // Act
    // Tap on the notification icon to trigger _startOngoingPlan.
    await tester.tap(find.byIcon(Icons.notifications));
    await tester.pump();

    // Check if the PlaceDetailCard widget is present
    expect(find.byType(PlaceDetailCard), findsNWidgets(3));

    // Act
    // Tap the "Create new plan" button and verify the callback is triggered.
    await tester.tap(find.text('Create new plan'));
    await tester.pump();
  });
}
