import 'package:flutter/material.dart';
import 'components/place_card.dart'; // Import the custom card widget

class PlanScreen extends StatelessWidget {
  final VoidCallback onClose;

  const PlanScreen({super.key, required this.onClose});

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Plan name',
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 24),
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
        toolbarHeight: 80,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
          ),
          onPressed: () {
            onClose();
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              // Handle share plan action
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.person, size: 30, color: primaryColor),
                const SizedBox(width: 10),
                const Text(
                  'Created by  ',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const Text('John Doe', style: TextStyle(fontSize: 18)),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Icon(Icons.timer, size: 30, color: primaryColor),
                const SizedBox(width: 10),
                const Text(
                  'Time duration  ',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const Text(
                  '3 hours',
                  style: TextStyle(fontSize: 18),
                ),
              ],
            ),
            const SizedBox(height: 50),
            buildRouting(
              primaryColor,
              '9:00 AM',
              PlaceDetailCard(
                imageUrl:
                    'https://res.klook.com/images/fl_lossy.progressive,q_65/c_fill,w_1200,h_630/w_80,x_15,y_15,g_south_west,l_Klook_water_br_trans_yhcmh3/activities/hpfkrhkwxohgg8tdq9xe/%E0%B8%A3%E0%B9%89%E0%B8%B2%E0%B8%99%E0%B8%94%E0%B9%87%E0%B8%AD%E0%B8%81%20%E0%B8%AD%E0%B8%B4%E0%B8%99%20%E0%B8%97%E0%B8%B2%E0%B8%A7%E0%B8%99%E0%B9%8C%20(Dog%20In%20Town)%20%E0%B9%83%E0%B8%99%E0%B8%A2%E0%B9%88%E0%B8%B2%E0%B8%99%E0%B9%80%E0%B8%AD%E0%B8%81%E0%B8%A1%E0%B8%B1%E0%B8%A2%20(Ekkamai)%20%E0%B9%81%E0%B8%A5%E0%B8%B0%E0%B8%A2%E0%B9%88%E0%B8%B2%E0%B8%99%E0%B8%AD%E0%B8%B2%E0%B8%A3%E0%B8%B5%E0%B8%A2%E0%B9%8C%20(Ari).jpg',
                title: 'Dog in Town Cafe',
                subtitle: 'Popular | Cafe | Food and Drink',
              ),
            ),
            buildRouting(
              primaryColor,
              '10:00 AM',
              PlaceDetailCard(
                imageUrl: 'https://picsum.photos/id/163/3456/2304',
                title: 'Coffee Cafe',
                subtitle: 'Cafe | Food and Drink',
              ),
            ),
            buildRouting(
              primaryColor,
              '11:00 AM',
              PlaceDetailCard(
                imageUrl: 'https://picsum.photos/id/180/3456/2304',
                title: 'Art Museum',
                subtitle: 'Museum',
              ),
            ),
            const SizedBox(height: 50),
            const Row(
              children: [
                Icon(Icons.location_on, size: 30),
                SizedBox(width: 8),
                Text(
                  'Map Routing',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              height: 220,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.grey.shade300,
              ),
              child: const Center(
                child: Icon(Icons.map, size: 100, color: Colors.grey),
              ),
            ),
            const SizedBox(height: 50),
            Column(
              children: [
                const Text('Want to adjust plan?',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey)),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    OutlinedButton(
                      onPressed: () {
                        // Handle edit plan action
                      },
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: primaryColor, width: 2),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 12),
                        child: Text(
                          'Edit Plan',
                          style: TextStyle(color: primaryColor, fontSize: 14),
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    ElevatedButton(
                      onPressed: () {
                        // Handle share plan action
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor),
                      child: const Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                        child: Text(
                          'Regenerate',
                          style: TextStyle(color: Colors.white, fontSize: 14),
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 50),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget buildRouting(Color primaryColor, String time, Widget placeCard) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            CircleAvatar(
              radius: 10,
              backgroundColor: primaryColor,
            ),
            Container(
              height: 220, // Height of the vertical line
              width: 2,
              color: primaryColor,
            ),
          ],
        ),
        const SizedBox(width: 16), // Spacing between point and card
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                time,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              placeCard,
            ],
          ),
        ),
      ],
    );
  }
}
