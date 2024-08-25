import 'package:flutter/material.dart';
import 'components/place_card.dart'; // Import the custom card widget

class PlanScreen extends StatelessWidget {
  const PlanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Plan name', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 24),),
        backgroundColor: Colors.white,
        centerTitle: true,
        toolbarHeight: 80,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.calendar_today, size: 30),
                SizedBox(width: 10),
                Text(
                  'Plan Date: 25th August 2024',
                  style: TextStyle(fontSize: 18),
                ),
              ],
            ),
            const SizedBox(height: 10),
            const Row(
              children: [
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
            // PlaceDetailCard example
            PlaceDetailCard(
              imageUrl: 'https://picsum.photos/id/42/3456/2304',
              title: 'Visit the Basketball Court',
              subtitle: 'Enjoy a game of basketball with friends.',
            ),
            const SizedBox(height: 10),
            PlaceDetailCard(
              imageUrl: 'https://picsum.photos/id/163/3456/2304',
              title: 'Have a Coffee at the Local Cafe',
              subtitle: 'Relax and enjoy a coffee break.',
            ),
            const SizedBox(height: 10),
            PlaceDetailCard(
              imageUrl: 'https://picsum.photos/id/180/3456/2304',
              title: 'Explore the Art Museum',
              subtitle: 'Discover beautiful art exhibits.',
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
