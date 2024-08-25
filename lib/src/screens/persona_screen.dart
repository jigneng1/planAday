import 'package:flutter/material.dart';
import 'package:plan_a_day/src/screens/home_screen.dart';

class PersonaScreen extends StatefulWidget {
  const PersonaScreen({super.key});

  @override
  _PersonaScreenState createState() => _PersonaScreenState();
}

class _PersonaScreenState extends State<PersonaScreen> {
  final List<String> _selectedInterests = [];
  static const int maxSelection = 5;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.only(left: 24.0, top: 16.0),
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
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 40.0),
                    child: GridView.count(
                      crossAxisCount: crossAxisCount,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      childAspectRatio: 1, 
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
                    ),
                  );
                },
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(40, 0, 40, 24),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HomeScreen(
                            selectedInterests: _selectedInterests,
                          ),
                        ),
                      );
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
    final bool isSelected = _selectedInterests.contains(label);

    return GestureDetector(
      onTap: () {
        setState(() {
          if (isSelected) {
            _selectedInterests.remove(label);
          } else if (_selectedInterests.length < maxSelection) {
            _selectedInterests.add(label);
          } else {
            // Optionally show a message to the user
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('You can select up to 4 interests only.'),
                duration: Duration(seconds: 2),
              ),
            );
          }
        });
      },
      child: Card(
        color: isSelected ? const Color.fromARGB(255, 255, 140, 91) : const Color(0xFFFDF6EC), // Highlight if selected
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              iconData,
              size: 40,
              color: isSelected ? Colors.white : const Color.fromARGB(255, 254, 109, 64),
            ),
            const SizedBox(height: 10),
            Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isSelected ? Colors.white : const Color.fromARGB(255, 254, 109, 64),
              ),
            ),
          ],
        ),
      ),
    );
  }
}