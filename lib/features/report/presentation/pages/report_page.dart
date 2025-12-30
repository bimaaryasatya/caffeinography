import 'package:flutter/material.dart';

class ReportPage extends StatelessWidget {
  const ReportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F0EB),
      appBar: AppBar(
        backgroundColor: const Color(0xFF5D4037),
        foregroundColor: Colors.white,
        title: const Text(
          'Reports',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Summary Cards
            Row(
              children: [
                Expanded(
                  child: _buildSummaryCard(
                    icon: Icons.receipt_long,
                    title: 'Today',
                    value: 'Rp 0',
                    subtitle: '0 orders',
                    color: const Color(0xFF5D4037),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildSummaryCard(
                    icon: Icons.calendar_month,
                    title: 'This Month',
                    value: 'Rp 0',
                    subtitle: '0 orders',
                    color: const Color(0xFF795548),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Quick Reports Section
            const Text(
              'Quick Reports',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color(0xFF5D4037),
              ),
            ),
            const SizedBox(height: 12),

            _buildReportTile(
              icon: Icons.trending_up,
              title: 'Sales Summary',
              subtitle: 'View daily/weekly/monthly sales',
              onTap: () {},
            ),
            _buildReportTile(
              icon: Icons.inventory_2,
              title: 'Stock Report',
              subtitle: 'View inventory levels',
              onTap: () {},
            ),
            _buildReportTile(
              icon: Icons.star,
              title: 'Best Sellers',
              subtitle: 'Top selling products',
              onTap: () {},
            ),
            _buildReportTile(
              icon: Icons.history,
              title: 'Transaction History',
              subtitle: 'All past transactions',
              onTap: () {},
            ),

            const SizedBox(height: 24),

            // Placeholder for charts
            Container(
              height: 200,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.brown.withValues(alpha: 0.08),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.bar_chart, size: 48, color: Color(0xFFBCAAA4)),
                    SizedBox(height: 8),
                    Text(
                      'Charts Coming Soon',
                      style: TextStyle(color: Color(0xFF8D6E63)),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard({
    required IconData icon,
    required String title,
    required String value,
    required String subtitle,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.15),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: Colors.white, size: 20),
              ),
              const Spacer(),
              Text(
                title,
                style: const TextStyle(color: Color(0xFF8D6E63), fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            subtitle,
            style: const TextStyle(color: Color(0xFF8D6E63), fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildReportTile({
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
            color: Colors.brown.withValues(alpha: 0.08),
            blurRadius: 8,
            offset: const Offset(0, 4),
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
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: const Color(0xFFEFEBE9),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: const Color(0xFF5D4037)),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
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
                const Icon(Icons.chevron_right, color: Color(0xFF8D6E63)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
