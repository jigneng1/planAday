import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:plan_a_day/src/screens/components/place_card.dart';

class HomeScreen extends StatefulWidget {
  final VoidCallback onCreatePlan;

  const HomeScreen({super.key, required this.onCreatePlan});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _haveOngoingPlan = false; // State variable

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
                    height: 240.0, // Fixed height for the top container
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
                        const SizedBox(height: 15),
                        Row(
                          children: [
                            const SizedBox(width: 60),
                            Expanded(
                              child: Center(
                                child: Stack(
                                  children: [
                                    // Stroked text as border.
                                    Text(
                                      'PlanADay',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Ubuntu',
                                        foreground: Paint()
                                          ..style = PaintingStyle.stroke
                                          ..strokeWidth = 3
                                          ..color = const Color.fromARGB(
                                              255, 255, 255, 255),
                                        shadows: const [
                                          Shadow(
                                            offset: Offset(4.0, 4.0),
                                            blurRadius: 4.0,
                                            color: Color.fromARGB(188, 0, 0, 0),
                                          ),
                                        ],
                                      ),
                                    ),
                                    // Solid text as fill.
                                    Text(
                                      'PlanADay',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Ubuntu',
                                        color: primaryColor,
                                      ),
                                    ),
                                  ],
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
                      const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 30),
                          child: Column(
                            children: [
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
                    200.0, // Adjust this based on the height of the top container and desired overlap
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
      itemCount: 3, // Number of cards in the carousel
      itemBuilder: (BuildContext context, int index, int realIndex) {
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
                  'https://www.theakyra.com/files/5415/8921/0258/Thonglor_Bangkok_District.jpg', // Replace with your image URL
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
              ),
              const Positioned(
                bottom: 16,
                left: 16,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tonglor',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Bar - Restaurant • 2 hours',
                      style: TextStyle(
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
              // Positioned(
              //   bottom: 16,
              //   right: 16,
              //   child: ElevatedButton(
              //     onPressed: () {},
              //     style: ElevatedButton.styleFrom(
              //       backgroundColor: Colors.grey,
              //     ),
              //     child: const Text('Detail',
              //         style: TextStyle(color: Colors.black)),
              //   ),
              // ),
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
