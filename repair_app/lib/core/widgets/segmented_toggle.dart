import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../theme/app_tokens.dart';
import 'pill_selector.dart';

/// Tinted track with an elevated white thumb on the active segment.
class SegmentedToggle<T> extends StatelessWidget {
  const SegmentedToggle({super.key, required this.options, required this.selected, required this.onSelected});

  final List<PillOption<T>> options;
  final T selected;
  final ValueChanged<T> onSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: const BoxDecoration(color: AppColors.surfaceMid, borderRadius: AppRadius.lg),
      child: Row(
        children: [
          for (final option in options)
            Expanded(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => onSelected(option.value),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  height: 40,
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  decoration: BoxDecoration(
                    color: option.value == selected ? AppColors.card : Colors.transparent,
                    borderRadius: AppRadius.md,
                    boxShadow: option.value == selected ? AppShadows.level1 : null,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (option.icon != null) ...[
                        Icon(option.icon, size: 16, color: AppColors.amberDeep),
                        const SizedBox(width: 6),
                      ],
                      Flexible(
                        child: Text(
                          option.label,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.labelMd.copyWith(
                            color: option.value == selected ? AppColors.slate : AppColors.textMuted,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
