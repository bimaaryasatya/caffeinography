import '../../../../core/database/sqlite_service.dart';
import '../models/transaction_model.dart';

class TransactionRepository {
  final SQLiteService _dbService = SQLiteService.instance;

  Future<int> createTransaction(
    TransactionModel transaction,
    List<TransactionItemModel> items,
  ) async {
    final db = await _dbService.database;

    return await db.transaction((txn) async {
      // 1. Insert Transaction
      final transactionId = await txn.insert(
        'transactions',
        transaction.toMap(),
      );

      // 2. Insert Items with the new transactionId
      for (final item in items) {
        // Create a new map for insertion with the correct transactionId
        final itemMap = {
          'transaction_id': transactionId,
          'product_id': item.productId,
          'quantity': item.quantity,
          'price': item.price,
        };
        await txn.insert('transaction_items', itemMap);

        // 3. Update Product Stock
        await txn.rawUpdate(
          'UPDATE products SET stock = stock - ? WHERE id = ?',
          [item.quantity, item.productId],
        );
      }

      return transactionId;
    });
  }

  Future<void> updatePaymentStatus(
    int transactionId,
    String status,
    String? paymentRef,
  ) async {
    final db = await _dbService.database;

    await db.transaction((txn) async {
      await txn.update(
        'transactions',
        {'payment_status': status, 'payment_ref': paymentRef},
        where: 'id = ?',
        whereArgs: [transactionId],
      );

      // If status is FAILED, restore stock
      if (status == 'FAILED') {
        final items = await txn.query(
          'transaction_items',
          where: 'transaction_id = ?',
          whereArgs: [transactionId],
        );

        for (final item in items) {
          await txn.rawUpdate(
            'UPDATE products SET stock = stock + ? WHERE id = ?',
            [item['quantity'], item['product_id']],
          );
        }
      }
    });
  }
}
