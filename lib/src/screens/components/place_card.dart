import 'package:flutter/material.dart';
import '../placeDetail_screen.dart';

class PlaceDetailCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String type;
  final String location;
  final String placeID;

  const PlaceDetailCard({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.type,
    required this.location,
    required this.placeID,
  });

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    return GestureDetector(
      onTap: () {
        // Navigate to place detail screen
        // Navigator.push(context, MaterialPageRoute(builder: (context) {
        //   return PlaceDetailPage(
        //     imageUrl: imageUrl,
        //     title: title,
        //   );
        // }));
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        elevation: 3,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 12.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image Section
              ClipRRect(
                borderRadius: BorderRadius.circular(12.0),
                child: Image.network(
                  imageUrl,
                  width: 120,
                  height: 120,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return const Center(
                      child: Text(
                        'Image not available',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(width: 12),
              // Content Section
              Expanded(
                child: SizedBox(
                  height: 120, // Ensure the Column gets proper height
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(), // Space between title and type

                      // Event type tag (e.g., Sports event)
                      Container(
                        decoration: BoxDecoration(
                          color: primaryColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(
                            vertical: 6, horizontal: 10),
                        child: Text(
                          type,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      const Spacer(), // Pushes the location to the bottom

                      // Location at the bottom
                      Row(
                        children: [
                          const Icon(Icons.place, color: Colors.grey, size: 16),
                          const SizedBox(width: 4),
                          // Ensure location text doesn't overflow
                          Flexible(
                            child: Text(
                              location,
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1, // Optional: limits text to 1 line
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
