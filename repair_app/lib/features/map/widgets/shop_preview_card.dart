import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../core/utils/feedback.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/status_badge.dart';
import '../../../data/static_data.dart';

/// Floating garage summary shown when a map pin is selected.
class ShopPreviewCard extends StatelessWidget {
  const ShopPreviewCard({super.key, required this.shop, required this.onViewShop});

  final Shop shop;
  final VoidCallback onViewShop;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
      decoration: const BoxDecoration(color: AppColors.card, borderRadius: AppRadius.xl, boxShadow: AppShadows.level3),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: const BoxDecoration(color: AppColors.surfaceHigh, borderRadius: AppRadius.pill),
          ),
          const SizedBox(height: 12),
          _Summary(shop: shop),
          const SizedBox(height: 12),
          _ContactBox(shop: shop),
          const SizedBox(height: 12),
          Row(
            children: [
              AppIconButton(
                icon: Icons.phone_in_talk_outlined,
                tooltip: 'Call',
                size: 48,
                onPressed: () => context.showFeedback('Calling ${shop.shortName} · ${shop.phone}'),
              ),
              const SizedBox(width: 8),
              AppButton(
                label: 'Route',
                icon: Icons.directions_outlined,
                variant: AppButtonVariant.tonal,
                onPressed: () => context.showFeedback('Opening directions to ${shop.shortName}'),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: AppButton(label: 'View Shop', trailingIcon: Icons.arrow_forward, onPressed: onViewShop),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Summary extends StatelessWidget {
  const _Summary({required this.shop});

  final Shop shop;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: AppRadius.lg,
          child: Image.asset(shop.image, width: 76, height: 76, fit: BoxFit.cover),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(shop.name, maxLines: 1, overflow: TextOverflow.ellipsis, style: AppTextStyles.titleLg),
              const SizedBox(height: 4),
              Wrap(
                spacing: 8,
                runSpacing: 4,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  StatusBadge(label: shop.typeLabel, tone: BadgeTone.info),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.star_rounded, size: 16, color: AppColors.amber),
                      Text(
                        ' ${shop.rating} (${shop.reviewCount})',
                        style: AppTextStyles.labelMd.copyWith(color: AppColors.amberDeep),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text('${shop.distanceKm} km away', style: AppTextStyles.bodySm.copyWith(color: AppColors.textMuted)),
              const SizedBox(height: 2),
              Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: shop.isOpen ? AppColors.emerald : AppColors.danger,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Flexible(
                    child: Text(
                      shop.isOpen ? 'Open Now (Closes ${shop.closingTime})' : 'Closed',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.labelMd.copyWith(
                        color: shop.isOpen ? AppColors.emeraldText : AppColors.danger,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ContactBox extends StatelessWidget {
  const _ContactBox({required this.shop});

  final Shop shop;

  @override
  Widget build(BuildContext context) {
    final muted = AppTextStyles.bodySm.copyWith(color: AppColors.textMuted);
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: const BoxDecoration(color: AppColors.surfaceLow, borderRadius: AppRadius.lg),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(Icons.location_on_outlined, size: 18, color: AppColors.amberDeep),
              const SizedBox(width: 8),
              Expanded(
                child: Text(shop.address, maxLines: 1, overflow: TextOverflow.ellipsis, style: AppTextStyles.bodyMd),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.phone_outlined, size: 18, color: AppColors.amberDeep),
              const SizedBox(width: 8),
              Text(shop.phone, style: AppTextStyles.labelLg),
              const Spacer(),
              if (shop.note != null)
                Flexible(
                  child: Text(shop.note!, maxLines: 1, overflow: TextOverflow.ellipsis, style: muted),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
