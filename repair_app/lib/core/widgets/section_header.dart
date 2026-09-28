import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

class SectionHeader extends StatelessWidget {
  const SectionHeader({super.key, required this.title, this.subtitle, this.badge, this.trailing});

  final String title;
  final String? subtitle;
  final Widget? badge;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Flexible(child: Text(title, style: AppTextStyles.headlineSm)),
                  if (badge != null) ...[const SizedBox(width: 8), badge!],
                ],
              ),
              if (subtitle != null) Text(subtitle!, style: AppTextStyles.bodySm.copyWith(color: AppColors.textMuted)),
            ],
          ),
        ),
        ?trailing,
      ],
    );
  }
}

/// All-caps amber label that opens a settings group, e.g. "BUSINESS & SHOP".
class GroupLabel extends StatelessWidget {
  const GroupLabel(this.label, {super.key, this.trailing});

  final String label;
  final String? trailing;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 0, 4, 8),
      child: Row(
        children: [
          Expanded(
            child: Text(label.toUpperCase(), style: AppTextStyles.labelSm.copyWith(color: AppColors.amberDeep)),
          ),
          if (trailing != null) Text(trailing!, style: AppTextStyles.labelMd.copyWith(color: AppColors.textMuted)),
        ],
      ),
    );
  }
}
