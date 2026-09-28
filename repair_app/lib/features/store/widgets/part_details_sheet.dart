import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/status_badge.dart';
import '../../../data/static_data.dart';

/// Fitment & seller details for a catalog part.
class PartDetailsSheet extends StatelessWidget {
  const PartDetailsSheet({super.key, required this.part, required this.onContact});

  final SparePart part;
  final VoidCallback onContact;

  static Future<void> show(BuildContext context, {required SparePart part, required VoidCallback onContact}) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (_) => PartDetailsSheet(part: part, onContact: onContact),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: AppRadius.xl,
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: Image.asset(part.image, fit: BoxFit.cover),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                StatusBadge(label: part.category.group, tone: BadgeTone.info, uppercase: true),
                const SizedBox(width: 8),
                StatusBadge(
                  label: part.isLowStock ? 'Only ${part.stock} left' : 'In Stock: ${part.stock}',
                  tone: part.isLowStock ? BadgeTone.warning : BadgeTone.success,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(part.name, style: AppTextStyles.headlineMd),
            const SizedBox(height: 4),
            Text(
              formatPrice(part.price),
              style: AppTextStyles.price.copyWith(color: AppColors.amberDeep, fontSize: 28),
            ),
            if (part.description.isNotEmpty) ...[
              const SizedBox(height: 12),
              Text(part.description, style: AppTextStyles.bodyMd.copyWith(color: AppColors.textMuted)),
            ],
            const SizedBox(height: 16),
            _Spec(icon: part.vehicleType.icon, label: 'Fits', value: part.fitment),
            _Spec(icon: Icons.category_outlined, label: 'Vehicle', value: part.vehicleType.label),
            _Spec(
              icon: Icons.storefront_outlined,
              label: 'Seller',
              value: '${part.shop.name} • ${formatDistance(part.shop.distanceKm)}',
            ),
            _Spec(icon: Icons.location_on_outlined, label: 'Address', value: part.shop.address),
            const SizedBox(height: 16),
            AppButton(
              label: 'Contact Seller · ${part.shop.phone}',
              icon: Icons.call,
              height: 54,
              expand: true,
              onPressed: () {
                Navigator.pop(context);
                onContact();
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _Spec extends StatelessWidget {
  const _Spec({required this.icon, required this.label, required this.value});

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: AppColors.amberDeep),
          const SizedBox(width: 10),
          SizedBox(
            width: 64,
            child: Text(label, style: AppTextStyles.labelMd.copyWith(color: AppColors.textMuted)),
          ),
          Expanded(child: Text(value, style: AppTextStyles.bodyMd)),
        ],
      ),
    );
  }
}
