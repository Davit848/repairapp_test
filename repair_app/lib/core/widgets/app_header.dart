import 'package:flutter/material.dart';

import '../../data/static_data.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../utils/feedback.dart';

/// Brand header shared by every tab: logo, "Repair" wordmark, section
/// subtitle, emergency shortcut and the signed-in user's avatar.
class AppHeader extends StatelessWidget implements PreferredSizeWidget {
  const AppHeader({super.key, required this.subtitle});

  final String subtitle;

  @override
  Size get preferredSize => const Size.fromHeight(72);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: preferredSize.height,
      automaticallyImplyLeading: false,
      titleSpacing: 16,
      shape: const Border(bottom: BorderSide(color: AppColors.border)),
      title: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.asset('assets/images/logo.png', width: 40, height: 40, fit: BoxFit.cover),
          ),
          const SizedBox(width: 10),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Repair', style: AppTextStyles.headlineSm.copyWith(height: 1.1)),
                Text(
                  subtitle.toUpperCase(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.labelSm.copyWith(color: AppColors.amberDeep),
                ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          tooltip: 'Emergency help',
          onPressed: () => context.showFeedback('Emergency hotline: ${StaticData.hotline}'),
          icon: const Icon(Icons.report_outlined, color: AppColors.slate),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 4, right: 16),
          child: CircleAvatar(
            radius: 20,
            backgroundColor: AppColors.surfaceHigh,
            backgroundImage: AssetImage(StaticData.owner.avatar),
          ),
        ),
      ],
    );
  }
}
