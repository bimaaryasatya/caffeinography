import 'package:flutter/material.dart';

import '../../data/models/transaction_model.dart';
import '../../data/repositories/transaction_repository.dart';
import '../../../product/data/models/product_model.dart';

class CartItem {
  final Product product;
  double quantity;

  CartItem({required this.product, this.quantity = 1});

  double get subtotal => product.sellPrice * quantity;
}

class TransactionController extends ChangeNotifier {
  final TransactionRepository _repository = TransactionRepository();

  final Map<int, CartItem> _cart = {};
  bool _isLoading = false;

  Map<int, CartItem> get cart => _cart;
  bool get isLoading => _isLoading;

  double get total => _cart.values.fold(0, (sum, item) => sum + item.subtotal);

  void addToCart(Product product) {
    if (_cart.containsKey(product.id)) {
      _cart[product.id]!.quantity += 1;
    } else {
      _cart[product.id!] = CartItem(product: product);
    }
    notifyListeners();
  }

  void removeFromCart(Product product) {
    if (_cart.containsKey(product.id)) {
      if (_cart[product.id]!.quantity > 1) {
        _cart[product.id]!.quantity -= 1;
      } else {
        _cart.remove(product.id);
      }
      notifyListeners();
    }
  }

  void clearCart() {
    _cart.clear();
    notifyListeners();
  }

  Future<TransactionModel?> checkout({
    required String paymentMethod,
    double? amountReceived,
  }) async {
    if (_cart.isEmpty) return null;

    _isLoading = true;
    notifyListeners();

    try {
      final now = DateTime.now();
      final invoice =
          'INV-${now.year}${now.month}${now.day}-${now.millisecondsSinceEpoch}';

      final double? change = amountReceived != null
          ? amountReceived - total
          : null;

      var transaction = TransactionModel(
        invoice: invoice,
        total: total,
        paymentMethod: paymentMethod,
        paymentStatus: paymentMethod == 'MIDTRANS' ? 'PENDING' : 'PAID',
        paymentRef: null,
        amountReceived: amountReceived,
        change: change,
        createdAt: now,
      );

      final items = _cart.values.map((item) {
        return TransactionItemModel(
          productId: item.product.id!,
          quantity: item.quantity,
          price: item.product.sellPrice,
        );
      }).toList();

      final transactionId = await _repository.createTransaction(
        transaction,
        items,
      );

      // Create updated model with ID
      transaction = TransactionModel(
        id: transactionId,
        invoice: invoice,
        total: total,
        paymentMethod: paymentMethod,
        paymentStatus: transaction.paymentStatus,
        paymentRef: null,
        amountReceived: amountReceived,
        change: change,
        createdAt: now,
      );

      clearCart();
      return transaction;
    } catch (e) {
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
