import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../core/widgets/pill_selector.dart';
import '../../../core/widgets/segmented_toggle.dart';
import '../../../data/static_data.dart';

enum ManageMode { parts, services }

/// Owner's workshop banner with the Parts / Services portal switch.
class ShopIdentityCard extends StatelessWidget {
  const ShopIdentityCard({
    super.key,
    required this.owner,
    required this.mode,
    required this.activeServices,
    required this.onModeChanged,
  });

  final OwnerProfile owner;
  final ManageMode mode;
  final int activeServices;
  final ValueChanged<ManageMode> onModeChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: const BoxDecoration(color: AppColors.surfaceMid, borderRadius: AppRadius.xl),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: const BoxDecoration(color: AppColors.slate, borderRadius: AppRadius.lg),
                child: const Icon(Icons.store_mall_directory_outlined, color: Colors.white),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(owner.shop.name, style: AppTextStyles.titleLg, maxLines: 1, overflow: TextOverflow.ellipsis),
                    Text.rich(
                      TextSpan(
                        text: 'Owner: ${owner.name} • ',
                        children: [
                          TextSpan(
                            text: 'Tier 1 Certified',
                            style: AppTextStyles.labelMd.copyWith(color: AppColors.amberDeep),
                          ),
                        ],
                      ),
                      style: AppTextStyles.bodySm.copyWith(color: AppColors.textMuted),
                    ),
                  ],
                ),
              ),
              Container(
                width: 10,
                height: 10,
                decoration: const BoxDecoration(color: AppColors.amber, shape: BoxShape.circle),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SegmentedToggle<ManageMode>(
            selected: mode,
            onSelected: onModeChanged,
            options: [
              const PillOption(ManageMode.parts, 'Parts & Items', icon: Icons.inventory_2_outlined),
              PillOption(ManageMode.services, 'Services ($activeServices Active)', icon: Icons.build_circle_outlined),
            ],
          ),
        ],
      ),
    );
  }
}
