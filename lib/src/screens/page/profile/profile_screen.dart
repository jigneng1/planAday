import 'package:flutter/material.dart';
import 'package:plan_a_day/services/api_service.dart';
import 'package:plan_a_day/services/auth_token.dart';
import 'package:plan_a_day/src/screens/page/authen/login_screen.dart';
import 'package:plan_a_day/src/screens/page/profile/persona_screen.dart';

class ProfileScreen extends StatelessWidget {
  final VoidCallback onBookmarkTap;
  const ProfileScreen({super.key, required this.onBookmarkTap});

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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error during logout: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<String?> _fetchUsername() async {
    final userDetails = await ApiService().getUserDetail();
    return userDetails?['username'];
  }

  @override
  Widget build(BuildContext context) {
    // Fetch username directly without a loading indicator
    final Future<String?> usernameFuture = _fetchUsername();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 24),
              FutureBuilder<String?>(
                future: usernameFuture,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return const Text(
                      'Error loading username',
                      style: TextStyle(fontSize: 22, color: Colors.red),
                    );
                  } else {
                    return Text(
                      snapshot.data ?? '',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    );
                  }
                },
              ),
              const SizedBox(height: 8),
              const Divider(thickness: 1, indent: 40, endIndent: 40),
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
                      icon: Icons.bookmark_added_outlined,
                      text: 'Saved',
                      onTap: () {
                        onBookmarkTap();
                      },
                    ),
                    _buildProfileMenuItem(
                      icon: Icons.history,
                      text: 'History',
                      onTap: () {},
                    ),
                    const SizedBox(height: 20),
                    const Divider(thickness: 1),
                    _buildProfileMenuItem(
                      icon: Icons.logout,
                      text: 'Logout',
                      onTap: () => _handleLogout(context),
                      color: Colors.red,
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

  Widget _buildProfileMenuItem({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
    Color color = const Color(0xFFFF6838),
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
