import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/status_badge.dart';
import '../../../data/static_data.dart';

/// Marketplace listing: workshop identity, scope checklist and fixed price.
class ServiceCard extends StatelessWidget {
  const ServiceCard({super.key, required this.service, required this.onCall, required this.onBook});

  final MechanicService service;
  final VoidCallback onCall;
  final VoidCallback onBook;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: AppDecorations.card,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Header(service: service),
          const SizedBox(height: 12),
          _IncludedList(items: service.included),
          const SizedBox(height: 12),
          _Footer(service: service, onCall: onCall, onBook: onBook),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.service});

  final MechanicService service;

  @override
  Widget build(BuildContext context) {
    final shop = service.shop;
    final eta = service.delivery == ServiceDelivery.mobileRescue
        ? '${service.estimatedMinutes}m Arrival'
        : formatDuration(service.estimatedMinutes);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: AppRadius.lg,
          child: SizedBox(
            width: 84,
            height: 84,
            child: Stack(
              fit: StackFit.expand,
              children: [
                if (service.image != null) Image.asset(service.image!, fit: BoxFit.cover),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Container(
                    color: service.delivery.isMobile ? AppColors.amber : AppColors.slate.withValues(alpha: 0.85),
                    padding: const EdgeInsets.symmetric(vertical: 3),
                    child: Text(
                      eta,
                      textAlign: TextAlign.center,
                      style: AppTextStyles.labelSm.copyWith(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              StatusBadge(
                label: service.delivery.marketLabel,
                icon: service.delivery.icon,
                tone: service.delivery.isMobile && !service.delivery.isInShop ? BadgeTone.warning : BadgeTone.info,
              ),
              const SizedBox(height: 4),
              Text(
                service.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.titleMd.copyWith(height: 1.3),
              ),
              Text(shop.name, style: AppTextStyles.bodySm.copyWith(color: AppColors.textMuted)),
              const SizedBox(height: 4),
              Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  const Icon(Icons.star_rounded, size: 15, color: AppColors.amber),
                  Text(' ${shop.rating}', style: AppTextStyles.labelMd.copyWith(color: AppColors.amberDeep)),
                  if (service.jobsLabel != null)
                    Text(' (${service.jobsLabel})', style: AppTextStyles.bodySm.copyWith(color: AppColors.textMuted)),
                  const SizedBox(width: 10),
                  const Icon(Icons.near_me_outlined, size: 14, color: AppColors.steel),
                  Text(' ${shop.distanceKm} km', style: AppTextStyles.bodySm.copyWith(color: AppColors.textMuted)),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _IncludedList extends StatelessWidget {
  const _IncludedList({required this.items});

  final List<String> items;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: const BoxDecoration(color: AppColors.surfaceLow, borderRadius: AppRadius.lg),
      child: Column(
        children: [
          for (final item in items)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 3),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.check_circle_outline, size: 16, color: AppColors.amber),
                  const SizedBox(width: 8),
                  Expanded(child: Text(item, style: AppTextStyles.bodySm)),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _Footer extends StatelessWidget {
  const _Footer({required this.service, required this.onCall, required this.onBook});

  final MechanicService service;
  final VoidCallback onCall;
  final VoidCallback onBook;

  @override
  Widget build(BuildContext context) {
    final isRescue = service.delivery == ServiceDelivery.mobileRescue;
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (service.priceCaption != null)
                Text(
                  service.priceCaption!.toUpperCase(),
                  style: AppTextStyles.labelSm.copyWith(color: AppColors.textMuted),
                ),
              Text.rich(
                TextSpan(
                  text: formatPrice(service.price),
                  style: AppTextStyles.price,
                  children: [
                    if (service.priceSuffix != null)
                      TextSpan(
                        text: ' ${service.priceSuffix}',
                        style: AppTextStyles.bodySm.copyWith(color: AppColors.textMuted),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
        AppIconButton(icon: Icons.call_outlined, tooltip: 'Call workshop', onPressed: onCall),
        const SizedBox(width: 8),
        AppButton(
          label: isRescue ? 'Request Now' : 'Book Service',
          trailingIcon: isRescue ? Icons.send_outlined : Icons.event_available_outlined,
          variant: isRescue ? AppButtonVariant.dark : AppButtonVariant.primary,
          onPressed: onBook,
        ),
      ],
    );
  }
}
