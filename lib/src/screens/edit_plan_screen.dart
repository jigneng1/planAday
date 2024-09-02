import 'dart:math';

import 'package:flutter/material.dart';
import 'components/place_card.dart'; // Import the custom card widget

class EditPlanScreen extends StatefulWidget {
  final Map<String, dynamic> planData;
  final VoidCallback onClose;
  final Function(Map<String, dynamic>) onDone;

  const EditPlanScreen({
    super.key,
    required this.onClose,
    required this.planData,
    required this.onDone,
  });

  @override
  _PlanScreenState createState() => _PlanScreenState();
}

class _PlanScreenState extends State<EditPlanScreen> {
  late Map<String, dynamic> updatedPlan;

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
  ];

  @override
  void initState() {
    super.initState();
    // Initialize updatedPlan with current planData
    updatedPlan = Map<String, dynamic>.from(widget.planData);
  }

  void _editPlanName() async {
    final newPlanName = await showDialog<String>(
      context: context,
      builder: (context) {
        final TextEditingController controller = TextEditingController(
          text: updatedPlan['planName'] ?? '',
        );
        return AlertDialog(
          title: Text('Edit Plan Name'),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(hintText: 'Enter new plan name'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context, controller.text);
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );

    if (newPlanName != null) {
      setState(() {
        updatedPlan['planName'] = newPlanName;
      });
    }
  }

  void _editStartTime() async {
    final TimeOfDay? newTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(
        DateTime.parse(
            updatedPlan['startTime'] ?? DateTime.now().toIso8601String()),
      ),
    );

    if (newTime != null) {
      final String newStartTime =
          '${newTime.hour}:${newTime.minute.toString().padLeft(2, '0')}';
      setState(() {
        updatedPlan['startTime'] = newStartTime;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    // Extract selected places from planData
    final selectedPlaces =
        updatedPlan['selectedPlaces'] as List<dynamic>? ?? [];

    List<Widget> routingWidgets = List.generate(selectedPlaces.length, (index) {
      final details = selectedPlaces[index];
      final time = '${9 + index}:00 AM'; // Example time format

      return buildRouting(
        primaryColor,
        time,
        PlaceDetailCard(
          imageUrl: details['imageUrl']!,
          title: details['title']!,
          subtitle: details['subtitle']!,
        ),
        index == selectedPlaces.length - 1, // Check if it's the last place
        index, // Pass index to buildRouting
      );
    });

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Expanded(
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  updatedPlan['planName'] ?? 'Plan',
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 24,
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: _editPlanName,
            ),
          ],
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
                GestureDetector(
                  onTap: _editStartTime,
                  child: Text(
                    '${updatedPlan['startTime'] ?? 'N/A'}',
                    style: TextStyle(
                      fontSize: 16,
                      color: primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
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
                LayoutBuilder(
                  builder: (context, constraints) {
                    double buttonWidth = constraints.maxWidth > 200
                        ? 90
                        : constraints.maxWidth * 0.4;

                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        OutlinedButton(
                          onPressed: widget.onClose,
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: primaryColor, width: 2),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            child: SizedBox(
                              width: buttonWidth,
                              child: Center(
                                child: Text(
                                  'Cancel',
                                  style: TextStyle(
                                    color: primaryColor,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 20),
                        ElevatedButton(
                          onPressed: () {
                            widget.onDone(updatedPlan);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 18,
                              vertical: 12,
                            ),
                            child: SizedBox(
                              width: buttonWidth,
                              child: const Center(
                                child: Text(
                                  'Done',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                  ),
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
            ),
          ],
        ),
      ),
    );
  }

  Widget buildRouting(Color primaryColor, String time, Widget placeCard,
      bool isLast, int index) {
    // Fetch the current place data
    final place = updatedPlan['selectedPlaces'][index];

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
            Dismissible(
              key: ValueKey('${place['title']}_$index'), // Unique key
              direction: DismissDirection.endToStart, // Swipe direction
              onDismissed: (direction) {
                // Update state to remove the dismissed place
                setState(() {
                  updatedPlan['selectedPlaces'].removeAt(index);
                  updatedPlan['numberOfPlaces'] = updatedPlan['selectedPlaces']
                      .length; // Update the number of places
                });
              },
              background: Container(
                color: Colors.red,
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: const Icon(Icons.delete, color: Colors.white),
              ),
              child: placeCard,
            ),
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
        )),
      ],
    );
  }
}
