import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../theme/app_tokens.dart';

class SearchField extends StatelessWidget {
  const SearchField({super.key, required this.hint, required this.onChanged, this.trailing});

  final String hint;
  final ValueChanged<String> onChanged;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52,
      decoration: const BoxDecoration(
        color: AppColors.card,
        borderRadius: AppRadius.lg,
        border: Border.fromBorderSide(BorderSide(color: AppColors.border)),
        boxShadow: AppShadows.level1,
      ),
      padding: const EdgeInsets.only(left: 14, right: 6),
      child: Row(
        children: [
          const Icon(Icons.search, color: AppColors.slate),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              onChanged: onChanged,
              style: AppTextStyles.bodyLg,
              textInputAction: TextInputAction.search,
              decoration: InputDecoration(
                hintText: hint,
                filled: false,
                isCollapsed: true,
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
              ),
            ),
          ),
          ?trailing,
        ],
      ),
    );
  }
}
