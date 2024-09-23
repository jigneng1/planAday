import 'package:flutter/material.dart';
import '../../../services/api_service.dart';
import '../placeDetail_screen.dart';

class PlaceDetailCard extends StatefulWidget {
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
  State<PlaceDetailCard> createState() => _PlaceDetailCardState();
}

class _PlaceDetailCardState extends State<PlaceDetailCard> {
  final ApiService apiService = ApiService();

  void _navigateToPlaceDetail(BuildContext context) async {
    try {
      // Fetch the place details from the API using the placeID
      final placeDetails = await apiService.getPlaceDetails(widget.placeID);

      // Navigate to PlaceDetailPage, passing in the required data
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PlaceDetailPage(
            imageUrl: placeDetails?['photo'] ?? 'https://via.placeholder.com/300',
            title: placeDetails?['displayName'] ?? 'Unknown Place',
            rating: placeDetails?['rating']?.toString() ?? 'No Rating',
            openHours: placeDetails?['currentOpeningHours']?.join('\n') ?? 'No Open Hours',
            tagsData: {
              'Wheelchair Parking': placeDetails?['accessibilityOptions']?['wheelchairAccessibleParking'] ?? false,
              'Wheelchair Entrance': placeDetails?['accessibilityOptions']?['wheelchairAccessibleEntrance'] ?? false,
              'Wheelchair Restroom': placeDetails?['accessibilityOptions']?['wheelchairAccessibleRestroom'] ?? false,
              'Wheelchair Seating': placeDetails?['accessibilityOptions']?['wheelchairAccessibleSeating'] ?? false,
              'Free Parking Lot': placeDetails?['parkingOptions']?['freeParkingLot'] ?? false,
              'Free Street Parking': placeDetails?['parkingOptions']?['freeStreetParking'] ?? false,
              'Takeout': placeDetails?['takeout'] ?? false,
              'Dog Friendly': placeDetails?['allowsDogs'] ?? false,
              'Live Music': placeDetails?['liveMusic'] ?? false,
            },
          ),
        ),
      );
    } catch (e) {
      // Handle the error, for example, by showing a snackbar or alert dialog
      print('Error fetching place details: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    return GestureDetector(
      onTap: () => _navigateToPlaceDetail(context), // Handle tap
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        elevation: 3,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 12.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Image Section
              ClipRRect(
                borderRadius: BorderRadius.circular(12.0),
                child: Image.network(
                  widget.imageUrl,
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
                  height: 120,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Title
                      Text(
                        widget.title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: primaryColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(
                            vertical: 6, horizontal: 10),
                        child: Text(
                          widget.type,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      // Location
                      Row(
                        children: [
                          const Icon(Icons.place, color: Colors.grey, size: 16),
                          const SizedBox(width: 4),
                          Flexible(
                            child: Text(
                              widget.location,
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
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