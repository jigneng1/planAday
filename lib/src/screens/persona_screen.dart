import 'package:flutter/material.dart';

class PersonaPage extends StatelessWidget {
  const PersonaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.only(left: 24.0),
                width: double.infinity,
                child: const Text(
                  'Choose your interests',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: Color.fromARGB(255, 254, 109, 64),
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
              LayoutBuilder(
                builder: (context, constraints) {
                  int crossAxisCount = constraints.maxWidth > 600 ? 4 : 2;
                  return GridView.count(
                    crossAxisCount: crossAxisCount,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    padding: const EdgeInsets.all(16.0),
                    shrinkWrap: true,
                    children: [
                      _buildInterestCard(Icons.whatshot, 'Popular'),
                      _buildInterestCard(Icons.local_cafe, 'Cafe'),
                      _buildInterestCard(Icons.fastfood, 'Food and Drink'),
                      _buildInterestCard(Icons.shopping_bag, 'Shopping'),
                      _buildInterestCard(Icons.fitness_center, 'Sport'),
                      _buildInterestCard(Icons.theater_comedy, 'Entertainment'),
                      _buildInterestCard(Icons.museum, 'Museum'),
                      _buildInterestCard(Icons.local_florist, 'Services'),
                    ],
                  );
                },
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      // Handle button press
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 254, 109, 64),
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                    ),
                    child: const Text(
                      'Done',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
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

  Widget _buildInterestCard(IconData iconData, String label) {
    return Card(
      color: const Color(0xFFFDF6EC), // Light beige color
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            iconData,
            size: 40,
            color: const Color.fromARGB(255, 254, 109, 64),
          ),
          const SizedBox(height: 10),
          Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 254, 109, 64),
            ),
          ),
        ],
      ),
    );
  }
}
