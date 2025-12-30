import '../models/payment_result.dart';
import 'payment_gateway.dart';

class QrisService implements PaymentGateway {
  @override
  Future<PaymentResult> pay({
    required String transactionId,
    required String invoice,
    required double amount,
  }) async {
    // TODO: Implement real QRIS generation or check
    // For now, we assume QRIS is scanned and paid immediately (Offline/Manual check) or simulated success.

    return PaymentResult(
      status: 'success',
      orderId: 'QRIS-$invoice',
      message: 'QRIS Payment Verified',
    );
  }
}
