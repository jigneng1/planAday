import 'package:flutter/material.dart';
import 'package:plan_a_day/services/api_service.dart';
import 'package:plan_a_day/src/screens/page/plan/create_plan_screen.dart';
import 'package:plan_a_day/src/screens/page/plan/edit_plan_screen.dart';
import 'package:plan_a_day/src/screens/page/plan/generated_screen.dart';
import 'package:plan_a_day/src/screens/home_screen.dart';
import 'package:plan_a_day/src/screens/page/authen/login_screen.dart';
import 'package:plan_a_day/src/screens/page/plan/other_plan_screen.dart';
import 'package:plan_a_day/src/screens/page/profile/bookmark_screen.dart';
import 'package:plan_a_day/src/screens/page/profile/history_screen.dart';
import 'package:plan_a_day/src/screens/page/profile/persona_screen.dart';
import 'package:plan_a_day/src/screens/placeDetail_screen.dart';
import 'package:plan_a_day/src/screens/page/plan/plan_screen.dart';
import 'package:plan_a_day/src/screens/page/profile/profile_screen.dart';
import 'package:plan_a_day/src/screens/page/authen/register_screen.dart';
import 'package:plan_a_day/src/screens/suggest_screen.dart';
import 'package:plan_a_day/src/screens/page/authen/welcome_screen.dart';

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
  Map<String, dynamic> _ongoingplanData = {};
  final List<Map<String, dynamic>> _allPlans = [];
  // final List<Map<String, dynamic>> _suggestPlans = getSuggestPlan();

  bool fromHistory() {
    // Ensure _indexBeforeCreate is not null before comparing
    return (_indexBeforeCreate ?? 0) == 13; // Use a default value if null
  }

  void onTabTapped(int index) {
    if (!mounted) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _isLoading = true;
        _currentIndex = index;
        _indexBeforeCreate = index;
        _isLoading = false;
      });
    });
  }

  void _goToHomeScreen() {
    if (!mounted) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _isLoading = true;
        _currentIndex = 0;
        _indexBeforeCreate = 0;
        _isLoading = false;
      });
    });
  }

  void _goToPlanScreen(String planID) async {
    if (!mounted) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
    setState(() {
      _isLoading = true;
    });
  });

    // Await the async call to get the plan detail
    Map<String, dynamic>? selectedPlan = await apiService.getPlanDetail(planID);

    if (!mounted) return;
    if (selectedPlan != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {
          _planData = selectedPlan;
          _currentIndex = 3;
          _indexBeforeCreate = 3;
          _isLoading = false;
        });
      });
    } else {
      print('Plan with ID $planID not found.');
      WidgetsBinding.instance.addPostFrameCallback((_) {
    setState(() {
      _isLoading = false;
    });
  });
    }
  }

  void _goBack() {
    if(!mounted) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
    setState(() {
      _currentIndex = _indexBeforeCreate;
    });
  });
  }

  void _goToGeneratedPlanScreen(String planID) {
    if(!mounted) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
    setState(() {
      _isLoading = true;
    });

    Map<String, dynamic>? selectedPlan = _allPlans
        .firstWhere((plan) => plan['planID'] == planID, orElse: () => {});

    if (selectedPlan.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {
          _planData = selectedPlan;
          _currentIndex = 12;
          _indexBeforeCreate = 12;
          _isLoading = false;
        });
      });
    } else {
      print('Plan with ID $planID not found.');
    }
    });
  }

  void _goToOtherPlanScreen(String planID) async {
    if(!mounted) return;
    WidgetsBinding.instance.addPostFrameCallback((_) async{
    setState(() {
      _isLoading = true;
    });

    Map<String, dynamic>? selectedPlan = await apiService.getPlanDetail(planID);

    if (mounted) {
      setState(() {
        _planData = selectedPlan ?? {}; // Fallback in case selectedPlan is null
        _currentIndex = 7;
        _isLoading = false;
      });
    }
    });
  }

  void _goToCreatePlanScreen() {
    if (!mounted) return;
    WidgetsBinding.instance.addPostFrameCallback((_) async{
    setState(() {
      _isLoading = true;
      _currentIndex = 2;
      _indexBeforeCreate = 2;
      _isLoading = false;
    });
    });
  }

  void _goToSuggestPlanScreen() {
    if (!mounted) return;
    WidgetsBinding.instance.addPostFrameCallback((_) async{
    setState(() {
      _isLoading = true;
      _currentIndex = 11;
      _indexBeforeCreate = 11;
      _isLoading = false;
    });
    });
  }

  void _goToPlaceDetailScreen(String placeIDinput, String planIDinput) {
    if (!mounted) return;
    WidgetsBinding.instance.addPostFrameCallback((_) async{
    setState(() {
      _isLoading = true;
    });
    });

    print('Place ID: $placeIDinput');
    if (placeIDinput.isNotEmpty && planIDinput.isNotEmpty) {
      if (!mounted) return;
      WidgetsBinding.instance.addPostFrameCallback((_) async{
      setState(() {
        placeID = placeIDinput;
        planID = planIDinput;
        _currentIndex = 6;
        _isLoading = false;
      });
      });
    } else {
      print('Place ID or Plan ID is empty');
    }
  }

  void _onStartPlan(String planID) async {
    if (!mounted) return;
    WidgetsBinding.instance.addPostFrameCallback((_) async{
    setState(() {
      _isLoading = true;
    });
    });
    Map<String, dynamic>? selectedPlan = await apiService.getPlanDetail(planID);
    print('Start Plan: $planID');

    if (selectedPlan != null) {
      if (!mounted) return;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {
          _ongoingPlanID = planID;
          _ongoingplanData = selectedPlan;
          _currentIndex = 0;
          _isLoading = false;
        });
      });
    } else {
      print('Plan with ID $planID not found.');
    }
  }

  void _onStopPlan() {
    if (!mounted) return;
    WidgetsBinding.instance.addPostFrameCallback((_) async{
    setState(() {
      _ongoingPlanID = '';
      // _currentIndex = 0;
    });
    });
  }

  void onDone(Map<String, dynamic> planData) async {
    final planId = await apiService.savePlan(planData);

    _goToPlanScreen(planId);
  }

  void _handleGeneratePlan(Map<String, dynamic> planInput) async {
    try {
      final plan = await apiService.getRandomPlan(planInput);

      if (plan != null) {
        if (!mounted) return;
        setState(() {
          _planData = plan;

          // Add the new plan to the list of all plans
          _allPlans.add(plan);

          _currentIndex = 12;
          _indexBeforeCreate = 12;
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
    if (!mounted) return;
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
      _currentIndex = 12;
      _isLoading = false;
    });
  }

  void _handleEditPlan(Map<String, dynamic> planData) {
    if (!mounted) return;
    setState(() {
      _isLoading = true;
      _planData = planData; // Store the data from CreatePlanScreen
      print('PlanScreen received plan data: $_planData');
      _currentIndex = 5;
      _indexBeforeCreate = 5;
      _isLoading = false;
    });
  }

  void _goToBookmarkPlanScreen() {
    if (!mounted) return;
    WidgetsBinding.instance.addPostFrameCallback((_) async{
    setState(() {
      _isLoading = true;
      _currentIndex = 13;
      _indexBeforeCreate = 13;
      _isLoading = false;
    });
    });
  }

  void _goToHistoryPlanScreen() {
    if (!mounted) return;
    WidgetsBinding.instance.addPostFrameCallback((_) async{
    setState(() {
      _isLoading = true;
      _currentIndex = 14;
      _indexBeforeCreate = 14;
      _isLoading = false;
    });
    });
  }

  void _goToProfile() {
    if (!mounted) return;
    WidgetsBinding.instance.addPostFrameCallback((_) async{
    setState(() {
      _isLoading = true;
      _currentIndex = 1;
      _indexBeforeCreate = 1;
      _isLoading = false;
    });
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
        ongoingPlanID: _ongoingPlanID,
        onGoingPlan: _ongoingplanData,
        onEndGoingPlan: _onStopPlan,
      ),
      ProfileScreen(
        onBookmarkTap: _goToBookmarkPlanScreen,
        onHistoryTap: _goToHistoryPlanScreen,
      ),
      CreatePlanScreen(
        onClose: _goToHomeScreen,
        onGeneratePlan: _handleGeneratePlan,
      ),
      PlanScreen(
        planData: _planData, // Pass the updated plan data
        onClose: _goToHomeScreen,
        onStartPlan: _onStartPlan,
        onGoingPlan: _ongoingPlanID,
        onStopPlan: _onStopPlan,
        onViewPlaceDetail: _goToPlaceDetailScreen,
      ),
      const PersonaScreen(),
      EditPlanScreen(
        planData: _planData, // Pass the updated plan data
        onClose: _goToHomeScreen,
        onCancel: _goToGeneratedPlanScreen,
        onDone: _handleDoneEditPlan,
        onViewPlaceDetail: _goToPlaceDetailScreen,
      ),
      PlaceDetailPage(
        placeID: placeID,
        planID: planID,
      ),
      OtherPlanScreen(
        onClose: _goBack,
        planData: _planData,
        onViewPlaceDetail: _goToPlaceDetailScreen,
        onGoingPlan: _ongoingPlanID,
        onStopPlan: _onStopPlan,
        onStartPlan: _onStartPlan,
        fromHistory: fromHistory(),
      ),
      const WelcomeScreen(),
      const RegisterScreen(),
      const LoginScreen(),
      SuggestScreen(
        onClose: _goToHomeScreen,
        onViewPlan: _goToOtherPlanScreen,
      ),
      GeneratedPlanScreen(
        onClose: _goToHomeScreen,
        planData: _planData,
        onEditPlan: _handleEditPlan,
        onDone: onDone,
        onViewPlaceDetail: _goToPlaceDetailScreen,
        onRegeneratePlan: _handleGeneratePlan,
      ),
      BookmarkPlanScreen(
        onClose: _goToProfile,
        onViewPlan: _goToOtherPlanScreen,
      ),
      HistoryPlanScreen(onClose: _goToProfile, onViewPlan: _goToPlanScreen),
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
                backgroundColor: Theme.of(context).primaryColor,
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
      bottomNavigationBar: Builder(
        builder: (BuildContext context) {
          return BottomAppBar(
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
          );
        },
      ),
    );
  }
}
