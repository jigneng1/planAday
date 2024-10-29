import 'package:flutter/material.dart';
import 'package:plan_a_day/src/screens/bookmark_plan.dart';
import 'package:plan_a_day/src/screens/history_plan_screen.dart';
import 'package:plan_a_day/src/screens/persona_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

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
              const Text(
                "MR. Sompong",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 8),
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
                      icon: Icons.bookmark_added_outlined,
                      text: 'Bookmarks',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const BookmarkPlanScreen(),
                          ),
                        );
                      },
                    ),
                    _buildProfileMenuItem(
                      icon: Icons.history,
                      text: 'History',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const HistoryPlanScreen(),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                    const Divider(thickness: 1),
                                        _buildProfileMenuItem(
                      icon: Icons.lock_outline,
                      text: 'Reset Password',
                      onTap: () {
                        // Navigate to reset password
                      },
                    ),
                    _buildProfileMenuItem(
                      icon: Icons.logout,
                      text: 'Logout',
                      onTap: () {
                        // Perform logout
                      },
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
    Color color = Colors.orange, // Default icon color
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
