class PaymentResult {
  final String status; // 'success', 'pending', 'failed'
  final String orderId;
  final String? message;

  PaymentResult({required this.status, required this.orderId, this.message});

  bool get isSuccess => status == 'success';
}
