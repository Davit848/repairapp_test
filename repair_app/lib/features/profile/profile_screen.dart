import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/theme/app_tokens.dart';
import '../../core/utils/dialogs.dart';
import '../../core/utils/feedback.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_header.dart';
import '../../core/widgets/section_header.dart';
import '../../core/widgets/stat_tile.dart';
import '../../data/static_data.dart';
import 'widgets/profile_header_card.dart';
import 'widgets/settings_group.dart';

enum AppLanguage { en, km }

/// Page 5 — account, workshop identity and preferences.
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key, required this.onManageInventory});

  final VoidCallback onManageInventory;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  AppLanguage _language = AppLanguage.en;

  void _comingSoon(String feature) => context.showFeedback('$feature is coming soon');

  Future<void> _logout() async {
    final confirmed = await confirmAction(
      context,
      title: 'Log out?',
      message: 'You will need to sign in again to manage your shop.',
      confirmLabel: 'Log Out',
    );
    if (confirmed && mounted) context.showFeedback('Logged out (demo mode)');
  }

  @override
  Widget build(BuildContext context) {
    const owner = StaticData.owner;
    final shop = owner.shop;

    return Scaffold(
      appBar: const AppHeader(subtitle: 'Technician Profile'),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          ProfileHeaderCard(owner: owner, onChangePhoto: () => _comingSoon('Photo upload')),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              _statCard(StatTile(value: '★ ${shop.rating}', label: '${shop.reviewCount} Reviews')),
              const SizedBox(width: 8),
              _statCard(StatTile(value: owner.memberSince, label: 'Member Since')),
              const SizedBox(width: 8),
              _statCard(
                StatTile(value: '${owner.stats.productsListed} Parts', label: 'Active Listings', highlight: true),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          const GroupLabel('Business & Shop', trailing: '3 Items'),
          SettingsGroup(
            children: [
              SettingsTile(
                icon: Icons.storefront_outlined,
                title: 'My Shop & Working Hours',
                subtitle: '${shop.shortName} • ${owner.workingHours}',
                onTap: () => _comingSoon('Working hours'),
              ),
              SettingsTile(
                icon: Icons.location_on_outlined,
                title: 'GPS Map Pin & Coordinates',
                subtitle: '${shop.latitude}° N, ${shop.longitude}° E',
                showAlertDot: true,
                onTap: () => _comingSoon('GPS pin calibration'),
              ),
              SettingsTile(
                icon: Icons.inventory_2_outlined,
                title: 'Manage Product Inventory',
                subtitle: 'Full CRUD • ${owner.stats.productsListed} live catalog parts',
                onTap: widget.onManageInventory,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          const GroupLabel('Account & Security', trailing: 'Credentials'),
          SettingsGroup(
            children: [
              SettingsTile(
                icon: Icons.badge_outlined,
                title: 'Edit Profile',
                subtitle: '${owner.name.toUpperCase()} • ${shop.phone} • Email',
                onTap: () => _comingSoon('Profile editor'),
              ),
              SettingsTile(
                icon: Icons.lock_reset,
                title: 'Password & Security Tokens',
                subtitle: '2FA active • API bearer keys',
                onTap: () => _comingSoon('Security settings'),
              ),
              SettingsTile(
                icon: Icons.notifications_active_outlined,
                title: 'Notification Preferences',
                subtitle: 'Customer dispatch calls & low stock',
                onTap: () => _comingSoon('Notification settings'),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          const GroupLabel('Preferences & Support', trailing: 'General'),
          SettingsGroup(
            children: [
              SettingsTile(
                icon: Icons.translate,
                title: 'Language',
                subtitle: _language == AppLanguage.en ? 'English (US)' : 'ភាសាខ្មែរ',
                trailing: _LanguageSwitch(
                  value: _language,
                  onChanged: (language) => setState(() => _language = language),
                ),
              ),
              SettingsTile(
                icon: Icons.support_agent,
                title: 'Customer Support & Mechanic Help',
                subtitle: '24/7 Priority Emergency dispatch line',
                onTap: () => context.showFeedback('Calling ${StaticData.hotline}'),
              ),
              SettingsTile(
                icon: Icons.policy_outlined,
                title: 'Terms of Service & Privacy Policy',
                subtitle: 'Compliance, warranties & data privacy',
                onTap: () => _comingSoon('Legal documents'),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          AppButton(
            label: 'Log Out',
            icon: Icons.logout,
            variant: AppButtonVariant.danger,
            height: 54,
            expand: true,
            onPressed: _logout,
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            'Repair Mobile v1.0.4',
            textAlign: TextAlign.center,
            style: AppTextStyles.bodySm.copyWith(color: AppColors.textMuted),
          ),
          const SizedBox(height: AppSpacing.md),
        ],
      ),
    );
  }

  Widget _statCard(Widget child) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 4),
        decoration: AppDecorations.card.copyWith(borderRadius: AppRadius.lg),
        child: child,
      ),
    );
  }
}

class _LanguageSwitch extends StatelessWidget {
  const _LanguageSwitch({required this.value, required this.onChanged});

  final AppLanguage value;
  final ValueChanged<AppLanguage> onChanged;

  @override
  Widget build(BuildContext context) {
    Widget option(AppLanguage language, String label) {
      final isActive = language == value;
      return GestureDetector(
        onTap: () => onChanged(language),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: isActive ? AppColors.amberDeep : Colors.transparent,
            borderRadius: AppRadius.pill,
          ),
          child: Text(label, style: AppTextStyles.labelMd.copyWith(color: isActive ? Colors.white : AppColors.slate)),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(3),
      decoration: const BoxDecoration(color: AppColors.surfaceHigh, borderRadius: AppRadius.pill),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [option(AppLanguage.en, 'EN'), option(AppLanguage.km, 'ខ្មែរ')],
      ),
    );
  }
}
