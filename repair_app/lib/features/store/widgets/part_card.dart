import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/status_badge.dart';
import '../../../data/static_data.dart';

class PartCard extends StatelessWidget {
  const PartCard({
    super.key,
    required this.part,
    required this.isSaved,
    required this.onToggleSaved,
    required this.onDetails,
    required this.onContact,
  });

  final SparePart part;
  final bool isSaved;
  final VoidCallback onToggleSaved;
  final VoidCallback onDetails;
  final VoidCallback onContact;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: AppDecorations.card,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Photo(part: part, isSaved: isSaved, onToggleSaved: onToggleSaved),
          const SizedBox(height: 10),
          Text(part.category.group.toUpperCase(), style: AppTextStyles.labelSm.copyWith(color: AppColors.textMuted)),
          const SizedBox(height: 2),
          Text(
            part.name,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.titleMd.copyWith(height: 1.25),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Icon(part.vehicleType.icon, size: 14, color: AppColors.amberDeep),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  part.fitment,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.bodySm.copyWith(color: AppColors.textMuted),
                ),
              ),
            ],
          ),
          const Spacer(),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(formatPrice(part.price), style: AppTextStyles.price.copyWith(color: AppColors.amberDeep)),
              const Spacer(),
              Flexible(
                child: Text(
                  part.priceNote,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.labelSm.copyWith(color: AppColors.textMuted),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          _SellerChip(shop: part.shop),
          const SizedBox(height: 8),
          LayoutBuilder(
            // Drop the phone glyph on narrow phones so both labels stay readable.
            builder: (context, constraints) => Row(
              children: [
                Expanded(
                  child: AppButton(
                    label: 'Details',
                    variant: AppButtonVariant.tonal,
                    height: 40,
                    compact: true,
                    onPressed: onDetails,
                  ),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: AppButton(
                    label: 'Contact',
                    icon: constraints.maxWidth > 170 ? Icons.call : null,
                    variant: AppButtonVariant.secondary,
                    height: 40,
                    compact: true,
                    onPressed: onContact,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Photo extends StatelessWidget {
  const _Photo({required this.part, required this.isSaved, required this.onToggleSaved});

  final SparePart part;
  final bool isSaved;
  final VoidCallback onToggleSaved;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: AppRadius.lg,
      child: SizedBox(
        height: 130,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(part.image, fit: BoxFit.cover),
            Positioned(
              top: 8,
              left: 8,
              child: StatusBadge(
                label: part.stockLabel,
                tone: part.isLowStock ? BadgeTone.warning : BadgeTone.light,
                dotColor: part.isLowStock ? AppColors.amber : AppColors.danger,
              ),
            ),
            Positioned(
              top: 4,
              right: 4,
              child: IconButton(
                tooltip: isSaved ? 'Remove bookmark' : 'Bookmark',
                onPressed: onToggleSaved,
                style: IconButton.styleFrom(backgroundColor: Colors.white.withValues(alpha: 0.9)),
                icon: Icon(
                  isSaved ? Icons.bookmark : Icons.bookmark_border,
                  size: 18,
                  color: isSaved ? AppColors.amberDeep : AppColors.slate,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SellerChip extends StatelessWidget {
  const _SellerChip({required this.shop});

  final Shop shop;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: const BoxDecoration(color: AppColors.surfaceLow, borderRadius: AppRadius.md),
      child: Row(
        children: [
          const Icon(Icons.storefront_outlined, size: 14, color: AppColors.amberDeep),
          const SizedBox(width: 6),
          Expanded(
            child: Text.rich(
              TextSpan(
                text: shop.shortName,
                children: [
                  TextSpan(
                    text: ' • ${formatDistance(shop.distanceKm)}',
                    style: const TextStyle(color: AppColors.steel),
                  ),
                ],
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.labelMd,
            ),
          ),
        ],
      ),
    );
  }
}
