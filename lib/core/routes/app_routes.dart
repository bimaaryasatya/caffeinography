import 'package:flutter/material.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/product/presentation/pages/product_page.dart';
import '../../features/transaction/presentation/pages/transaction_page.dart';
import '../../features/receipt/presentation/pages/receipt_page.dart';
import '../../features/report/presentation/pages/report_page.dart';
import '../../features/product/presentation/pages/product_form_page.dart';
import '../../features/settings/presentation/pages/settings_page.dart';

class AppRoutes {
  static const String home = '/';
  static const String products = '/products';
  static const String productForm = '/products/form';
  static const String transactions = '/transactions';
  static const String receipts = '/receipts';
  static const String reports = '/reports';
  static const String settings = '/settings';

  static Map<String, WidgetBuilder> get routes => {
    home: (context) => const HomePage(),
    products: (context) => const ProductPage(),
    transactions: (context) => const TransactionPage(),
    receipts: (context) => const ReceiptPage(),
    reports: (context) => const ReportPage(),
    settings: (context) => const SettingsPage(),
    productForm: (context) => const ProductFormPage(),
  };
}
