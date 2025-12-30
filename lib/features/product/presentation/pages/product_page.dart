import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/routes/app_routes.dart';
import '../controllers/product_controller.dart';
import '../../data/models/product_model.dart';

class ProductPage extends StatelessWidget {
  const ProductPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F0EB),
      appBar: AppBar(
        backgroundColor: const Color(0xFF5D4037),
        foregroundColor: Colors.white,
        title: const Text(
          'Products',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        elevation: 0,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.pushNamed(context, AppRoutes.productForm),
        backgroundColor: const Color(0xFF5D4037),
        icon: const Icon(Icons.add),
        label: const Text('Add Product'),
      ),
      body: Consumer<ProductController>(
        builder: (context, controller, child) {
          if (controller.isLoading && controller.products.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFF5D4037)),
            );
          }

          if (controller.error != null && controller.products.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Color(0xFFBCAAA4),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Error: ${controller.error}',
                    style: const TextStyle(color: Color(0xFF8D6E63)),
                  ),
                ],
              ),
            );
          }

          if (controller.products.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.inventory_2_outlined,
                    size: 80,
                    color: Color(0xFFBCAAA4),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'No products yet',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF5D4037),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Add your first product to get started',
                    style: TextStyle(color: Color(0xFF8D6E63)),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            color: const Color(0xFF5D4037),
            onRefresh: () => controller.loadProducts(),
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: controller.products.length,
              itemBuilder: (context, index) {
                final product = controller.products[index];
                return _buildProductCard(context, controller, product);
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildProductCard(
    BuildContext context,
    ProductController controller,
    Product product,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.brown.withValues(alpha: 0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            Navigator.pushNamed(
              context,
              AppRoutes.productForm,
              arguments: product,
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Product Icon
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: const Color(0xFFEFEBE9),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.local_cafe,
                    color: Color(0xFF8D6E63),
                    size: 28,
                  ),
                ),
                const SizedBox(width: 16),
                // Product Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF3E2723),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFEFEBE9),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              product.category,
                              style: const TextStyle(
                                fontSize: 12,
                                color: Color(0xFF795548),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Icon(
                            Icons.inventory_2_outlined,
                            size: 14,
                            color: product.stock > 0
                                ? const Color(0xFF8D6E63)
                                : Colors.red,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${product.stock} ${product.unit}',
                            style: TextStyle(
                              fontSize: 12,
                              color: product.stock > 0
                                  ? const Color(0xFF8D6E63)
                                  : Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Price & Actions
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Rp ${product.sellPrice.toStringAsFixed(0)}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF5D4037),
                      ),
                    ),
                    const SizedBox(height: 8),
                    GestureDetector(
                      onTap: () => _confirmDelete(context, controller, product),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.red.shade50,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.delete_outline,
                          color: Colors.red.shade400,
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _confirmDelete(
    BuildContext context,
    ProductController controller,
    Product product,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Delete Product'),
        content: Text('Are you sure you want to delete "${product.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancel',
              style: TextStyle(color: Color(0xFF8D6E63)),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              controller.deleteProduct(product.id!);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
