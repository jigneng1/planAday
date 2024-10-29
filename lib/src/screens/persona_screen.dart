import 'package:flutter/material.dart';

class PersonaScreen extends StatefulWidget {
  const PersonaScreen({super.key});

  @override
  _PersonaScreenState createState() => _PersonaScreenState();
}

class _PersonaScreenState extends State<PersonaScreen> {
  final Set<String> _selectedInterests = {};
  static const int maxSelection = 5;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const HeaderText(),
              const SizedBox(height: 6),
              LayoutBuilder(
                builder: (context, constraints) {
                  int crossAxisCount = constraints.maxWidth > 600 ? 4 : 2;
                  return Padding(
                    padding: const EdgeInsets.only(left: 32, right: 32),
                    child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 4,
                        childAspectRatio: 1,
                      ),
                      itemCount: interests.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        final interest = interests[index];
                        return InterestCard(
                          iconData: interest.icon,
                          label: interest.label,
                          isSelected:
                              _selectedInterests.contains(interest.label),
                          onTap: () {
                            setState(() {
                              if (_selectedInterests.contains(interest.label)) {
                                _selectedInterests.remove(interest.label);
                              } else if (_selectedInterests.length <
                                  maxSelection) {
                                _selectedInterests.add(interest.label);
                              }
                            });
                          },
                        );
                      },
                    ),
                  );
                },
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(36, 0, 36, 24),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
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
}

class HeaderText extends StatelessWidget {
  const HeaderText({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 18.0),
      width: double.infinity,
      child: const Text(
        'Choose your interests',
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: Color.fromARGB(255, 254, 109, 64),
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}

class InterestCard extends StatelessWidget {
  final IconData iconData;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const InterestCard({
    required this.iconData,
    required this.label,
    required this.isSelected,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              // Gradient circumference container
              Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: isSelected
                      ? const LinearGradient(
                          colors: [Color(0xFFFFA726), Color(0xFFFF7043)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        )
                      : null,
                ),
              ),
              // Inner solid color circle container
              Container(
                width: 80,
                height: 80,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white, // Inner circle color
                ),
                child: Icon(
                  iconData,
                  size: 40,
                  color: isSelected
                      ? const Color(0xFFFF7043)
                      : const Color(0xFFFF7043),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: isSelected
                  ? const Color(0xFFFF7043)
                  : const Color.fromARGB(255, 132, 132, 132),
            ),
          ),
        ],
      ),
    );
  }
}

class Interest {
  final IconData icon;
  final String label;

  Interest(this.icon, this.label);
}

final List<Interest> interests = [
  Interest(Icons.whatshot, 'Popular'),
  Interest(Icons.local_cafe, 'Cafe'),
  Interest(Icons.fastfood, 'Food and Drink'),
  Interest(Icons.shopping_bag, 'Shopping'),
  Interest(Icons.fitness_center, 'Sport'),
  Interest(Icons.theater_comedy, 'Entertainment'),
  Interest(Icons.museum, 'Museum'),
  Interest(Icons.local_florist, 'Services'),
];
