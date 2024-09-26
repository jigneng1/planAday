import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plan_a_day/main.dart'; // Your main app file
import 'package:plan_a_day/src/screens/home_screen.dart';
import 'package:plan_a_day/src/screens/persona_screen.dart';
import 'package:plan_a_day/src/app.dart';
import 'package:network_image_mock/network_image_mock.dart';

void main() {
  group('MainLayout Widget Test', () {
    // Test case: Verify the existence of BottomAppBar and HomeScreen as default
    testWidgets(
        'Existence: BottomAppBar in MainLayout and HomeScreen by default',
        (WidgetTester tester) async {
      await mockNetworkImagesFor(() async {
        // Pump the MainLayout widget
        await tester.pumpWidget(
          const MaterialApp(
            home: MainLayout(),
          ),
        );

        // Ensure HomeScreen is shown by default
        expect(find.byType(HomeScreen), findsOneWidget);
        expect(find.byType(BottomAppBar), findsOneWidget);
      });
    });

    // Test case: FloatingActionButton and Icons in BottomAppBar
    testWidgets('Action: FloatingActionButton and BottomAppBar interaction',
        (WidgetTester tester) async {
      await mockNetworkImagesFor(() async {
        // Pump the main app widget
        await tester.pumpWidget(const MyApp());

        // Trigger a frame after the widget has been built
        await tester.pump();

        // Verify the FloatingActionButton with icon size and add icon
        expect(
            find.byWidgetPredicate((widget) =>
                widget is FloatingActionButton &&
                (widget.child as Icon).icon == Icons.add &&
                (widget.child as Icon).size == 40.0),
            findsOneWidget);

        // Verify the home icon in BottomAppBar is selected (colored orange)
        expect(
            find.byWidgetPredicate((widget) =>
                widget is Icon &&
                widget.icon == Icons.home_filled &&
                widget.color == Colors.orange.shade900),
            findsOneWidget);

        // Verify the profile icon in BottomAppBar is not selected (colored grey)
        expect(
            find.byWidgetPredicate((widget) =>
                widget is Icon &&
                widget.icon == Icons.person &&
                widget.color == Colors.grey.shade400),
            findsOneWidget);

        // Test navigation by tapping on icons
        await tester.tap(find.byIcon(Icons.home_filled));
        await tester.pumpAndSettle();
        expect(find.byType(HomeScreen), findsOneWidget);

        // Tap on the Profile icon and ensure ProfileScreen is displayed
        await tester.tap(find.byIcon(Icons.person));
        await tester.pumpAndSettle();
        expect(find.byType(PersonaScreen), findsOneWidget);
      });
    });
  });
}
