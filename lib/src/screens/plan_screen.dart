import 'dart:math';
import 'package:flutter/material.dart';
import 'components/place_card.dart'; // Import the custom card widget

class PlanScreen extends StatefulWidget {
  final Map<String, dynamic> planData;
  final VoidCallback onClose;
  final Function(Map<String, dynamic>) onEditPlan;

  const PlanScreen({super.key, required this.onClose, required this.planData, required this.onEditPlan});

  @override
  _PlanScreenState createState() => _PlanScreenState();
}

class _PlanScreenState extends State<PlanScreen> {
  List<Map<String, String>>? selectedPlaces;

  @override
  void initState() {
    super.initState();
    _initializePlan();
  }

  void _initializePlan() {
  // Use existing selected places if available, otherwise randomize
  if (widget.planData.containsKey('selectedPlaces')) {
    selectedPlaces = List<Map<String, String>>.from(widget.planData['selectedPlaces']);
  } else {
    selectedPlaces = _randomizePlaces(widget.planData['numberOfPlaces']);
    // Save the randomized places back to planData
    widget.planData['selectedPlaces'] = selectedPlaces;
  }
}


  List<Map<String, String>> _randomizePlaces(int numberOfPlaces) {
    final random = Random();
    final List<Map<String, String>> placeDetails = [
    {
      'imageUrl':
          'https://res.klook.com/images/fl_lossy.progressive,q_65/c_fill,w_1200,h_630/w_80,x_15,y_15,g_south_west,l_Klook_water_br_trans_yhcmh3/activities/hpfkrhkwxohgg8tdq9xe/%E0%B8%A3%E0%B9%89%E0%B8%B2%E0%B8%99%E0%B8%94%E0%B9%87%E0%B8%AD%E0%B8%81%20%E0%B8%AD%E0%B8%B4%E0%B8%99%20%E0%B8%97%E0%B8%B2%E0%B8%A7%E0%B8%99%E0%B9%8C%20(Dog%20In%20Town)%20%E0%B9%83%E0%B8%99%E0%B8%A2%E0%B9%88%E0%B8%B2%E0%B8%99%E0%B9%80%E0%B8%AD%E0%B8%81%E0%B8%A1%E0%B8%B1%E0%B8%A2%20(Ekkamai)%20%E0%B9%81%E0%B8%A5%E0%B8%B0%E0%B8%A2%E0%B9%88%E0%B8%B2%E0%B8%99%E0%B8%AD%E0%B8%B2%E0%B8%A3%E0%B8%B5%E0%B8%A2%E0%B9%8C%20(Ari).jpg',
      'title': 'Dog in Town Cafe',
      'subtitle': 'Popular | Cafe | Food and Drink',
    },
    {
      'imageUrl':
          'https://partyspacedesign.com/wp-content/uploads/2020/12/660D67D7-56B3-4513-ADB8-8F8D4F78F993.jpeg',
      'title': 'NANA Coffee Roasters',
      'subtitle': 'Cafe | Food and Drink',
    },
    {
      'imageUrl':
          'https://thethaiger.com/th/wp-content/uploads/2023/04/1-5.png',
      'title': 'Vinyl Museum',
      'subtitle': 'Museum',
    },
    {
      'imageUrl':
          'https://asianitinerary.com/wp-content/uploads/2023/03/76a579eae9477daabbb397e3d6eeb142.jpeg',
      'title': 'Bangkok Art and Culture Centre',
      'subtitle': 'Art | Museum',
    },
    // Add more details as needed
  ];
    
    return List.generate(numberOfPlaces, (_) => placeDetails[random.nextInt(placeDetails.length)]);
  }

  void _handleEditPlan() {
    final Map<String, dynamic> updatedPlanData = {
      'planName': widget.planData['planName'],
      'startTime': widget.planData['startTime'],
      'numberOfPlaces': widget.planData['numberOfPlaces'],
      'selectedPlaces': selectedPlaces,  // Use current selected places
    };

  widget.onEditPlan(updatedPlanData);
}


  @override
  Widget build(BuildContext context) {
    print('At plan Received plan data: ${widget.planData}');
    final primaryColor = Theme.of(context).primaryColor;

    // Check if selectedPlaces is not null and has places to display
  if (selectedPlaces == null) {
    return const Center(child: CircularProgressIndicator());
  }

  // Generate routing widgets based on the selected places
  List<Widget> routingWidgets = List.generate(selectedPlaces!.length, (index) {
    final details = selectedPlaces![index];
    final time = '${9 + index}:00 AM'; // Example time format

    return buildRouting(
      primaryColor,
      time,
      PlaceDetailCard(
        imageUrl: details['imageUrl']!,
        title: details['title']!,
        subtitle: details['subtitle']!,
      ),
      index == selectedPlaces!.length - 1, // Check if it's the last place
    );
  });

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.planData['planName'] ?? 'Plan',
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 24),
        ),
        backgroundColor: Colors.transparent,
        scrolledUnderElevation: 0,
        centerTitle: true,
        toolbarHeight: 80,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: widget.onClose,
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
                Icon(Icons.person, size: 25, color: primaryColor),
                const SizedBox(width: 10),
                const Text(
                  'Generated by  ',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const Text('John Doe', style: TextStyle(fontSize: 16)),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Icon(Icons.timer, size: 25, color: primaryColor),
                const SizedBox(width: 10),
                const Text(
                  'Time duration  ',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const Text(
                  '3 hours',
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Icon(Icons.calendar_today, size: 25, color: primaryColor),
                const SizedBox(width: 10),
                const Text(
                  'Start date  ',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const Text(
                  '22 August 2024',
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
            const SizedBox(height: 40),
            ...routingWidgets,
            const SizedBox(height: 50),
            const Row(
              children: [
                Icon(Icons.location_on, size: 30),
                SizedBox(width: 8),
                Text(
                  'Routing Path',
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
                LayoutBuilder(
                  builder: (context, constraints) {
                    double buttonWidth = constraints.maxWidth > 200
                        ? 90
                        : constraints.maxWidth * 0.4;

                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        OutlinedButton(
                          onPressed: () {
                            // Handle edit plan action
                            _handleEditPlan();
                          },
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: primaryColor, width: 2),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 0, vertical: 12),
                            child: SizedBox(
                              width: buttonWidth,
                              child: Center(
                                child: Text(
                                  'Edit Plan',
                                  style: TextStyle(
                                      color: primaryColor, fontSize: 14),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 20),
                        ElevatedButton(
                          onPressed: () {
                            // Handle regenerate action
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: primaryColor),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 12),
                            child: SizedBox(
                              width: buttonWidth,
                              child: const Center(
                                child: Text(
                                  'Regenerate',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 14),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 50),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget buildRouting(
      Color primaryColor, String time, Widget placeCard, bool isLast) {
    return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Column(
        children: [
          CircleAvatar(
            radius: 10,
            backgroundColor: primaryColor,
          ),
          Container(
            height: isLast ? 200 : 270, // Height of the vertical line
            width: 2,
            color: primaryColor,
          ),
        ],
      ),
      const SizedBox(width: 16), // Spacing between point and card
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              time,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            placeCard,
            const SizedBox(height: 16),
            if (!isLast) ...[
              const Row(
                children: [
                  Icon(Icons.directions_walk, size: 30, color: Colors.grey),
                  SizedBox(width: 5),
                  Text(
                    '10 mins',
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(width: 20),
                  Icon(Icons.directions_car, size: 30, color: Colors.grey),
                  SizedBox(width: 5),
                  Text(
                    '5 mins',
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              )
            ],
          ],
        ),
      ),
    ]);
  }
}
