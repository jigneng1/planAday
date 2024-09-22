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
  bool _haveOngoingPlan = false;

  Map<String, dynamic> _planData = {};

  // List to store multiple plans
  List<Map<String, dynamic>> _allPlans = [];

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void _goToHomeScreen() {
    setState(() {
      _currentIndex = 0;
    });
  }

  void _goToPlanScreen(String planID) {
  // Search for the plan by planID in the list of all plans
  Map<String, dynamic>? selectedPlan = _allPlans.firstWhere(
    (plan) => plan['planID'] == planID,
    orElse: () => {},
  );

  if (selectedPlan.isNotEmpty) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _planData = selectedPlan;  // Update the _planData with the selected plan
        _currentIndex = 3;         // Navigate to PlanScreen (index 3)
      });
    });
  } else {
    print('Plan with ID $planID not found.');
  }
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

  void _onStartPlan() {
    setState(() {
      _haveOngoingPlan = true;
      _currentIndex = 0;
    });
  }

  void _onStopPlan() {
    setState(() {
      _haveOngoingPlan = false;
      // _currentIndex = 0;
    });
  }

  void _handleGeneratePlan(Map<String, dynamic> planInput) async {
    try {
      final plan = await apiService.getRandomPlan(planInput);

      if (plan != null) {
        setState(() {
          _planData = plan;

          // Add the new plan to the list of all plans
          _allPlans.add(plan);

          _currentIndex = 3;
        });
      } else {
        print('Failed to receive new plan data');
      }

      print('Plan data sent successfully');
      print(_allPlans);
    } catch (error) {
      print('Error sending plan data: $error');
    }
  }

  void _handleDoneEditPlan(Map<String, dynamic> planData) {
    setState(() {
      _planData = planData; // Store the data from EditPlanScreen

      // Update the existing plan in the list if it exists
      int index = _allPlans.indexWhere((plan) => plan['planID'] == planData['planID']);
      if (index != -1) {
        _allPlans[index] = planData;
      }

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
        allPlans: _allPlans,
        haveOngoingPlan: _haveOngoingPlan,
        onViewOngoingPlan: _goToPlanScreen,
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
        onStartPlan: _onStartPlan,
        onGoingPlan: _haveOngoingPlan,
        onStopPlan: _onStopPlan,
      ),
      const PersonaScreen(),
      EditPlanScreen(
        planData: _planData, // Pass the updated plan data
        onClose: _goToHomeScreen,
        onCancel: _goToPlanScreen,
        onDone: _handleDoneEditPlan,
      ),
      PlaceDetailPage(
        onPlan: _goToHomeScreen, imageUrl: '', title: '',
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

