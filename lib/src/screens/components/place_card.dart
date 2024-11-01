import 'package:flutter/material.dart';

class PlaceCard extends StatefulWidget {
  final String planID;
  final String imageUrl;
  final String title;
  final String type;
  final String location;
  final String placeID;
  final Function(String placeID, String planID) onViewPlaceDetail;

  const PlaceCard({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.type,
    required this.location,
    required this.placeID, required this.onViewPlaceDetail, required this.planID,
  });

  @override
  State<PlaceCard> createState() => _PlaceDetailCardState();
}

class _PlaceDetailCardState extends State<PlaceCard> {

  @override
  Widget build(BuildContext context) {
    // final primaryColor = Theme.of(context).primaryColor;

    return GestureDetector(
      onTap: (){
        widget.onViewPlaceDetail(widget.placeID, widget.planID);
      }, // Handle tap
      child: Card(
        color: Colors.white,
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
                          overflow: TextOverflow.ellipsis,
                        ),
                        maxLines: 2,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(
                            vertical: 6, horizontal: 10),
                        child: Text(
                          widget.type,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
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
