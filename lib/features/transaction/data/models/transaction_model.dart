class TransactionModel {
  final int? id;
  final String invoice;
  final double total;
  final String paymentMethod;
  final String paymentStatus;
  final String? paymentRef;
  final double? amountReceived;
  final double? change;
  final DateTime createdAt;

  TransactionModel({
    this.id,
    required this.invoice,
    required this.total,
    required this.paymentMethod,
    required this.paymentStatus,
    this.paymentRef,
    this.amountReceived,
    this.change,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'invoice': invoice,
      'total': total,
      'payment_method': paymentMethod,
      'payment_status': paymentStatus,
      'payment_ref': paymentRef,
      'amount_received': amountReceived,
      'change': change,
      'created_at': createdAt.toIso8601String(),
    };
  }
}

class TransactionItemModel {
  final int? id;
  final int? transactionId;
  final int productId;
  final double quantity;
  final double price;

  TransactionItemModel({
    this.id,
    this.transactionId,
    required this.productId,
    required this.quantity,
    required this.price,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'transaction_id': transactionId,
      'product_id': productId,
      'quantity': quantity,
      'price': price,
    };
  }
}
