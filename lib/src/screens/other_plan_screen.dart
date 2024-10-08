import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../../services/api_service.dart';
import './components/place_card.dart'; // Import the custom card widget

class OtherPlanScreen extends StatefulWidget {
  final Map<String, dynamic> planData;
  final VoidCallback onClose;
  final Function(String placeID, String planID) onViewPlaceDetail;

  const OtherPlanScreen(
      {super.key,
      required this.onClose,
      required this.planData,
      required this.onViewPlaceDetail,
  });

  @override
  _OtherPlanScreenState createState() => _OtherPlanScreenState();
}

class _OtherPlanScreenState extends State<OtherPlanScreen> {
  Map<String, dynamic>? selectedPlaces;
  List<Map<String, String>> travelTimes = [];
  final ApiService apiService = ApiService();

  @override
  void initState() {
    super.initState();
    _initializePlan();
  }

  @override
  void dispose() {
    // Cancel any ongoing timers, streams, or other resources
    super.dispose();
  }

  void _initializePlan() {
    // Use existing selected places if available
    if (widget.planData.containsKey('selectedPlaces')) {
      selectedPlaces =
          Map<String, dynamic>.from(widget.planData['selectedPlaces']);
      if (selectedPlaces != null) {
        getTimeTravel();
      }
    } else {
      selectedPlaces = {}; // Initialize with an empty map if not available
    }
  }

  String formatType(String type) {
    return type
        .replaceAll('_', ' ')
        .split(' ')
        .map((word) => word[0].toUpperCase() + word.substring(1))
        .join(' ');
  }

  void getTimeTravel() async {
    if (widget.planData['numberOfPlaces'] > 1) {
      try {
        // Fetch the travel time data
        final placeId = selectedPlaces!.keys.toList();
        final travelTime = await apiService.getTimeTravel(placeId);
        print(
            'Fetched travel time: $travelTime'); // Log the fetched travel time

        if (travelTime.isNotEmpty) {
          // Check if the widget is still mounted before updating the state
          if (mounted) {
            setState(() {
              travelTimes = travelTime; // Store the travel time data
            });
          }
          print('Travel time data received successfully.');
        } else {
          print('API returned no travel time data.');
        }
      } catch (e) {
        print('Error fetching travel time data: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    print('At plan Received plan data: ${widget.planData}');
    final primaryColor = Theme.of(context).primaryColor;

    // Check if selectedPlaces is not null and has places to display
    if (selectedPlaces == null || selectedPlaces!.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    // Generate routing widgets based on the selected places
    List<Widget> routingWidgets = [];
    selectedPlaces!.forEach((key, details) {
      // Parse the startTime from 'HH:mm' format
      final startTimeString = widget.planData['startTime'];
      DateTime startTime;

      try {
        startTime = DateFormat('HH:mm')
            .parse(startTimeString); // Parse the time as a DateTime object
      } catch (e) {
        startTime = DateTime(2024, 1, 1, 9, 0);
        print('Error parsing start time: $e');
      }

      // Calculate the time for each place
      final placeTime = startTime.add(Duration(hours: routingWidgets.length));
      final time = DateFormat('h:mm a').format(placeTime);

      selectedPlaces![key]['time'] = time;

      routingWidgets.add(buildRouting(
        primaryColor,
        time,
        PlaceCard(
          planID: widget.planData['planID'],
          imageUrl: details['photosUrl'] ?? '',
          title: details['displayName'] ?? 'No Title',
          type: formatType(details['primaryType'] ?? 'No Type'),
          location: details['shortFormattedAddress'] ?? 'No Location',
          placeID: details['id'] ?? 'No ID',
          onViewPlaceDetail: widget.onViewPlaceDetail,
        ),
        routingWidgets.length == selectedPlaces!.length - 1,
        routingWidgets.length < travelTimes.length
            ? travelTimes[routingWidgets.length]
            : null,
      ));
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
            onPressed: () {},
            icon: const Icon(Icons.share),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Row(
            //   children: [
            //     Icon(Icons.person, size: 25, color: primaryColor),
            //     const SizedBox(width: 10),
            //     const Text(
            //       'Generated by  ',
            //       style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            //     ),
            //     const Text('User', style: TextStyle(fontSize: 16)),
            //   ],
            // ),
            // const SizedBox(height: 10),
            Row(
              children: [
                Icon(Icons.timer, size: 25, color: primaryColor),
                const SizedBox(width: 10),
                const Text(
                  'Time duration  ',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  widget.planData['numberOfPlaces'] != null
                      ? '${widget.planData['numberOfPlaces']!} hours'
                      : 'Unknown',
                  style: const TextStyle(fontSize: 16),
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
                Text(
                  widget.planData['startDate'] ?? 'Today',
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
            const SizedBox(height: 40),
            ...routingWidgets,
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }

  Widget buildRouting(Color primaryColor, String time, Widget placeCard,
      bool isLast, Map<String, dynamic>? travelTime) {
    return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Column(
        children: [
          CircleAvatar(
            radius: 10,
            backgroundColor: primaryColor,
          ),
          Container(
            height: isLast ? 180 : 250, // Height of the vertical line
            width: 3,
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
            const SizedBox(height: 12),
            placeCard,
            const SizedBox(height: 16),
            if (!isLast) ...[
              Row(
                children: [
                  const Icon(Icons.directions_walk,
                      size: 30, color: Colors.grey),
                  const SizedBox(width: 5),
                  Text(
                    travelTime?['walking'] ?? 'Loading',
                    style: const TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 20),
                  const Icon(Icons.directions_car,
                      size: 30, color: Colors.grey),
                  const SizedBox(width: 5),
                  Text(
                    travelTime?['driving'] ?? 'Loading',
                    style: const TextStyle(
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
