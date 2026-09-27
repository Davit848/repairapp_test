import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/product.dart';
import '../../providers/product_provider.dart';
import '../../utils/validators.dart';

const productCategories = [
  'Engine',
  'Brake',
  'Electrical',
  'Tire',
  'Battery',
  'Oil',
  'Filter',
  'Light',
  'Body',
  'Other',
];

// Add a new product, or edit an existing one when [product] is given.
class ProductFormScreen extends StatefulWidget {
  final Product? product;
  const ProductFormScreen({super.key, this.product});

  bool get isEditing => product != null;

  @override
  State<ProductFormScreen> createState() => _ProductFormScreenState();
}

class _ProductFormScreenState extends State<ProductFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _priceController;
  late final TextEditingController _stockController;
  late final TextEditingController _descriptionController;
  late String _vehicleType;
  String? _category;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    final product = widget.product;
    _nameController = TextEditingController(text: product?.name);
    _priceController = TextEditingController(text: product?.price.toStringAsFixed(2));
    _stockController = TextEditingController(text: product?.stock.toString());
    _descriptionController = TextEditingController(text: product?.description);
    _vehicleType = product?.vehicleType.toLowerCase() ?? 'car';
    _category = product?.category;
    // Keep categories created before this list existed selectable
    if (_category != null && !productCategories.contains(_category)) _category = 'Other';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _stockController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    final data = {
      'name': _nameController.text.trim(),
      'price': double.parse(_priceController.text.trim()),
      'stock': int.parse(_stockController.text.trim()),
      'description': _descriptionController.text.trim(),
      'vehicle_type': _vehicleType,
      'category': _category,
    };

    final productProvider = Provider.of<ProductProvider>(context, listen: false);
    final error = widget.isEditing
        ? await productProvider.updateProduct(widget.product!.id, data)
        : await productProvider.createProduct(data);

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(error ?? (widget.isEditing ? 'Product updated!' : 'Product created!')),
        backgroundColor: error != null ? Colors.red : null,
      ),
    );
    if (error == null) {
      Navigator.pop(context);
    } else {
      setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.isEditing ? 'Edit Product' : 'Add Product')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Product Name', border: OutlineInputBorder()),
                validator: (value) => Validators.required(value, 'a product name'),
              ),
              const SizedBox(height: 16),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _priceController,
                      decoration: const InputDecoration(labelText: 'Price (\$)', border: OutlineInputBorder()),
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      validator: Validators.price,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _stockController,
                      decoration: const InputDecoration(labelText: 'Stock', border: OutlineInputBorder()),
                      keyboardType: TextInputType.number,
                      validator: Validators.stock,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Text('Vehicle Type', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              SegmentedButton<String>(
                segments: const [
                  ButtonSegment(value: 'car', label: Text('Car'), icon: Icon(Icons.directions_car)),
                  ButtonSegment(value: 'motor', label: Text('Motor'), icon: Icon(Icons.two_wheeler)),
                ],
                selected: {_vehicleType},
                onSelectionChanged: (selection) => setState(() => _vehicleType = selection.first),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                initialValue: _category,
                decoration: const InputDecoration(labelText: 'Category', border: OutlineInputBorder()),
                items: productCategories
                    .map((category) => DropdownMenuItem(value: category, child: Text(category)))
                    .toList(),
                onChanged: (value) => setState(() => _category = value),
                validator: (value) => value == null ? 'Please choose a category' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description', border: OutlineInputBorder()),
                maxLines: 3,
                validator: (value) => Validators.required(value, 'a description'),
              ),
              const SizedBox(height: 24),
              _isSubmitting
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: _submit,
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white),
                      child: Text(widget.isEditing ? 'Save Changes' : 'Create Product'),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
