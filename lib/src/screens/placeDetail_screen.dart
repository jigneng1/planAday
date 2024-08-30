import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: PlaceDetailPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class PlaceDetailPage extends StatelessWidget {
  const PlaceDetailPage({super.key});

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
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: MediaQuery.of(context).size.height * 0.4,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Image.network(
                'https://www.theakyra.com/files/5415/8921/0258/Thonglor_Bangkok_District.jpg',
                fit: BoxFit.cover,
              ),
            ),
            leading: Padding(
              padding: const EdgeInsets.all(8.0), // Add padding to align
              child: IconButton(
                onPressed: () {
                  // Handle back button press
                },
                icon: const Icon(Icons.arrow_back, color: Colors.white),
              ),
            ),
            actions: const [
              Padding(
                padding: EdgeInsets.only(
                    left: 18, right: 18), // Add padding to align
                child: Icon(Icons.favorite_border, color: Colors.white),
              ),
            ],
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(20),
              child: Container(
                width: double.infinity,
                height: 40,
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                          child: Column(
                        children: [
                          Container(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 24),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Dog In Town Siam',
                                    style: TextStyle(
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      _buildTag('DineIn'),
                                      _buildTag('servesDessert'),
                                      _buildTag('freeStreetParking'),
                                    ],
                                  ),
                                  const SizedBox(height: 16),
                                  const Row(
                                    children: [
                                      Icon(Icons.star, color: Colors.orange),
                                      Icon(Icons.star, color: Colors.orange),
                                      Icon(Icons.star, color: Colors.orange),
                                      Icon(Icons.star, color: Colors.orange),
                                      Icon(Icons.star_half,
                                          color: Colors.orange),
                                      SizedBox(width: 8),
                                      Text(
                                        '(369 reviews)',
                                        style: TextStyle(fontSize: 16),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  const Text(
                                    'Open hour: 8 AM - 5 PM',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  const Text(
                                    'jnngfkjbndfkjbndjkfbdfb dfb df bodfb df b dfb df b df bdf b df bdf bdfbd fbdf bdfbdfbdfbdfbfdb dfb dfb dfb f dfb kslbServing fun and happiness of many adorable dogs.\n** DO NOT allow other dogs in the cafe area',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  const SizedBox(height: 16),
                                  const Text(
                                    'Location area',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Container(
                                    height: 220,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      color: Colors.grey.shade300,
                                    ),
                                    child: const Center(
                                      child: Icon(Icons.map,
                                          size: 100, color: Colors.grey),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  const Text(
                                    '3 km away',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  const SizedBox(
                                      height: 200), // Extra space for scrolling
                                ],
                              ),
                            ),
                          ),
                        ],
                      ))
                    ],
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
