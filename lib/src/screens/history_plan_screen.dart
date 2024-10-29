import 'package:flutter/material.dart';

class HistoryPlanScreen extends StatelessWidget {
  const HistoryPlanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        // title: const Text("History Plan"),
        backgroundColor: Colors.white,
      ),
      body: const Center(
        child: Text("History"),
      ),
    );
  }
}
