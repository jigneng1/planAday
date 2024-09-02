import 'package:flutter/material.dart';
import 'package:plan_a_day/src/screens/create_plan_screen.dart';
import 'package:plan_a_day/src/screens/edit_plan_screen.dart';
import 'package:plan_a_day/src/screens/home_screen.dart';
import 'package:plan_a_day/src/screens/persona_screen.dart';
import 'package:plan_a_day/src/screens/plan_screen.dart';
import 'package:plan_a_day/src/screens/profile_screen.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _currentIndex = 0;
  int _indexBeforeCreate = 0;

  late final List<Widget> _children;

  Map<String, dynamic> _planData = {}; // Store plan data

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void _goToHomeScreen() {
    setState(() {
      _currentIndex = _indexBeforeCreate; // Assuming HomeScreen is at index 0
    });
  }

  void _handleGeneratePlan(Map<String, dynamic> planData) {
    setState(() {
      _planData = planData; // Store the data from CreatePlanScreen
      print('PlanScreen received plan data: $_planData');
      _currentIndex = 3; // Navigate to PlanScreen
    });
  }

  void _handleEditPlan(Map<String, dynamic> planData) {
    setState(() {
      _planData = planData; // Store the data from CreatePlanScreen
      print('PlanScreen received plan data: $_planData');
      _currentIndex = 5; // Assuming HomeScreen is at index 0
    });
  }

  @override
  Widget build(BuildContext context) {
    // Build the children dynamically to ensure PlanScreen gets the latest plan data
    final List<Widget> children = [
      const HomeScreen(),
      ProfileScreen(),
      CreatePlanScreen(
        onClose: _goToHomeScreen,
        onGeneratePlan: _handleGeneratePlan,
      ),
      PlanScreen(
        planData: _planData, // Pass the updated plan data
        onClose: _goToHomeScreen,
        onEditPlan: _handleEditPlan,
      ),
      PersonaScreen(),
      EditPlanScreen(
        planData: _planData, // Pass the updated plan data
        onClose: _goToHomeScreen,
        onDone: _handleGeneratePlan,
      ),
    ];

    return Scaffold(
      body: children[_currentIndex], // Use the latest list
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Container(
        margin: const EdgeInsets.only(top: 30),
        height: 64,
        width: 64,
        child: FloatingActionButton(
          backgroundColor: Colors.orange[900],
          elevation: 0,
          onPressed: () {
            setState(() {
              _indexBeforeCreate = _currentIndex;
            });
            onTabTapped(2); // Navigate to CreatePlanScreen
          },
          shape: RoundedRectangleBorder(
            side: const BorderSide(width: 3, color: Colors.transparent),
            borderRadius: BorderRadius.circular(100),
          ),
          child: const Icon(
            size: 40,
            Icons.add,
            color: Colors.white,
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.white10,
        child: Container(
          margin: const EdgeInsets.only(left: 12.0, right: 12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                margin: const EdgeInsets.fromLTRB(0, 0, 80, 0),
                child: IconButton(
                  onPressed: () {
                    onTabTapped(0);
                  },
                  iconSize: _currentIndex == 0 ? 40 : 30,
                  icon: Icon(
                    Icons.home_filled,
                    color: _currentIndex == 0
                        ? Colors.orange.shade900
                        : Colors.grey.shade400,
                  ),
                ),
              ),
              IconButton(
                onPressed: () {
                  onTabTapped(4);
                },
                iconSize: _currentIndex == 4 ? 40 : 30,
                icon: Icon(
                  Icons.person,
                  color: _currentIndex == 4
                      ? Colors.orange.shade900
                      : Colors.grey.shade400,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

