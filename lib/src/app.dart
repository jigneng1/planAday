import 'package:flutter/material.dart';
import 'package:plan_a_day/services/api_service.dart';
import 'package:plan_a_day/src/screens/create_plan_screen.dart';
import 'package:plan_a_day/src/screens/data/place_details.dart';
import 'package:plan_a_day/src/screens/edit_plan_screen.dart';
import 'package:plan_a_day/src/screens/home_screen.dart';
import 'package:plan_a_day/src/screens/login_screen.dart';
import 'package:plan_a_day/src/screens/other_plan_screen.dart';
import 'package:plan_a_day/src/screens/persona_screen.dart';
import 'package:plan_a_day/src/screens/placeDetail_screen.dart';
import 'package:plan_a_day/src/screens/plan_screen.dart';
import 'package:plan_a_day/src/screens/profile_screen.dart';
import 'package:plan_a_day/src/screens/register_screen.dart';
import 'package:plan_a_day/src/screens/suggest_screen.dart';
import 'package:plan_a_day/src/screens/welcome_screen.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  final ApiService apiService = ApiService();
  int _currentIndex = 0;
  int _indexBeforeCreate = 0;
  String _ongoingPlanID = '';
  String placeID = '';
  String planID = '';
  bool _isLoading = false;

  Map<String, dynamic> _planData = {};

  // List to store multiple plans
  final List<Map<String, dynamic>> _allPlans = [];
  final List<Map<String, dynamic>> _suggestPlans = getSuggestPlan();

  void onTabTapped(int index) {
    setState(() {
      _isLoading = true;
      _currentIndex = index;
      _isLoading = false;
    });
  }

  void _goToHomeScreen() {
    setState(() {
      _isLoading = true;
      _currentIndex = 0;
      _isLoading = false;
    });
  }

  void _goToPlanScreen(String planID) {
    setState(() {
      _isLoading = true;
    });

    Map<String, dynamic>? selectedPlan = _allPlans
        .firstWhere((plan) => plan['planID'] == planID, orElse: () => {});

    if (selectedPlan.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {
          _planData = selectedPlan;
          _currentIndex = 3;
          _isLoading = false;
        });
      });
    } else {
      print('Plan with ID $planID not found.');
    }
  }

  void _goToOtherPlanScreen(String planID) {
    setState(() {
      _isLoading = true;
    });

    Map<String, dynamic>? selectedPlan = _suggestPlans.firstWhere(
      (suggestPlan) => suggestPlan['planID'] == planID,
      orElse: () => {},
    );

    if (selectedPlan.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {
          _planData = selectedPlan;
          _currentIndex = 7;
          _isLoading = false;
        });
      });
    } else {
      print('Plan with ID $planID not found.');
    }
  }

  void setOnGoingPlan(String planID) {
    Map<String, dynamic>? selectedPlan = _allPlans.firstWhere(
      (plan) => plan['planID'] == planID,
      orElse: () => {},
    );
    if (selectedPlan.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {
          _planData = selectedPlan;
        });
      });
    } else {
      print('Plan with ID $planID not found.');
    }
  }

  void _goToCreatePlanScreen() {
    setState(() {
      _isLoading = true;
      _currentIndex = 2;
      _isLoading = false;
    });
  }

  void _goToSuggestPlanScreen() {
    setState(() {
      _isLoading = true;
      _currentIndex = 11;
      _isLoading = false;
    });
  }

  void _goToPlaceDetailScreen(String placeIDinput, String planIDinput) {
    setState(() {
      _isLoading = true;
    });

    print('Place ID: $placeIDinput');
    if (placeIDinput.isNotEmpty && planIDinput.isNotEmpty) {
      setState(() {
        placeID = placeIDinput;
        planID = planIDinput;
        _currentIndex = 6;
        _isLoading = false;
      });
    } else {
      print('Place ID or Plan ID is empty');
    }
  }

  void _onStartPlan(String planID) {
    Map<String, dynamic>? selectedPlan = _allPlans.firstWhere(
      (plan) => plan['planID'] == planID,
      orElse: () => {},
    );
    if (selectedPlan.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {
          _ongoingPlanID = planID;
          _planData = selectedPlan;
          _currentIndex = 0;
        });
      });
    } else {
      print('Plan with ID $planID not found.');
    }
  }

  void _onStopPlan() {
    setState(() {
      _ongoingPlanID = '';
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
      _isLoading = true;
      _planData = planData; // Store the data from EditPlanScreen

      // Update the existing plan in the list if it exists
      int index =
          _allPlans.indexWhere((plan) => plan['planID'] == planData['planID']);
      if (index != -1) {
        _allPlans[index] = planData;
      }

      print('PlanScreen received plan data: $_planData');
      _currentIndex = 3;
      _isLoading = false;
    });
  }

  void _handleEditPlan(Map<String, dynamic> planData) {
    setState(() {
      _isLoading = true;
      _planData = planData; // Store the data from CreatePlanScreen
      print('PlanScreen received plan data: $_planData');
      _currentIndex = 5;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> children = [
      HomeScreen(
        onCreatePlan: _goToCreatePlanScreen,
        onPlan: _goToPlanScreen,
        onOtherPlan: _goToOtherPlanScreen,
        onViewSuggestPlan: _goToSuggestPlanScreen,
        allPlans: _allPlans,
        ongoingPlanID: _ongoingPlanID,
        onGoingPlan: _planData,
        onEndGoingPlan: _onStopPlan,
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
        onStartPlan: _onStartPlan,
        onGoingPlan: _ongoingPlanID,
        onStopPlan: _onStopPlan,
        onViewPlaceDetail: _goToPlaceDetailScreen,
        onRegeneratePlan: _handleDoneEditPlan,
      ),
      const PersonaScreen(),
      EditPlanScreen(
        planData: _planData, // Pass the updated plan data
        onClose: _goToHomeScreen,
        onCancel: _goToPlanScreen,
        onDone: _handleDoneEditPlan,
        onViewPlaceDetail: _goToPlaceDetailScreen,
      ),
      PlaceDetailPage(
        placeID: placeID,
        planID: planID,
        onBack: _goToPlanScreen,
      ),
      SavePlanScreen(
          onClose: _goToHomeScreen,
          planData: _planData,
          onViewPlaceDetail: _goToPlaceDetailScreen,
          onGoingPlan: _ongoingPlanID,
          onStopPlan: _onStopPlan,
          onStartPlan: _onStartPlan,),
      const WelcomeScreen(),
      const RegisterScreen(),
      const LoginScreen(),
      SuggestScreen(onClose: _goToHomeScreen,),
    ];

    return Scaffold(
      resizeToAvoidBottomInset:
          true, // Keep this true to prevent content from being resized
      body: Stack(
        children: [
          children[_currentIndex],
          if (_isLoading)
            Container(
              color: Colors.black54,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: MediaQuery.of(context).viewInsets.bottom != 0.0
          ? null
          : Container(
              margin: EdgeInsets.only(
                top: 30,
                bottom: MediaQuery.of(context).viewInsets.bottom > 0
                    ? 0
                    : 20, // Adjust based on keyboard
              ),
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
        color: Colors.white,
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
                  onTabTapped(1);
                },
                iconSize: _currentIndex == 1 ? 40 : 30,
                icon: Icon(
                  Icons.person,
                  color: _currentIndex == 1
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
