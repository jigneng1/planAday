import 'package:flutter/material.dart';
import '../../../services/api_service.dart';

class PlaceDetailPage extends StatefulWidget {
  final String placeID;
  final String planID;
  final Function(String planID) onBack;

  const PlaceDetailPage({super.key, required this.placeID, required this.onBack, required this.planID});

  @override
  _PlaceDetailPageState createState() => _PlaceDetailPageState();
}

class _PlaceDetailPageState extends State<PlaceDetailPage> {
  final ApiService apiService = ApiService();
  late String imageUrl = 'No image';
  late String title = 'No title';
  late String rating = 'No rating';
  late String openHours = 'No opening hours';
  late Map<String, bool> tagsData = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchPlaceDetails();
  }

  Future<void> _fetchPlaceDetails() async {
    try {
      final placeDetails = await apiService.getPlaceDetails(widget.placeID);
      String formattedOpenHours = (placeDetails?['currentOpeningHours'] as List<dynamic>?)
          !.join('\n');

      setState(() {
        imageUrl = placeDetails?['photo'];
        title = placeDetails?['displayName'];
        rating = placeDetails!['rating'].toString();
        openHours = formattedOpenHours;
        tagsData = {
              'Wheelchair Parking': placeDetails['accessibilityOptions']?['wheelchairAccessibleParking'] ?? false,
              'Wheelchair Entrance': placeDetails['accessibilityOptions']?['wheelchairAccessibleEntrance'] ?? false,
              'Wheelchair Restroom': placeDetails['accessibilityOptions']?['wheelchairAccessibleRestroom'] ?? false,
              'Wheelchair Seating': placeDetails['accessibilityOptions']?['wheelchairAccessibleSeating'] ?? false,
              'Free Parking Lot': placeDetails['parkingOptions']?['freeParkingLot'] ?? false,
              'Free Street Parking': placeDetails['parkingOptions']?['freeStreetParking'] ?? false,
              'Takeout': placeDetails['takeout'] ?? false,
              'Dog Friendly': placeDetails['allowsDogs'] ?? false,
              'Live Music': placeDetails['liveMusic'] ?? false,
            };
        isLoading = false;
      });
    } catch (error) {
      setState(() {
        isLoading = false;
      });
      // Handle the error appropriately, e.g., show a dialog or a message
      print('Error fetching place details: $error');
    }
  }

  Widget _buildTag(String text) {
    return Container(
      margin: const EdgeInsets.only(right: 8.0),
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      decoration: BoxDecoration(
        color: Colors.orange.shade100,
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Text(
        text,
        style: TextStyle(color: Colors.orange.shade700),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    // Tag conditions: true
    List<Widget> tags = tagsData.entries
        .where((entry) => entry.value)
        .map((entry) => _buildTag(entry.key))
        .toList();

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: MediaQuery.of(context).size.height * 0.4,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Image.network(
                imageUrl,
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
            leading: IconButton(
              onPressed: (){
                widget.onBack(widget.planID);
              },
              icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
            ),
            actions: const [
              Padding(
                padding: EdgeInsets.only(left: 18, right: 18),
                child: Icon(Icons.favorite_border, color: Colors.white),
              ),
            ],
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(60),
              child: Container(
                width: double.infinity,
                height: 24,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40.0),
                    topRight: Radius.circular(40.0),
                  ),
                ),
              ),
            ),
          ),
          SliverFillRemaining(
            hasScrollBody: true,
            child: Container(
              color: Colors.white,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24.0, vertical: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          if (tags.isNotEmpty)
                            Wrap(
                              spacing: 2.0,
                              runSpacing: 4.0,
                              children: tags,
                            ),
                          const SizedBox(height: 16),
                          // Rating section
                          Row(
                            children: [
                              const Icon(Icons.star, color: Colors.orange),
                              const SizedBox(width: 4),
                              Text(
                                rating.isNotEmpty ? rating : 'No Rating',
                                style: const TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            openHours.isNotEmpty
                                ? 'Open Hours:\n\n$openHours'
                                : 'No Opening Hours',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 16),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
