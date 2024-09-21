import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../services/api_service.dart';
import 'components/place_card.dart'; // Import the custom card widget

class PlanScreen extends StatefulWidget {
  final Map<String, dynamic> planData;
  final VoidCallback onClose;
  final VoidCallback onPlaceDetail;
  final Function(Map<String, dynamic>) onEditPlan;

  const PlanScreen({super.key, required this.onClose, required this.planData, required this.onEditPlan, required this.onPlaceDetail});

  @override
  _PlanScreenState createState() => _PlanScreenState();
}

class _PlanScreenState extends State<PlanScreen> {
  Map<String, dynamic>? selectedPlaces;
  List<Map<String, String>> travelTimes = [];
  final ApiService apiService = ApiService();

  @override
  void initState() {
    super.initState();
    _initializePlan();
  }

  void _initializePlan() {
    // Use existing selected places if available
    if (widget.planData.containsKey('selectedPlaces')) {
      selectedPlaces = Map<String, dynamic>.from(widget.planData['selectedPlaces']);
      if(selectedPlaces != null){
        getTimeTravel();
      }
    } else {
      selectedPlaces = {}; // Initialize with an empty map if not available
    }
  }

  void _handleEditPlan() {
    final Map<String, dynamic> updatedPlanData = {
      'planName': widget.planData['planName'],
      'startTime': widget.planData['startTime'],
      'startDate': widget.planData['startDate'],
      'numberOfPlaces': widget.planData['numberOfPlaces'],
      'planID': widget.planData['planID'],
      'selectedPlaces': selectedPlaces, 
    };
    widget.onEditPlan(updatedPlanData);
  }

  void _handleRegeneratePlan() async {
  setState(() {
    selectedPlaces = null; // Temporarily clear selectedPlaces to show loading
  });

  try {
    // Fetch the new plan data
    final plan = await apiService.getRandomPlaces(widget.planData['planID'], widget.planData['numberOfPlaces']);
    print('Fetched plan: $plan'); // Log the fetched plan

    if (plan != null && plan.isNotEmpty) {
      // Since the plan itself contains the places, use it as the selectedPlaces
      setState(() {
        selectedPlaces = Map<String, dynamic>.from(plan); // Use the entire plan as selected places
        getTimeTravel();
      });
      print('State updated with new selected places.');
    } else {
      // Handle empty response from the API
      print('API returned no plan.');
      setState(() {
        selectedPlaces = {}; // Fallback to an empty map
      });
    }
  } catch (e) {
    // Log any errors
    print('Error fetching new places: $e');
    setState(() {
      selectedPlaces = {}; // Fallback in case of error
    });
  }
}

  String formatType(String type) {
    return type
        .replaceAll('_', ' ')  
        .split(' ')
        .map((word) => word[0].toUpperCase() + word.substring(1))
        .join(' ');
  }

  void getTimeTravel() async{
    if(widget.planData['numberOfPlaces'] > 1){
      try {
        // Fetch the travel time data
        final placeId = selectedPlaces!.keys.toList();
        final travelTime = await apiService.getTimeTravel(placeId);
        print('Fetched travel time: $travelTime'); // Log the fetched travel time

        if (travelTime != null && travelTime.isNotEmpty) {
          // Handle the travel time data
          setState(() {
            travelTimes = travelTime; // Store the travel time data
          });
          print('Travel time data received successfully.');
        } else {
          // Handle empty response from the API
          print('API returned no travel time data.');
        }
      } catch (e) {
        // Log any errors
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
        startTime = DateFormat('HH:mm').parse(startTimeString); // Parse the time as a DateTime object
      } catch (e) {
        startTime = DateTime(2024, 1, 1, 9, 0);
        print('Error parsing start time: $e');
      }

      // Calculate the time for each place
      final placeTime = startTime.add(Duration(hours: routingWidgets.length));
      final time = DateFormat('h:mm a').format(placeTime);

      routingWidgets.add(buildRouting(
        primaryColor,
        time,
        PlaceDetailCard(
          imageUrl: details['photosUrl'] ?? '', 
          title: details['displayName'] ?? 'No Title', 
          type: formatType(details['primaryType']  ?? 'No Type'),  
          location: details['shortFormattedAddress'] ?? 'No Location', 
          placeID: details['id'] ?? 'No ID',    
        ),
        routingWidgets.length == selectedPlaces!.length - 1,
        routingWidgets.length < travelTimes.length ? travelTimes[routingWidgets.length] : null,
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
                const Text('User', style: TextStyle(fontSize: 16)),
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
                            _handleRegeneratePlan();
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
      Color primaryColor, String time, Widget placeCard, bool isLast, Map<String, dynamic>? travelTime) {
    return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Column(
        children: [
          CircleAvatar(
            radius: 10,
            backgroundColor: primaryColor,
          ),
          Container(
            height: isLast ? 180 : 270, // Height of the vertical line
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
            const SizedBox(height: 12),
            placeCard,
            const SizedBox(height: 16),
            if (!isLast) ...[
              Row(
                children: [
                  Icon(Icons.directions_walk, size: 30, color: Colors.grey),
                  SizedBox(width: 5),
                  Text(
                    travelTime?['walking'] ?? 'Loading',
                    style: const TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 20),
                  const Icon(Icons.directions_car, size: 30, color: Colors.grey),
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
