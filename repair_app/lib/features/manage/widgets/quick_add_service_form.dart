import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/status_badge.dart';
import '../../../data/static_data.dart';

/// Inline composer that publishes a new labor service to the marketplace.
class QuickAddServiceForm extends StatefulWidget {
  const QuickAddServiceForm({super.key, required this.newId, required this.onPublish, required this.onSaveDraft});

  final String Function() newId;
  final ValueChanged<MechanicService> onPublish;
  final ValueChanged<MechanicService> onSaveDraft;

  @override
  State<QuickAddServiceForm> createState() => _QuickAddServiceFormState();
}

class _QuickAddServiceFormState extends State<QuickAddServiceForm> {
  static const _defaultTags = ['Jet Cleaning', 'Float Adjustment', 'Road Test'];

  final _formKey = GlobalKey<FormState>();
  final _title = TextEditingController(text: 'Carburetor Tuning & Jetting');
  final _price = TextEditingController(text: '25.00');
  final _minutes = TextEditingController(text: '35');
  ServiceCategory _category = ServiceCategory.engine;
  ServiceDelivery _delivery = ServiceDelivery.both;
  PricingModel _pricing = PricingModel.fixed;
  final List<String> _tags = [..._defaultTags];

  @override
  void dispose() {
    _title.dispose();
    _price.dispose();
    _minutes.dispose();
    super.dispose();
  }

  MechanicService? _build({required bool active}) {
    if (!_formKey.currentState!.validate()) return null;
    return MechanicService(
      id: widget.newId(),
      title: _title.text.trim(),
      category: _category,
      delivery: _delivery,
      pricingModel: _pricing,
      price: double.parse(_price.text),
      estimatedMinutes: int.parse(_minutes.text),
      shop: StaticData.owner.shop,
      included: List.of(_tags),
      isActive: active,
    );
  }

  void _submit({required bool publish}) {
    final service = _build(active: publish);
    if (service == null) return;
    publish ? widget.onPublish(service) : widget.onSaveDraft(service);
    _formKey.currentState!.reset();
    _title.clear();
    setState(
      () => _tags
        ..clear()
        ..addAll(_defaultTags),
    );
  }

  Future<void> _addTag() async {
    final controller = TextEditingController();
    final tag = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add included task'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(hintText: 'e.g. Spark plug check'),
          onSubmitted: (value) => Navigator.pop(context, value),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          FilledButton(onPressed: () => Navigator.pop(context, controller.text), child: const Text('Add')),
        ],
      ),
    );
    controller.dispose();
    if (tag != null && tag.trim().isNotEmpty) setState(() => _tags.add(tag.trim()));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: AppDecorations.card,
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _header(),
            const SizedBox(height: AppSpacing.md),
            TextFormField(
              controller: _title,
              decoration: const InputDecoration(labelText: 'Service title', suffixIcon: Icon(Icons.handyman_outlined)),
              validator: (value) => (value == null || value.trim().isEmpty) ? 'Required' : null,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _dropdown<ServiceCategory>(
                    label: 'Category',
                    value: _category,
                    values: ServiceCategory.values,
                    text: (c) => c.label,
                    onChanged: (value) => setState(() => _category = value),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _dropdown<ServiceDelivery>(
                    label: 'Service delivery',
                    value: _delivery,
                    values: ServiceDelivery.values,
                    text: (d) => d.label,
                    onChanged: (value) => setState(() => _delivery = value),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  flex: 4,
                  child: _dropdown<PricingModel>(
                    label: 'Pricing',
                    value: _pricing,
                    values: PricingModel.values,
                    text: (p) => p.label,
                    onChanged: (value) => setState(() => _pricing = value),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  flex: 3,
                  child: TextFormField(
                    controller: _price,
                    decoration: const InputDecoration(labelText: 'Price', prefixText: '\$ '),
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    validator: (value) => double.tryParse(value ?? '') == null ? 'Invalid' : null,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  flex: 2,
                  child: TextFormField(
                    controller: _minutes,
                    decoration: const InputDecoration(labelText: 'Min'),
                    keyboardType: TextInputType.number,
                    validator: (value) => int.tryParse(value ?? '') == null ? 'Invalid' : null,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            Text("What's Included (Motorist Guarantee)", style: AppTextStyles.labelMd),
            const SizedBox(height: 8),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: [
                for (final tag in _tags)
                  InputChip(
                    label: Text(tag),
                    avatar: const Icon(Icons.check, size: 14, color: AppColors.amberDeep),
                    labelStyle: AppTextStyles.labelMd,
                    backgroundColor: AppColors.surfaceLow,
                    side: BorderSide.none,
                    shape: const StadiumBorder(),
                    onDeleted: () => setState(() => _tags.remove(tag)),
                  ),
                ActionChip(
                  label: const Text('Add Tag'),
                  avatar: const Icon(Icons.add, size: 14),
                  labelStyle: AppTextStyles.labelMd,
                  backgroundColor: AppColors.surfaceHigh,
                  side: BorderSide.none,
                  shape: const StadiumBorder(),
                  onPressed: _addTag,
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                Expanded(
                  child: AppButton(
                    label: 'Save as Draft',
                    variant: AppButtonVariant.tonal,
                    height: 52,
                    onPressed: () => _submit(publish: false),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: AppButton(
                    label: 'Publish Service',
                    icon: Icons.publish,
                    variant: AppButtonVariant.dark,
                    height: 52,
                    onPressed: () => _submit(publish: true),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _header() {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: const BoxDecoration(color: AppColors.slate, borderRadius: AppRadius.md),
          child: const Icon(Icons.post_add, color: Colors.white),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Quick Add Service', style: AppTextStyles.headlineSm),
              Text(
                'Publish immediately to Motorist Search',
                style: AppTextStyles.bodySm.copyWith(color: AppColors.textMuted),
              ),
            ],
          ),
        ),
        const StatusBadge(label: 'Draft', uppercase: true),
      ],
    );
  }

  Widget _dropdown<T>({
    required String label,
    required T value,
    required List<T> values,
    required String Function(T) text,
    required ValueChanged<T> onChanged,
  }) {
    return DropdownButtonFormField<T>(
      initialValue: value,
      isExpanded: true,
      decoration: InputDecoration(labelText: label),
      items: [
        for (final v in values)
          DropdownMenuItem(
            value: v,
            child: Text(text(v), overflow: TextOverflow.ellipsis),
          ),
      ],
      onChanged: (v) => onChanged(v as T),
    );
  }
}
