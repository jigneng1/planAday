import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:plan_a_day/main.dart';
import 'package:plan_a_day/src/app.dart';
import 'package:plan_a_day/src/screens/home_screen.dart'; // Import your main app file

void main() {
  group('MainLayout Widget Test', () {
    //  await mockNetworkImagesFor(() async {}
    //Verify the existence of BottomAppBar
    testWidgets('Existence: BottomAppBar in MainLayout',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: MainLayout(),
        ),
      );

      // Find BottomAppBar
      expect(find.byType(BottomAppBar), findsOneWidget);
    });

    //Verify that HomeScreen is shown initially
    testWidgets('Display: HomeScreen (default)', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: MainLayout(),
        ),
      );

      // Find HomeScreen
      expect(find.byType(HomeScreen), findsOneWidget);
    });
expect(find.byType(HomeScreen), findsOneWidget);
    testWidgets('Action: FloatingActionButton and BottomAppBar',
        (WidgetTester tester) async {
      // Pump the main app widget into the widget tree
      await tester.pumpWidget(const MyApp());

      // Trigger a frame after the widget has been built
      await tester.pump();

      // Verify the FloatingActionButton
      expect(
          find.byWidgetPredicate((widget) =>
              widget is FloatingActionButton &&
              (widget.child as Icon).icon == Icons.add &&
              (widget.child as Icon).size == 40.0),
          findsOneWidget);

      // Verify the Icons in BottomAppBar
      expect(
          find.byWidgetPredicate((widget) =>
              widget is Icon &&
              widget.icon == Icons.home_filled &&
              widget.color == Colors.orange.shade900),
          findsOneWidget);

      expect(
          find.byWidgetPredicate((widget) =>
              widget is Icon &&
              widget.icon == Icons.person &&
              widget.color == Colors.grey.shade400),
          findsOneWidget);

      // Tap on icon selection
      await tester.tap(find.byIcon(Icons.home_filled));
      await tester.pump(); // Rebuild the widget tree after the tap

      expect(find.byType(HomeScreen), findsOneWidget);
    });
  });
}
