import 'package:flutter/material.dart';
import 'package:plan_a_day/services/api_service.dart';
import 'package:plan_a_day/src/screens/create_plan_screen.dart';
import 'package:plan_a_day/src/screens/edit_plan_screen.dart';
import 'package:plan_a_day/src/screens/home_screen.dart';
import 'package:plan_a_day/src/screens/persona_screen.dart';
import 'package:plan_a_day/src/screens/placeDetail_screen.dart';
import 'package:plan_a_day/src/screens/plan_screen.dart';
import 'package:plan_a_day/src/screens/profile_screen.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  final ApiService apiService = ApiService();
  int _currentIndex = 0;
  int _indexBeforeCreate = 0;

  Map<String, dynamic> _planData = {};

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void _goToHomeScreen() {
    setState(() {
      _currentIndex = _indexBeforeCreate;
    });
  }

  void _goToPlanScreen() {
    setState(() {
      _currentIndex = 3;
    });
  }

  void _goToCreatePlanScreen() {
    setState(() {
      _currentIndex = 2;
    });
  }

  void _goToPlaceDetailScreen() {
    setState(() {
      _currentIndex = 6;
    });
  }

  void _handleGeneratePlan(Map<String, dynamic> planInput) async {
    // print('PlanScreen received input plan data: $planInput');
    try {
      final plan = await apiService.getRandomPlan(planInput);

      if (plan != null) {
        setState(() {
          _planData = plan;
          // print('PlanScreen updated with new plan data: $_planData');
          _currentIndex = 3;
        });
      } else {
        print('Failed to receive new plan data');
      }

      print('Plan data sent successfully');
    } catch (error) {
      print('Error sending plan data: $error');
    }
  }

  void _handleDoneEditPlan(Map<String, dynamic> planData) {
    setState(() {
      _planData = planData; // Store the data from EditPlanScreen
      print('PlanScreen received plan data: $_planData');
      _currentIndex = 3;
    });
  }

  void _handleEditPlan(Map<String, dynamic> planData) {
    setState(() {
      _planData = planData; // Store the data from CreatePlanScreen
      print('PlanScreen received plan data: $_planData');
      _currentIndex = 5;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> children = [
      HomeScreen(
        onCreatePlan: _goToCreatePlanScreen,
        onPlan: _goToPlanScreen,
      ),
      const ProfileScreen(),
      CreatePlanScreen(
        onClose: _goToHomeScreen,
        onGeneratePlan: _handleGeneratePlan,
      ),
      PlanScreen(
        planData: _planData, // Pass the updated plan data
        onClose: _goToHomeScreen,
        onEditPlan: _handleEditPlan,
        onPlaceDetail: _goToPlaceDetailScreen,
      ),
      const PersonaScreen(),
      EditPlanScreen(
        planData: _planData, // Pass the updated plan data
        onClose: _goToPlanScreen,
        onCancel: _handleDoneEditPlan,
        onDone: _handleDoneEditPlan,
      ),
      PlaceDetailPage(
        onPlan: _goToPlanScreen,
        imageUrl: '',
        title: '',
        tagsData: const {},
        rating: '',
        openHours: '',
        ladtitude: 0,
        longtitude: 0,
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
