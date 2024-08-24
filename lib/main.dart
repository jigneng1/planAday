import 'package:flutter/material.dart';
import 'package:plan_a_day/src/app.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PlanAday',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          useMaterial3: true,
          primaryColor: Colors.orange,
          primarySwatch: Colors.orange),
      home: const MainLayout(),
    );
  }
}
