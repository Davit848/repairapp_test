import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../core/widgets/status_badge.dart';
import '../../../data/static_data.dart';

/// Avatar, verified identity and workshop contact summary.
class ProfileHeaderCard extends StatelessWidget {
  const ProfileHeaderCard({super.key, required this.owner, required this.onChangePhoto});

  final OwnerProfile owner;
  final VoidCallback onChangePhoto;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: AppDecorations.card,
      child: Column(
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(color: AppColors.surfaceHigh, shape: BoxShape.circle),
                child: CircleAvatar(radius: 52, backgroundImage: AssetImage(owner.avatar)),
              ),
              Positioned(
                right: -2,
                bottom: 4,
                child: Material(
                  color: AppColors.amberDeep,
                  shape: const CircleBorder(side: BorderSide(color: Colors.white, width: 3)),
                  child: IconButton(
                    tooltip: 'Change photo',
                    onPressed: onChangePhoto,
                    icon: const Icon(Icons.photo_camera_outlined, size: 18, color: Colors.white),
                    constraints: const BoxConstraints.tightFor(width: 40, height: 40),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(owner.name.toUpperCase(), style: AppTextStyles.headlineMd),
              const SizedBox(width: 6),
              const Icon(Icons.verified_outlined, color: AppColors.amberDeep),
            ],
          ),
          const SizedBox(height: 6),
          StatusBadge(label: owner.role, tone: BadgeTone.info, icon: Icons.shield_outlined),
          const SizedBox(height: AppSpacing.md),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: const BoxDecoration(color: AppColors.surfaceLow, borderRadius: AppRadius.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.storefront_outlined, size: 18, color: AppColors.amberDeep),
                    const SizedBox(width: 8),
                    Expanded(child: Text(owner.shop.name, style: AppTextStyles.titleMd)),
                  ],
                ),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 16,
                  runSpacing: 4,
                  children: [
                    _contact(Icons.phone_outlined, owner.shop.phone),
                    _contact(Icons.mail_outline, owner.email),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _contact(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: AppColors.textMuted),
        const SizedBox(width: 6),
        Flexible(
          child: Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.bodyMd.copyWith(color: AppColors.textMuted),
          ),
        ),
      ],
    );
  }
}
