import 'dart:io';
import 'dart:math';
import '../models/payment_result.dart';
import 'payment_gateway.dart';

class MidtransService implements PaymentGateway {
  @override
  Future<PaymentResult> pay({
    required String transactionId,
    required String invoice,
    required double amount,
  }) async {
    // 1. Check Internet Connectivity
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isEmpty || result[0].rawAddress.isEmpty) {
        return PaymentResult(
          status: 'failed',
          orderId: '',
          message: 'No internet connection',
        );
      }
    } on SocketException catch (_) {
      return PaymentResult(
        status: 'failed',
        orderId: '',
        message: 'No internet connection',
      );
    }

    // 2. Simulate Network Delay (1-2 seconds)
    await Future.delayed(Duration(milliseconds: 1000 + Random().nextInt(1000)));

    // 3. Simulate Payment Processing (Random Outcome)
    // TODO: Replace with real Midtrans API call
    // e.g., http.post('https://api.sandbox.midtrans.com/v2/charge', ...)

    final random = Random();
    final outcome = random.nextDouble();
    final orderId = 'MID-$invoice-${random.nextInt(10000)}';

    if (outcome < 0.8) {
      // 80% Success
      return PaymentResult(
        status: 'success',
        orderId: orderId,
        message: 'Payment Successful',
      );
    } else if (outcome < 0.9) {
      // 10% Pending
      return PaymentResult(
        status: 'pending',
        orderId: orderId,
        message: 'Payment Pending',
      );
    } else {
      // 10% Failed
      return PaymentResult(
        status: 'failed',
        orderId: '',
        message: 'Payment Failed by Gateway',
      );
    }
  }
}
