import 'package:flutter/material.dart';

class PlaceDetailPage extends StatelessWidget {
  final VoidCallback onPlan;
  final String imageUrl;
  final String title;
  final String rating;
  final String openHours;
  final Map<String, bool> tagsData;

  PlaceDetailPage({
    super.key,
    required this.onPlan,
    required this.imageUrl,
    required this.title,
    required this.rating,
    required this.openHours,
    required this.tagsData,
  });

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
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
            ),
            actions: const [
              Padding(
                padding: EdgeInsets.only(left: 18, right: 18),
                child: Icon(Icons.favorite_border, color: Colors.white),
              ),
            ],
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(20),
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
          SliverToBoxAdapter(
            child: Container(
              color: Colors.white,
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
                            spacing: 8.0, // Spacing between tags
                            children: tags,
                          ),
                        const SizedBox(height: 16),
                        // Rating section
                        Row(
                          children: [
                            Icon(Icons.star, color: Colors.orange),
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
        ],
      ),
    );
  }
}
