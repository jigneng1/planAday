import 'package:flutter/material.dart';

class PlanScreen extends StatelessWidget {
  const PlanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Plan'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Your Plan Summary',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            // Example of plan details
            Row(
              children: const [
                Icon(Icons.calendar_today, size: 30),
                SizedBox(width: 10),
                Text(
                  'Plan Date: 25th August 2024',
                  style: TextStyle(fontSize: 18),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: const [
                Icon(Icons.timer, size: 30),
                SizedBox(width: 10),
                Text(
                  'Start Time: 10:00 AM',
                  style: TextStyle(fontSize: 18),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              'Activities',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView(
                children: const [
                  ListTile(
                    leading: Icon(Icons.sports_basketball),
                    title: Text('Visit the Basketball Court'),
                  ),
                  ListTile(
                    leading: Icon(Icons.local_cafe),
                    title: Text('Have a coffee at the local cafe'),
                  ),
                  ListTile(
                    leading: Icon(Icons.museum),
                    title: Text('Explore the Art Museum'),
                  ),
                  // Add more activities here
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
