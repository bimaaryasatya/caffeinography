import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/routes/app_routes.dart';
import 'features/product/presentation/controllers/product_controller.dart';
import 'features/transaction/presentation/controllers/transaction_controller.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProductController()),
        ChangeNotifierProvider(create: (_) => TransactionController()),
      ],
      child: MaterialApp(
        title: 'CoffeePOS',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.brown),
          useMaterial3: true,
        ),
        initialRoute: AppRoutes.home,
        routes: AppRoutes.routes,
      ),
    );
  }
}
