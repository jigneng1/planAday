import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../services/api_service.dart';
import '../../components/place_card.dart'; // Import the custom card widget

class GeneratedPlanScreen extends StatefulWidget {
  final Map<String, dynamic> planData;
  final VoidCallback onClose;
  final Function(String placeID, String planID) onViewPlaceDetail;
  final Function(Map<String, dynamic>) onEditPlan;
  final Function(Map<String, dynamic>) onRegeneratePlan;
  final Function(Map<String, dynamic>) onDone;


  const GeneratedPlanScreen(
      {super.key,
      required this.onClose,
      required this.planData,
      required this.onEditPlan,
      required this.onDone,
      required this.onViewPlaceDetail,
      required this.onRegeneratePlan});

  @override
  _GeneratedPlanScreenState createState() => _GeneratedPlanScreenState();
}

class _GeneratedPlanScreenState extends State<GeneratedPlanScreen> {
  List<Map<String, dynamic>>? selectedPlaces;
  List<Map<String, String>> travelTimes = [];
  final ApiService apiService = ApiService();

  @override
  void initState() {
    super.initState();
    _initializePlan();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _initializePlan() {
    // Use existing selected places if available
    if (widget.planData.containsKey('selectedPlaces')) {
      // Ensure that 'selectedPlaces' is a list
      if (widget.planData['selectedPlaces'] is List) {
        selectedPlaces =
            List<Map<String, dynamic>>.from(widget.planData['selectedPlaces']);
        getTimeTravel(); // Call to get travel times if places are selected
      } else {
        // Handle the case where 'selectedPlaces' is not a list
        print('selectedPlaces is not a List.');
        selectedPlaces = []; // Initialize with an empty list if not available
      }
    } else {
      selectedPlaces = []; // Initialize with an empty list if not available
    }
  }

  void _handleEditPlan() {
    final Map<String, dynamic> updatedPlanData = {
      'planName': widget.planData['planName'],
      'startTime': widget.planData['startTime'],
      'startDate': widget.planData['startDate'],
      'category': widget.planData['category'],
      'numberOfPlaces': widget.planData['numberOfPlaces'],
      'planID': widget.planData['planID'],
      'selectedPlaces': selectedPlaces,
    };
    widget.onEditPlan(updatedPlanData);
  }

  void _handleRegeneratePlan() async {
    bool confirmed = await showDialog(
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
                Image.asset('assets/images/undraw_Exciting_news_re_y1iw.png',
                    height: 250),
                const SizedBox(height: 16),
                const Text(
                  'Are you sure you want to regenerate the plan?',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.of(context).pop(true); // Confirm regeneration
                    },
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size.fromHeight(50),
                      side: BorderSide(
                          color: Theme.of(context).primaryColor,
                          width: 2), // Set border color to primaryColor
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                    child: Text(
                      'Regenerate the plan',
                      style: TextStyle(
                        color: Theme.of(context)
                            .primaryColor, // Set text color to primaryColor
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(false); // Cancel regeneration
                  },
                  child: const Text(
                    'No',
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

    // Proceed with regenerating the plan if confirmed
    if (confirmed == true) {
      setState(() {
        selectedPlaces =
            null; // Temporarily clear selectedPlaces to show loading
      });

      try {
        final plan = await apiService.getRandomPlaces(
            widget.planData['planID'], widget.planData['numberOfPlaces']);
        print('Fetched plan: $plan');

        if (plan != null && plan.isNotEmpty) {
          if (mounted) {
            setState(() {
              selectedPlaces = List<Map<String, dynamic>>.from(plan);
              getTimeTravel(); // Call the travel time fetching function
              Map<String, dynamic> planDetail = {
                'planName': widget.planData['planName'],
                'startTime': widget.planData['startTime'],
                'startDate': widget.planData['startDate'],
                'category': widget.planData['category'],
                'numberOfPlaces': widget.planData['numberOfPlaces'],
                'planID': widget.planData['planID'],
                'selectedPlaces': selectedPlaces,
              };
              widget.onRegeneratePlan(planDetail);
            });
          }
        } else {
          print('API returned no plan.');
          if (mounted) {
            setState(() {
              selectedPlaces = []; // Fallback to an empty map
            });
          }
        }
      } catch (e) {
        print('Error fetching new places: $e');
        if (mounted) {
          setState(() {
            selectedPlaces = []; // Fallback in case of error
          });
        }
      }
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
        // Extract place IDs from the selectedPlaces list and cast them to List<String>
        final placeIds = selectedPlaces
                ?.map((place) =>
                    place['id'] as String) // Explicitly cast to String
                .toList() ??
            [];

        // Fetch the travel time data
        final travelTime = await apiService.getTimeTravel(placeIds);
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

  void onBack(){
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
                Image.asset('assets/images/undraw_Throw_away_re_x60k.png'),
                const SizedBox(height: 16),
                const Text(
                  'The plan will be discarded. Are you sure you want to close this plan?',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 20),
                Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        widget.onClose();
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(50),
                        backgroundColor: Theme.of(context).primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),
                      child: const Text(
                        'Yes',
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
                    'No',
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

  void savePlan(){
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
                Image.asset('assets/images/undraw_Notify_re_65on.png'),
                const SizedBox(height: 16),
                const Text(
                  'If you click done, the plan cannot be edit anymore. Are you sure you want to save this plan?',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 20),
                Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        widget.onDone(widget.planData);
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(50),
                        backgroundColor: Theme.of(context).primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),
                      child: const Text(
                        'Yes',
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
                    'No',
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
    final startTimeString = widget.planData['startTime'];
    DateTime startTime;

    try {
      startTime = DateFormat('HH:mm')
          .parse(startTimeString); // Parse the time as a DateTime object
    } catch (e) {
      startTime = DateTime(2024, 1, 1, 9, 0);
      print('Error parsing start time: $e');
    }

// Iterate over the list of selected places
    for (int i = 0; i < selectedPlaces!.length; i++) {
      final details = selectedPlaces![i];

      // Calculate the time for each place
      final placeTime = startTime.add(Duration(hours: i));
      final time = DateFormat('h:mm a').format(placeTime);

      // Update the 'time' field in the current place details
      selectedPlaces![i]['time'] = time;

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
        i == selectedPlaces!.length - 1, // Check if it's the last item
        i < travelTimes.length ? travelTimes[i] : null,
      ));
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Column(
          children: [
            Text(
              widget.planData['planName'] ?? 'No Name',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 5),
            const Text(
              'Draft plan',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
          ],
        ),
        backgroundColor: Colors.transparent,
        scrolledUnderElevation: 0,
        centerTitle: true,
        toolbarHeight: 80,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black,size: 30,),
          onPressed: onBack,
        ),
        actions: [
          IconButton(
            onPressed: savePlan,
            icon: const Icon(Icons.check, color: Colors.black,size: 30,),
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.15),
                    spreadRadius: 1,
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
            LayoutBuilder(
              builder: (context, constraints) {
                double buttonWidth = constraints.maxWidth > 200
                    ? constraints.maxWidth
                    : constraints.maxWidth * 0.4;
                return Column(
                  children: [
                    const Text(
                      'Want to adjust plan?',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _handleRegeneratePlan,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primaryColor,
                            ),
                            child: const Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 12),
                              child: Center(
                                child: Text(
                                  'Regenerate',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 12),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: OutlinedButton(
                            onPressed: _handleEditPlan,
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(color: primaryColor, width: 2),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 0, vertical: 12),
                              child: Center(
                                child: Text(
                                  'Edit Plan',
                                  style: TextStyle(
                                      color: primaryColor, fontSize: 12),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 50),
                    // ElevatedButton(
                    //   onPressed: () {
                    //     savePlan();
                    //   },
                    //   style: ElevatedButton.styleFrom(
                    //     backgroundColor: primaryColor,
                    //   ),
                    //   child: Padding(
                    //     padding: const EdgeInsets.symmetric(
                    //         horizontal: 20, vertical: 12),
                    //     child: SizedBox(
                    //       width: buttonWidth,
                    //       child: const Center(
                    //         child: Text(
                    //                     'Done',
                    //                     style: TextStyle(
                    //                         color: Colors.white, fontSize: 12),
                    //                   )
                    //       ),
                    //     ),
                    //   ),
                    // ),
                  ],
                );
              },
            ),
            // const SizedBox(height: 50),
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
