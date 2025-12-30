import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F0EB),
      appBar: AppBar(
        backgroundColor: const Color(0xFF5D4037),
        foregroundColor: Colors.white,
        title: const Text(
          'Settings',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Section
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.brown.withValues(alpha: 0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: const Color(0xFF5D4037),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(
                      Icons.store,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Caffeinography',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF3E2723),
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Coffee Shop POS',
                          style: TextStyle(color: Color(0xFF8D6E63)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            const Text(
              'General',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF8D6E63),
              ),
            ),
            const SizedBox(height: 12),

            _buildSettingsTile(
              icon: Icons.store,
              title: 'Store Info',
              subtitle: 'Manage store details',
              onTap: () {},
            ),
            _buildSettingsTile(
              icon: Icons.receipt,
              title: 'Receipt Settings',
              subtitle: 'Customize receipt format',
              onTap: () {},
            ),
            _buildSettingsTile(
              icon: Icons.payment,
              title: 'Payment Methods',
              subtitle: 'Configure payment options',
              onTap: () {},
            ),

            const SizedBox(height: 24),

            const Text(
              'Data',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF8D6E63),
              ),
            ),
            const SizedBox(height: 12),

            _buildSettingsTile(
              icon: Icons.backup,
              title: 'Backup & Restore',
              subtitle: 'Manage your data',
              onTap: () {},
            ),
            _buildSettingsTile(
              icon: Icons.sync,
              title: 'Sync Settings',
              subtitle: 'Cloud sync options',
              onTap: () {},
            ),

            const SizedBox(height: 24),

            const Text(
              'About',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF8D6E63),
              ),
            ),
            const SizedBox(height: 12),

            _buildSettingsTile(
              icon: Icons.info_outline,
              title: 'About App',
              subtitle: 'Version 1.0.0',
              onTap: () {},
            ),
            _buildSettingsTile(
              icon: Icons.help_outline,
              title: 'Help & Support',
              subtitle: 'Get assistance',
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.brown.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: const Color(0xFFEFEBE9),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: const Color(0xFF5D4037), size: 22),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF3E2723),
                        ),
                      ),
                      Text(
                        subtitle,
                        style: const TextStyle(
                          color: Color(0xFF8D6E63),
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right, color: Color(0xFFBCAAA4)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
