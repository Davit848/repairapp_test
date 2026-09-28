import 'package:flutter/material.dart';

import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../core/widgets/app_button.dart';
import '../../../data/static_data.dart';

/// Create / edit form for a shop inventory item. Pops the saved [SparePart].
class ProductFormSheet extends StatefulWidget {
  const ProductFormSheet({super.key, required this.id, this.initial});

  final String id;
  final SparePart? initial;

  static Future<SparePart?> show(BuildContext context, {required String id, SparePart? initial}) {
    return showModalBottomSheet<SparePart>(
      context: context,
      isScrollControlled: true,
      builder: (_) => ProductFormSheet(id: id, initial: initial),
    );
  }

  @override
  State<ProductFormSheet> createState() => _ProductFormSheetState();
}

class _ProductFormSheetState extends State<ProductFormSheet> {
  final _formKey = GlobalKey<FormState>();
  late final _name = TextEditingController(text: widget.initial?.name);
  late final _fitment = TextEditingController(text: widget.initial?.fitment);
  late final _price = TextEditingController(text: widget.initial?.price.toStringAsFixed(2));
  late final _stock = TextEditingController(text: widget.initial?.stock.toString());
  late PartCategory _category = widget.initial?.category ?? PartCategory.brakePads;
  late VehicleType _vehicle = widget.initial?.vehicleType ?? VehicleType.motorcycle;

  bool get _isEditing => widget.initial != null;

  @override
  void dispose() {
    _name.dispose();
    _fitment.dispose();
    _price.dispose();
    _stock.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final price = double.parse(_price.text);
    final stock = int.parse(_stock.text);
    final part =
        widget.initial?.copyWith(
          name: _name.text.trim(),
          category: _category,
          vehicleType: _vehicle,
          fitment: _fitment.text.trim(),
          price: price,
          stock: stock,
        ) ??
        SparePart(
          id: widget.id,
          name: _name.text.trim(),
          category: _category,
          vehicleType: _vehicle,
          fitment: _fitment.text.trim(),
          price: price,
          priceNote: 'Fixed',
          stock: stock,
          shop: StaticData.owner.shop,
          image: StaticData.categoryImages[_category]!,
        );
    Navigator.pop(context, part);
  }

  String? _required(String? value) => (value == null || value.trim().isEmpty) ? 'Required' : null;

  String? _positiveNumber(String? value) {
    final number = double.tryParse(value ?? '');
    return number == null || number < 0 ? 'Enter a valid amount' : null;
  }

  String? _wholeNumber(String? value) {
    final number = int.tryParse(value ?? '');
    return number == null || number < 0 ? 'Enter a whole number' : null;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(_isEditing ? 'Edit Product' : 'Add New Product', style: AppTextStyles.headlineSm),
              const SizedBox(height: AppSpacing.md),
              TextFormField(
                controller: _name,
                decoration: const InputDecoration(labelText: 'Product title'),
                textCapitalization: TextCapitalization.words,
                validator: _required,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<PartCategory>(
                      initialValue: _category,
                      isExpanded: true,
                      decoration: const InputDecoration(labelText: 'Category'),
                      items: [for (final c in PartCategory.values) DropdownMenuItem(value: c, child: Text(c.label))],
                      onChanged: (value) => setState(() => _category = value!),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: DropdownButtonFormField<VehicleType>(
                      initialValue: _vehicle,
                      isExpanded: true,
                      decoration: const InputDecoration(labelText: 'Vehicle'),
                      items: [for (final v in VehicleType.values) DropdownMenuItem(value: v, child: Text(v.label))],
                      onChanged: (value) => setState(() => _vehicle = value!),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _fitment,
                decoration: const InputDecoration(labelText: 'Compatible models', hintText: 'e.g. Honda Click 125'),
                validator: _required,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _price,
                      decoration: const InputDecoration(labelText: 'Price', prefixText: '\$ '),
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      validator: _positiveNumber,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _stock,
                      decoration: const InputDecoration(labelText: 'Stock units'),
                      keyboardType: TextInputType.number,
                      validator: _wholeNumber,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),
              AppButton(
                label: _isEditing ? 'Save Changes' : 'Publish to Live Catalog',
                icon: Icons.cloud_upload_outlined,
                height: 54,
                expand: true,
                onPressed: _submit,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
