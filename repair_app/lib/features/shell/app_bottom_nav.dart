import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/theme/app_tokens.dart';
import 'main_shell.dart';

/// Daylight bottom dock with a safety-amber notch under the active tab.
class AppBottomNav extends StatelessWidget {
  const AppBottomNav({super.key, required this.tabs, required this.selected, required this.onSelected});

  final List<AppTab> tabs;
  final AppTab selected;
  final ValueChanged<AppTab> onSelected;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: AppColors.card,
        border: Border(top: BorderSide(color: AppColors.border)),
        boxShadow: AppShadows.level2,
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 68,
          child: Row(
            children: [
              for (final tab in tabs)
                Expanded(
                  child: _NavItem(tab: tab, isActive: tab == selected, onTap: () => onSelected(tab)),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({required this.tab, required this.isActive, required this.onTap});

  final AppTab tab;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = isActive ? AppColors.amberDeep : AppColors.textMuted;
    return Semantics(
      selected: isActive,
      button: true,
      label: tab.label,
      child: InkResponse(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(tab.icon, color: color, size: 24),
            const SizedBox(height: 2),
            Text(tab.label, style: AppTextStyles.labelMd.copyWith(color: color)),
            const SizedBox(height: 4),
            AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              width: isActive ? 20 : 0,
              height: 4,
              decoration: const BoxDecoration(color: AppColors.amber, borderRadius: AppRadius.pill),
            ),
          ],
        ),
      ),
    );
  }
}
