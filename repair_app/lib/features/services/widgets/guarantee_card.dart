import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_tokens.dart';

class GuaranteeCard extends StatelessWidget {
  const GuaranteeCard({super.key});

  static const _points = [
    (
      Icons.verified_user_outlined,
      '100% Vetted Techs',
      'ID-verified mechanics with certified technical workshop credentials.',
    ),
    (Icons.receipt_long_outlined, 'Fixed Upfront Quotes', 'Zero hidden roadside markups or unexpected labor fees.'),
    (
      Icons.history_outlined,
      '30-Day Labor Warranty',
      'If the issue recurs within 30 days, we fix it at zero extra labor cost.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surfaceMid,
        borderRadius: AppRadius.xl,
        border: Border.all(color: AppColors.surfaceHigh),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(color: AppColors.card, borderRadius: AppRadius.md),
                child: const Icon(Icons.shield_outlined, color: AppColors.amberDeep),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Repair Service Guarantee', style: AppTextStyles.titleMd),
                    Text('Strict Service Standards', style: AppTextStyles.labelMd.copyWith(color: AppColors.amberDeep)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          for (final (icon, title, body) in _points)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(icon, size: 18, color: AppColors.amberDeep),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text.rich(
                      TextSpan(
                        text: '$title: ',
                        style: AppTextStyles.labelLg,
                        children: [TextSpan(text: body, style: AppTextStyles.bodyMd)],
                      ),
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
