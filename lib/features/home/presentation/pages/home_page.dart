import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F0EB),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: const Color(0xFF5D4037),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.coffee,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Caffeinography',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF3E2723),
                        ),
                      ),
                      Text(
                        'Point of Sale',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF8D6E63),
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 40),

              // Quick Actions Title
              const Text(
                'Quick Actions',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF5D4037),
                ),
              ),

              const SizedBox(height: 16),

              // Main Grid
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  children: [
                    _buildMenuCard(
                      context,
                      icon: Icons.point_of_sale,
                      title: 'New Order',
                      subtitle: 'Create transaction',
                      color: const Color(0xFF5D4037),
                      route: '/transactions',
                    ),
                    _buildMenuCard(
                      context,
                      icon: Icons.inventory_2,
                      title: 'Products',
                      subtitle: 'Manage inventory',
                      color: const Color(0xFF795548),
                      route: '/products',
                    ),
                    _buildMenuCard(
                      context,
                      icon: Icons.receipt_long,
                      title: 'Receipts',
                      subtitle: 'View history',
                      color: const Color(0xFF8D6E63),
                      route: '/receipts',
                    ),
                    _buildMenuCard(
                      context,
                      icon: Icons.bar_chart,
                      title: 'Reports',
                      subtitle: 'Sales analytics',
                      color: const Color(0xFFA1887F),
                      route: '/reports',
                    ),
                  ],
                ),
              ),

              // Settings Button
              _buildSettingsButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required String route,
  }) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, route),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.2),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(icon, color: Colors.white, size: 28),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF3E2723),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF8D6E63),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSettingsButton(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, '/settings'),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFD7CCC8)),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.settings, color: Color(0xFF8D6E63)),
            SizedBox(width: 8),
            Text(
              'Settings',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Color(0xFF5D4037),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
