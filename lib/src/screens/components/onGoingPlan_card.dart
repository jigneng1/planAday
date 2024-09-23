import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class OngoingPlanWidget extends StatefulWidget {
  final String planID;
  final Map<String, dynamic> plan;
  final Function(String) onViewOngoingPlan;
  final VoidCallback onEndPlan;

  OngoingPlanWidget({
    required this.planID,
    required this.plan,
    required this.onViewOngoingPlan, required this.onEndPlan,
  });

  @override
  _OngoingPlanWidgetState createState() => _OngoingPlanWidgetState();
}

class _OngoingPlanWidgetState extends State<OngoingPlanWidget> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> places = widget.plan['selectedPlaces'].values
        .cast<Map<String, dynamic>>()
        .toList();
    
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
        padding: const EdgeInsets.all(30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Plan name (prevent overflow)
            Text(
              widget.plan['planName'] ?? 'Ongoing plan',
              style: const TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1, 
            ),
            const SizedBox(height: 18),
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
                          places[currentIndex]['displayName'],
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
                          places[currentIndex]['time'], // Add time if available
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
                          places[currentIndex + 1]['displayName'],
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
                          places[currentIndex + 1]['time'], // Add time if available
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {
                    launchMapUrl();
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 8,
                    ),
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Icon(Icons.map, color: Colors.white, size: 20,),
                  ),
                ElevatedButton(
                onPressed: () {
                  setState(() {
                    if (currentIndex < places.length - 1) {
                      currentIndex++;
                    } else {
                      widget.onEndPlan();
                    }
                  });
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 8,
                  ),
                  backgroundColor: const Color(0xFFFF6838),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Text(
                  currentIndex == places.length - 1 ? 'End' : 'Next',
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
