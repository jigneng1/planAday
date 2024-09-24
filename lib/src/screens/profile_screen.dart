import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Profile picture and name
            const SizedBox(height: 30),
            const CircleAvatar(
              radius: 60,
              backgroundImage: NetworkImage(
                  'https://via.placeholder.com/150'), // Placeholder image
            ),
            const SizedBox(height: 16),
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
                    icon: Icons.lock_outline,
                    text: 'Reset Password',
                    onTap: () {
                      // Navigate to reset password
                    },
                  ),
                  _buildProfileMenuItem(
                    icon: Icons.favorite_border,
                    text: 'Favorite Place',
                    onTap: () {
                      // Navigate to favorite places
                    },
                  ),
                  _buildProfileMenuItem(
                    icon: Icons.star_border,
                    text: 'My interests',
                    onTap: () {
                      // Navigate to interests
                    },
                  ),
                  _buildProfileMenuItem(
                    icon: Icons.history,
                    text: 'History',
                    onTap: () {
                      // Navigate to history
                    },
                  ),
                  const SizedBox(height: 20),
                  const Divider(thickness: 1),
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
