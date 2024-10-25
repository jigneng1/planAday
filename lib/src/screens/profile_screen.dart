import 'package:flutter/material.dart';
import 'package:plan_a_day/services/auth_token.dart';
import 'package:plan_a_day/src/screens/login_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});
  // Function to handle logout
  void _handleLogout(BuildContext context) async {
    try {
      await clearToken(); // Clear the stored token

      // Navigate to login page and remove all previous routes
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );

      // Alternative way if you want to push to a specific widget:
      // Navigator.of(context).pushAndRemoveUntil(
      //   MaterialPageRoute(builder: (context) => LoginScreen()),
      //   (Route<dynamic> route) => false,
      // );
    } catch (e) {
      // Handle any errors that might occur during logout
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error during logout: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        // Wrap Column with Center widget to center horizontally
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center, // Centers content vertically
          children: [
            const Text(
              "Profile Screen",
              style: TextStyle(fontSize: 24),
            ),
            GestureDetector(
              onTap: () => _handleLogout(context),
              child: Container(
                height: 55,
                width: 300,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  gradient: const LinearGradient(
                    colors: [Color(0xfffb9a4b), Color(0xffff6838)],
                  ),
                ),
                child: const Center(
                  child: Text(
                    'Log out',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
