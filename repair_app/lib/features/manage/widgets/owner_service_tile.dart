import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/status_badge.dart';
import '../../../data/static_data.dart';

/// Provider-side row for a bookable labor service.
class OwnerServiceTile extends StatelessWidget {
  const OwnerServiceTile({
    super.key,
    required this.service,
    required this.onEdit,
    required this.onToggle,
    required this.onDelete,
  });

  final MechanicService service;
  final VoidCallback onEdit;
  final VoidCallback onToggle;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final isRescue = service.delivery == ServiceDelivery.mobileRescue;
    final muted = !service.isActive;

    return Opacity(
      opacity: muted ? 0.7 : 1,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: AppDecorations.card,
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: isRescue ? AppColors.amberWash : AppColors.surfaceLow,
                    borderRadius: AppRadius.md,
                  ),
                  child: Icon(service.category.icon, color: isRescue ? AppColors.amberDeep : AppColors.slate),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Wrap(
                        spacing: 6,
                        runSpacing: 4,
                        children: [
                          StatusBadge(
                            label: service.delivery.label,
                            tone: isRescue ? BadgeTone.warning : BadgeTone.info,
                          ),
                          StatusBadge(
                            label: service.isActive ? 'Active' : 'Paused',
                            tone: service.isActive ? BadgeTone.info : BadgeTone.neutral,
                            dotColor: service.isActive ? AppColors.amber : null,
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(service.title, style: AppTextStyles.titleMd, maxLines: 1, overflow: TextOverflow.ellipsis),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(formatPrice(service.price), style: AppTextStyles.price),
                    Text(service.pricingModel.label, style: AppTextStyles.labelSm.copyWith(color: AppColors.textMuted)),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.only(left: 10),
              decoration: const BoxDecoration(color: AppColors.surfaceLow, borderRadius: AppRadius.md),
              child: Row(
                children: [
                  Icon(
                    isRescue ? Icons.speed : Icons.timer_outlined,
                    size: 16,
                    color: isRescue ? AppColors.danger : AppColors.textMuted,
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      isRescue ? '${service.estimatedMinutes} min response' : 'Est. ${service.estimatedMinutes} min',
                      style: AppTextStyles.labelMd.copyWith(color: isRescue ? AppColors.danger : AppColors.textMuted),
                    ),
                  ),
                  _TileAction(icon: Icons.edit_outlined, label: 'Edit', onPressed: onEdit),
                  _TileAction(
                    icon: service.isActive ? Icons.pause_circle_outline : Icons.play_circle_outline,
                    label: service.isActive ? 'Pause' : 'Resume',
                    color: service.isActive ? AppColors.slate : AppColors.amber,
                    onPressed: onToggle,
                  ),
                  IconButton(
                    tooltip: 'Delete',
                    icon: const Icon(Icons.delete_outline, size: 20, color: AppColors.danger),
                    onPressed: onDelete,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TileAction extends StatelessWidget {
  const _TileAction({required this.icon, required this.label, required this.onPressed, this.color = AppColors.slate});

  final IconData icon;
  final String label;
  final VoidCallback onPressed;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 16),
      label: Text(label),
      style: TextButton.styleFrom(
        foregroundColor: color,
        textStyle: AppTextStyles.labelMd,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        minimumSize: const Size(48, 40),
      ),
    );
  }
}
