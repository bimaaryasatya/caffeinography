import 'package:flutter/material.dart';
import '../../data/models/product_model.dart';
import '../../data/repositories/product_repository.dart';

class ProductController extends ChangeNotifier {
  final ProductRepository _repository = ProductRepository();

  List<Product> _products = [];
  bool _isLoading = false;
  String? _error;

  List<Product> get products => _products;
  bool get isLoading => _isLoading;
  String? get error => _error;

  ProductController() {
    loadProducts();
  }

  Future<void> loadProducts() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _products = await _repository.getAllProducts();
      // Sort by newest first
      _products.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addProduct(Product product) async {
    _isLoading = true;
    notifyListeners();
    try {
      await _repository.insertProduct(product);
      await loadProducts();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> updateProduct(Product product) async {
    _isLoading = true;
    notifyListeners();
    try {
      await _repository.updateProduct(product);
      await loadProducts();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> deleteProduct(int id) async {
    _isLoading = true;
    notifyListeners();
    try {
      await _repository.deleteProduct(id);
      await loadProducts();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }
}
