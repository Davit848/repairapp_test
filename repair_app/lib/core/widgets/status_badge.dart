import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../theme/app_tokens.dart';

enum BadgeTone {
  neutral(AppColors.surfaceHigh, AppColors.slate),
  success(AppColors.emeraldSoft, AppColors.emeraldText),
  warning(AppColors.amberSoft, AppColors.amberDeep),
  danger(AppColors.dangerSoft, AppColors.danger),
  info(AppColors.blueSoft, AppColors.blue),
  dark(AppColors.slate, Colors.white),
  light(Colors.white, AppColors.slate);

  const BadgeTone(this.background, this.foreground);

  final Color background;
  final Color foreground;
}

/// Compact pill for stock levels, delivery modes and verification status.
class StatusBadge extends StatelessWidget {
  const StatusBadge({
    super.key,
    required this.label,
    this.tone = BadgeTone.neutral,
    this.icon,
    this.dotColor,
    this.uppercase = false,
  });

  final String label;
  final BadgeTone tone;
  final IconData? icon;
  final Color? dotColor;
  final bool uppercase;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(color: tone.background, borderRadius: AppRadius.pill),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (dotColor != null) ...[
            Container(
              width: 7,
              height: 7,
              decoration: BoxDecoration(color: dotColor, shape: BoxShape.circle),
            ),
            const SizedBox(width: 5),
          ],
          if (icon != null) ...[Icon(icon, size: 13, color: tone.foreground), const SizedBox(width: 4)],
          Flexible(
            child: Text(
              uppercase ? label.toUpperCase() : label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: (uppercase ? AppTextStyles.labelSm : AppTextStyles.labelMd).copyWith(color: tone.foreground),
            ),
          ),
        ],
      ),
    );
  }
}
