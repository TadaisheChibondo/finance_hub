import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'About',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 40),

            // App Icon / Logo
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(50),
              ),
              child: const Icon(
                Icons.account_balance_wallet,
                size: 60,
                color: Colors.green,
              ),
            ),

            const SizedBox(height: 20),

            // App Name
            const Text(
              'Finance Hub',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),

            const SizedBox(height: 8),

            // Version
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                'Version 1.0.0',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
            ),

            const SizedBox(height: 40),

            // Description Card
            _buildInfoCard(
              title: 'About This App',
              icon: Icons.info_outline,
              children: [
                const Text(
                  'Finance Hub is a mobile app designed to help users track expenses, apply for simulated mini-loans, and access financial education.',
                  style: TextStyle(fontSize: 14, height: 1.4),
                ),
                const SizedBox(height: 12),
                const Text(
                  'This app was developed as a school project to demonstrate mobile development skills using Flutter and Firebase.',
                  style: TextStyle(fontSize: 14, height: 1.4),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Disclaimer Card (Important)
            _buildInfoCard(
              title: '⚠️ Disclaimer',
              icon: Icons.warning_amber_rounded,
              iconColor: Colors.orange,  // FIXED: Changed from IconData? to Color?
              children: [
                const Text(
                  'This is a school project demonstration only.',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text(
                  'No real money is lent or owed. All loan approvals are simulated for educational purposes. Do not use this app for actual financial transactions.',
                  style: TextStyle(fontSize: 13, height: 1.4),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Team Card
            _buildInfoCard(
              title: '👥 Team Members',
              icon: Icons.people,
              children: [
                _buildTeamMemberRow('Project Lead', '______'),
                _buildTeamMemberRow('GitHub Manager', '______'),
                _buildTeamMemberRow('Backend + Database', '______'),
                _buildTeamMemberRow('Auth Screens', '______'),
                _buildTeamMemberRow('Dashboard', '______'),
                _buildTeamMemberRow('Add Expense', '______'),
                _buildTeamMemberRow('View Expenses', '______'),
                _buildTeamMemberRow('Loan Apply', '______'),
                _buildTeamMemberRow('Loan History', '______'),
                _buildTeamMemberRow('Advice', '______'),
                _buildTeamMemberRow('Profile', '______'),
                _buildTeamMemberRow('Settings + About', '______'),
              ],
            ),

            const SizedBox(height: 16),

            // Tech Stack Card
            _buildInfoCard(
              title: '🛠️ Tech Stack',
              icon: Icons.code,
              children: [
                _buildTechRow(Icons.flutter_dash, 'Flutter', 'Frontend framework'),
                _buildTechRow(Icons.cloud, 'Firebase', 'Authentication & Database'),
                _buildTechRow(Icons.bolt, 'Provider', 'State management'),
              ],
            ),

            const SizedBox(height: 40),

            // Footer
            Padding(
              padding: const EdgeInsets.only(bottom: 30),
              child: Text(
                '© 2026 Finance Hub - School Project',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildInfoCard({
    required String title,
    required IconData icon,
    Color? iconColor,  // FIXED: This was IconData? but should be Color?
    required List<Widget> children,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: iconColor ?? Colors.green, size: 22),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...children,
          ],
        ),
      ),
    );
  }

  // Team member row widget
  Widget _buildTeamMemberRow(String role, String name) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              role,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const Text(':  '),
          Expanded(
            child: Text(
              name.isEmpty ? 'TBD' : name,
              style: const TextStyle(fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }

  // Tech stack row widget
  Widget _buildTechRow(IconData icon, String tech, String description) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.green),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                tech,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                description,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}