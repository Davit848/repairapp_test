import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

/// Big tabular number over a small caption, e.g. "142 / Map Views Today".
class StatTile extends StatelessWidget {
  const StatTile({super.key, required this.value, required this.label, this.highlight = false});

  final String value;
  final String label;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          value,
          style: AppTextStyles.headlineSm.copyWith(
            color: highlight ? AppColors.amberDeep : AppColors.text,
            fontFeatures: const [FontFeature.tabularFigures()],
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          textAlign: TextAlign.center,
          style: AppTextStyles.labelMd.copyWith(color: AppColors.textMuted),
        ),
      ],
    );
  }
}
