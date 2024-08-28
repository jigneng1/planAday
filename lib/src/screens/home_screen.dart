import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    return Scaffold(
      backgroundColor: primaryColor,
      body: SafeArea(
        child: Stack(
          children: [
            // Background containers
            Column(
              children: [
                Container(
                  height: 240.0, // Fixed height for the top container
                  child: Column(
                    children: [
                      const SizedBox(height: 15),
                      Row(
                        children: [
                          const SizedBox(width: 25),
                          const Expanded(
                            child: Center(
                              child: Text(
                                'PlanADay',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Ubuntu',
                                  color: Colors.orange,
                                ),
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.notifications,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              // Handle profile action
                            },
                          ),
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
                                fontSize: 50,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontFamily: 'SourceCodePro'
                              ),
                            ),
                          ],
                        ),
                        )
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(60),
                      topRight: Radius.circular(60),
                    ),
                  ),
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
              top: 180.0, // Adjust this based on the height of the top container and desired overlap
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 10.0),
                child: Card(
                  color: Colors.white,
                  elevation: 4.0,
                  child: SizedBox(
                    height: 100.0,
                    width: MediaQuery.of(context).size.width,
                    child: Center(
                      child: Text('Create new plan', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: primaryColor),),
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
