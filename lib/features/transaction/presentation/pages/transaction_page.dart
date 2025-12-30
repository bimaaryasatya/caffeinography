import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../product/presentation/controllers/product_controller.dart';
import '../controllers/transaction_controller.dart';
import '../../data/models/transaction_model.dart';

class TransactionPage extends StatefulWidget {
  const TransactionPage({super.key});

  @override
  State<TransactionPage> createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProductController>().loadProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('New Transaction')),
      body: Column(
        children: [
          // 1. Product List (Top Half)
          Expanded(
            flex: 6,
            child: Consumer<ProductController>(
              builder: (context, productCtrl, child) {
                if (productCtrl.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                return GridView.builder(
                  padding: const EdgeInsets.all(8),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 1.5,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                  ),
                  itemCount: productCtrl.products.length,
                  itemBuilder: (context, index) {
                    final product = productCtrl.products[index];
                    return Card(
                      elevation: 2,
                      child: InkWell(
                        onTap: () {
                          context.read<TransactionController>().addToCart(
                            product,
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                product.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${product.sellPrice}',
                                style: const TextStyle(color: Colors.green),
                              ),
                              Text(
                                'Stock: ${product.stock}',
                                style: TextStyle(
                                  color: product.stock > 0
                                      ? Colors.grey
                                      : Colors.red,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          const Divider(thickness: 2, height: 2),
          // 2. Cart List (Bottom adjustable area)
          Expanded(
            flex: 4,
            child: Consumer<TransactionController>(
              builder: (context, transCtrl, child) {
                if (transCtrl.cart.isEmpty) {
                  return const Center(child: Text('Cart is empty'));
                }
                return ListView.separated(
                  padding: const EdgeInsets.all(8),
                  itemCount: transCtrl.cart.length,
                  separatorBuilder: (context, index) => const Divider(),
                  itemBuilder: (context, index) {
                    final item = transCtrl.cart.values.toList()[index];
                    return ListTile(
                      dense: true,
                      title: Text(
                        item.product.name,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        '${item.product.sellPrice} x ${item.quantity.toInt()}',
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(
                              Icons.remove_circle_outline,
                              color: Colors.red,
                            ),
                            onPressed: () =>
                                transCtrl.removeFromCart(item.product),
                          ),
                          Text(
                            '${item.quantity.toInt()}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.add_circle_outline,
                              color: Colors.green,
                            ),
                            onPressed: () => transCtrl.addToCart(item.product),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '${item.subtotal}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
          // 3. Checkout Summary
          Consumer<TransactionController>(
            builder: (context, transCtrl, child) {
              return Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.brown[50],
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 4,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: SafeArea(
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text('Total', style: TextStyle(fontSize: 14)),
                            Text(
                              '${transCtrl.total}',
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                          ],
                        ),
                      ),
                      ElevatedButton(
                        onPressed: transCtrl.cart.isEmpty || transCtrl.isLoading
                            ? null
                            : () => _showPaymentSheet(context, transCtrl),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 16,
                          ),
                          backgroundColor: Colors.brown,
                          foregroundColor: Colors.white,
                        ),
                        child: transCtrl.isLoading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text(
                                'Checkout',
                                style: TextStyle(fontSize: 16),
                              ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  void _showPaymentSheet(
    BuildContext context,
    TransactionController controller,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 16,
          right: 16,
          top: 16,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Select Payment Method',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ListTile(
              title: const Text('CASH'),
              leading: const Icon(Icons.money),
              onTap: () {
                Navigator.pop(context);
                _showCashDialog(context, controller);
              },
            ),
            ListTile(
              title: const Text('QRIS'),
              leading: const Icon(Icons.qr_code),
              onTap: () => _processPayment(context, controller, 'QRIS'),
            ),
            ListTile(
              title: const Text('MIDTRANS'),
              leading: const Icon(Icons.payment),
              onTap: () => _processPayment(context, controller, 'MIDTRANS'),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  void _showCashDialog(BuildContext context, TransactionController controller) {
    final amountController = TextEditingController();
    double change = 0;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Cash Payment'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Total: ${controller.total}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: amountController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Amount Received',
                    ),
                    onChanged: (value) {
                      final received = double.tryParse(value) ?? 0;
                      setState(() {
                        change = received - controller.total;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  if (change >= 0)
                    Text(
                      'Change: $change',
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  else
                    const Text(
                      'Insufficient Amount',
                      style: TextStyle(color: Colors.red),
                    ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed:
                      (double.tryParse(amountController.text) ?? 0) >=
                          controller.total
                      ? () {
                          Navigator.pop(context);
                          _processPayment(
                            context,
                            controller,
                            'CASH',
                            amountReceived: double.tryParse(
                              amountController.text,
                            ),
                          );
                        }
                      : null,
                  child: const Text('Pay'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _processPayment(
    BuildContext context,
    TransactionController controller,
    String method, {
    double? amountReceived,
  }) async {
    try {
      await controller.checkout(
        paymentMethod: method,
        amountReceived: amountReceived,
      );
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Transaction Successful!')),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }
}
