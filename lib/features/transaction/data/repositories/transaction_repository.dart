import '../../../../core/database/sqlite_service.dart';
import '../models/transaction_model.dart';

class TransactionRepository {
  final SQLiteService _dbService = SQLiteService.instance;

  Future<void> createTransaction(
    TransactionModel transaction,
    List<TransactionItemModel> items,
  ) async {
    final db = await _dbService.database;

    await db.transaction((txn) async {
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
    });
  }
}
