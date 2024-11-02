import 'package:flutter/material.dart';
import 'package:plan_a_day/src/screens/page/profile/persona_screen.dart';
import 'package:plan_a_day/services/auth_token.dart';
import 'package:plan_a_day/src/screens/page/authen/login_screen.dart';
import 'package:plan_a_day/services/api_service.dart'; 
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  final VoidCallback onBookmarkTap;
  final VoidCallback onHistoryTap;

  const ProfileScreen({super.key, required this.onBookmarkTap, required this.onHistoryTap});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  ApiService apiService = ApiService();
  String username = 'Loading...';
  
  @override
void initState() {
  super.initState();
  _checkAndFetchUserDetails();
}

Future<void> _checkAndFetchUserDetails() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool hasFetchedUsername = prefs.getBool('hasFetchedUsername') ?? false;

  if (!hasFetchedUsername) {
    await _fetchUserDetails();
    await prefs.setBool('hasFetchedUsername', true);
  } else {
    setState(() {
      username = prefs.getString('username') ?? 'Unknown User';
    });
  }
}

Future<void> _fetchUserDetails() async {
  try {
    final userDetails = await apiService.getUserDetail();
    String fetchedUsername = userDetails?['username'] ?? 'Unknown User';

    setState(() {
      username = fetchedUsername;
    });

    // Store the username locally for future loads
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', fetchedUsername);

  } catch (e) {
    setState(() {
      username = 'Error fetching username';
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Error fetching user details: ${e.toString()}'),
        backgroundColor: Colors.red,
      ),
    );
  }
}

  // Function to handle logout
  void _handleLogout(BuildContext context) async {
    try {
      await clearToken(); // Clear the stored token
      // Navigate to login page and remove all previous routes
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
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
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 24),
              Center(
                child: Image.asset(
                  'assets/images/launchLogo2.png',
                  height: 120,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                username,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 12),
              const Divider(thickness: 1, indent: 40, endIndent: 40),

              // Menu items
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  children: [
                    _buildProfileMenuItem(
                      icon: Icons.star_border,
                      text: 'My interests',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const PersonaScreen(),
                          ),
                        );
                      },
                    ),
                    _buildProfileMenuItem(
                      icon: Icons.bookmark_border,
                      text: 'Bookmark',
                      onTap: widget.onBookmarkTap,
                    ),
                    _buildProfileMenuItem(
                      icon: Icons.history,
                      text: 'History',
                      onTap: widget.onHistoryTap,
                    ),
                    const SizedBox(height: 20),
                    const Divider(thickness: 1),
                    _buildProfileMenuItem(
                      icon: Icons.logout,
                      text: 'Logout',
                      onTap: () => _handleLogout(context),
                      color: Colors.red, // Red icon for logout
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Menu item widget builder
  Widget _buildProfileMenuItem({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
    Color color = const Color(0xFFFF6838), // Default icon color
  }) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(
        text,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      ),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(vertical: 8),
    );
  }
}
