import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/status_badge.dart';

/// High-contrast roadside emergency dispatch card.
class RescueBanner extends StatelessWidget {
  const RescueBanner({super.key, required this.onBookMobile, required this.onHotline});

  final VoidCallback onBookMobile;
  final VoidCallback onHotline;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: const BoxDecoration(color: AppColors.slate, borderRadius: AppRadius.xl, boxShadow: AppShadows.level2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: const BoxDecoration(color: AppColors.amber, borderRadius: AppRadius.md),
                child: const Icon(Icons.emergency_share_outlined, color: Colors.white),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('PRIORITY RESCUE', style: AppTextStyles.labelSm.copyWith(color: AppColors.amberBright)),
                    Text('Stranded on the Road?', style: AppTextStyles.headlineSm.copyWith(color: Colors.white)),
                  ],
                ),
              ),
              const StatusBadge(label: '15-25 min ETA', tone: BadgeTone.light),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Immediate mobile tech dispatch across Phnom Penh. Heavy duty jumpstarts, '
            'flat tires, chain snaps, and roadside mechanical diagnosis.',
            style: AppTextStyles.bodyMd.copyWith(color: const Color(0xFFCBD5E1)),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: AppButton(label: 'Book Mobile', icon: Icons.near_me, height: 50, onPressed: onBookMobile),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: FilledButton.icon(
                  onPressed: onHotline,
                  icon: const Icon(Icons.call, size: 18),
                  label: const Text('Hotline (24/7)'),
                  style: FilledButton.styleFrom(
                    minimumSize: const Size(48, 50),
                    backgroundColor: AppColors.slateSoft,
                    foregroundColor: Colors.white,
                    textStyle: AppTextStyles.labelLg,
                    shape: const RoundedRectangleBorder(borderRadius: AppRadius.lg),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
