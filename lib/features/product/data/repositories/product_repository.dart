import '../../../../core/database/sqlite_service.dart';
import '../models/product_model.dart';

class ProductRepository {
  final SQLiteService _db = SQLiteService.instance;
  final String _table = 'products';

  Future<List<Product>> getAllProducts() async {
    final List<Map<String, dynamic>> maps = await _db.getAll(_table);
    return List.generate(maps.length, (i) => Product.fromMap(maps[i]));
  }

  Future<int> insertProduct(Product product) async {
    return await _db.insert(_table, product.toMap());
  }

  Future<int> updateProduct(Product product) async {
    if (product.id == null) {
      throw Exception('Cannot update product without ID');
    }
    return await _db.update(_table, product.toMap(), product.id!);
  }

  Future<int> deleteProduct(int id) async {
    return await _db.delete(_table, id);
  }
}
