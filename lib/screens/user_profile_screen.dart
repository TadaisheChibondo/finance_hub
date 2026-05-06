import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Profile", style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 40),
            
            // 1. User Avatar
            const CircleAvatar(
              radius: 60,
              backgroundColor: Color(0xFF2C3E50),
              child: Icon(Icons.person, size: 60, color: Colors.white),
            ),
            
            const SizedBox(height: 20),
            
            // 2. User Information
            const Text(
              "Dennis Shingirai",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const Text(
              "dennis@example.com",
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 10),
            const Text(
              "Joined: May 2026",
              style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic, color: Colors.blueGrey),
            ),
            
            const SizedBox(height: 50),
            
            // 3. Navigation Buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Column(
                children: [
                  // Settings Button
                  _buildProfileButton(
                    icon: Icons.settings,
                    label: "Account Settings",
                    color: const Color(0xFF2C3E50),
                    onPressed: () {
                      // Navigate to Settings
                    },
                  ),
                  
                  const SizedBox(height: 15),
                  
                  // Logout Button
                  _buildProfileButton(
                    icon: Icons.logout,
                    label: "Logout",
                    color: const Color(0xFFC0392B),
                    onPressed: () {
                      _showLogoutDialog(context);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper widget to keep the code clean
  Widget _buildProfileButton({
    required IconData icon, 
    required String label, 
    required Color color, 
    required VoidCallback onPressed
  }) {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, color: Colors.white),
        label: Text(label, style: const TextStyle(color: Colors.white, fontSize: 16)),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 2,
        ),
      ),
    );
  }

  // Function to handle Logout Navigation
  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Logout"),
        content: const Text("Are you sure you want to return to the login page?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              // This clears the navigation stack and returns to Login
              Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
            },
            child: const Text("Logout", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}