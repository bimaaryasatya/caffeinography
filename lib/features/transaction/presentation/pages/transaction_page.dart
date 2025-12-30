import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../product/presentation/controllers/product_controller.dart';
import '../controllers/transaction_controller.dart';
import '../../../payment/presentation/controllers/payment_controller.dart';

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
      backgroundColor: const Color(0xFFF5F0EB),
      appBar: AppBar(
        backgroundColor: const Color(0xFF5D4037),
        foregroundColor: Colors.white,
        title: const Text(
          'New Order',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        elevation: 0,
        actions: [
          Consumer<TransactionController>(
            builder: (context, ctrl, _) => ctrl.cart.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.delete_sweep),
                    onPressed: () => ctrl.clearCart(),
                    tooltip: 'Clear Cart',
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
      body: Column(
        children: [
          // Products Grid
          Expanded(
            flex: 5,
            child: Consumer<ProductController>(
              builder: (context, productCtrl, _) {
                if (productCtrl.isLoading) {
                  return const Center(
                    child: CircularProgressIndicator(color: Color(0xFF5D4037)),
                  );
                }
                return GridView.builder(
                  padding: const EdgeInsets.all(12),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 1.1,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemCount: productCtrl.products.length,
                  itemBuilder: (context, index) {
                    final product = productCtrl.products[index];
                    final isOutOfStock = product.stock <= 0;
                    return GestureDetector(
                      onTap: isOutOfStock
                          ? null
                          : () => context
                                .read<TransactionController>()
                                .addToCart(product),
                      child: Container(
                        decoration: BoxDecoration(
                          color: isOutOfStock
                              ? Colors.grey.shade200
                              : Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.brown.withValues(alpha: 0.1),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Stack(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 44,
                                    height: 44,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFEFEBE9),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Icon(
                                      Icons.local_cafe,
                                      color: isOutOfStock
                                          ? Colors.grey
                                          : const Color(0xFF8D6E63),
                                    ),
                                  ),
                                  const Spacer(),
                                  Text(
                                    product.name,
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: isOutOfStock
                                          ? Colors.grey
                                          : const Color(0xFF3E2723),
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Rp ${product.sellPrice.toStringAsFixed(0)}',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: isOutOfStock
                                          ? Colors.grey
                                          : const Color(0xFF5D4037),
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    'Stock: ${product.stock.toInt()}',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: isOutOfStock
                                          ? Colors.red
                                          : const Color(0xFF8D6E63),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (isOutOfStock)
                              Positioned(
                                top: 8,
                                right: 8,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Text(
                                    'OUT',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),

          // Cart Section
          Expanded(
            flex: 4,
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: Offset(0, -4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Cart Header
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.shopping_cart,
                          color: Color(0xFF5D4037),
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'Your Order',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF3E2723),
                          ),
                        ),
                        const Spacer(),
                        Consumer<TransactionController>(
                          builder: (context, ctrl, _) => Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFEFEBE9),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              '${ctrl.cart.length} items',
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF5D4037),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 1),

                  // Cart Items
                  Expanded(
                    child: Consumer<TransactionController>(
                      builder: (context, transCtrl, _) {
                        if (transCtrl.cart.isEmpty) {
                          return const Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.shopping_bag_outlined,
                                  size: 48,
                                  color: Color(0xFFBCAAA4),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'Cart is empty',
                                  style: TextStyle(color: Color(0xFF8D6E63)),
                                ),
                              ],
                            ),
                          );
                        }
                        return ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: transCtrl.cart.length,
                          itemBuilder: (context, index) {
                            final item = transCtrl.cart.values.toList()[index];
                            return Container(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              decoration: const BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(color: Color(0xFFEFEBE9)),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          item.product.name,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w600,
                                            color: Color(0xFF3E2723),
                                          ),
                                        ),
                                        Text(
                                          'Rp ${item.product.sellPrice.toStringAsFixed(0)}',
                                          style: const TextStyle(
                                            fontSize: 13,
                                            color: Color(0xFF8D6E63),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      _buildQtyButton(
                                        icon: Icons.remove,
                                        onTap: () => transCtrl.removeFromCart(
                                          item.product,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 40,
                                        child: Text(
                                          '${item.quantity.toInt()}',
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      _buildQtyButton(
                                        icon: Icons.add,
                                        onTap: () =>
                                            transCtrl.addToCart(item.product),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(width: 16),
                                  SizedBox(
                                    width: 80,
                                    child: Text(
                                      'Rp ${item.subtotal.toStringAsFixed(0)}',
                                      textAlign: TextAlign.end,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF5D4037),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),

                  // Footer
                  Consumer<TransactionController>(
                    builder: (context, transCtrl, _) => Container(
                      padding: const EdgeInsets.all(20),
                      decoration: const BoxDecoration(
                        color: Color(0xFF5D4037),
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(24),
                        ),
                      ),
                      child: SafeArea(
                        top: false,
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Text(
                                    'Total',
                                    style: TextStyle(
                                      color: Color(0xFFBCAAA4),
                                      fontSize: 14,
                                    ),
                                  ),
                                  Text(
                                    'Rp ${transCtrl.total.toStringAsFixed(0)}',
                                    style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            ElevatedButton(
                              onPressed:
                                  transCtrl.cart.isEmpty || transCtrl.isLoading
                                  ? null
                                  : () => _showPaymentSheet(context, transCtrl),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: const Color(0xFF5D4037),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 32,
                                  vertical: 16,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                              child: transCtrl.isLoading
                                  ? const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : const Text(
                                      'Pay Now',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQtyButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: const Color(0xFFEFEBE9),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, size: 18, color: const Color(0xFF5D4037)),
      ),
    );
  }

  void _showPaymentSheet(
    BuildContext context,
    TransactionController controller,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Payment Method',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF3E2723),
              ),
            ),
            const SizedBox(height: 20),
            _buildPaymentOption(
              icon: Icons.money,
              title: 'Cash',
              subtitle: 'Pay with cash',
              onTap: () {
                Navigator.pop(context);
                _showCashDialog(context, controller);
              },
            ),
            const SizedBox(height: 12),
            _buildPaymentOption(
              icon: Icons.qr_code,
              title: 'QRIS',
              subtitle: 'Scan QR code',
              onTap: () {
                Navigator.pop(context);
                _processPayment(context, controller, 'QRIS');
              },
            ),
            const SizedBox(height: 12),
            _buildPaymentOption(
              icon: Icons.credit_card,
              title: 'Midtrans',
              subtitle: 'Digital payment',
              onTap: () {
                Navigator.pop(context);
                _processPayment(context, controller, 'MIDTRANS');
              },
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFF5F0EB),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: const Color(0xFF5D4037),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: Colors.white),
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
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
            const Spacer(),
            const Icon(Icons.chevron_right, color: Color(0xFF8D6E63)),
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
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text(
            'Cash Payment',
            style: TextStyle(color: Color(0xFF3E2723)),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F0EB),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Total:',
                      style: TextStyle(color: Color(0xFF8D6E63)),
                    ),
                    Text(
                      'Rp ${controller.total.toStringAsFixed(0)}',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF5D4037),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: amountController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Amount Received',
                  prefixIcon: const Icon(
                    Icons.attach_money,
                    color: Color(0xFF8D6E63),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFFD7CCC8)),
                  ),
                ),
                onChanged: (value) {
                  final received = double.tryParse(value) ?? 0;
                  setState(() => change = received - controller.total);
                },
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: change >= 0
                      ? Colors.green.shade50
                      : Colors.red.shade50,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      change >= 0 ? 'Change:' : 'Insufficient',
                      style: TextStyle(
                        color: change >= 0 ? Colors.green : Colors.red,
                      ),
                    ),
                    if (change >= 0)
                      Text(
                        'Rp ${change.toStringAsFixed(0)}',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.green.shade700,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'Cancel',
                style: TextStyle(color: Color(0xFF8D6E63)),
              ),
            ),
            ElevatedButton(
              onPressed:
                  (double.tryParse(amountController.text) ?? 0) >=
                      controller.total
                  ? () {
                      Navigator.pop(context);
                      _processPayment(
                        context,
                        controller,
                        'CASH',
                        amountReceived: double.tryParse(amountController.text),
                      );
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF5D4037),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Confirm'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _processPayment(
    BuildContext context,
    TransactionController controller,
    String method, {
    double? amountReceived,
  }) async {
    try {
      final transaction = await controller.checkout(
        paymentMethod: method,
        amountReceived: amountReceived,
      );
      if (transaction == null) return;
      if (!context.mounted) return;

      if (method == 'MIDTRANS' || method == 'QRIS') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Processing Payment...'),
            backgroundColor: Color(0xFF5D4037),
          ),
        );

        final paymentCtrl = context.read<PaymentController>();
        final result = await paymentCtrl.processPayment(
          transactionId: transaction.id!,
          invoice: transaction.invoice,
          amount: transaction.total,
          paymentMethod: method,
        );

        if (!context.mounted) return;

        if (result.status == 'success') {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Payment Successful! Order: ${result.orderId}'),
              backgroundColor: Colors.green,
            ),
          );
        } else if (result.status == 'pending') {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Payment Pending. Order: ${result.orderId}'),
              backgroundColor: Colors.orange,
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Payment Failed: ${result.message}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Order Complete!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }
}
