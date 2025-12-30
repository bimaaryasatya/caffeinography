import '../../data/models/payment_result.dart';
import '../../data/services/midtrans_service.dart';
import '../../data/services/payment_gateway.dart';
import '../../data/services/qris_service.dart';
import '../../../transaction/data/repositories/transaction_repository.dart';

class PaymentController {
  final TransactionRepository _transactionRepository = TransactionRepository();

  // Cache services to avoid recreating them
  final MidtransService _midtransService = MidtransService();
  final QrisService _qrisService = QrisService();

  Future<PaymentResult> processPayment({
    required int transactionId,
    required String invoice,
    required double amount,
    required String paymentMethod,
  }) async {
    PaymentGateway gateway;

    // 1. Select Gateway
    switch (paymentMethod) {
      case 'MIDTRANS':
        gateway = _midtransService;
        break;
      case 'QRIS':
        gateway = _qrisService;
        break;
      case 'CASH':
        // Cash is handled directly in UI/TransactionController usually,
        // but if routed here, return success immediately.
        return PaymentResult(
          status: 'success',
          orderId: 'CASH-$invoice',
          message: 'Cash Payment',
        );
      default:
        return PaymentResult(
          status: 'failed',
          orderId: '',
          message: 'Unknown payment method',
        );
    }

    // 2. Process Payment
    final result = await gateway.pay(
      transactionId: transactionId.toString(),
      invoice: invoice,
      amount: amount,
    );

    // 3. Map status to DB status
    String dbStatus = 'PENDING';
    if (result.status == 'success') {
      dbStatus = 'PAID';
    } else if (result.status == 'pending') {
      dbStatus = 'PENDING';
    } else {
      dbStatus = 'FAILED';
    }

    // 4. Update Transaction Repository (Including FAILED to restore stock)
    await _transactionRepository.updatePaymentStatus(
      transactionId,
      dbStatus,
      result.orderId,
    );

    return result;
  }
}
