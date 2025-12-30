import '../models/payment_result.dart';

abstract class PaymentGateway {
  Future<PaymentResult> pay({
    required String transactionId,
    required String invoice,
    required double amount,
  });
}
