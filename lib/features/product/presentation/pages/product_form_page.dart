import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/models/product_model.dart';
import '../controllers/product_controller.dart';

class ProductFormPage extends StatefulWidget {
  const ProductFormPage({super.key});

  @override
  State<ProductFormPage> createState() => _ProductFormPageState();
}

class _ProductFormPageState extends State<ProductFormPage> {
  final _formKey = GlobalKey<FormState>();

  int? _id;
  final _nameController = TextEditingController();
  final _categoryController = TextEditingController();
  String _type = 'BAHAN';
  final _buyPriceController = TextEditingController();
  final _sellPriceController = TextEditingController();
  final _stockController = TextEditingController();
  final _unitController = TextEditingController();
  DateTime? _createdAt;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is Product) {
      _id = args.id;
      _nameController.text = args.name;
      _categoryController.text = args.category;
      _type = args.type;
      _buyPriceController.text = args.buyPrice.toString();
      _sellPriceController.text = args.sellPrice.toString();
      _stockController.text = args.stock.toString();
      _unitController.text = args.unit;
      _createdAt = args.createdAt;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _categoryController.dispose();
    _buyPriceController.dispose();
    _sellPriceController.dispose();
    _stockController.dispose();
    _unitController.dispose();
    super.dispose();
  }

  void _save() async {
    if (_formKey.currentState!.validate()) {
      final product = Product(
        id: _id,
        name: _nameController.text,
        category: _categoryController.text,
        type: _type,
        buyPrice: double.tryParse(_buyPriceController.text) ?? 0,
        sellPrice: double.tryParse(_sellPriceController.text) ?? 0,
        stock: double.tryParse(_stockController.text) ?? 0,
        unit: _unitController.text,
        createdAt: _createdAt ?? DateTime.now(),
      );

      final controller = context.read<ProductController>();

      try {
        if (_id == null) {
          await controller.addProduct(product);
        } else {
          await controller.updateProduct(product);
        }
        if (mounted) Navigator.pop(context);
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
          );
        }
      }
    }
  }

  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: const Color(0xFF8D6E63)),
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFD7CCC8)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFD7CCC8)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF5D4037), width: 2),
      ),
      labelStyle: const TextStyle(color: Color(0xFF8D6E63)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = _id != null;
    return Scaffold(
      backgroundColor: const Color(0xFFF5F0EB),
      appBar: AppBar(
        backgroundColor: const Color(0xFF5D4037),
        foregroundColor: Colors.white,
        title: Text(
          isEditing ? 'Edit Product' : 'Add Product',
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product Icon Header
              Center(
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: const Color(0xFF5D4037),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(
                    Icons.local_cafe,
                    color: Colors.white,
                    size: 40,
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Basic Info Section
              const Text(
                'Basic Information',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF5D4037),
                ),
              ),
              const SizedBox(height: 12),

              TextFormField(
                controller: _nameController,
                decoration: _inputDecoration('Product Name', Icons.label),
                validator: (value) =>
                    value?.isEmpty == true ? 'Required' : null,
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _categoryController,
                decoration: _inputDecoration('Category', Icons.category),
                validator: (value) =>
                    value?.isEmpty == true ? 'Required' : null,
              ),
              const SizedBox(height: 16),

              DropdownButtonFormField<String>(
                value: _type,
                decoration: _inputDecoration('Type', Icons.type_specimen),
                items: const [
                  DropdownMenuItem(
                    value: 'BAHAN',
                    child: Text('BAHAN (Ingredient)'),
                  ),
                  DropdownMenuItem(
                    value: 'CAFE',
                    child: Text('CAFE (Ready to Sell)'),
                  ),
                ],
                onChanged: (val) {
                  if (val != null) setState(() => _type = val);
                },
              ),
              const SizedBox(height: 24),

              // Pricing Section
              const Text(
                'Pricing',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF5D4037),
                ),
              ),
              const SizedBox(height: 12),

              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _buyPriceController,
                      decoration: _inputDecoration(
                        'Buy Price',
                        Icons.shopping_cart,
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) =>
                          value?.isEmpty == true ? 'Required' : null,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _sellPriceController,
                      decoration: _inputDecoration('Sell Price', Icons.sell),
                      keyboardType: TextInputType.number,
                      validator: (value) =>
                          value?.isEmpty == true ? 'Required' : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Inventory Section
              const Text(
                'Inventory',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF5D4037),
                ),
              ),
              const SizedBox(height: 12),

              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _stockController,
                      decoration: _inputDecoration('Stock', Icons.inventory),
                      keyboardType: TextInputType.number,
                      validator: (value) =>
                          value?.isEmpty == true ? 'Required' : null,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _unitController,
                      decoration: _inputDecoration('Unit', Icons.scale),
                      validator: (value) =>
                          value?.isEmpty == true ? 'Required' : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // Save Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _save,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF5D4037),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 2,
                  ),
                  child: Text(
                    isEditing ? 'Update Product' : 'Save Product',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
