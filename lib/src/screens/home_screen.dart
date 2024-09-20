import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:plan_a_day/src/screens/components/place_card.dart';

class HomeScreen extends StatefulWidget {
  final VoidCallback onCreatePlan;
  final VoidCallback onPlan;

  const HomeScreen(
      {super.key, required this.onCreatePlan, required this.onPlan});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _haveOngoingPlan = false; // State variable

  List<Map<String, String>> places = [
    {
      'placeName': 'Tonglor',
      'placeDetails': 'Bar - Restaurant • 2 hours',
      'imageUrl':
          'https://www.theakyra.com/files/5415/8921/0258/Thonglor_Bangkok_District.jpg',
    },
    {
      'placeName': 'Sukhumvit',
      'placeDetails': 'Shopping - Dining • 3 hours',
      'imageUrl':
          'https://www.realasset.co.th/ckfinder/userfiles/images/0001-skytrain.jpg',
    },
    {
      'placeName': 'Chinatown',
      'placeDetails': 'Cultural Tour • 4 hours',
      'imageUrl':
          'https://upload.wikimedia.org/wikipedia/commons/6/64/Yaowarat_at_night_%2832455695783%29.jpg',
    },
  ];

  void _startOngoingPlan() {
    setState(() {
      _haveOngoingPlan = !_haveOngoingPlan; // Toggle the state
    });
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Stack(
            children: [
              // Main scrollable content
              Column(
                children: [
                  Container(
                    height: 250.0, // Fixed height for the top container
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xfffb9a4b), Color(0xffff6838)],
                        stops: [0.3, 0.7],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(40),
                        bottomRight: Radius.circular(40),
                      ),
                    ),
                    child: Column(
                      children: [
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            const SizedBox(width: 60),
                            Expanded(
                              child: Center(
                                child: Image.asset(
                                  'assets/images/Asset_14x.png',
                                  height: 50,
                                ),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.notifications,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                // Handle notification action
                                _startOngoingPlan();
                              },
                            ),
                            const SizedBox(width: 20),
                          ],
                        ),
                        const SizedBox(height: 20),
                        const Center(
                          child: Column(
                            children: [
                              Text(
                                'Where you want to ',
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                'Go?',
                                style: TextStyle(
                                  fontSize: 55,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontFamily: 'SourceCodePro',
                                  shadows: [
                                    Shadow(
                                      offset: Offset(4.0, 4.0),
                                      blurRadius: 4.0,
                                      color: Color.fromARGB(178, 60, 60, 60),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 80, 0, 0),
                    child: Column(
                      children: [
                        _buildCarouselSlider(),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () {
                            // Handle regenerate action
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                          ),
                          child: const Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 6, vertical: 10),
                            child: SizedBox(
                              width: 100,
                              child: Center(
                                child: Text(
                                  'View All',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 14),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 50),
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // const SizedBox(
                            //     width: 40), // Add some padding from the left
                            const Text(
                              'Recent Plans',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                // Handle see all action
                              },
                              child: const Text(
                                'See all',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  shadows: [
                                    Shadow(
                                        color: Colors.grey,
                                        offset: Offset(0, -5))
                                  ],
                                  color: Colors.transparent,
                                  decoration: TextDecoration.underline,
                                  decorationColor: Colors.grey,
                                  decorationThickness: 2,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      Padding(
                          padding: EdgeInsets.symmetric(horizontal: 30),
                          child: Column(
                            children: [
                              GestureDetector(
                                onTap: widget.onPlan,
                                child: const PlaceDetailCard(
                                  imageUrl:
                                      'https://thethaiger.com/th/wp-content/uploads/2023/04/1-5.png',
                                  title: 'Vinyl Museum',
                                  subtitle: 'Museum',
                                ),
                              ),
                              const SizedBox(height: 20),
                              PlaceDetailCard(
                                imageUrl:
                                    'https://thethaiger.com/th/wp-content/uploads/2023/04/1-5.png',
                                title: 'Vinyl Museum',
                                subtitle: 'Museum',
                              ),
                              SizedBox(height: 20),
                              PlaceDetailCard(
                                imageUrl:
                                    'https://thethaiger.com/th/wp-content/uploads/2023/04/1-5.png',
                                title: 'Vinyl Museum',
                                subtitle: 'Museum',
                              ),
                              SizedBox(height: 50),
                            ],
                          )),
                    ],
                  ),
                ],
              ),
              // Overlay container
              Positioned(
                top:
                    210.0, // Adjust this based on the height of the top container and desired overlap
                left: 0,
                right: 0,
                child: GestureDetector(
                  onTap: widget.onCreatePlan,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 40.0),
                    child: Card(
                      color: Colors.white,
                      elevation: 5.0,
                      child: SizedBox(
                        height: 70.0,
                        width: MediaQuery.of(context).size.width,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(Icons.add, size: 35, color: primaryColor),
                            const SizedBox(width: 10),
                            Text(
                              'Create new plan',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: primaryColor,
                              ),
                            ),
                            const SizedBox(width: 11),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCarouselSlider() {
    return CarouselSlider.builder(
      itemCount: places
          .length, // Number of cards in the carousel based on the list length
      itemBuilder: (BuildContext context, int index, int realIndex) {
        final place = places[index]; // Get current place data
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.network(
                  place['imageUrl']!, // Replace with dynamic image URL
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
              ),
              Positioned(
                bottom: 16,
                left: 16,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      place['placeName']!, // Dynamic place name
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      place['placeDetails']!, // Dynamic place details
                      style: const TextStyle(
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
      options: CarouselOptions(
        height: 200,
        viewportFraction: 0.8,
        enlargeCenterPage: true,
        autoPlay: true,
      ),
    );
  }
}
