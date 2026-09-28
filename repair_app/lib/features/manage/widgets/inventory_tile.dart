import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/status_badge.dart';
import '../../../data/static_data.dart';

/// Shop inventory row with inline quantity adjusters.
class InventoryTile extends StatelessWidget {
  const InventoryTile({
    super.key,
    required this.part,
    required this.onAdjust,
    required this.onEdit,
    required this.onDelete,
  });

  static const criticalStock = 3;
  static const restockAmount = 5;

  final SparePart part;
  final ValueChanged<int> onAdjust;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  bool get _isCritical => part.stock <= criticalStock;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: AppDecorations.card,
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: AppRadius.md,
                child: Image.asset(part.image, width: 64, height: 64, fit: BoxFit.cover),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _Details(part: part, isCritical: _isCritical),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              if (_isCritical)
                AppButton(
                  label: 'Restock +$restockAmount',
                  icon: Icons.add_business_outlined,
                  height: 40,
                  compact: true,
                  onPressed: () => onAdjust(restockAmount),
                )
              else
                _QuantityStepper(onAdjust: onAdjust, canDecrease: part.stock > 0),
              const Spacer(),
              AppButton(label: 'Edit', variant: AppButtonVariant.tonal, height: 40, compact: true, onPressed: onEdit),
              const SizedBox(width: 8),
              AppIconButton(
                icon: Icons.delete_outline,
                tooltip: 'Delete',
                variant: AppButtonVariant.danger,
                size: 40,
                onPressed: onDelete,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Details extends StatelessWidget {
  const _Details({required this.part, required this.isCritical});

  final SparePart part;
  final bool isCritical;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(child: StatusBadge(label: part.category.label.split(' ').first, uppercase: true)),
            const SizedBox(width: 8),
            Flexible(
              child: isCritical
                  ? const StatusBadge(label: 'Low Stock', tone: BadgeTone.warning, icon: Icons.warning_amber_rounded)
                  : Text('Active Live', style: AppTextStyles.labelMd.copyWith(color: AppColors.amber)),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(part.name, style: AppTextStyles.titleMd, maxLines: 1, overflow: TextOverflow.ellipsis),
        Text.rich(
          TextSpan(
            text: formatPrice(part.price),
            style: AppTextStyles.price,
            children: [
              TextSpan(
                text: isCritical ? '  • Only ${part.stock} left' : '  • In Stock: ${part.stock} units',
                style: AppTextStyles.bodySm.copyWith(
                  color: isCritical ? AppColors.danger : AppColors.textMuted,
                  fontWeight: isCritical ? FontWeight.w600 : null,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _QuantityStepper extends StatelessWidget {
  const _QuantityStepper({required this.onAdjust, required this.canDecrease});

  final ValueChanged<int> onAdjust;
  final bool canDecrease;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(color: AppColors.surfaceLow, borderRadius: AppRadius.md),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            tooltip: 'Decrease stock',
            icon: const Icon(Icons.remove, size: 18),
            onPressed: canDecrease ? () => onAdjust(-1) : null,
          ),
          Text('Qty', style: AppTextStyles.labelMd),
          IconButton(tooltip: 'Increase stock', icon: const Icon(Icons.add, size: 18), onPressed: () => onAdjust(1)),
        ],
      ),
    );
  }
}
