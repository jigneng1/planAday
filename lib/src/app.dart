import 'package:flutter/material.dart';
import 'package:plan_a_day/src/screens/create_plan_screen.dart';
import 'package:plan_a_day/src/screens/home_screen.dart';
import 'package:plan_a_day/src/screens/profile_screen.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _currentIndex = 0;

  late final List<Widget> _children;

  @override
  void initState() {
    super.initState();
    _children = [
      const HomeScreen(),
      ProfileScreen(),
      CreatePlanScreen(onClose: _goToHomeScreen), // Pass the callback
    ];
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void _goToHomeScreen() {
    setState(() {
      _currentIndex = 1; // Assuming HomeScreen is at index 0
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _children[_currentIndex],
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Container(
        margin: const EdgeInsets.only(top: 30),
        height: 64,
        width: 64,
        child: FloatingActionButton(
          backgroundColor: Colors.orange[900],
          elevation: 0,
          onPressed: () {
            onTabTapped(2);
          },
          shape: RoundedRectangleBorder(
              side: const BorderSide(width: 3, color: Colors.transparent),
              borderRadius: BorderRadius.circular(100)),
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
                  //padding: const EdgeInsets.only(bottom: 10),
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
                //padding: const EdgeInsets.only(bottom: 10),
              )
            ],
          ),
        ),
      ),
    );
  }
}
