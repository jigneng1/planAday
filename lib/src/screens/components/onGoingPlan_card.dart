import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class OngoingPlanWidget extends StatefulWidget {
  final String planID;
  final Map<String, dynamic> plan;
  final Function(String) onViewOngoingPlan;
  final VoidCallback onEndPlan;

  const OngoingPlanWidget({super.key, 
    required this.planID,
    required this.plan,
    required this.onViewOngoingPlan, required this.onEndPlan,
  });

  @override
  _OngoingPlanWidgetState createState() => _OngoingPlanWidgetState();
}

class _OngoingPlanWidgetState extends State<OngoingPlanWidget> {
  int currentIndex = 0;

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
                        widget.onEndPlan();
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
    List<Map<String, dynamic>> places = (widget.plan['selectedPlaces'] as List).cast<Map<String, dynamic>>();

    final startTimeString = widget.plan['startTime'];
    DateTime startTime;

    try {
      startTime = DateFormat('HH:mm')
          .parse(startTimeString); // Parse the time as a DateTime object
    } catch (e) {
      startTime = DateTime(2024, 1, 1, 9, 0);
      print('Error parsing start time: $e');
    }

// Iterate over the list of selected places
    for (int i = 0; i < places.length; i++) {
      final details = places[i];

      // Calculate the time for each place
      final placeTime = startTime.add(Duration(hours: i));
      final time = DateFormat('h:mm a').format(placeTime);

      // Update the 'time' field in the current place details
      places[i]['time'] = time;
    }
    
    // Function to launch the map with the current place
    Future<void> launchMapUrl() async {
      // Get the current place's display name
      String currentPlace = places[currentIndex]['displayName'];
      
      // Construct the Google Maps URL for the current place
      String baseUrl = 'https://www.google.co.th/maps/dir/My+Location/';
      String location = Uri.encodeComponent(currentPlace.replaceAll(' ', '+'));
      String url = baseUrl + location;

      final Uri googleMapsUrl = Uri.parse(url);
      if (await canLaunchUrl(googleMapsUrl)) {
        await launchUrl(googleMapsUrl);
      } else {
        throw 'Could not launch $googleMapsUrl';
      }
    }

    return Card(
      color: const Color.fromARGB(174, 255, 255, 255),
      margin: const EdgeInsets.fromLTRB(40, 80, 40, 30),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
      elevation: 10,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 30,
          vertical: 25,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Ongoing Plan', style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                )),
                Text(
              widget.plan['planName'] ?? 'Plan name',
              style: const TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1, 
            ),
                  ],
                ),
                IconButton(
                  onPressed: () {
                    launchMapUrl();
                  },
                  icon: const Icon(Icons.map, color: Colors.grey, size: 30,)
                ),
              ],
            ),
            const SizedBox(height: 15),
            if (places.isNotEmpty)
              Row(
                children: [
                  const Icon(
                    Icons.location_on,
                    size: 30,
                    color: Color(0xFFFF6838),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    // Ensures text stays within card boundaries
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          places[currentIndex]['displayName'] ?? 'No title',
                          style: const TextStyle( 
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFFF6838),
                            fontSize: 15,
                          ),
                          overflow:
                              TextOverflow.ellipsis, // Ellipsis for long text
                          maxLines: 1,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          places[currentIndex]['time'] ?? 'Unknown', // Add time if available
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color(0xFFFF6838),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            const SizedBox(height: 8),
            if (places.length > currentIndex + 1)
              Row(
                children: [
                  const SizedBox(width: 6),
                  const Icon(
                    Icons.circle_outlined,
                    size: 18,
                    color: Colors.grey,
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    // Ensures text stays within card boundaries
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          places[currentIndex + 1]['displayName'] ?? 'No title',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: Colors.black54,
                          ),
                          overflow:
                              TextOverflow.ellipsis, // Ellipsis for long text
                          maxLines: 1,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          places[currentIndex + 1]['time'] ?? 'Unknown', // Add time if available
                          style: const TextStyle(
                            fontSize: 11,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            const Spacer(),
            Align(
              alignment: Alignment.bottomRight,
              child : ElevatedButton(
                onPressed: () {
                  setState(() {
                    if (currentIndex < places.length - 1) {
                      currentIndex++;
                    } else {
                      handleStopPlan();
                    }
                  });
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 8,
                  ),
                  backgroundColor: currentIndex == places.length - 1 ?  Colors.red :const Color(0xFFFF6838), 
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Text(
                  currentIndex == places.length - 1 ? 'End' : 'Next',
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
