import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../data/static_data.dart';

/// Garage pin: a round icon marker with a floating name + rating tag.
/// The selected pin grows into an amber teardrop with a bold callout.
class ShopMarker extends StatelessWidget {
  const ShopMarker({super.key, required this.shop, required this.isSelected, required this.onTap});

  final Shop shop;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: '${shop.name}, rated ${shop.rating}',
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _Tag(shop: shop, isSelected: isSelected),
            const SizedBox(height: 6),
            isSelected ? _SelectedPin(icon: shop.mapIcon) : _RoundPin(icon: shop.mapIcon),
          ],
        ),
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  const _Tag({required this.shop, required this.isSelected});

  final Shop shop;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    final foreground = isSelected ? Colors.white : AppColors.slate;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: isSelected ? 8 : 4),
      decoration: BoxDecoration(
        color: isSelected ? AppColors.amberDeep : AppColors.card,
        borderRadius: AppRadius.pill,
        boxShadow: AppShadows.level2,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(shop.mapIcon, size: 14, color: isSelected ? Colors.white : AppColors.amber),
          const SizedBox(width: 4),
          Text(
            shop.shortName,
            style: (isSelected ? AppTextStyles.labelLg : AppTextStyles.labelMd).copyWith(color: foreground),
          ),
          const SizedBox(width: 6),
          Text(
            '${shop.rating}★',
            style: AppTextStyles.labelMd.copyWith(color: isSelected ? Colors.white : AppColors.amberDeep),
          ),
        ],
      ),
    );
  }
}

class _RoundPin extends StatelessWidget {
  const _RoundPin({required this.icon});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: AppColors.slate,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 3),
        boxShadow: AppShadows.level2,
      ),
      child: Icon(icon, size: 18, color: Colors.white),
    );
  }
}

class _SelectedPin extends StatelessWidget {
  const _SelectedPin({required this.icon});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 52,
      height: 64,
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          const Icon(Icons.location_on, size: 64, color: AppColors.amber),
          Positioned(
            top: 12,
            child: Container(
              width: 26,
              height: 26,
              decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
              child: Icon(icon, size: 16, color: AppColors.amberDeep),
            ),
          ),
        ],
      ),
    );
  }
}

/// The motorist's live GPS dot with accuracy halo.
class UserMarker extends StatelessWidget {
  const UserMarker({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 52,
          height: 52,
          alignment: Alignment.center,
          decoration: BoxDecoration(color: AppColors.blue.withValues(alpha: 0.18), shape: BoxShape.circle),
          child: Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              color: AppColors.blue,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 3),
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
          decoration: const BoxDecoration(color: AppColors.slate, borderRadius: AppRadius.pill),
          child: Text('YOU', style: AppTextStyles.labelSm.copyWith(color: Colors.white)),
        ),
      ],
    );
  }
}
