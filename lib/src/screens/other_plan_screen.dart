import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../../services/api_service.dart';
import './components/place_card.dart'; // Import the custom card widget

class SavePlanScreen extends StatefulWidget {
  final Map<String, dynamic> planData;
  final VoidCallback onClose;
  final String onGoingPlan;
  final Function(String placeID, String planID) onViewPlaceDetail;
  final Function(String planID) onStartPlan;
  final VoidCallback onStopPlan;

  const SavePlanScreen({
    super.key,
    required this.onClose,
    required this.planData,
    required this.onViewPlaceDetail,
    required this.onGoingPlan,
    required this.onStartPlan,
    required this.onStopPlan,
  });

  @override
  _SavePlanScreenState createState() => _SavePlanScreenState();
}

class _SavePlanScreenState extends State<SavePlanScreen> {
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
  // Check if planData contains selectedPlaces
  if (widget.planData.containsKey('selectedPlaces')) {
    // Convert the List of places into a Map with id as key
    List<dynamic> placesList = widget.planData['selectedPlaces'];
    selectedPlaces = {};
    
    for (var place in placesList) {
      // Use the place's id as the key and the entire place object as the value
      selectedPlaces![place['id']] = {
        'id': place['id'],
        'displayName': place['displayName'],
        'primaryType': place['primaryType'] ?? 'unknown',
        'shortFormattedAddress': place['shortFormattedAddress'],
        'photosUrl': place['photosUrl'],
      };
    }
    
    if (selectedPlaces!.isNotEmpty) {
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

  void handleStartPlan() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          child: Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                // Image at the top
                Image.asset('assets/images/undraw_Navigation_re_wxx4.png'),
                const SizedBox(height: 16),
                const Text(
                  'Are you ready to start the plan?',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 20),
                Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: ElevatedButton(
                      onPressed: () {
                        // Handle notifications enabling
                        Navigator.of(context).pop();
                        widget.onStartPlan(widget.planData['planID']);
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(50),
                        backgroundColor: const Color(0xFFFF6838),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),
                      child: const Text(
                        'Start the plan',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    )),
                const SizedBox(height: 15),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the dialog
                  },
                  child: const Text(
                    'Not now',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 16,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        );
      },
    );
  }

  void handleStopPlan() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          child: Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                // Image at the top
                Image.asset('assets/images/undraw_Coolness_re_sllr.png'),
                const SizedBox(height: 16),
                const Text(
                  'Are you sure you want to end this plan?',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 20),
                Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        widget.onStopPlan();
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(50),
                        backgroundColor: Colors.red,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),
                      child: const Text(
                        'End the plan',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    )),
                const SizedBox(height: 15),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the dialog
                  },
                  child: const Text(
                    'Not now',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 16,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        );
      },
    );
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          widget.planData['planName'] ?? 'Plan',
          style: const TextStyle(
              fontWeight: FontWeight.w600, fontSize: 24, color: Colors.white),
          overflow: TextOverflow.ellipsis,
        ),
        backgroundColor: primaryColor,
        scrolledUnderElevation: 0,
        centerTitle: true,
        toolbarHeight: 80,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: widget.onClose,
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.bookmark_border, color: Colors.white, size: 30,),
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Plan Information Container
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.15),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Duration Row
                  Row(
                    children: [
                      Icon(Icons.person, size: 25, color: primaryColor),
                      const SizedBox(width: 10),
                      const Text(
                        'Generated by:',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(width: 5),
                      Text(
                        'User',
                        style: TextStyle(fontSize: 16, color: primaryColor),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  Row(
                    children: [
                      Icon(Icons.timer, size: 25, color: primaryColor),
                      const SizedBox(width: 10),
                      const Text(
                        'Time Duration:',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(width: 5),
                      Text(
                        widget.planData['numberOfPlaces'] != null
                            ? '${widget.planData['numberOfPlaces']} hours'
                            : 'Unknown',
                        style: TextStyle(fontSize: 16, color: primaryColor),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  // Start Date Row
                  Row(
                    children: [
                      Icon(Icons.calendar_today, size: 25, color: primaryColor),
                      const SizedBox(width: 10),
                      const Text(
                        'Start Date:',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(width: 5),
                      Text(
                        widget.planData['startDate'] ?? 'Today',
                        style: TextStyle(fontSize: 16, color: primaryColor),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Routing Details Container
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.15),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ...routingWidgets,
                ],
              ),
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity, // Max width
              child: ElevatedButton(
                onPressed: () {
                  widget.onGoingPlan == widget.planData['planID']
                      ? handleStopPlan()
                      : handleStartPlan();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      widget.onGoingPlan != widget.planData['planID']
                          ? primaryColor
                          : Colors.red,
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  child: Center(
                    child: widget.onGoingPlan != widget.planData['planID']
                        ? const Text(
                            'Start the plan',
                            style: TextStyle(color: Colors.white, fontSize: 12),
                          )
                        : const Text(
                            'Stop the Plan',
                            style: TextStyle(color: Colors.white, fontSize: 12),
                          ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 80)
          ],
        ),
      ),
    );
  }

  Widget buildRouting(
    Color primaryColor,
    String time,
    Widget placeCard,
    bool isLast,
    Map<String, dynamic>? travelTime,
  ) {
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
              height:
                  isLast ? 170 : 250, // Adjusted height for consistent design
              width: 2.5,
              color: primaryColor,
            ),
          ],
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Time Display
              Text(
                time,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 10),

              placeCard,
              const SizedBox(height: 16),

              // Travel Time Display
              if (!isLast)
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.directions_walk,
                              size: 24, color: primaryColor),
                          const SizedBox(width: 5),
                          Text(
                            travelTime?['walking'] ?? 'Loading',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Icon(Icons.directions_car,
                              size: 24, color: primaryColor),
                          const SizedBox(width: 5),
                          Text(
                            travelTime?['driving'] ?? 'Loading',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
