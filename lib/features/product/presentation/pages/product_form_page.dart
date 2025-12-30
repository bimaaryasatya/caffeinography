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

  // Fields
  int? _id;
  final _nameController = TextEditingController();
  final _categoryController = TextEditingController();
  String _type = 'BAHAN'; // Default
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
      final name = _nameController.text;
      final category = _categoryController.text;
      final buyPrice = double.tryParse(_buyPriceController.text) ?? 0;
      final sellPrice = double.tryParse(_sellPriceController.text) ?? 0;
      final stock = double.tryParse(_stockController.text) ?? 0;
      final unit = _unitController.text;

      final product = Product(
        id: _id,
        name: name,
        category: category,
        type: _type,
        buyPrice: buyPrice,
        sellPrice: sellPrice,
        stock: stock,
        unit: unit,
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
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Error: $e')));
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = _id != null;
    return Scaffold(
      appBar: AppBar(title: Text(isEditing ? 'Edit Product' : 'New Product')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _categoryController,
                decoration: const InputDecoration(labelText: 'Category'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: _type,
                decoration: const InputDecoration(labelText: 'Type'),
                items: const [
                  DropdownMenuItem(value: 'BAHAN', child: Text('BAHAN')),
                  DropdownMenuItem(value: 'CAFE', child: Text('CAFE')),
                ],
                onChanged: (val) {
                  if (val != null) setState(() => _type = val);
                },
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _buyPriceController,
                      decoration: const InputDecoration(labelText: 'Buy Price'),
                      keyboardType: TextInputType.number,
                      validator: (value) =>
                          value == null || value.isEmpty ? 'Required' : null,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _sellPriceController,
                      decoration: const InputDecoration(
                        labelText: 'Sell Price',
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) =>
                          value == null || value.isEmpty ? 'Required' : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _stockController,
                      decoration: const InputDecoration(labelText: 'Stock'),
                      keyboardType: TextInputType.number,
                      validator: (value) =>
                          value == null || value.isEmpty ? 'Required' : null,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _unitController,
                      decoration: const InputDecoration(labelText: 'Unit'),
                      validator: (value) =>
                          value == null || value.isEmpty ? 'Required' : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _save,
                  child: Text(isEditing ? 'Update' : 'Save'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
