import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:plan_a_day/src/screens/components/onGoingPlan_card.dart';
import 'package:plan_a_day/src/screens/components/plan_card.dart';

class HomeScreen extends StatefulWidget {
  final VoidCallback onCreatePlan;
  final Function(String id) onPlan;
  final Function(String id) onViewOngoingPlan;
  final String ongoingPlanID;
  final Map<String, dynamic> onGoingPlan;
  final List<Map<String, dynamic>> allPlans;
  final VoidCallback onEndGoingPlan;

  const HomeScreen(
      {super.key,
      required this.onCreatePlan,
      required this.onPlan,
      required this.ongoingPlanID,
      required this.allPlans,
      required this.onViewOngoingPlan,
      required this.onGoingPlan,
      required this.onEndGoingPlan});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Map<String, String>> places = [
    {
      'placeName': 'Thonglor',
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

  // void _startOngoingPlan() {
  //   setState(() {
  //     _haveOngoingPlan = !_haveOngoingPlan; // Toggle the state
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          child: Stack(
            children: [
              // Main scrollable content
              Column(
                children: [
                  Container(
                    width: double.infinity,
                    height: widget.ongoingPlanID != ''
                        ? 370
                        : 320, // Fixed height for the top container
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
                    child: widget.ongoingPlanID != ''
                        ? OngoingPlanWidget(
                            planID: widget.ongoingPlanID,
                            plan: widget.onGoingPlan,
                            onViewOngoingPlan: widget.onViewOngoingPlan,
                            onEndPlan: widget.onEndGoingPlan)
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const SizedBox(height: 70),
                              Center(
                                child: Image.asset(
                                  'assets/images/Asset_14x.png',
                                  height: 50,
                                ),
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
                                            color:
                                                Color.fromARGB(178, 60, 60, 60),
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
                    padding: widget.ongoingPlanID != ''
                        ? const EdgeInsets.only(top: 20)
                        : const EdgeInsets.only(top: 70),
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
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 40),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'All Plans',
                              style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 30),
                          child: widget.allPlans.isEmpty
                              ? const Padding(
                                  padding: EdgeInsets.all(30),
                                  child: Center(
                                    child: Text(
                                      'No recent plans',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ))
                              : Column(
                                  children: widget.allPlans.map((plan) {
                                    return GestureDetector(
                                        onTap: () =>
                                            widget.onPlan(plan['planID']),
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(bottom: 20),
                                          child: PlanCard(
                                            imageUrl: plan['selectedPlaces']
                                                    .values
                                                    .first['photosUrl'] ??
                                                '', // Use the first place image
                                            title: plan['planName'] ?? '',
                                            subtitle: (plan['category']
                                                    as List<String>)
                                                .join(', '),
                                            time: plan['numberOfPlaces']
                                                .toString(),
                                          ),
                                        ));
                                  }).toList(),
                                )),
                      const SizedBox(height: 50),
                    ],
                  ),
                ],
              ),
              // Overlay container
              widget.ongoingPlanID != ''
                  ? const SizedBox()
                  : Positioned(
                      top: 255,
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
                                  Icon(Icons.add,
                                      size: 35, color: primaryColor),
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
          margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          elevation: 4, // Add elevation to lift the card
          child: Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: Image.network(
                  place['imageUrl']!, // Replace with dynamic image URL
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                ),
              ),
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Colors.black.withOpacity(0.6),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.4),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(24),
                      bottomRight: Radius.circular(24),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        place['placeName']!, // Dynamic place name
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2, // Modern letter spacing
                        ),
                      ),
                      const SizedBox(
                          height: 4), // Spacing between title and details
                      Text(
                        place['placeDetails']!, // Dynamic place details
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 4),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
      options: CarouselOptions(
        height: 220,
        viewportFraction: 0.85,
        enlargeCenterPage: true,
        autoPlay: true,
        autoPlayInterval: const Duration(seconds: 3),
        autoPlayAnimationDuration: const Duration(milliseconds: 800),
        enlargeStrategy: CenterPageEnlargeStrategy.height,
      ),
    );
  }
}
