import 'package:flutter/material.dart';

class ReceiptPage extends StatelessWidget {
  const ReceiptPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F0EB),
      appBar: AppBar(
        backgroundColor: const Color(0xFF5D4037),
        foregroundColor: Colors.white,
        title: const Text(
          'Receipts',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        elevation: 0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: const Color(0xFFEFEBE9),
                borderRadius: BorderRadius.circular(24),
              ),
              child: const Icon(
                Icons.receipt_long,
                size: 48,
                color: Color(0xFFBCAAA4),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'No Receipts Yet',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Color(0xFF5D4037),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Completed orders will appear here',
              style: TextStyle(color: Color(0xFF8D6E63)),
            ),
          ],
        ),
      ),
    );
  }
}
