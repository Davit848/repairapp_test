import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../theme/app_tokens.dart';

enum AppButtonVariant {
  /// Safety amber dispatch action.
  primary(AppColors.amber, Colors.white),

  /// Deep amber, used for "Contact" on catalog cards.
  secondary(AppColors.amberDeep, Colors.white),

  /// Industrial slate action.
  dark(AppColors.slate, Colors.white),

  /// Soft blue tooling action.
  tonal(AppColors.surfaceHigh, AppColors.slate),

  /// Destructive soft action.
  danger(AppColors.dangerSoft, AppColors.danger);

  const AppButtonVariant(this.background, this.foreground);

  final Color background;
  final Color foreground;
}

class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.icon,
    this.trailingIcon,
    this.height = 48,
    this.expand = false,
    this.compact = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final IconData? icon;
  final IconData? trailingIcon;
  final double height;
  final bool expand;

  /// Tighter padding and smaller label for dense cards.
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final button = FilledButton(
      onPressed: onPressed,
      style: FilledButton.styleFrom(
        backgroundColor: variant.background,
        foregroundColor: variant.foreground,
        minimumSize: Size(48, height),
        padding: EdgeInsets.symmetric(horizontal: compact ? 8 : 14),
        textStyle: compact ? AppTextStyles.labelMd : AppTextStyles.labelLg,
        shape: const RoundedRectangleBorder(borderRadius: AppRadius.lg),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[Icon(icon, size: compact ? 16 : 18), SizedBox(width: compact ? 4 : 6)],
          Flexible(child: Text(label, maxLines: 1, overflow: TextOverflow.ellipsis)),
          if (trailingIcon != null) ...[const SizedBox(width: 6), Icon(trailingIcon, size: 18)],
        ],
      ),
    );
    return expand ? SizedBox(width: double.infinity, child: button) : button;
  }
}

/// Square 44px icon action, e.g. call shortcut next to a CTA.
class AppIconButton extends StatelessWidget {
  const AppIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.tooltip,
    this.variant = AppButtonVariant.tonal,
    this.size = 44,
  });

  final IconData icon;
  final VoidCallback? onPressed;
  final String? tooltip;
  final AppButtonVariant variant;
  final double size;

  @override
  Widget build(BuildContext context) {
    return IconButton.filled(
      tooltip: tooltip,
      onPressed: onPressed,
      icon: Icon(icon, size: 20),
      style: IconButton.styleFrom(
        backgroundColor: variant.background,
        foregroundColor: variant.foreground,
        fixedSize: Size.square(size),
        shape: const RoundedRectangleBorder(borderRadius: AppRadius.md),
      ),
    );
  }
}
