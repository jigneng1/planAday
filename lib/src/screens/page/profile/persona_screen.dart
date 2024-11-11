import 'package:flutter/material.dart';
import 'package:plan_a_day/services/api_service.dart';
import 'package:plan_a_day/services/auth_token.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PersonaScreen extends StatefulWidget {
  const PersonaScreen({super.key});

  @override
  _PersonaScreenState createState() => _PersonaScreenState();
}

class _PersonaScreenState extends State<PersonaScreen> {
  ApiService apiService = ApiService();
  final Set<String> _selectedInterests = {};
  static const int maxSelection = 5;

  @override
  void initState() {
    super.initState();
    getInterests();
  }

  Future<void> getInterests() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? savedInterests = prefs.getStringList('interests');

    if (savedInterests != null && savedInterests.isNotEmpty) {
      setState(() {
        _selectedInterests.addAll(savedInterests);
      });
    } else {
      final List<String> interest = await apiService.getInterest();
      if (mounted) {
        setState(() {
          _selectedInterests.addAll(interest);
        });
        await prefs.setStringList('interests', interest);
      }
    }
  }

  void _saveInterests() async {
    final bool success = await apiService.saveInterest(_selectedInterests.toList());
    if (_selectedInterests.isEmpty) {
      clearAllSharedPreferences();
      Navigator.pop(context);
      return;
    }
    if (success) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setStringList('interests', _selectedInterests.toList());
      setState(() {
        _selectedInterests.clear();
      });
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to save interests. Please try again.'),
        ),
      );
    }
  }

  Future<bool> _onWillPop() async {
    if (_selectedInterests.isNotEmpty) {
      return await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Unsaved Changes'),
            content: const Text('You have unsaved changes. Are you sure you want to leave?'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Stay'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('Leave'),
              ),
            ],
          );
        },
      ) ?? false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                HeaderText(
                  selectedCount: _selectedInterests.length,
                  maxSelection: maxSelection,
                ),
                const SizedBox(height: 18),
                LayoutBuilder(
                  builder: (context, constraints) {
                    int crossAxisCount = constraints.maxWidth > 600 ? 4 : 2;
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
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
                          bool isSelected = _selectedInterests.contains(interest.label.toLowerCase());
                          bool isDisabled = _selectedInterests.length >= maxSelection && !isSelected;

                          return InterestCard(
                            iconData: interest.icon,
                            label: interest.label,
                            isSelected: isSelected,
                            isDisabled: isDisabled,
                            onTap: () {
                              if (isDisabled) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('You can select up to 5 interests only.'),
                                  ),
                                );
                                return;
                              }
                              setState(() {
                                if (isSelected) {
                                  _selectedInterests.remove(interest.label.toLowerCase());
                                } else if (_selectedInterests.length < maxSelection) {
                                  _selectedInterests.add(interest.label.toLowerCase());
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
                        _saveInterests();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 254, 109, 64),
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
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
      ),
    );
  }
}

class HeaderText extends StatelessWidget {
  final int selectedCount;
  final int maxSelection;

  const HeaderText({
    required this.selectedCount,
    required this.maxSelection,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
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
        ),
        const SizedBox(height: 8),
        Text(
          'You can select at most $maxSelection interests. $selectedCount/$maxSelection selected',
          style: const TextStyle(
            fontSize: 14,
            color: Color.fromARGB(255, 132, 132, 132),
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class InterestCard extends StatelessWidget {
  final IconData iconData;
  final String label;
  final bool isSelected;
  final bool isDisabled;
  final VoidCallback onTap;

  const InterestCard({
    required this.iconData,
    required this.label,
    required this.isSelected,
    required this.isDisabled,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      scale: isSelected ? 1.1 : 1.0,
      duration: const Duration(milliseconds: 200),
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
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
                    color: isDisabled ? Colors.grey[300] : null,
                  ),
                ),
                Container(
                  width: 80,
                  height: 80,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                  child: Icon(
                    iconData,
                    size: 40,
                    color: isDisabled ? Colors.grey : const Color(0xFFFF7043),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: isDisabled
                    ? Colors.grey
                    : isSelected
                        ? const Color(0xFFFF7043)
                        : const Color.fromARGB(255, 132, 132, 132),
              ),
            ),
          ],
        ),
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
  Interest(Icons.local_cafe, 'Cafe'),
  Interest(Icons.fastfood, 'Restaurant'),
  Interest(Icons.shopping_bag, 'Store'),
  Interest(Icons.park, 'Park'),
  Interest(Icons.fitness_center, 'Gym'),
  Interest(Icons.theater_comedy, 'Movie_Theater'),
  Interest(Icons.museum, 'Museum'),
  Interest(Icons.palette, 'Art_Gallery'),
];
