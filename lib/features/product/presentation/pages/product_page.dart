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
      appBar: AppBar(title: const Text('Products')),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, AppRoutes.productForm);
        },
        child: const Icon(Icons.add),
      ),
      body: Consumer<ProductController>(
        builder: (context, controller, child) {
          if (controller.isLoading && controller.products.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (controller.error != null && controller.products.isEmpty) {
            return Center(child: Text('Error: ${controller.error}'));
          }

          if (controller.products.isEmpty) {
            return const Center(child: Text('No products found.'));
          }

          return RefreshIndicator(
            onRefresh: () => controller.loadProducts(),
            child: ListView.builder(
              itemCount: controller.products.length,
              itemBuilder: (context, index) {
                final product = controller.products[index];
                return ListTile(
                  title: Text(product.name),
                  subtitle: Text(
                    '${product.category} | Stock: ${product.stock} ${product.unit}',
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '${product.sellPrice}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () =>
                            _confirmDelete(context, controller, product),
                      ),
                    ],
                  ),
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      AppRoutes.productForm,
                      arguments: product,
                    );
                  },
                );
              },
            ),
          );
        },
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
        title: const Text('Delete Product'),
        content: Text('Are you sure you want to delete ${product.name}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              controller.deleteProduct(product.id!);
              Navigator.pop(context);
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
