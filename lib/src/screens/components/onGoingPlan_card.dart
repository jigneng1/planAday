import 'package:flutter/material.dart';

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

    return Card(
      color: const Color.fromARGB(174, 255, 255, 255),
      margin: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
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
            const SizedBox(height: 16),
            if (places.isNotEmpty)
              Row(
                children: [
                  const Icon(
                    Icons.location_on,
                    size: 30,
                    color: Colors.black,
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
                            color: Colors.black54,
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
                    widget.onViewOngoingPlan(widget.planID);
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40,
                      vertical: 8,
                    ),
                    backgroundColor: const Color(0xFFFF6838),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text(
                    'View plan',
                    style: TextStyle(color: Colors.white),
                  ),
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
                    horizontal: 40,
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
