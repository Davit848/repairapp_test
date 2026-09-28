import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../theme/app_tokens.dart';

class PillOption<T> {
  const PillOption(this.value, this.label, {this.icon});

  final T value;
  final String label;
  final IconData? icon;
}

/// Horizontally scrolling single-select pill row (category / garage filters).
class PillSelector<T> extends StatelessWidget {
  const PillSelector({
    super.key,
    required this.options,
    required this.selected,
    required this.onSelected,
    this.activeColor = AppColors.slate,
    this.uppercase = false,
  });

  final List<PillOption<T>> options;
  final T selected;
  final ValueChanged<T> onSelected;
  final Color activeColor;
  final bool uppercase;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: AppSpacing.screen,
        itemCount: options.length,
        separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.sm),
        itemBuilder: (context, index) {
          final option = options[index];
          final isActive = option.value == selected;
          final foreground = isActive ? Colors.white : AppColors.slate;
          return Material(
            color: isActive ? activeColor : AppColors.card,
            shape: RoundedRectangleBorder(
              borderRadius: AppRadius.pill,
              side: BorderSide(color: isActive ? activeColor : AppColors.border),
            ),
            child: InkWell(
              customBorder: const StadiumBorder(),
              onTap: () => onSelected(option.value),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (option.icon != null) ...[
                      Icon(option.icon, size: 16, color: isActive ? Colors.white : AppColors.amber),
                      const SizedBox(width: 6),
                    ],
                    Text(
                      uppercase ? option.label.toUpperCase() : option.label,
                      style: (uppercase ? AppTextStyles.labelMd : AppTextStyles.labelLg).copyWith(color: foreground),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
