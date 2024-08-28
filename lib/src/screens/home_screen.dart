import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  final VoidCallback onCreatePlan;

  const HomeScreen({super.key, required this.onCreatePlan});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            // Background containers
            Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                      color: primaryColor,
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(40),
                        bottomRight: Radius.circular(40),
                      ),
                    ),
                  height: 240.0, // Fixed height for the top container
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
                                        ..strokeWidth = 4 // Adjust the stroke width
                                        ..color = const Color.fromARGB(255, 255, 255, 255),
                                      shadows: const [
                                        Shadow(
                                          offset: Offset(4.0, 4.0),
                                          blurRadius: 4.0,
                                          color: Color.fromARGB(188, 0, 0, 0),
                                        ),
                                      ], // Stroke color
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
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(16.0),
                    child: const Center(
                      child: Text('test'),
                    ),
                  ),
                ),
              ],
            ),
            // Overlay container
            Positioned(
              top: 200.0, // Adjust this based on the height of the top container and desired overlap
              left: 0,
              right: 0,
              child: GestureDetector(
                onTap: widget.onCreatePlan, // Use widget to access the parent widget's properties
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 40.0),
                  child: Card(
                    color: Colors.white,
                    elevation: 4.0,
                    child: SizedBox(
                      height: 80.0,
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
    );
  }
}
