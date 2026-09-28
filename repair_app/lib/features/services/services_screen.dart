import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/theme/app_tokens.dart';
import '../../core/utils/feedback.dart';
import '../../core/widgets/app_header.dart';
import '../../core/widgets/pill_selector.dart';
import '../../core/widgets/section_header.dart';
import '../../core/widgets/segmented_toggle.dart';
import '../../core/widgets/status_badge.dart';
import '../../data/static_data.dart';
import 'widgets/guarantee_card.dart';
import 'widgets/rescue_banner.dart';
import 'widgets/service_card.dart';

enum _ModeFilter { all, mobile, garage }

/// Page 2 — labor marketplace with transparent, fixed upfront pricing.
class ServicesScreen extends StatefulWidget {
  const ServicesScreen({super.key});

  @override
  State<ServicesScreen> createState() => _ServicesScreenState();
}

class _ServicesScreenState extends State<ServicesScreen> {
  _ModeFilter _mode = _ModeFilter.all;
  ServiceCategory? _category;

  List<MechanicService> get _results {
    final services = StaticData.marketplaceServices.where((service) {
      final matchesMode = switch (_mode) {
        _ModeFilter.all => true,
        _ModeFilter.mobile => service.delivery.isMobile,
        _ModeFilter.garage => service.delivery.isInShop,
      };
      return matchesMode && (_category == null || service.category == _category);
    }).toList();
    return services..sort((a, b) => a.shop.distanceKm.compareTo(b.shop.distanceKm));
  }

  @override
  Widget build(BuildContext context) {
    final results = _results;
    return Scaffold(
      appBar: const AppHeader(subtitle: 'Service Hub'),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
        children: [
          const Padding(padding: AppSpacing.screen, child: _Intro()),
          const SizedBox(height: AppSpacing.md),
          Padding(
            padding: AppSpacing.screen,
            child: RescueBanner(
              onBookMobile: () => context.showFeedback('Dispatching the nearest mobile mechanic…'),
              onHotline: () => context.showFeedback('Calling ${StaticData.hotline}'),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Padding(
            padding: AppSpacing.screen,
            child: SegmentedToggle<_ModeFilter>(
              selected: _mode,
              onSelected: (mode) => setState(() => _mode = mode),
              options: const [
                PillOption(_ModeFilter.all, 'All Modes'),
                PillOption(_ModeFilter.mobile, 'Mobile', icon: Icons.moped_outlined),
                PillOption(_ModeFilter.garage, 'Garage Only', icon: Icons.warehouse_outlined),
              ],
            ),
          ),
          const SizedBox(height: 12),
          PillSelector<ServiceCategory?>(
            selected: _category,
            onSelected: (category) => setState(() => _category = category),
            options: [
              const PillOption(null, 'All Services', icon: Icons.grid_view_rounded),
              for (final category in ServiceCategory.values) PillOption(category, category.label, icon: category.icon),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          Padding(
            padding: AppSpacing.screen,
            child: SectionHeader(
              title: 'Available Near You',
              badge: const StatusBadge(label: '14 Online', tone: BadgeTone.success),
              trailing: Row(
                children: [
                  const Icon(Icons.sort, size: 18, color: AppColors.textMuted),
                  const SizedBox(width: 4),
                  Text('Nearest First', style: AppTextStyles.labelMd.copyWith(color: AppColors.textMuted)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          if (results.isEmpty)
            Padding(
              padding: const EdgeInsets.all(AppSpacing.xl),
              child: Text(
                'No services match these filters yet.',
                textAlign: TextAlign.center,
                style: AppTextStyles.bodyMd.copyWith(color: AppColors.textMuted),
              ),
            ),
          for (final service in results)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
              child: ServiceCard(
                service: service,
                onCall: () => context.showFeedback('Calling ${service.shop.shortName} · ${service.shop.phone}'),
                onBook: () => context.showFeedback('Request sent to ${service.shop.shortName}'),
              ),
            ),
          const SizedBox(height: AppSpacing.sm),
          const Padding(padding: AppSpacing.screen, child: GuaranteeCard()),
        ],
      ),
    );
  }
}

class _Intro extends StatelessWidget {
  const _Intro();

  @override
  Widget build(BuildContext context) {
    final meta = AppTextStyles.bodySm.copyWith(color: AppColors.textMuted);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('PHNOM PENH TECH NETWORK', style: AppTextStyles.labelSm.copyWith(color: AppColors.amberDeep)),
        const SizedBox(height: 4),
        Text('Professional Mechanic Services', style: AppTextStyles.headlineLg),
        const SizedBox(height: 6),
        Wrap(
          spacing: 10,
          runSpacing: 4,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.verified_outlined, size: 14, color: AppColors.amberDeep),
                const SizedBox(width: 4),
                Text('Certified Mechanics', style: meta.copyWith(color: AppColors.amberDeep)),
              ],
            ),
            Text('• Fixed Upfront Pricing', style: meta),
            Text('• Garage & Mobile', style: meta),
          ],
        ),
      ],
    );
  }
}
